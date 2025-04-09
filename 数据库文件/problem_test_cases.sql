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

 Date: 03/04/2025 21:43:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for problem_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `problem_test_cases`;
CREATE TABLE `problem_test_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL,
  `input` text NOT NULL,
  `output` text NOT NULL,
  `is_example` tinyint(1) DEFAULT '0' COMMENT '是否为显示样例',
  `order_num` int DEFAULT '0' COMMENT '测试用例顺序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `fk_problem_test_cases` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of problem_test_cases
-- ----------------------------
BEGIN;
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (1, 1, '2 3', '5', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (2, 2, '5\n1 5 3 8 2', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (3, 3, 'hello', 'olleh', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (4, 4, '5', '120', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (5, 5, '7', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (6, 6, '5 3', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (7, 7, '5\n4 2 7 1 9', '1', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (8, 8, 'abc def', 'abcdef', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (9, 9, '6', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (10, 10, '8', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (11, 11, '5\n9 3 6 2 7', '2 3 6 7 9', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (12, 12, 'apple p', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (13, 13, 'hello world world java', 'hello java', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (14, 14, '12 18', '6', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (15, 15, '121', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (16, 16, '2 2\n1 2\n3 4\n5 6\n7 8', '6 8\n10 12', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (17, 17, 'I love programming', 'programming love I', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (18, 18, '5', '1\n1 1\n1 2 1\n1 3 3 1\n1 4 6 4 1', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (19, 19, '10 20', '11 13 17 19', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (20, 20, '6\n1 2 2 3 3 3', '1 2 3', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (21, 21, '5\n1 2 3 4 5', '15', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (22, 22, 'hello', 'olleh', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (23, 23, '6', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (24, 25, '8', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (25, 29, '1010', '10', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (26, 30, '6\n100 4 200 1 3 2', '4', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (27, 33, '1 1', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (28, 34, '11', '11', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (32, 1, '10 20', '30', 0, 2, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (33, 1, '-5 8', '3', 0, 3, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (34, 1, '0 0', '0', 0, 4, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (35, 1, '999 1', '1000', 0, 5, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
