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

 Date: 10/03/2025 08:25:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `display_name` varchar(50) DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `gender` enum('男性','女性') DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `bio` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of user_profile
-- ----------------------------
BEGIN;
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (1, 1, 'admin', '1艾垦', 'public/uploads/avatars/avatar-1741487554262-652128186.png', '男性', '2025-01-01', '柳州', '服务器Admin\n', '2025-01-23 10:25:55', '2025-03-09 10:32:34');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (8, 3, 'test', 'test', NULL, NULL, NULL, NULL, NULL, '2025-02-05 11:10:37', '2025-02-05 11:10:37');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (11, 2, 'temp_admin', 'temp_admin', NULL, NULL, NULL, NULL, NULL, '2025-02-05 11:26:08', '2025-02-05 11:26:08');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (20, 6, 'student1', '学生1', NULL, NULL, NULL, NULL, NULL, '2025-02-05 11:53:55', '2025-02-05 11:53:55');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (21, 7, 'VIP1', '会员1', NULL, NULL, NULL, NULL, NULL, '2025-02-05 11:57:34', '2025-02-05 11:57:34');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (22, 8, 'student', 'student', NULL, NULL, NULL, NULL, NULL, '2025-03-08 10:58:41', '2025-03-08 10:58:41');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (23, 9, 'teacher', 'teacher', NULL, NULL, NULL, NULL, NULL, '2025-03-08 11:01:51', '2025-03-08 11:01:51');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
