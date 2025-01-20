CREATE DATABASE IF NOT EXISTS AIreview;
USE AIreview;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(11) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 先清除可能存在的测试用户
DELETE FROM users WHERE username = 'icon';

-- 使用新生成的哈希值
INSERT INTO users (username, password) VALUES 
('icon', '$2b$10$J9hakhYmdPue/h//tSX2UeTrx0vRrpIUnccuSonV8nlHgGpB8vuDi'); 