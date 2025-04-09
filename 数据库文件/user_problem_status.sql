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

 Date: 07/03/2025 09:02:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user_problem_status
-- ----------------------------
DROP TABLE IF EXISTS `user_problem_status`;
CREATE TABLE `user_problem_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `problem_id` int NOT NULL COMMENT '题目ID',
  `status` enum('Not Attempted','Wrong Answer','Accepted','Runtime Error','Compilation Error','Time Limit Exceeded','Memory Limit Exceeded') COLLATE utf8mb4_unicode_ci DEFAULT 'Not Attempted',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `first_submission_time` timestamp NULL DEFAULT NULL COMMENT '首次提交时间',
  `last_submission_time` timestamp NULL DEFAULT NULL COMMENT '最后提交时间',
  `submission_count` int DEFAULT '0' COMMENT '提交次数',
  `average_execution_time` float DEFAULT NULL COMMENT '平均执行时间',
  `average_memory_usage` float DEFAULT NULL COMMENT '平均内存使用',
  `viewed_solution` tinyint(1) DEFAULT '0' COMMENT '是否查看过题解',
  `completed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_problem` (`user_id`,`problem_id`),
  KEY `idx_problem_id` (`problem_id`),
  CONSTRAINT `fk_status_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`),
  CONSTRAINT `fk_status_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=305 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户通过的题目表';

-- ----------------------------
-- Records of user_problem_status
-- ----------------------------
BEGIN;
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (1, 1, 7, 'Accepted', '2025-01-22 16:39:17', '2025-01-22 16:39:17', NULL, NULL, 0, NULL, NULL, 0, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (2, 1, 2, 'Accepted', '2025-01-23 09:11:27', '2025-01-24 16:14:37', NULL, NULL, 0, NULL, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (3, 1, 6, 'Accepted', '2025-01-23 10:09:25', '2025-01-23 10:09:25', NULL, NULL, 0, NULL, NULL, 0, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (4, 1, 8, 'Accepted', '2025-01-23 14:06:41', '2025-01-23 14:06:41', NULL, NULL, 0, NULL, NULL, 0, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (6, 1, 1, 'Accepted', '2025-01-23 16:24:22', '2025-02-17 17:02:16', NULL, NULL, 11, 1286.42, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (7, 1, 3, 'Accepted', '2025-01-23 16:25:05', '2025-01-26 13:05:05', NULL, NULL, 1, 0, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (8, 1, 4, 'Accepted', '2025-01-23 16:28:13', '2025-01-25 12:27:28', NULL, NULL, 0, NULL, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (9, 1, 5, 'Accepted', '2025-01-23 16:28:33', '2025-01-23 16:28:33', NULL, NULL, 0, NULL, NULL, 0, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (23, 1, 9, 'Accepted', '2025-01-25 09:25:48', '2025-01-25 10:21:55', NULL, NULL, 2, 0, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (48, 1, 10, 'Accepted', '2025-01-25 12:17:20', '2025-01-26 12:39:24', NULL, NULL, 1, 0, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (50, 1, 11, 'Accepted', '2025-01-25 12:18:32', '2025-01-26 11:59:04', NULL, NULL, 4, 0, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (91, 1, 19, 'Accepted', '2025-01-26 12:00:32', '2025-01-26 12:04:21', NULL, NULL, 3, 0, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (116, 1, 15, 'Accepted', '2025-01-26 12:09:18', '2025-01-26 12:10:01', NULL, NULL, 1, 0, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (155, 1, 17, 'Accepted', '2025-01-26 12:42:29', '2025-01-26 12:55:36', NULL, NULL, 2, 0, NULL, 1, '2025-02-05 13:14:33');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
