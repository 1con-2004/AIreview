-- 临时关闭外键约束检查
SET FOREIGN_KEY_CHECKS = 0;

-- 清空表数据
TRUNCATE TABLE AIreview.classes;
TRUNCATE TABLE AIreview.classroom_discussions;
TRUNCATE TABLE AIreview.classroom_files;
TRUNCATE TABLE AIreview.classroom_messages;
TRUNCATE TABLE AIreview.classrooms;
TRUNCATE TABLE AIreview.communities;
TRUNCATE TABLE AIreview.community_announcements;
TRUNCATE TABLE AIreview.community_members;
TRUNCATE TABLE AIreview.learning_path_directions;
TRUNCATE TABLE AIreview.learning_path_recommend;
TRUNCATE TABLE AIreview.learning_path_weakness_analysis;
TRUNCATE TABLE AIreview.learning_plan_problems;
TRUNCATE TABLE AIreview.learning_plans;
TRUNCATE TABLE AIreview.likes;
TRUNCATE TABLE AIreview.posts;
TRUNCATE TABLE AIreview.problem_categories;
TRUNCATE TABLE AIreview.problem_categories_backup;
TRUNCATE TABLE AIreview.problem_category_relations;
TRUNCATE TABLE AIreview.problem_pool;
TRUNCATE TABLE AIreview.problem_pool_categories;
TRUNCATE TABLE AIreview.problem_pool_solution_code;
TRUNCATE TABLE AIreview.problem_pool_solutions;
TRUNCATE TABLE AIreview.problem_pool_test_cases;
TRUNCATE TABLE AIreview.problem_pool_usage;
TRUNCATE TABLE AIreview.problem_test_cases;
TRUNCATE TABLE AIreview.problems;
TRUNCATE TABLE AIreview.solution_code;
TRUNCATE TABLE AIreview.solution_languages;
TRUNCATE TABLE AIreview.solution_main;
TRUNCATE TABLE AIreview.student_info;
TRUNCATE TABLE AIreview.submissions;
TRUNCATE TABLE AIreview.user_profile;
TRUNCATE TABLE AIreview.user_roles;
TRUNCATE TABLE AIreview.user_visits;
TRUNCATE TABLE AIreview.users;

-- 重新启用外键约束检查
SET FOREIGN_KEY_CHECKS = 1; 