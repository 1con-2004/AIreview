# problem_deletion_fixed_log

1. [ ✅ ] 发现在删除题目时存在SQL错误，导致删除操作失败

2. { 2024.4.22 } 修改了以下文件：
   - `backend/src/api/problems/index.js`，删除了更新`problem_category_relations`表中不存在的`problem_number`字段的SQL语句。

3. [ ✅ ] 对于题目删除失败问题的解决方案:

   - 移除错误SQL语句：删除了对`problem_category_relations`表中不存在的`problem_number`字段的更新操作。此错误出现在两个地方：
     1. 删除题目后的重排序逻辑中
     2. 单独的重排序API中

   - 问题原因：代码尝试更新`problem_category_relations`表中的`problem_number`字段，但从数据库表结构来看，该表只包含`id`, `problem_id`, `category_id`和`created_at`字段，没有`problem_number`字段。

   - 解决方式：保留其他表的更新逻辑，仅移除对`problem_category_relations`表的错误更新操作。

# 问题根本原因

在实现题目删除和重排序功能时，开发者可能假设所有与题目相关的表都有`problem_number`字段，但实际上`problem_category_relations`表只是一个多对多的关联表，只存储题目ID和分类ID的关系，并不需要存储题目编号。

# 后续预防措施

1. 在开发涉及数据库操作的功能前，应先仔细检查相关表的结构，确保SQL语句中引用的字段确实存在。

2. 编写重要功能时应考虑添加错误处理机制，当单个SQL操作失败时不应导致整个事务失败。

3. 对于重要的增删改操作，建议先在开发环境或测试环境中完整运行一遍，确保没有SQL错误。

4. 可以考虑利用ORM工具来减少SQL语句编写错误的可能性。 