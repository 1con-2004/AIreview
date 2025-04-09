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

 Date: 07/03/2025 08:25:30
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for classrooms
-- ----------------------------
DROP TABLE IF EXISTS `classrooms`;
CREATE TABLE `classrooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `classroom_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '课堂码',
  `teacher_id` int NOT NULL COMMENT '创建教师ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '课堂标题',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '课堂描述',
  `status` tinyint(1) DEFAULT '1' COMMENT '课堂状态：0-关闭，1-开放',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_classroom_code` (`classroom_code`),
  KEY `fk_classroom_teacher` (`teacher_id`),
  CONSTRAINT `fk_classroom_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂信息表';

-- ----------------------------
-- Records of classrooms
-- ----------------------------
BEGIN;
INSERT INTO `classrooms` (`id`, `classroom_code`, `teacher_id`, `title`, `description`, `status`, `created_at`, `updated_at`) VALUES (1, 'BWXHW', 1, 'JAVA', 'JAVA', 0, '2025-03-06 08:11:19', '2025-03-07 08:22:45');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
