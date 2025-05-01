# 数据库配置

本目录包含AIreview系统的数据库初始化脚本和配置文件，用于MySQL数据库的初始化和管理。

## 目录结构

```
db/
├── init/              # 数据库初始化脚本目录
│   ├── 01-schema.sql # 数据库表结构定义
│   ├── 02-data.sql   # 初始数据导入
│   └── 03-views.sql  # 视图定义(可选)
└── backups/          # 数据库备份目录(可选)
```

## 数据库结构

AIreview系统使用MySQL 8.0作为数据库，主要包含以下表结构:

### 核心表

1. **用户相关**
   - `users` - 用户基本信息
   - `user_profiles` - 用户详细资料
   - `roles` - 用户角色定义
   - `permissions` - 权限定义

2. **题目相关**
   - `problems` - 题目基本信息
   - `problem_details` - 题目详细内容
   - `test_cases` - 测试用例
   - `tags` - 题目标签
   - `problem_tags` - 题目与标签关联

3. **提交相关**
   - `submissions` - 代码提交记录
   - `submission_results` - 提交结果详情
   - `submission_test_results` - 测试用例执行结果

4. **学习相关**
   - `learning_plans` - 学习计划
   - `learning_paths` - 学习路径
   - `user_progress` - 用户学习进度
   - `learning_resources` - 学习资源

5. **教学相关**
   - `classrooms` - 课堂信息
   - `classroom_members` - 课堂成员
   - `assignments` - 作业
   - `assignment_submissions` - 作业提交

6. **社区相关**
   - `posts` - 讨论帖
   - `comments` - 评论
   - `likes` - 点赞记录

### 关系图

```
users 1--* submissions
users 1--* user_progress
users *--* classrooms (通过 classroom_members)

problems 1--* submissions
problems *--* tags (通过 problem_tags)
problems 1--* test_cases

learning_plans 1--* learning_paths
learning_plans *--* users (通过 user_progress)

classrooms 1--* assignments
assignments 1--* assignment_submissions
```

## 初始化流程

当Docker容器首次启动时，MySQL会执行`init/`目录下的SQL脚本，按照文件名字母顺序执行:

1. 首先执行`01-schema.sql`创建数据库表结构
2. 然后执行`02-data.sql`导入初始数据
3. 最后执行`03-views.sql`创建视图(如有)

## 数据库配置

在`docker-compose.yml`中配置数据库服务:

```yaml
services:
  db:
    image: mysql:8.0
    container_name: aireview-db
    volumes:
      - db_data:/var/lib/mysql
      - ./db/init:/docker-entrypoint-initdb.d
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=AIreview
      - MYSQL_USER=aireview
      - MYSQL_PASSWORD=aireview
    ports:
      - "3307:3306"
    networks:
      - aireview_network
```

## 连接数据库

### 从容器内连接

```bash
docker exec -it aireview-db mysql -u root -proot AIreview
```

### 从宿主机连接

```bash
mysql -h localhost -P 3307 -u root -proot AIreview
```

## 备份与恢复

### 创建备份

```bash
# 创建完整备份
docker exec aireview-db sh -c 'exec mysqldump -u root -p"root" AIreview' > ./db/backups/full_backup_$(date +%Y%m%d).sql

# 创建结构备份
docker exec aireview-db sh -c 'exec mysqldump -u root -p"root" --no-data AIreview' > ./db/backups/schema_backup_$(date +%Y%m%d).sql
```

### 恢复备份

```bash
# 从备份文件恢复
cat ./db/backups/backup_file.sql | docker exec -i aireview-db mysql -u root -proot AIreview
```

## 数据库维护

### 查看表状态

```sql
SHOW TABLE STATUS FROM AIreview;
```

### 优化表

```sql
OPTIMIZE TABLE table_name;
```

### 检查和修复表

```sql
CHECK TABLE table_name;
REPAIR TABLE table_name;
```

## 数据库安全性

为确保数据库安全:

1. 使用强密码
2. 限制数据库端口访问，仅允许必要的连接
3. 定期备份数据
4. 定期更新MySQL版本
5. 使用最小权限原则设置用户权限

## 开发建议

1. 在本地开发时，使用可视化工具如MySQL Workbench或DataGrip管理数据库
2. 使用版本控制管理数据库脚本
3. 文档化所有数据库变更
4. 在测试环境验证数据库变更后再应用到生产环境 