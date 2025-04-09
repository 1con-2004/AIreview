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

 Date: 10/03/2025 08:25:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('normal','vip','super_vip','teacher','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '用户角色',
  `role_expire_time` timestamp NULL DEFAULT NULL COMMENT '角色过期时间（针对会员）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_phone` (`phone`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (1, 'admin', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'admin@example.com', NULL, '2025-01-22 12:15:35', 1, NULL, 'admin', NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (2, 'temp_admin', '$2b$10$YEiRwJpQj9HvKxwQX9VYpOyy0qzHVVv5EZOyVQHCxVNZyqP.JVmPi', 'temp@example.com', NULL, '2025-01-22 12:27:37', 1, NULL, 'super_vip', NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (3, 'test', 'test123', '123@qq.com', NULL, '2025-01-24 10:03:39', 1, NULL, 'teacher', NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (6, 'student1', '$2b$10$kti7yxUgaM9A3Mngg4VAk.aXB0F/4cd7MFTq0MYMgT42HiYSXvWsK', 'xuesheng@qq.com', NULL, '2025-02-05 11:53:55', 1, NULL, 'normal', NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (7, 'VIP1', '$2b$10$pw2KRFpKOgR8SDm/si.UmuCVI0k5Yv5pbX8cv30D2KM7T8XooJETK', 'vip1@qq.com', NULL, '2025-02-05 11:57:34', 1, NULL, 'vip', NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (8, 'student', '$2b$10$nru7E2W1IQkM2bjMQmBlhuv19FAsdRYRvaWngRwHj4dGgWHCQz8vm', '13377238689@163.com', NULL, '2025-03-08 10:58:41', 1, NULL, 'normal', NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (9, 'teacher', '$2b$10$.PNPjVhMTaYDAn.WTmbHAebU.2x40BWgeej/ynDaMolNuTtur5.6y', '17324042932@163.com', '17324042932', '2025-03-08 11:01:51', 1, NULL, 'teacher', NULL);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
