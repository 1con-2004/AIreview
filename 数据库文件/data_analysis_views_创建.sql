-- 1. 学生解题能力分析视图 - 用于生成雷达图
CREATE OR REPLACE VIEW `v_student_problem_solving_capability` AS
SELECT 
    si.user_id,
    si.student_no,
    si.real_name,
    si.department,
    si.class_id,
    pc.name AS category_name,
    pc.parent_id,
    (
        SELECT COUNT(*)
        FROM user_problem_status ups
        JOIN problems p ON ups.problem_id = p.id
        JOIN problem_category_relations pcr ON p.id = pcr.problem_id
        WHERE ups.user_id = si.user_id
        AND pcr.category_id = pc.id
        AND ups.status = 'Accepted'
    ) AS solved_count,
    (
        SELECT COUNT(*)
        FROM problems p
        JOIN problem_category_relations pcr ON p.id = pcr.problem_id
        WHERE pcr.category_id = pc.id
    ) AS total_count,
    ROUND(
        (
            SELECT COUNT(*)
            FROM user_problem_status ups
            JOIN problems p ON ups.problem_id = p.id
            JOIN problem_category_relations pcr ON p.id = pcr.problem_id
            WHERE ups.user_id = si.user_id
            AND pcr.category_id = pc.id
            AND ups.status = 'Accepted'
        ) / 
        IF(
            (
                SELECT COUNT(*)
                FROM problems p
                JOIN problem_category_relations pcr ON p.id = pcr.problem_id
                WHERE pcr.category_id = pc.id
            ) = 0, 
            1, 
            (
                SELECT COUNT(*)
                FROM problems p
                JOIN problem_category_relations pcr ON p.id = pcr.problem_id
                WHERE pcr.category_id = pc.id
            )
        ) * 100, 
        2
    ) AS completion_rate
FROM 
    student_info si
CROSS JOIN 
    problem_categories pc
WHERE 
    pc.level = 2;

-- 2. 学生提交错误分析视图 - 用于生成饼图
CREATE OR REPLACE VIEW `v_submission_error_analysis` AS
SELECT 
    si.user_id,
    si.student_no,
    si.real_name,
    si.department,
    si.class_id,
    s.status,
    COUNT(*) AS error_count,
    ROUND(COUNT(*) * 100.0 / (
        SELECT COUNT(*) 
        FROM submissions 
        WHERE user_id = si.user_id AND status != 'Accepted'
    ), 2) AS error_percentage
FROM 
    submissions s
JOIN 
    student_info si ON s.user_id = si.user_id
WHERE 
    s.status != 'Accepted' AND s.status != 'Pending'
GROUP BY 
    si.user_id, s.status;

-- 3. 班级解题进度分析视图 - 用于生成堆叠条形图
CREATE OR REPLACE VIEW `v_class_problem_progress` AS
SELECT 
    c.id AS class_id,
    c.class_name,
    p.difficulty,
    COUNT(DISTINCT p.id) AS total_problems,
    COUNT(DISTINCT CASE WHEN ups.status = 'Accepted' THEN p.id END) AS solved_problems,
    ROUND(
        COUNT(DISTINCT CASE WHEN ups.status = 'Accepted' THEN p.id END) * 100.0 / 
        COUNT(DISTINCT p.id), 
        2
    ) AS completion_rate
FROM 
    classes c
CROSS JOIN 
    problems p
LEFT JOIN 
    student_info si ON si.class_id = c.id
LEFT JOIN 
    user_problem_status ups ON ups.problem_id = p.id AND ups.user_id = si.user_id
GROUP BY 
    c.id, p.difficulty;

-- 4. 学生解题时间分布视图 - 用于生成热力图
CREATE OR REPLACE VIEW `v_student_solving_time_distribution` AS
SELECT 
    si.user_id,
    si.student_no,
    si.real_name,
    DAYNAME(s.created_at) AS day_of_week,
    HOUR(s.created_at) AS hour_of_day,
    COUNT(*) AS submission_count
FROM 
    submissions s
JOIN 
    student_info si ON s.user_id = si.user_id
GROUP BY 
    si.user_id, DAYNAME(s.created_at), HOUR(s.created_at);

-- 5. 解题路径分析视图 - 用于生成学习路径图/流线图
CREATE OR REPLACE VIEW `v_problem_solving_path` AS
SELECT 
    s1.user_id,
    p1.id AS from_problem_id,
    p1.problem_number AS from_problem_number,
    p1.title AS from_problem_title,
    p2.id AS to_problem_id,
    p2.problem_number AS to_problem_number,
    p2.title AS to_problem_title,
    COUNT(*) AS transition_count
FROM 
    submissions s1
JOIN 
    submissions s2 ON s1.user_id = s2.user_id AND s1.id < s2.id AND 
                     s2.created_at > s1.created_at AND 
                     TIMESTAMPDIFF(HOUR, s1.created_at, s2.created_at) < 24
JOIN 
    problems p1 ON s1.problem_id = p1.id
JOIN 
    problems p2 ON s2.problem_id = p2.id
WHERE 
    p1.id != p2.id
GROUP BY 
    s1.user_id, p1.id, p2.id
HAVING 
    COUNT(*) > 1;

-- 6. 知识掌握深度分析视图 - 用于生成3D柱状图
CREATE OR REPLACE VIEW `v_knowledge_mastery_depth` AS
SELECT 
    si.user_id,
    si.student_no,
    si.real_name,
    pc.name AS category_name,
    pc.parent_id,
    ppc.name AS parent_category_name,
    COUNT(DISTINCT p.id) AS problem_count,
    AVG(CASE WHEN ups.status = 'Accepted' THEN 1 ELSE 0 END) AS mastery_rate,
    SUM(CASE 
        WHEN p.difficulty = '简单' AND ups.status = 'Accepted' THEN 1
        ELSE 0
    END) AS easy_solved,
    SUM(CASE 
        WHEN p.difficulty = '中等' AND ups.status = 'Accepted' THEN 2
        ELSE 0
    END) AS medium_solved,
    SUM(CASE 
        WHEN p.difficulty = '困难' AND ups.status = 'Accepted' THEN 3
        ELSE 0
    END) AS hard_solved,
    (
        SUM(CASE 
            WHEN p.difficulty = '简单' AND ups.status = 'Accepted' THEN 1
            ELSE 0
        END) +
        SUM(CASE 
            WHEN p.difficulty = '中等' AND ups.status = 'Accepted' THEN 2
            ELSE 0
        END) +
        SUM(CASE 
            WHEN p.difficulty = '困难' AND ups.status = 'Accepted' THEN 3
            ELSE 0
        END)
    ) AS mastery_score
FROM 
    student_info si
CROSS JOIN 
    problem_categories pc
LEFT JOIN 
    problem_categories ppc ON pc.parent_id = ppc.id
LEFT JOIN 
    problem_category_relations pcr ON pc.id = pcr.category_id
LEFT JOIN 
    problems p ON pcr.problem_id = p.id
LEFT JOIN 
    user_problem_status ups ON ups.problem_id = p.id AND ups.user_id = si.user_id
WHERE 
    pc.level = 2
GROUP BY 
    si.user_id, pc.id;

-- 7. 学生做题时长分析视图 - 用于生成箱线图
CREATE OR REPLACE VIEW `v_problem_solving_duration` AS
SELECT 
    si.user_id,
    si.student_no,
    si.real_name,
    p.id AS problem_id,
    p.problem_number,
    p.title,
    p.difficulty,
    TIMESTAMPDIFF(MINUTE, 
        (SELECT MIN(created_at) FROM submissions WHERE user_id = si.user_id AND problem_id = p.id),
        (SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM user_problem_status WHERE user_id = si.user_id AND problem_id = p.id AND status = 'Accepted')
                THEN (SELECT MIN(created_at) FROM submissions WHERE user_id = si.user_id AND problem_id = p.id AND status = 'Accepted')
                ELSE (SELECT MAX(created_at) FROM submissions WHERE user_id = si.user_id AND problem_id = p.id)
            END
        )
    ) AS solving_duration_minutes
FROM 
    student_info si
JOIN 
    submissions s ON si.user_id = s.user_id
JOIN 
    problems p ON s.problem_id = p.id
GROUP BY 
    si.user_id, p.id
HAVING 
    COUNT(s.id) > 0;

-- 8. 学习进度对比视图 - 用于生成多重比较图
CREATE OR REPLACE VIEW `v_learning_progress_comparison` AS
SELECT 
    c.id AS class_id,
    c.class_name,
    si.user_id,
    si.student_no,
    si.real_name,
    COUNT(DISTINCT CASE WHEN ups.status = 'Accepted' THEN p.id END) AS problems_solved,
    (SELECT COUNT(*) FROM problems) AS total_problems,
    ROUND(
        COUNT(DISTINCT CASE WHEN ups.status = 'Accepted' THEN p.id END) * 100.0 / 
        (SELECT COUNT(*) FROM problems), 
        2
    ) AS completion_percentage,
    AVG(CASE 
        WHEN ups.status = 'Accepted' THEN 
            TIMESTAMPDIFF(MINUTE, ups.first_submission_time, ups.last_submission_time)
        ELSE NULL
    END) AS avg_solving_time,
    (
        SELECT COUNT(*) 
        FROM submissions s 
        WHERE s.user_id = si.user_id
    ) AS total_submissions,
    (
        SELECT COUNT(*) 
        FROM submissions s 
        WHERE s.user_id = si.user_id AND s.status = 'Accepted'
    ) AS successful_submissions,
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
    ) AS success_rate
FROM 
    classes c
JOIN 
    student_info si ON si.class_id = c.id
LEFT JOIN 
    user_problem_status ups ON ups.user_id = si.user_id
LEFT JOIN 
    problems p ON ups.problem_id = p.id
GROUP BY 
    c.id, si.user_id;