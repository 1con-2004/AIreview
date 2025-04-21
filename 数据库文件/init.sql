-- 确保使用正确的数据库
USE AIreview;

-- 导出表结构，不创建数据库
-- 根据之前查询的表结构创建表
-- 这里列出了部分关键表结构，实际项目需要导出完整的表结构

-- 用户表
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255),
  `role` ENUM('admin', 'teacher', 'student') DEFAULT 'student',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 问题表
CREATE TABLE IF NOT EXISTS `problems` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `difficulty` ENUM('简单', '中等', '困难') DEFAULT '中等',
  `time_limit` INT DEFAULT 1000 COMMENT '毫秒',
  `memory_limit` INT DEFAULT 256 COMMENT 'MB',
  `created_by` INT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 测试用例表
CREATE TABLE IF NOT EXISTS `problem_test_cases` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `problem_id` INT NOT NULL,
  `input` TEXT,
  `output` TEXT,
  `is_example` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 提交记录表
CREATE TABLE IF NOT EXISTS `submissions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `problem_id` INT NOT NULL,
  `code` TEXT NOT NULL,
  `language` VARCHAR(50) NOT NULL,
  `status` VARCHAR(50) DEFAULT 'Pending',
  `runtime` INT DEFAULT 0 COMMENT '毫秒',
  `memory` INT DEFAULT 0 COMMENT 'KB',
  `error_message` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 默认管理员账户
INSERT INTO `users` (`username`, `password`, `email`, `role`) VALUES 
('admin', '$2b$10$1Cm03fBv/53M8hbR8Uy5g.w.H3gwJpAJGJJJcVjo6jSr9FJHUPBGq', 'admin@example.com', 'admin');
-- 密码为: admin123

-- 默认教师账户
INSERT INTO `users` (`username`, `password`, `email`, `role`) VALUES 
('teacher', '$2b$10$1Cm03fBv/53M8hbR8Uy5g.w.H3gwJpAJGJJJcVjo6jSr9FJHUPBGq', 'teacher@example.com', 'teacher');
-- 密码为: admin123

-- 默认学生账户
INSERT INTO `users` (`username`, `password`, `email`, `role`) VALUES 
('student', '$2b$10$1Cm03fBv/53M8hbR8Uy5g.w.H3gwJpAJGJJJcVjo6jSr9FJHUPBGq', 'student@example.com', 'student');
-- 密码为: admin123

-- 添加示例问题
INSERT INTO `problems` (`title`, `description`, `difficulty`, `time_limit`, `memory_limit`, `created_by`) VALUES 
('两数之和', '给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那两个整数，并返回他们的数组下标。你可以假设每种输入只会对应一个答案。但是，你不能重复利用这个数组中同样的元素。', '简单', 1000, 256, 1);

-- 添加示例测试用例
INSERT INTO `problem_test_cases` (`problem_id`, `input`, `output`, `is_example`) VALUES 
(1, '[2, 7, 11, 15]\n9', '[0, 1]', TRUE),
(1, '[3, 2, 4]\n6', '[1, 2]', TRUE),
(1, '[3, 3]\n6', '[0, 1]', FALSE); 