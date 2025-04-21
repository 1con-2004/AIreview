-- 测试数据插入脚本
USE AIreview;

-- 插入基础角色数据
INSERT INTO `user_roles` (`id`, `role_name`, `description`) VALUES
(1, 'normal', '普通用户'),
(2, 'vip', '会员用户'),
(3, 'super_vip', '超级会员用户'),
(4, 'teacher', '教师用户'),
(5, 'admin', '管理员用户');

-- 插入基础用户数据
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `status`, `role`) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsNSEYy4/N3.8ePULuw/2', 'admin@example.com', '13800000000', 1, 'admin'),
(2, 'teacher1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsNSEYy4/N3.8ePULuw/2', 'teacher1@example.com', '13800000001', 1, 'teacher'),
(3, 'student1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsNSEYy4/N3.8ePULuw/2', 'student1@example.com', '13800000002', 1, 'normal');

-- 插入用户资料数据
INSERT INTO `user_profile` (`user_id`, `nickname`, `display_name`, `avatar_url`, `bio`) VALUES
(1, 'Admin', '系统管理员', 'http://localhost:8080/static/avatars/admin.png', '系统管理员账号'),
(2, 'Teacher', '示例教师', 'http://localhost:8080/static/avatars/teacher.png', '示例教师账号'),
(3, 'Student', '示例学生', 'http://localhost:8080/static/avatars/student.png', '示例学生账号');

-- 插入班级信息
INSERT INTO `classes` (`id`, `class_name`) VALUES
(1, '计算机科学2025级1班'),
(2, '软件工程2025级1班');

-- 插入学生信息
INSERT INTO `student_info` (`user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `class_id`) VALUES
(3, '202500001', '张三', '计算机学院', '计算机科学与技术', '2025', 1);

-- 插入编程语言
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`) VALUES
(1, 'Python', 'def solution(input_data):\n    # 请在此实现你的算法\n    pass\n'),
(2, 'Java', 'class Solution {\n    public static void main(String[] args) {\n        // 请在此实现你的算法\n    }\n}'),
(3, 'C++', '#include <iostream>\nusing namespace std;\n\nint main() {\n    // 请在此实现你的算法\n    return 0;\n}'),
(4, 'JavaScript', 'function solution(input) {\n    // 请在此实现你的算法\n    return null;\n}');

-- 插入社区数据
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `created_by`, `status`) VALUES
(1, '官方社区', 'official', '平台官方社区，分享编程经验和技巧', 1, 1),
(2, '计算机学院社区', 'college', '计算机学院专属交流社区', 2, 1),
(3, '计算机科学2025级1班社区', 'class', '班级内部交流社区', 2, 1);

-- 插入社区成员
INSERT INTO `community_members` (`community_id`, `user_id`, `role`) VALUES
(1, 1, 'owner'),
(1, 2, 'member'),
(1, 3, 'member'),
(2, 2, 'owner'),
(2, 3, 'member'),
(3, 2, 'owner'),
(3, 3, 'member');

-- 插入社区公告
INSERT INTO `community_announcements` (`community_id`, `community_name`, `announcement`) VALUES
(1, '官方社区', '欢迎来到官方社区，请遵守社区规则，友好交流！'),
(2, '计算机学院社区', '欢迎计算机学院的同学们，这里是我们的专属交流空间！'),
(3, '计算机科学2025级1班社区', '欢迎班级同学，这里可以讨论课程、作业等话题！');

-- 插入题目分类
INSERT INTO `problem_categories` (`id`, `name`, `description`, `level`, `slug`) VALUES
(1, '算法', '算法相关题目', 1, 'algorithm'),
(2, '数据结构', '数据结构相关题目', 1, 'data-structure'),
(3, '动态规划', '动态规划相关题目', 2, 'dynamic-programming'),
(4, '贪心算法', '贪心算法相关题目', 2, 'greedy'),
(5, '数组', '数组相关题目', 2, 'array'),
(6, '链表', '链表相关题目', 2, 'linked-list');

-- 插入示例题目
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`) VALUES
(1, 'P001', '两数之和', '简单', '数组,哈希表', '给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那两个整数，并返回他们的数组下标。\n\n你可以假设每种输入只会对应一个答案。但是，数组中同一个元素不能使用两遍。\n\n示例:\n给定 nums = [2, 7, 11, 15], target = 9\n因为 nums[0] + nums[1] = 2 + 7 = 9\n所以返回 [0, 1]', 1000, 256),
(2, 'P002', '反转链表', '简单', '链表', '反转一个单链表。\n\n示例:\n输入: 1->2->3->4->5->NULL\n输出: 5->4->3->2->1->NULL\n\n进阶:\n你可以迭代或递归地反转链表。你能否用两种方法解决这道题？', 1000, 256);

-- 插入测试用例
INSERT INTO `problem_test_cases` (`problem_id`, `problem_number`, `input`, `output`, `is_example`) VALUES
(1, 'P001', '[2,7,11,15]\n9', '[0,1]', 1),
(1, 'P001', '[3,2,4]\n6', '[1,2]', 1),
(2, 'P002', '[1,2,3,4,5]', '[5,4,3,2,1]', 1);

-- 插入题目解答
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`) VALUES
(1, 1, 'P001', '使用哈希表存储每个元素的值和索引，遍历数组时，检查当前元素与目标值的差是否存在于哈希表中。', 'O(n)', 'O(n)'),
(2, 2, 'P002', '使用三个指针：prev、current和next，遍历链表，改变指针方向。', 'O(n)', 'O(1)');

-- 插入题目解答代码
INSERT INTO `solution_code` (`solution_id`, `language_id`, `standard_solution`) VALUES
(1, 1, 'def two_sum(nums, target):\n    hash_map = {}\n    for i, num in enumerate(nums):\n        complement = target - num\n        if complement in hash_map:\n            return [hash_map[complement], i]\n        hash_map[num] = i\n    return []'),
(1, 2, 'public int[] twoSum(int[] nums, int target) {\n    Map<Integer, Integer> map = new HashMap<>();\n    for (int i = 0; i < nums.length; i++) {\n        int complement = target - nums[i];\n        if (map.containsKey(complement)) {\n            return new int[] { map.get(complement), i };\n        }\n        map.put(nums[i], i);\n    }\n    throw new IllegalArgumentException("No two sum solution");\n}'),
(2, 1, 'def reverse_list(head):\n    prev = None\n    current = head\n    while current:\n        next_temp = current.next\n        current.next = prev\n        prev = current\n        current = next_temp\n    return prev'),
(2, 2, 'public ListNode reverseList(ListNode head) {\n    ListNode prev = null;\n    ListNode curr = head;\n    while (curr != null) {\n        ListNode nextTemp = curr.next;\n        curr.next = prev;\n        prev = curr;\n        curr = nextTemp;\n    }\n    return prev;\n}');

-- 插入学习计划
INSERT INTO `learning_plans` (`id`, `title`, `description`, `tag`, `difficulty_level`, `estimated_days`, `user_id`) VALUES
(1, '算法入门', '适合初学者的算法入门学习计划', '算法', '简单', 7, NULL),
(2, '数据结构基础', '掌握常见数据结构的使用和实现', '数据结构', '中等', 14, NULL);

-- 插入学习计划题目
INSERT INTO `learning_plan_problems` (`plan_id`, `problem_id`, `problem_number`, `order_index`, `section`) VALUES
(1, 1, 'P001', 1, '哈希表应用'),
(2, 2, 'P002', 1, '链表操作');

-- 创建课堂
INSERT INTO `classrooms` (`id`, `classroom_code`, `teacher_id`, `title`, `description`, `status`) VALUES
(1, 'CS101', 2, '数据结构与算法基础', '本课程讲解数据结构与算法的基本概念和应用', 1); 