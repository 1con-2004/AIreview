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

 Date: 10/03/2025 08:51:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for classroom_discussions
-- ----------------------------
DROP TABLE IF EXISTS `classroom_discussions`;
CREATE TABLE `classroom_discussions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `classroom_id` int NOT NULL COMMENT '关联课堂ID',
  `user_id` int NOT NULL COMMENT '发送用户ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_discussion_classroom` (`classroom_id`),
  KEY `fk_discussion_user` (`user_id`),
  CONSTRAINT `fk_discussion_classroom` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_discussion_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂讨论表';

-- ----------------------------
-- Records of classroom_discussions
-- ----------------------------
BEGIN;
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (1, 1, 1, 'hi', '2025-03-06 09:48:31');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (2, 1, 1, 'hi', '2025-03-06 09:56:20');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (3, 1, 1, 'hi', '2025-03-06 09:58:56');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (4, 1, 1, 'hi', '2025-03-06 09:58:58');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (5, 1, 1, '你好', '2025-03-06 10:02:01');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
