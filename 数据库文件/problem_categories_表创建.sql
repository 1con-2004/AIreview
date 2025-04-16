-- 创建problem_categories表
CREATE TABLE `problem_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `description` varchar(255) DEFAULT NULL COMMENT '分类描述',
  `parent_id` int DEFAULT NULL COMMENT '父分类ID',
  `order_num` int DEFAULT 0 COMMENT '显示顺序',
  `level` int DEFAULT 1 COMMENT '分类层级: 1-顶级分类, 2-二级分类, 3-三级分类',
  `slug` varchar(50) DEFAULT NULL COMMENT '分类标识符',
  `icon` varchar(50) DEFAULT NULL COMMENT '分类图标',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目分类表';

-- 创建problem_category_relations表用于题目与分类的多对多关系
CREATE TABLE `problem_category_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `category_id` int NOT NULL COMMENT '分类ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_problem_category` (`problem_id`,`category_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_problem_id` (`problem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目-分类关联表';

-- 插入顶级分类
INSERT INTO `problem_categories` (`name`, `description`, `parent_id`, `level`, `slug`, `icon`) VALUES
('数据结构', '与数据结构相关的算法题', NULL, 1, 'data-structure', 'structure'),
('算法技巧', '常见算法技巧与思想', NULL, 1, 'algorithm', 'algorithm'),
('数学', '数学相关的问题', NULL, 1, 'math', 'calculator'),
('基础编程', '基础编程能力考察', NULL, 1, 'basic', 'code');

-- 插入二级分类-数据结构
INSERT INTO `problem_categories` (`name`, `description`, `parent_id`, `level`, `slug`, `icon`) VALUES
('数组', '数组类型的问题', 1, 2, 'array', 'array'),
('链表', '链表操作相关问题', 1, 2, 'linked-list', 'link'),
('树', '树结构相关问题', 1, 2, 'tree', 'tree'),
('图', '图算法相关问题', 1, 2, 'graph', 'graph'),
('栈', '栈相关问题', 1, 2, 'stack', 'stack'),
('队列', '队列相关问题', 1, 2, 'queue', 'queue'),
('哈希表', '哈希表相关问题', 1, 2, 'hash-table', 'hash');

-- 插入二级分类-算法技巧
INSERT INTO `problem_categories` (`name`, `description`, `parent_id`, `level`, `slug`, `icon`) VALUES
('排序', '排序算法相关问题', 2, 2, 'sorting', 'sort'),
('搜索', '查找与搜索算法', 2, 2, 'searching', 'search'),
('动态规划', '动态规划相关问题', 2, 2, 'dynamic-programming', 'dp'),
('贪心算法', '贪心策略相关问题', 2, 2, 'greedy', 'greedy'),
('分治算法', '分治策略相关问题', 2, 2, 'divide-and-conquer', 'divide'),
('回溯算法', '回溯法相关问题', 2, 2, 'backtracking', 'backtrack'),
('双指针', '双指针技巧相关问题', 2, 2, 'two-pointers', 'pointers');

-- 插入二级分类-数学
INSERT INTO `problem_categories` (`name`, `description`, `parent_id`, `level`, `slug`, `icon`) VALUES
('几何', '几何问题', 3, 2, 'geometry', 'geometry'),
('概率统计', '概率与统计相关问题', 3, 2, 'probability', 'stats'),
('数论', '数论相关问题', 3, 2, 'number-theory', 'numbers'),
('组合数学', '组合数学相关问题', 3, 2, 'combinatorics', 'combine'),
('递归', '递归相关问题', 3, 2, 'recursion', 'recursion'),
('进制转换', '进制转换相关问题', 3, 2, 'base-conversion', 'conversion');

-- 插入二级分类-基础编程
INSERT INTO `problem_categories` (`name`, `description`, `parent_id`, `level`, `slug`, `icon`) VALUES
('字符串', '字符串操作相关问题', 4, 2, 'string', 'string'),
('位运算', '位操作相关问题', 4, 2, 'bit-manipulation', 'bits'),
('模拟', '模拟类问题', 4, 2, 'simulation', 'simulation'),
('约束满足', '满足条件和约束的问题', 4, 2, 'constraint-satisfaction', 'constraint');

-- 存储过程: 根据problems表的tags字段自动填充problem_category_relations表
DELIMITER //
CREATE PROCEDURE populate_problem_categories()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE problem_id INT;
    DECLARE problem_tags VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT id, tags FROM problems WHERE tags IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO problem_id, problem_tags;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 处理每个标签并添加关系
        process_tags: BEGIN
            DECLARE tag VARCHAR(50);
            DECLARE pos INT DEFAULT 1;
            DECLARE len INT DEFAULT LENGTH(problem_tags);
            DECLARE category_id INT;
            
            -- 解析逗号分隔的标签
            WHILE pos <= len DO
                -- 提取一个标签
                SET tag = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(problem_tags, ',', pos), ',', -1));
                
                -- 查找对应的分类ID
                SELECT id INTO category_id FROM problem_categories 
                WHERE name = tag OR name LIKE CONCAT('%', tag, '%') LIMIT 1;
                
                -- 如果找到分类，则添加关系
                IF category_id IS NOT NULL THEN
                    INSERT IGNORE INTO problem_category_relations (problem_id, category_id)
                    VALUES (problem_id, category_id);
                END IF;
                
                SET pos = pos + 1;
            END WHILE;
        END process_tags;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 执行存储过程填充关系表
CALL populate_problem_categories();

-- 删除临时存储过程
DROP PROCEDURE IF EXISTS populate_problem_categories; 