-- 1. 创建学生学习行为分析表 - 用于记录学生的学习过程和行为
CREATE TABLE `student_learning_behaviors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `behavior_type` enum('submission','view_solution','practice','review','tutorial_view') NOT NULL COMMENT '行为类型',
  `problem_id` int DEFAULT NULL COMMENT '题目ID',
  `category_id` int DEFAULT NULL COMMENT '分类ID',
  `time_spent` int DEFAULT NULL COMMENT '花费时间(秒)',
  `behavior_date` date NOT NULL COMMENT '行为日期',
  `behavior_time` time NOT NULL COMMENT '行为时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_problem_id` (`problem_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_behavior_date` (`behavior_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生学习行为记录表';

-- 2. 创建学习路径进度表 - 跟踪学生在各个学习路径上的进度
CREATE TABLE `student_learning_path_progress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `path_id` int NOT NULL COMMENT '学习路径ID',
  `current_node` int DEFAULT NULL COMMENT '当前节点ID',
  `completed_nodes` int DEFAULT 0 COMMENT '已完成节点数',
  `total_nodes` int DEFAULT 0 COMMENT '总节点数',
  `progress_percentage` decimal(5,2) DEFAULT 0.00 COMMENT '完成百分比',
  `start_date` date DEFAULT NULL COMMENT '开始日期',
  `last_activity_date` date DEFAULT NULL COMMENT '最后活动日期',
  `estimated_completion_date` date DEFAULT NULL COMMENT '预计完成日期',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_path` (`user_id`,`path_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_path_id` (`path_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学习路径进度表';

-- 3. 创建学生能力评估表 - 基于各种指标评估学生的整体编程能力
CREATE TABLE `student_skill_assessment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `category_id` int DEFAULT NULL COMMENT '技能分类ID',
  `skill_name` varchar(50) NOT NULL COMMENT '技能名称',
  `skill_level` decimal(5,2) DEFAULT 0.00 COMMENT '技能水平 (0-100)',
  `assessment_date` date NOT NULL COMMENT '评估日期',
  `previous_level` decimal(5,2) DEFAULT NULL COMMENT '上次评估水平',
  `growth_rate` decimal(5,2) DEFAULT NULL COMMENT '成长率',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_skill_date` (`user_id`,`skill_name`,`assessment_date`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_assessment_date` (`assessment_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生能力评估表';

-- 4. 创建班级学习热度表 - 记录班级整体的学习活跃度
CREATE TABLE `class_activity_heatmap` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL COMMENT '班级ID',
  `activity_date` date NOT NULL COMMENT '活动日期',
  `hour_0` int DEFAULT 0 COMMENT '0点活跃度',
  `hour_1` int DEFAULT 0 COMMENT '1点活跃度',
  `hour_2` int DEFAULT 0 COMMENT '2点活跃度',
  `hour_3` int DEFAULT 0 COMMENT '3点活跃度',
  `hour_4` int DEFAULT 0 COMMENT '4点活跃度',
  `hour_5` int DEFAULT 0 COMMENT '5点活跃度',
  `hour_6` int DEFAULT 0 COMMENT '6点活跃度',
  `hour_7` int DEFAULT 0 COMMENT '7点活跃度',
  `hour_8` int DEFAULT 0 COMMENT '8点活跃度',
  `hour_9` int DEFAULT 0 COMMENT '9点活跃度',
  `hour_10` int DEFAULT 0 COMMENT '10点活跃度',
  `hour_11` int DEFAULT 0 COMMENT '11点活跃度',
  `hour_12` int DEFAULT 0 COMMENT '12点活跃度',
  `hour_13` int DEFAULT 0 COMMENT '13点活跃度',
  `hour_14` int DEFAULT 0 COMMENT '14点活跃度',
  `hour_15` int DEFAULT 0 COMMENT '15点活跃度',
  `hour_16` int DEFAULT 0 COMMENT '16点活跃度',
  `hour_17` int DEFAULT 0 COMMENT '17点活跃度',
  `hour_18` int DEFAULT 0 COMMENT '18点活跃度',
  `hour_19` int DEFAULT 0 COMMENT '19点活跃度',
  `hour_20` int DEFAULT 0 COMMENT '20点活跃度',
  `hour_21` int DEFAULT 0 COMMENT '21点活跃度',
  `hour_22` int DEFAULT 0 COMMENT '22点活跃度',
  `hour_23` int DEFAULT 0 COMMENT '23点活跃度',
  `total_activity` int DEFAULT 0 COMMENT '总活跃度',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_date` (`class_id`,`activity_date`),
  KEY `idx_class_id` (`class_id`),
  KEY `idx_activity_date` (`activity_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级学习热度表';

-- 5. 创建题目关联分析表 - 记录不同题目之间的关联程度
CREATE TABLE `problem_correlation_analysis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id_1` int NOT NULL COMMENT '题目1 ID',
  `problem_id_2` int NOT NULL COMMENT '题目2 ID',
  `correlation_score` decimal(5,2) DEFAULT 0.00 COMMENT '关联度分数 (0-100)',
  `solved_together_count` int DEFAULT 0 COMMENT '一起解决的次数',
  `common_categories_count` int DEFAULT 0 COMMENT '共同分类数',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_problem_pair` (`problem_id_1`,`problem_id_2`),
  KEY `idx_problem_id_1` (`problem_id_1`),
  KEY `idx_problem_id_2` (`problem_id_2`),
  KEY `idx_correlation_score` (`correlation_score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目关联分析表';

-- 6. 创建问题难度趋势表 - 记录一段时间内题目难度的变化趋势
CREATE TABLE `problem_difficulty_trend` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `assessment_date` date NOT NULL COMMENT '评估日期',
  `average_attempts` decimal(5,2) DEFAULT NULL COMMENT '平均尝试次数',
  `success_rate` decimal(5,2) DEFAULT NULL COMMENT '成功率',
  `average_solving_time` int DEFAULT NULL COMMENT '平均解决时间(分钟)',
  `calculated_difficulty` decimal(5,2) DEFAULT NULL COMMENT '计算得出的难度分值 (0-100)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_problem_date` (`problem_id`,`assessment_date`),
  KEY `idx_problem_id` (`problem_id`),
  KEY `idx_assessment_date` (`assessment_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目难度趋势表';

-- 创建学生综合分析视图 - 用于3D气泡图
CREATE OR REPLACE VIEW `v_student_comprehensive_analysis` AS
SELECT 
    si.user_id,
    si.student_no,
    si.real_name,
    si.department,
    si.class_id,
    COUNT(DISTINCT CASE WHEN ups.status = 'Accepted' THEN ups.problem_id END) AS problems_solved,
    (
        SELECT COUNT(*) 
        FROM submissions s 
        WHERE s.user_id = si.user_id
    ) AS submission_count,
    ROUND(
        (
            SELECT COUNT(*) 
            FROM submissions s 
            WHERE s.user_id = si.user_id AND s.status = 'Accepted'
        ) * 100.0 / 
        IF(
            (
                SELECT COUNT(*) 
                FROM submissions s 
                WHERE s.user_id = si.user_id
            ) = 0, 
            1, 
            (
                SELECT COUNT(*) 
                FROM submissions s 
                WHERE s.user_id = si.user_id
            )
        ), 
        2
    ) AS success_rate,
    AVG(
        CASE 
            WHEN p.difficulty = '简单' THEN 1
            WHEN p.difficulty = '中等' THEN 2
            WHEN p.difficulty = '困难' THEN 3
            ELSE 0
        END
    ) AS avg_difficulty_solved
FROM 
    student_info si
LEFT JOIN 
    user_problem_status ups ON si.user_id = ups.user_id
LEFT JOIN 
    problems p ON ups.problem_id = p.id
GROUP BY 
    si.user_id;

-- 创建班级层次结构视图 - 用于树状结构图或桑基图
CREATE OR REPLACE VIEW `v_class_hierarchy_visualization` AS
WITH department_stats AS (
    SELECT 
        si.department,
        COUNT(DISTINCT si.user_id) AS student_count,
        COUNT(DISTINCT si.class_id) AS class_count
    FROM 
        student_info si
    WHERE 
        si.department IS NOT NULL
    GROUP BY 
        si.department
),
class_stats AS (
    SELECT 
        si.department,
        si.class_id,
        c.class_name,
        COUNT(DISTINCT si.user_id) AS student_count,
        SUM(CASE WHEN ups.status = 'Accepted' THEN 1 ELSE 0 END) AS problem_solved_count,
        COUNT(DISTINCT p.id) AS total_problem_count
    FROM 
        student_info si
    JOIN 
        classes c ON si.class_id = c.id
    LEFT JOIN 
        user_problem_status ups ON si.user_id = ups.user_id
    LEFT JOIN 
        problems p ON ups.problem_id = p.id
    WHERE 
        si.department IS NOT NULL AND si.class_id IS NOT NULL
    GROUP BY 
        si.department, si.class_id
)
SELECT 
    ds.department,
    ds.student_count AS department_student_count,
    ds.class_count,
    cs.class_id,
    cs.class_name,
    cs.student_count AS class_student_count,
    cs.problem_solved_count,
    cs.total_problem_count,
    ROUND(
        cs.problem_solved_count * 100.0 / 
        IF(cs.total_problem_count = 0, 1, cs.total_problem_count), 
        2
    ) AS completion_rate
FROM 
    department_stats ds
LEFT JOIN 
    class_stats cs ON ds.department = cs.department;

-- 数据填充存储过程: 根据现有数据生成一些学生学习行为数据
DELIMITER //
CREATE PROCEDURE generate_student_learning_behaviors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id INT;
    DECLARE problem_id INT;
    DECLARE category_id INT;
    DECLARE submission_date DATETIME;
    DECLARE behavior_type VARCHAR(20);
    DECLARE time_spent INT;
    
    -- 从submissions表中获取数据
    DECLARE cur CURSOR FOR 
        SELECT s.user_id, s.problem_id, pcr.category_id, s.created_at
        FROM submissions s
        LEFT JOIN problem_category_relations pcr ON s.problem_id = pcr.problem_id
        WHERE pcr.category_id IS NOT NULL;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- 先清空表
    TRUNCATE TABLE student_learning_behaviors;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO user_id, problem_id, category_id, submission_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 添加提交行为
        SET behavior_type = 'submission';
        SET time_spent = FLOOR(RAND() * 600) + 60; -- 60-660秒
        
        INSERT INTO student_learning_behaviors 
            (user_id, behavior_type, problem_id, category_id, time_spent, behavior_date, behavior_time)
        VALUES 
            (user_id, behavior_type, problem_id, category_id, time_spent, 
             DATE(submission_date), TIME(submission_date));
        
        -- 有50%的概率添加查看解决方案行为
        IF RAND() < 0.5 THEN
            SET behavior_type = 'view_solution';
            SET time_spent = FLOOR(RAND() * 300) + 30; -- 30-330秒
            
            INSERT INTO student_learning_behaviors 
                (user_id, behavior_type, problem_id, category_id, time_spent, behavior_date, behavior_time)
            VALUES 
                (user_id, behavior_type, problem_id, category_id, time_spent, 
                 DATE(submission_date), ADDTIME(TIME(submission_date), '00:10:00'));
        END IF;
        
        -- 有30%的概率添加复习行为
        IF RAND() < 0.3 THEN
            SET behavior_type = 'review';
            SET time_spent = FLOOR(RAND() * 900) + 300; -- 300-1200秒
            
            INSERT INTO student_learning_behaviors 
                (user_id, behavior_type, problem_id, category_id, time_spent, behavior_date, behavior_time)
            VALUES 
                (user_id, behavior_type, problem_id, category_id, time_spent, 
                 DATE(DATE_ADD(submission_date, INTERVAL 1 DAY)), 
                 ADDTIME(TIME(submission_date), '00:00:00'));
        END IF;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;

-- 执行存储过程填充学习行为数据
CALL generate_student_learning_behaviors();

-- 删除临时存储过程
DROP PROCEDURE IF EXISTS generate_student_learning_behaviors; 