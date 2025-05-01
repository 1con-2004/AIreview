-- 检查是否存在analytics_events表，如果不存在则创建
CREATE TABLE IF NOT EXISTS analytics_events (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  event_type VARCHAR(50) NOT NULL,
  user_id VARCHAR(50) NOT NULL,
  page_name VARCHAR(100),
  element_name VARCHAR(100),
  element_id VARCHAR(100),
  timestamp BIGINT NOT NULL,
  metadata JSON,
  ip VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 检查并添加必要的索引以提高查询性能（先检查索引是否存在）
-- event_type索引
SET @index1_exists = (
  SELECT COUNT(1) FROM information_schema.statistics 
  WHERE table_schema = 'AIreview' 
  AND table_name = 'analytics_events' 
  AND index_name = 'idx_analytics_events_event_type'
);

SET @create_index1_sql = IF(@index1_exists = 0, 
  'CREATE INDEX idx_analytics_events_event_type ON analytics_events (event_type)',
  'SELECT "索引event_type已存在，无需创建"');

PREPARE stmt1 FROM @create_index1_sql;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;

-- user_id索引
SET @index2_exists = (
  SELECT COUNT(1) FROM information_schema.statistics 
  WHERE table_schema = 'AIreview' 
  AND table_name = 'analytics_events' 
  AND index_name = 'idx_analytics_events_user_id'
);

SET @create_index2_sql = IF(@index2_exists = 0, 
  'CREATE INDEX idx_analytics_events_user_id ON analytics_events (user_id)',
  'SELECT "索引user_id已存在，无需创建"');

PREPARE stmt2 FROM @create_index2_sql;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- timestamp索引
SET @index3_exists = (
  SELECT COUNT(1) FROM information_schema.statistics 
  WHERE table_schema = 'AIreview' 
  AND table_name = 'analytics_events' 
  AND index_name = 'idx_analytics_events_timestamp'
);

SET @create_index3_sql = IF(@index3_exists = 0, 
  'CREATE INDEX idx_analytics_events_timestamp ON analytics_events (timestamp)',
  'SELECT "索引timestamp已存在，无需创建"');

PREPARE stmt3 FROM @create_index3_sql;
EXECUTE stmt3;
DEALLOCATE PREPARE stmt3;

-- page_name索引
SET @index4_exists = (
  SELECT COUNT(1) FROM information_schema.statistics 
  WHERE table_schema = 'AIreview' 
  AND table_name = 'analytics_events' 
  AND index_name = 'idx_analytics_events_page_name'
);

SET @create_index4_sql = IF(@index4_exists = 0, 
  'CREATE INDEX idx_analytics_events_page_name ON analytics_events (page_name)',
  'SELECT "索引page_name已存在，无需创建"');

PREPARE stmt4 FROM @create_index4_sql;
EXECUTE stmt4;
DEALLOCATE PREPARE stmt4;

-- 尝试修改timestamp列，确保它能存储足够大的数字（JavaScript的时间戳是毫秒级）
ALTER TABLE analytics_events MODIFY COLUMN timestamp BIGINT NOT NULL;

-- 确保metadata列是JSON类型，以便存储完整的事件数据
ALTER TABLE analytics_events MODIFY COLUMN metadata JSON;

-- 检查是否已存在清理过程
DROP PROCEDURE IF EXISTS cleanup_old_analytics_events;

-- 创建一个存储过程来清理过期的埋点数据（例如超过3个月的数据）
DELIMITER //
CREATE PROCEDURE cleanup_old_analytics_events()
BEGIN
    -- 删除3个月前的数据
    DELETE FROM analytics_events 
    WHERE timestamp < (UNIX_TIMESTAMP() - 7776000) * 1000; -- 90天 * 24小时 * 60分钟 * 60秒 * 1000毫秒
END //
DELIMITER ;

-- 检查是否已存在事件调度器
SET @event_exists = (
  SELECT COUNT(1) FROM information_schema.events
  WHERE event_schema = 'AIreview'
  AND event_name = 'analytics_cleanup_event'
);

-- 如果事件调度器已存在，先删除
SET @drop_event_sql = IF(@event_exists > 0,
  'DROP EVENT analytics_cleanup_event',
  'SELECT "事件调度器不存在，无需删除"');

PREPARE drop_stmt FROM @drop_event_sql;
EXECUTE drop_stmt;
DEALLOCATE PREPARE drop_stmt;

-- 创建一个事件调度器，每月运行一次清理过程
CREATE EVENT analytics_cleanup_event
ON SCHEDULE EVERY 1 MONTH
DO
    CALL cleanup_old_analytics_events(); 