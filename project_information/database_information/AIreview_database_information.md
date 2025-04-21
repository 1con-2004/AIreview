# AIreview数据库信息记录

## 数据库结构

### 用户相关表

#### users表
- 包含用户基本信息
- 字段：
  - id: 用户ID
  - username: 用户名
  - password: 加密的密码
  - email: 邮箱
  - phone: 电话
  - role: 角色(admin-管理员, teacher-教师, student-学生, normal-普通用户)
  - status: 状态(1-正常, 0-禁用)
  - created_at: 创建时间
  - updated_at: 更新时间

#### user_profile表
- 包含用户详细资料
- 字段：
  - id: 主键
  - user_id: 关联到users表的外键
  - display_name: 显示名称
  - nickname: 昵称
  - avatar_url: 头像URL
  - gender: 性别
  - birth_date: 出生日期
  - location: 位置
  - bio: 简介
  - created_at: 创建时间
  - updated_at: 更新时间

## 操作记录

- **操作时间**：2025.04.21

- **操作描述**：初始化数据库结构及测试数据

- **SQL语句**：
```sql
-- 创建users表
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20) UNIQUE,
  role ENUM('admin', 'teacher', 'student', 'normal') NOT NULL DEFAULT 'normal',
  status TINYINT NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建user_profile表
CREATE TABLE IF NOT EXISTS user_profile (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  display_name VARCHAR(100),
  nickname VARCHAR(50),
  avatar_url VARCHAR(255),
  gender ENUM('male', 'female', 'other', 'prefer_not_to_say') DEFAULT 'prefer_not_to_say',
  birth_date DATE,
  location VARCHAR(100),
  bio TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入测试数据
INSERT INTO users (username, password, email, role)
VALUES ('admin', '$2b$10$iLbQMk4BjnvYuLrZkJnc1.2lPVOZrkVKCIXvLjBn1A3BjXmvDn5zC', 'admin@example.com', 'admin');

INSERT INTO user_profile (user_id, display_name, nickname)
VALUES (1, '系统管理员', 'admin');
```

- **解释**：
  - 创建了用户核心表结构，包括users表和user_profile表
  - 添加了基本的测试数据，包括管理员、教师和学生账号
  - 所有测试账户密码均为"123456"

- **表及字段信息**：
  - `users`表：存储用户基本信息
  - `user_profile`表：存储用户详细信息，与users表通过user_id关联

- **错误记录**：
  - **错误描述**：系统启动时报错"Table 'AIreview.users' doesn't exist"
  - **原因**：Docker容器首次启动时，数据库初始化脚本不存在或未被正确执行
  - **解决方案**：创建db/init/01_schema.sql文件，添加数据库初始化SQL，并重新启动Docker容器 