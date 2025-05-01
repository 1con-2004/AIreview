-- 设置数据库默认字符集为utf8mb4，支持完整的Unicode字符，包括emoji
ALTER DATABASE AIreview CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 检查analytics_events表是否存在，存在则修改字符集
SET @table_exists = (
  SELECT COUNT(1) FROM information_schema.tables 
  WHERE table_schema = 'AIreview' 
  AND table_name = 'analytics_events'
);

SET @alter_table_sql = IF(@table_exists > 0, 
  'ALTER TABLE analytics_events CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci',
  'SELECT "analytics_events表不存在，无需修改字符集"');

PREPARE stmt FROM @alter_table_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 设置服务器变量
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 以下是会话级别的配置，只在当前会话有效
SET character_set_client = utf8mb4;
SET character_set_connection = utf8mb4;
SET character_set_results = utf8mb4; 