# 用户删除外键约束问题修复记录

1. [ ✅ ] 发现在删除用户时遇到外键约束错误，无法删除被其他表引用的用户

2. { 2025.4.17 } 修改了文件路径为`backend/src/api/user/index.js`，改进了用户删除功能。具体修改内容为在删除用户前，先处理所有引用该用户的外键约束关系，包括：

   - 将该用户创建的社区（communities表）的created_by字段更新为管理员
   - 删除该用户在classroom_discussions表中的记录
   - 将该用户作为教师的classrooms表中的teacher_id更新为管理员
   - 处理community_members表中用户作为成员和邀请者的记录
   - 删除该用户的learning_plans, likes, posts等记录
   - 更新problem_pool表中用户作为创建者的记录
   - 删除该用户的problem_pool_usage和submissions记录
   - 删除用户的profile和student_info记录
   - 最后删除users表中的用户记录

3. [ ✅ ] 对于用户删除的问题解决方案，采用了两种策略：
   - 对于关键业务数据（如社区、课堂等），将用户引用更新为系统管理员ID，保留业务数据的完整性
   - 对于用户个人数据（如提交记录、点赞等），直接删除相关记录

## 问题出现原因

在数据库设计中，多个表通过外键约束引用了users表的id字段，包括：
- communities表: created_by字段引用users表的id
- classroom_discussions表: user_id字段引用users表的id
- classrooms表: teacher_id字段引用users表的id
等多个表

当尝试删除用户时，由于这些外键约束的存在，MySQL会阻止删除操作，抛出错误：
```
Cannot delete or update a parent row: a foreign key constraint fails (`aireview`.`communities`, CONSTRAINT `fk_community_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`))
```

## 解决方案评估

本修复方案在删除用户前，先处理所有涉及该用户的外键关系。优缺点如下：

### 优点
1. 保留了关键业务数据的完整性，如社区、课堂等数据不会因用户删除而丢失
2. 实现了完整的用户数据清理，确保不会留下孤立数据
3. 使用事务处理确保了数据一致性，任何步骤失败都会回滚整个操作

### 缺点
1. 删除操作较为复杂，涉及多个表的更新和删除
2. 某些业务数据的所有权发生了转移（如从被删除用户转移到管理员），可能会影响数据溯源

### 替代方案
可以考虑的替代方案包括：
1. 不真正删除用户，而是将用户标记为"已删除"状态
2. 在表设计时使用ON DELETE CASCADE选项，自动级联删除关联记录
3. 使用软删除策略，保留所有数据但标记为无效 