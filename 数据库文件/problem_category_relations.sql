/*
 Navicat Premium Dump SQL

 Source Server         : Docker下的数据库
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3307
 Source Schema         : AIreview

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 22/04/2025 22:33:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for problem_category_relations
-- ----------------------------
DROP TABLE IF EXISTS `problem_category_relations`;
CREATE TABLE `problem_category_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '问题ID',
  `category_id` int NOT NULL COMMENT '分类ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `problem_id` (`problem_id`,`category_id`),
  KEY `problem_id_2` (`problem_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of problem_category_relations
-- ----------------------------
BEGIN;
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (1, 1, 29, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (2, 1, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (3, 2, 29, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (4, 2, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (5, 3, 18, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (6, 4, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (7, 4, 21, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (8, 5, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (9, 5, 23, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (10, 6, 29, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (11, 6, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (12, 7, 29, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (13, 7, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (14, 8, 18, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (15, 9, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (16, 9, 21, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (17, 10, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (18, 10, 23, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (19, 11, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (20, 11, 19, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (21, 12, 18, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (22, 13, 18, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (23, 14, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (24, 14, 24, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (25, 15, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (26, 15, 23, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (27, 16, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (28, 16, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (29, 17, 18, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (30, 18, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (31, 18, 24, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (32, 19, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (33, 19, 24, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (34, 20, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (35, 21, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (36, 22, 18, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (37, 23, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (38, 23, 21, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (39, 25, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (40, 25, 23, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (41, 29, 3, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (42, 29, 22, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (43, 30, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (44, 30, 24, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (45, 30, 25, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (46, 33, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (47, 34, 20, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (48, 34, 17, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (49, 38, 26, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (50, 38, 27, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (51, 42, 18, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (52, 42, 28, '2025-04-18 08:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (53, 43, 26, '2025-04-20 11:05:04');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (54, 43, 27, '2025-04-20 11:05:04');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
