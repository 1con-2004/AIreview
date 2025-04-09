/*
 Navicat Premium Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : AIreview

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 04/04/2025 17:14:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for solution_main
-- ----------------------------
DROP TABLE IF EXISTS `solution_main`;
CREATE TABLE `solution_main` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `solution_approach` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通用解题思路',
  `time_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均时间复杂度',
  `space_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均空间复杂度',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_main_problem` (`problem_id`),
  CONSTRAINT `fk_main_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of solution_main
-- ----------------------------
BEGIN;
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (1, 1, '直接读取两个整数并相加输出即可。注意使用scanf读取输入，printf输出结果。1', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-24 15:02:09');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (2, 2, '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最大值，遍历数组更新最大值。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (3, 3, '读取字符串后，从后向前遍历字符串，依次输出每个字符即可得到反转结果。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (4, 4, '使用循环从1乘到n，注意使用long long类型避免整数溢出。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (5, 5, '定义isPrime函数判断是否为质数。从2到sqrt(n)遍历，如果n能被任何数整除则不是质数。', 'O(sqrt(n))', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (6, 6, '直接读取两个整数并相减输出即可。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (7, 7, '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最小值，遍历数组更新最小值。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (8, 8, '读取两个字符串后直接拼接输出即可。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (9, 9, '使用循环计算斐波那契数列。维护两个变量记录前两个数，不断更新得到下一个数。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (10, 10, '判断一个数除以2的余数是否为0即可。使用取模运算符%。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (11, 11, '使用冒泡排序算法，通过两层循环不断比较相邻元素并交换位置，将最大的元素逐步\"冒泡\"到数组末尾。', 'O(n^2)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (12, 12, '遍历字符串，统计目标字符出现的次数。使用循环和计数器实现。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (13, 13, '使用strtok函数分割字符串，遍历所有单词，跳过\"world\"单词不输出。注意处理空格和字符串拼接。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (14, 14, '使用欧几里得算法（辗转相除法）求最大公约数。递归实现：当b为0时返回a，否则递归计算gcd(b, a%b)。', 'O(log(min(a,b)))', 'O(log(min(a,b)))', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (15, 15, '将数字反转，如果反转后的数字等于原数字，则是回文数。使用取模和除法运算逐位提取数字并重新组合。', 'O(log n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (16, 16, '使用二维数组存储两个矩阵，对应位置的元素相加即可。注意输出格式的处理。', 'O(n*m)', 'O(n*m)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (17, 17, '先将字符串按空格分割成单词数组，然后从后向前遍历数组输出单词。注意处理单词之间的空格。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (18, 18, '使用二维数组存储杨辉三角，每个数是上一行相邻两个数的和。第一列全为1，其他位置的值等于上一行的相邻两个数之和。', 'O(n^2)', 'O(n^2)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (19, 19, '在给定范围内遍历每个数，使用isPrime函数判断是否为质数。注意输出格式，数字之间需要空格分隔。', 'O((end-start)*sqrt(max(end)))', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (20, 20, '使用一个新数组存储不重复的元素。遍历原数组，对于每个元素，检查是否已经在新数组中存在，如果不存在则添加到新数组。', 'O(n^2)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (21, 21, '使用一个变量sum累加数组中的每个元素。遍历一次数组即可得到总和。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (22, 22, '从字符串末尾向前遍历，依次输出每个字符即可得到反转的字符串。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (23, 23, '使用迭代方法计算斐波那契数列。维护三个变量a、b、c，其中a和b分别表示前两个数，c用于计算它们的和。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (25, 25, '判断一个数是否为偶数，只需要判断它除以2的余数是否为0。使用取模运算符%即可。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (29, 29, '从左到右遍历二进制字符串，对于每一位，将当前结果乘2再加上当前位的值。注意字符转数字需要减去字符\'0\'的ASCII值。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (33, 33, '对应题目0027', 'O(N)', 'O(1)', '2025-02-25 18:45:04', '2025-04-04 11:30:47');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (34, 30, '对应题目0028', '', '', '2025-02-25 18:49:52', '2025-04-04 11:30:52');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (35, 34, '对应题目0029', '11', '11', '2025-02-25 19:00:52', '2025-04-04 11:30:57');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (36, 37, '测试用例3', 'n', '1', '2025-04-04 11:13:32', '2025-04-04 11:13:32');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
