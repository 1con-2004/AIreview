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

 Date: 04/04/2025 11:11:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for solution_languages
-- ----------------------------
DROP TABLE IF EXISTS `solution_languages`;
CREATE TABLE `solution_languages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `language_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '编程语言名称',
  `code_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '代码模板',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_language` (`language_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of solution_languages
-- ----------------------------
BEGIN;
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (1, 'c', '#include <stdio.h>\n\nint main() {\n    // 你的代码\n    return 0;\n}', '2025-02-09 20:35:22');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (2, 'python', 'def solution():\n    # 你的代码\n    pass', '2025-02-09 20:40:33');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (3, 'java', 'public class Solution {\n    public static void main(String[] args) {\n        // 你的代码\n    }\n}', '2025-02-09 20:40:33');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (4, 'cpp', '#include <iostream>\nusing namespace std;\n\nint main() {\n    // 代码实现\n    return 0;\n}', '2025-02-09 20:53:23');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
