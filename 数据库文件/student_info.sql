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

 Date: 10/03/2025 08:36:50
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for student_info
-- ----------------------------
DROP TABLE IF EXISTS `student_info`;
CREATE TABLE `student_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '关联用户ID',
  `student_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学号',
  `real_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '真实姓名',
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '院系',
  `major` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '专业',
  `grade` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '年级',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `class_id` int DEFAULT NULL COMMENT '关联班级ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_no` (`student_no`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  KEY `fk_student_class` (`class_id`),
  CONSTRAINT `fk_student_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学生信息表';

-- ----------------------------
-- Records of student_info
-- ----------------------------
BEGIN;
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (1, 1, '202313008218', '吴益通', '人文学院', '舞蹈学', '2023', '2025-03-04 14:44:14', '2025-03-05 09:16:48', 3);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (3, 7, '202313008222', '里里', '', '', '', '2025-03-04 15:42:17', NULL, NULL);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
