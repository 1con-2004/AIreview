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

 Date: 10/03/2025 08:53:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for classroom_messages
-- ----------------------------
DROP TABLE IF EXISTS `classroom_messages`;
CREATE TABLE `classroom_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `classroom_id` int NOT NULL COMMENT '关联课堂ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_message_classroom` (`classroom_id`),
  CONSTRAINT `fk_message_classroom` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂留言表';

-- ----------------------------
-- Records of classroom_messages
-- ----------------------------
BEGIN;
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (1, 1, 'JAVA的开发基础：C语言', '2025-03-06 08:12:03');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (2, 1, '这是最新的逻辑', '2025-03-06 10:16:41');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (3, 1, '新1', '2025-03-06 10:16:46');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (4, 1, '新2', '2025-03-06 10:16:48');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (5, 1, '新3', '2025-03-06 10:16:51');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (6, 1, '新4', '2025-03-06 10:16:55');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
