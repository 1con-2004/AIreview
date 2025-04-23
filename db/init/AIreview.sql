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

 Date: 23/04/2025 23:05:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for classes
-- ----------------------------
DROP TABLE IF EXISTS `classes`;
CREATE TABLE `classes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '班级名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台管理——班级信息表';

-- ----------------------------
-- Records of classes
-- ----------------------------
BEGIN;
INSERT INTO `classes` (`id`, `class_name`) VALUES (1, '2023级计算机科学与技术1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (2, '舞蹈学');
INSERT INTO `classes` (`id`, `class_name`) VALUES (3, '舞蹈学2班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (4, '2023级计算机科学与技术2班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (5, '2023级计算机科学与技术3班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (6, '2023级数据科学与大数据技术1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (7, '2023级软件工程1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (8, '2023级人工智能1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (9, '2023级物联网工程1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (10, '2023级网络工程1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (11, '2023级电子信息工程1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (12, '2023级通信工程1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (13, '2023级信息安全1班');
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂——课堂讨论表';

-- ----------------------------
-- Records of classroom_discussions
-- ----------------------------
BEGIN;
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (1, 1, 1, 'hi', '2025-03-06 09:48:31');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (2, 1, 1, 'hi', '2025-03-06 09:56:20');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (3, 1, 1, 'hi', '2025-03-06 09:58:56');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (4, 1, 1, 'hi', '2025-03-06 09:58:58');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (5, 1, 1, '你好', '2025-03-06 10:02:01');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (6, 1, 1, '1', '2025-04-22 16:18:55');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (7, 1, 1, '2', '2025-04-22 16:22:20');
COMMIT;

-- ----------------------------
-- Table structure for classroom_files
-- ----------------------------
DROP TABLE IF EXISTS `classroom_files`;
CREATE TABLE `classroom_files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `classroom_id` int NOT NULL COMMENT '关联课堂ID',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名称',
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件路径',
  `file_size` int NOT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件类型',
  `upload_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_file_classroom` (`classroom_id`),
  CONSTRAINT `fk_file_classroom` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂——课堂文件表';

-- ----------------------------
-- Records of classroom_files
-- ----------------------------
BEGIN;
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (12, 1, '未命名.txt', '1e84cab125320e1c916497db5ec05c1a.txt', 15, 'txt', '2025-03-06 09:46:48');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (13, 1, '测试头像.png', '6cc347e6bb7c4b6841f8ed5b96b426bd.png', 11592, 'png', '2025-03-06 09:47:06');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (14, 1, '测试表格.xlsx', '319c7bdc36009a4113481bfcf5e2e4a3.xlsx', 9313, 'xlsx', '2025-03-06 09:47:12');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (15, 1, '测试头像PDF.pdf', '4ba56be06d58e59261e7a41b7d42c9bb.pdf', 13417, 'pdf', '2025-03-06 09:47:17');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (16, 1, '测试表格.xlsx', 'b89cc1e3f96f60e621d8129d42da90bc.xlsx', 9313, 'xlsx', '2025-03-06 09:47:29');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (17, 1, '测试word.docx', '9687d8a258e02dae0924cd0bce5708a0.docx', 10174, 'docx', '2025-03-06 09:47:35');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (18, 1, '测试头像4.png', 'dd5c9916fc67e50926e86dd6737d649a.png', 7537, 'png', '2025-04-22 16:18:18');
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂——课堂留言表';

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
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (7, 1, '1', '2025-04-22 14:45:46');
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂——课堂基本信息表';

-- ----------------------------
-- Records of classrooms
-- ----------------------------
BEGIN;
INSERT INTO `classrooms` (`id`, `classroom_code`, `teacher_id`, `title`, `description`, `status`, `created_at`, `updated_at`) VALUES (1, 'BWXHW', 1, 'JAVA', 'JAVA', 1, '2025-03-06 08:11:19', '2025-04-22 16:17:30');
COMMIT;

-- ----------------------------
-- Table structure for communities
-- ----------------------------
DROP TABLE IF EXISTS `communities`;
CREATE TABLE `communities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '社区名称',
  `type` enum('official','class','college') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '社区类型：官方、班级、学院',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '社区描述',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片',
  `school` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所属学校（班级和学院社区需要）',
  `college` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '所属学院（学院社区需要）',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '班级名称（班级社区需要）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int NOT NULL COMMENT '创建者ID',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `announcement` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '社区公告',
  `announcement_updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '公告更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_created_by` (`created_by`),
  CONSTRAINT `fk_community_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区——社区基本信息表';

-- ----------------------------
-- Records of communities
-- ----------------------------
BEGIN;
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (1, '官方社区', 'official', '官方技术交流与公告发布', 'https://www.svgrepo.com/show/303388/java-4-logo.svg', NULL, NULL, NULL, '2025-01-21 18:05:10', 1, 1, NULL, '2025-04-18 01:02:02');
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (2, '算法学习社区', 'official', '一起学习数据结构与算法', 'https://www.svgrepo.com/show/353528/c.svg', NULL, NULL, NULL, '2025-01-21 18:05:10', 1, 1, NULL, '2025-04-18 01:02:02');
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (3, '前端技术社区', 'class', '前端开发技术交流', 'https://www.svgrepo.com/show/303494/vue-9-logo.svg', NULL, NULL, NULL, '2025-01-21 18:05:10', 1, 1, NULL, '2025-04-18 01:02:02');
COMMIT;

-- ----------------------------
-- Table structure for community_announcements
-- ----------------------------
DROP TABLE IF EXISTS `community_announcements`;
CREATE TABLE `community_announcements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `community_id` int DEFAULT NULL,
  `community_name` varchar(100) DEFAULT NULL,
  `announcement` text NOT NULL,
  `announcement_updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COMMENT='社区——公告内容表';

-- ----------------------------
-- Records of community_announcements
-- ----------------------------
BEGIN;
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (1, 1, '官方社区', '欢迎来到AI代码审查平台！我们致力于帮助开发者提升代码质量。', '2025-01-21 18:05:24');
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (2, 1, '官方社区', '新功能上线：现在支持多种编程语言的代码审查！', '2025-01-21 18:05:24');
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (3, 2, '算法学习社区', '每周五晚8点在线算法讲解，欢迎参加！', '2025-01-21 18:05:24');
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (4, 3, '前端技术社区', '前端框架专题讨论：Vue3 vs React18性能对比', '2025-01-21 18:05:24');
COMMIT;

-- ----------------------------
-- Table structure for community_members
-- ----------------------------
DROP TABLE IF EXISTS `community_members`;
CREATE TABLE `community_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `community_id` int NOT NULL COMMENT '社区ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `role` enum('member','admin','owner') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'member' COMMENT '成员角色',
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `invited_by` int DEFAULT NULL COMMENT '邀请人ID',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-已退出，1-正常',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_community_user` (`community_id`,`user_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_invited_by` (`invited_by`),
  CONSTRAINT `fk_community_member` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`),
  CONSTRAINT `fk_member_inviter` FOREIGN KEY (`invited_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区——社区成员表';

-- ----------------------------
-- Records of community_members
-- ----------------------------
BEGIN;
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (1, 1, 1, 'owner', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (3, 1, 3, 'member', '2025-01-22 12:04:33', NULL, 1);
COMMIT;

-- ----------------------------
-- Table structure for learning_path_directions
-- ----------------------------
DROP TABLE IF EXISTS `learning_path_directions`;
CREATE TABLE `learning_path_directions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `tag` varchar(50) NOT NULL,
  `url` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `source` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `tag` (`tag`),
  CONSTRAINT `learning_path_directions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `learning_path_directions_ibfk_2` FOREIGN KEY (`tag`) REFERENCES `learning_path_weakness_analysis` (`tag`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of learning_path_directions
-- ----------------------------
BEGIN;
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (154, 1, '判断', 'https://search.bilibili.com/all?keyword=编程%E5%88%A4%E6%96%AD', '判断编程教学视频集锦', '哔哩哔哩', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (155, 1, '判断', 'https://www.douyin.com/search/编程%E5%88%A4%E6%96%AD', '判断相关短视频教程', '抖音', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (156, 1, '判断', 'https://so.csdn.net/so/search?q=编程%E5%88%A4%E6%96%AD', '判断学习资料大全', 'CSDN', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (157, 1, '字符串', 'https://search.bilibili.com/all?keyword=编程%E5%AD%97%E7%AC%A6%E4%B8%B2', '字符串编程教学视频集锦', '哔哩哔哩', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (158, 1, '字符串', 'https://www.douyin.com/search/编程%E5%AD%97%E7%AC%A6%E4%B8%B2', '字符串相关短视频教程', '抖音', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (159, 1, '字符串', 'https://so.csdn.net/so/search?q=编程%E5%AD%97%E7%AC%A6%E4%B8%B2', '字符串学习资料大全', 'CSDN', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (160, 1, '动态规划', 'https://search.bilibili.com/all?keyword=编程%E5%8A%A8%E6%80%81%E8%A7%84%E5%88%92', '动态规划编程教学视频集锦', '哔哩哔哩', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (161, 1, '动态规划', 'https://www.douyin.com/search/编程%E5%8A%A8%E6%80%81%E8%A7%84%E5%88%92', '动态规划相关短视频教程', '抖音', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (162, 1, '动态规划', 'https://so.csdn.net/so/search?q=编程%E5%8A%A8%E6%80%81%E8%A7%84%E5%88%92', '动态规划学习资料大全', 'CSDN', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
COMMIT;

-- ----------------------------
-- Table structure for learning_path_recommend
-- ----------------------------
DROP TABLE IF EXISTS `learning_path_recommend`;
CREATE TABLE `learning_path_recommend` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `tag` varchar(50) NOT NULL,
  `problem_number` varchar(10) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `tag` (`tag`),
  CONSTRAINT `learning_path_recommend_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `learning_path_recommend_ibfk_2` FOREIGN KEY (`tag`) REFERENCES `learning_path_weakness_analysis` (`tag`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of learning_path_recommend
-- ----------------------------
BEGIN;
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (80, 1, '序列', '0026', '最长连续序列1', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (81, 1, '递归', '0031', '合并两个有序链表', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (82, 1, '递归', '0023', '斐波那契数列计算', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (83, 1, '递归', '0004', '阶乘计算', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (84, 1, '字符串', '0030', '最长回文子串', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (85, 1, '字符串', '0022', '字符串反转', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (86, 1, '字符串', '0008', '字符串拼接', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
COMMIT;

-- ----------------------------
-- Table structure for learning_path_weakness_analysis
-- ----------------------------
DROP TABLE IF EXISTS `learning_path_weakness_analysis`;
CREATE TABLE `learning_path_weakness_analysis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `tag` varchar(50) NOT NULL,
  `idea` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_tag` (`tag`),
  CONSTRAINT `learning_path_weakness_analysis_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of learning_path_weakness_analysis
-- ----------------------------
BEGIN;
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (79, 1, '序列', '🔍 **序列核心思路**:\n- 序列处理是算法中的基础，常用于处理数组、链表等数据结构。\n- 核心是理解如何遍历、搜索、排序和操作序列。\n\n🔧 **关键点**:\n- **遍历**: 使用循环结构（for, while）逐一访问序列元素。\n- **搜索**: 使用条件判断和循环寻找特定元素。\n- **排序**: 掌握冒泡、选择、插入等基本排序算法。\n- **操作**: 理解如何插入、删除、更新序列元素。\n\n📌 **常见解题技巧**:\n- **模拟**: 通过手动操作理解算法逻辑。\n- **图解**: 用图表展示算法步骤，直观易懂。\n- **测试**: 编写测试用例，验证算法的正确性。\n\n🔐 **序列学习小贴士**:\n- **基础扎实**: 熟悉基本数据结构和算法。\n- **实践为主**: 多写代码，积累经验。\n- **循序渐进**: 从简单到复杂，逐步提升。', '2025-04-23 15:03:06', '2025-04-23 15:03:06');
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (80, 1, '递归', '🌟 递归核心思路 🌟\n- 递归就是函数自己调用自己\n- 解决问题时，先分解成更小的子问题\n- 当子问题足够小，可以直接解决时，开始返回结果\n\n🔍 关键点 🔍\n- 明确递归终止条件（基准情况）\n- 每次递归都向基准情况靠近\n- 避免无限递归\n\n📝 常见解题技巧 📝\n- 分解问题：将大问题拆成小问题\n- 模拟递归过程：手动写出递归调用过程\n- 尝试非递归解法：理解递归的本质后，尝试用循环实现\n\n🔧 注意事项 🔧\n- 递归可能导致栈溢出，注意递归深度\n- 理解递归的逻辑，不要盲目使用\n\n🌈 递归小贴士 🌈\n- 递归是一种强大的工具，但使用不当会出问题\n- 多练习，理解递归的本质\n- 递归不是万能的，有时循环更高效', '2025-04-23 15:03:06', '2025-04-23 15:03:06');
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (81, 1, '字符串', '🔍 **核心思路**：\n- 字符串是编程中的文本数据，处理时要注意区分大小写和空格。\n- 主要操作包括拼接、查找、替换和长度计算。\n\n🔧 **关键点**：\n- 使用 `+` 或 `str.join()` 进行字符串拼接。\n- 利用 `str.find()` 和 `str.index()` 查找子串。\n- `str.replace()` 用于替换子串。\n- `len()` 获取字符串长度。\n\n🎯 **常见解题技巧**：\n- 避免重复拼接，使用 `join()` 提高效率。\n- 处理大小写敏感问题时，使用 `str.lower()` 或 `str.upper()`。\n- 使用列表推导式简化操作。\n- 熟练掌握字符串方法，如 `split()`, `strip()`, `startswith()`, `endswith()`。\n\n📝 **要点总结**：\n- 拼接：`\"Hello\" + \" World\"` 或 `\"Hello\".join([\" \", \"World\"])`\n- 查找：`\"Hello\".find(\"l\")`\n- 替换：`\"Hello\".replace(\"l\", \"L\")`\n- 长度：`len(\"Hello\")`\n- 大小写：`\"Hello\".lower()`, `\"hello\".upper()`', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (82, 1, '判断', '学习 \"判断\" 相关的概念和技巧 👨‍💻\n\n掌握这个知识点可以帮助你提高解题能力和代码质量 🚀\n\n核心要点：\n- 理解基本原理和实现方式 📝\n- 掌握常见应用场景 🔍\n- 学习典型解题策略 💡\n\n多做相关练习，理解其核心思想！💪', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (83, 1, '动态规划', '学习 \"动态规划\" 相关的概念和技巧 👨‍💻\n\n掌握这个知识点可以帮助你提高解题能力和代码质量 🚀\n\n核心要点：\n- 理解基本原理和实现方式 📝\n- 掌握常见应用场景 🔍\n- 学习典型解题策略 💡\n\n多做相关练习，理解其核心思想！💪', '2025-04-23 15:03:07', '2025-04-23 15:03:07');
COMMIT;

-- ----------------------------
-- Table structure for learning_plan_problems
-- ----------------------------
DROP TABLE IF EXISTS `learning_plan_problems`;
CREATE TABLE `learning_plan_problems` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int NOT NULL COMMENT '学习计划ID',
  `problem_id` int NOT NULL COMMENT '题目ID',
  `problem_number` varchar(50) DEFAULT NULL,
  `order_index` int NOT NULL COMMENT '题目顺序',
  `section` varchar(100) DEFAULT NULL COMMENT '所属章节',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_problem_id` (`problem_id`),
  CONSTRAINT `fk_lpp_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `learning_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_lpp_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学习计划-题目关联表';

-- ----------------------------
-- Records of learning_plan_problems
-- ----------------------------
BEGIN;
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (1, 4, 16, '0016', 1, '基础查询', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (2, 4, 20, '0020', 2, '基础查询', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (3, 4, 21, '0021', 3, '聚合函数', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (5, 4, 30, '0026', 5, '高级查询', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (6, 5, 1, '0001', 1, '基础运算', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (7, 5, 6, '0006', 2, '基础运算', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (8, 5, 21, '0021', 3, '基础运算', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (9, 5, 2, '0002', 4, '数组基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (10, 5, 7, '0007', 5, '数组基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (11, 5, 11, '0011', 6, '数组基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (12, 5, 3, '0003', 7, '字符串基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (13, 5, 12, '0012', 8, '字符串基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (15, 5, 10, '0010', 10, '条件判断', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (16, 6, 5, '0005', 1, '数学进阶', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (17, 6, 15, '0015', 2, '数学进阶', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (18, 6, 19, '0019', 3, '数学进阶', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (19, 6, 18, '0018', 4, '动态规划', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (20, 6, 23, '0023', 5, '动态规划', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (21, 6, 30, '0026', 6, '动态规划', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (23, 6, 29, '0025', 8, '数据结构', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (24, 6, 13, '0013', 9, '字符串处理', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (25, 6, 14, '0014', 10, '算法思维', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (31, 2, 18, '0018', 1, '动态规划', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (32, 2, 23, '0023', 2, '动态规划', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (33, 2, 30, '0026', 3, '动态规划', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (34, 2, 13, '0013', 4, '字符串处理', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (35, 2, 14, '0014', 5, '算法思维', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (36, 3, 5, '0005', 1, '数学进阶', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (37, 3, 15, '0015', 2, '数学进阶', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (38, 3, 19, '0019', 3, '数学进阶', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (40, 3, 29, '0025', 5, '数据结构', '2025-02-03 11:33:12');
COMMIT;

-- ----------------------------
-- Table structure for learning_plans
-- ----------------------------
DROP TABLE IF EXISTS `learning_plans`;
CREATE TABLE `learning_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '计划标题',
  `description` text COMMENT '计划描述',
  `icon` varchar(255) DEFAULT NULL COMMENT '计划图标路径',
  `tag` varchar(50) DEFAULT NULL COMMENT '计划标签',
  `difficulty_level` varchar(20) DEFAULT NULL COMMENT '难度级别',
  `estimated_days` int DEFAULT NULL COMMENT '预计完成天数',
  `points` text COMMENT '要点描述（JSON格式存储）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `learning_plans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学习计划主表';

-- ----------------------------
-- Records of learning_plans
-- ----------------------------
BEGIN;
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (2, '动态规划（基础版）', '更细的知识点拆分，让入门更轻松', '/icons/algorithm.png', '算法入门', '简单', 15, '[\"系统学习动态规划基础\",\"从易到难的题目编排\",\"配套详细的解题思路\",\"适合算法学习初期的用户\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (3, 'LeetCode 热题 100', '力扣最受刷题发烧友欢迎的 100 题', '/icons/hot.png', '热门精选', '中等', 25, '[\"精选最热门的 100 道题目\",\"覆盖多个算法知识点\",\"题目难度分布合理\",\"适合系统提升算法能力\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (4, 'SQL 50 题', '面试必刷的 SQL 精选题目', '/icons/sql.png', 'SQL专题', '中等', 20, '[\"覆盖 SQL 常见面试题型\",\"从基础到高级查询\",\"包含多表联查和性能优化\",\"适合数据库开发岗位面试\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (5, '编程入门 100 题', '为编程新手量身打造的入门题集', '/icons/beginner.png', '入门推荐', '简单', 40, '[\"从零开始的编程入门\",\"循序渐进的难度安排\",\"详细的解题思路讲解\",\"适合编程初学者\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (6, '会员专享题集', '精心筛选的高质量面试题集', '/icons/premium.png', '会员专享', '困难', 35, '[\"高质量算法面试题\",\"大厂常考题目精选\",\"面试真题解析\",\"适合准备大厂面试的用户\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
COMMIT;

-- ----------------------------
-- Table structure for likes
-- ----------------------------
DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '点赞用户ID',
  `target_id` int NOT NULL COMMENT '点赞目标ID',
  `target_type` enum('post','comment') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '点赞目标类型',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_target` (`user_id`,`target_id`,`target_type`),
  KEY `idx_target` (`target_id`,`target_type`),
  CONSTRAINT `fk_like_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区——帖子点赞表';

-- ----------------------------
-- Records of likes
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `community_id` int NOT NULL COMMENT '所属社区ID',
  `user_id` int NOT NULL COMMENT '发帖人ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子内容',
  `type` enum('normal','announcement') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '帖子类型：普通、公告',
  `status` enum('draft','published','deleted') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published' COMMENT '帖子状态',
  `view_count` int DEFAULT '0' COMMENT '浏览次数',
  `like_count` int DEFAULT '0' COMMENT '点赞次数',
  `comment_count` int DEFAULT '0' COMMENT '评论次数',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_top` tinyint(1) DEFAULT '0' COMMENT '是否置顶',
  `is_essence` tinyint(1) DEFAULT '0' COMMENT '是否精华',
  PRIMARY KEY (`id`),
  KEY `idx_community_id` (`community_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_post_community` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`),
  CONSTRAINT `fk_post_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区——帖子表';

-- ----------------------------
-- Records of posts
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_categories
-- ----------------------------
DROP TABLE IF EXISTS `problem_categories`;
CREATE TABLE `problem_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `description` varchar(255) DEFAULT NULL COMMENT '分类描述',
  `parent_id` int DEFAULT NULL COMMENT '父分类ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `level` int DEFAULT '1' COMMENT '分类层级: 1-顶级分类, 2-二级分类, 3-三级分类',
  `slug` varchar(50) DEFAULT NULL COMMENT '分类标识符',
  `icon` varchar(50) DEFAULT NULL COMMENT '分类图标',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of problem_categories
-- ----------------------------
BEGIN;
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (1, '数据结构', '与数据结构相关的算法题', NULL, 0, 1, 'data-structure', 'structure', '2025-04-18 08:30:41', '2025-04-18 08:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (2, '算法技巧', '常见算法技巧与思想', NULL, 0, 1, 'algorithm', 'algorithm', '2025-04-18 08:30:41', '2025-04-18 08:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (3, '数学', '数学相关的问题', NULL, 0, 1, 'math', 'calculator', '2025-04-18 08:30:41', '2025-04-18 08:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (4, '基础编程', '基础编程能力考察', NULL, 0, 1, 'basic', 'code', '2025-04-18 08:30:41', '2025-04-18 08:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (17, '数组', '数组类型的问题', 1, 0, 2, 'array', 'array', '2025-04-18 08:30:56', '2025-04-18 08:30:56');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (18, '字符串', '字符串操作相关问题', 4, 0, 2, 'string', 'string', '2025-04-18 08:31:06', '2025-04-18 08:31:06');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (19, '排序', '排序算法相关问题', 2, 0, 2, 'sorting', 'sort', '2025-04-18 08:31:09', '2025-04-18 08:31:09');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (20, '双指针', '双指针技巧相关问题', 2, 0, 2, 'two-pointers', 'pointers', '2025-04-18 08:31:12', '2025-04-18 08:31:12');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (21, '递归', '递归相关问题', 3, 0, 2, 'recursion', 'recursion', '2025-04-18 08:31:15', '2025-04-18 08:31:15');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (22, '进制转换', '进制转换相关问题', 3, 0, 2, 'base-conversion', 'conversion', '2025-04-18 08:31:18', '2025-04-18 08:31:18');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (23, '判断', '逻辑判断相关问题', 3, 0, 2, 'judgement', 'judge', '2025-04-18 08:31:21', '2025-04-18 08:31:21');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (24, '算法', '通用算法实现相关问题', 2, 0, 2, 'algorithm-impl', 'implement', '2025-04-18 08:31:24', '2025-04-18 08:31:24');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (25, '序列', '序列相关问题', 1, 0, 2, 'sequence', 'sequence', '2025-04-18 08:31:27', '2025-04-18 08:31:27');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (26, '树', '树结构相关问题', 1, 0, 2, 'tree', 'tree', '2025-04-18 08:31:30', '2025-04-18 08:31:30');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (27, '广度优先搜索', '图的广度优先搜索算法', 2, 0, 2, 'bfs', 'search', '2025-04-18 08:31:33', '2025-04-18 08:31:33');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (28, '动态规划', '动态规划相关问题', 2, 0, 2, 'dynamic-programming', 'dp', '2025-04-18 08:31:36', '2025-04-18 08:31:36');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (29, '基础', '基础编程概念和实践', 4, 0, 2, 'basic-concepts', 'basics', '2025-04-18 08:31:44', '2025-04-18 08:31:44');
COMMIT;

-- ----------------------------
-- Table structure for problem_categories_backup
-- ----------------------------
DROP TABLE IF EXISTS `problem_categories_backup`;
CREATE TABLE `problem_categories_backup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `description` varchar(255) DEFAULT NULL COMMENT '分类描述',
  `parent_id` int DEFAULT NULL COMMENT '父分类ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `level` int DEFAULT '1' COMMENT '分类层级: 1-顶级分类, 2-二级分类, 3-三级分类',
  `slug` varchar(50) DEFAULT NULL COMMENT '分类标识符',
  `icon` varchar(50) DEFAULT NULL COMMENT '分类图标',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目分类表';

-- ----------------------------
-- Records of problem_categories_backup
-- ----------------------------
BEGIN;
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (1, '数据结构', '与数据结构相关的算法题', NULL, 0, 1, 'data-structure', 'structure', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (2, '算法技巧', '常见算法技巧与思想', NULL, 0, 1, 'algorithm', 'algorithm', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (3, '数学', '数学相关的问题', NULL, 0, 1, 'math', 'calculator', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (4, '基础编程', '基础编程能力考察', NULL, 0, 1, 'basic', 'code', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (5, '数组', '数组类型的问题', 1, 0, 2, 'array', 'array', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (6, '链表', '链表操作相关问题', 1, 0, 2, 'linked-list', 'link', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (7, '树', '树结构相关问题', 1, 0, 2, 'tree', 'tree', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (8, '图', '图算法相关问题', 1, 0, 2, 'graph', 'graph', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (9, '栈', '栈相关问题', 1, 0, 2, 'stack', 'stack', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (10, '队列', '队列相关问题', 1, 0, 2, 'queue', 'queue', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (11, '哈希表', '哈希表相关问题', 1, 0, 2, 'hash-table', 'hash', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (12, '排序', '排序算法相关问题', 2, 0, 2, 'sorting', 'sort', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (13, '搜索', '查找与搜索算法', 2, 0, 2, 'searching', 'search', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (14, '动态规划', '动态规划相关问题', 2, 0, 2, 'dynamic-programming', 'dp', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (15, '贪心算法', '贪心策略相关问题', 2, 0, 2, 'greedy', 'greedy', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (16, '分治算法', '分治策略相关问题', 2, 0, 2, 'divide-and-conquer', 'divide', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (17, '回溯算法', '回溯法相关问题', 2, 0, 2, 'backtracking', 'backtrack', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (18, '双指针', '双指针技巧相关问题', 2, 0, 2, 'two-pointers', 'pointers', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (19, '几何', '几何问题', 3, 0, 2, 'geometry', 'geometry', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (20, '概率统计', '概率与统计相关问题', 3, 0, 2, 'probability', 'stats', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (21, '数论', '数论相关问题', 3, 0, 2, 'number-theory', 'numbers', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (22, '组合数学', '组合数学相关问题', 3, 0, 2, 'combinatorics', 'combine', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (23, '递归', '递归相关问题', 3, 0, 2, 'recursion', 'recursion', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (24, '进制转换', '进制转换相关问题', 3, 0, 2, 'base-conversion', 'conversion', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (25, '字符串', '字符串操作相关问题', 4, 0, 2, 'string', 'string', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (26, '位运算', '位操作相关问题', 4, 0, 2, 'bit-manipulation', 'bits', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (27, '模拟', '模拟类问题', 4, 0, 2, 'simulation', 'simulation', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
INSERT INTO `problem_categories_backup` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (28, '约束满足', '满足条件和约束的问题', 4, 0, 2, 'constraint-satisfaction', 'constraint', '2025-04-16 10:19:42', '2025-04-16 10:19:42');
COMMIT;

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

-- ----------------------------
-- Table structure for problem_pool
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool`;
CREATE TABLE `problem_pool` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '题目标题',
  `difficulty` enum('简单','中等','困难') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '难度等级',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签，多个标签用逗号分隔',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '题目描述',
  `time_limit` int DEFAULT '1000' COMMENT '时间限制(ms)',
  `memory_limit` int DEFAULT '256' COMMENT '内存限制(MB)',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '题目分类，如算法、数据结构等',
  `source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '题目来源',
  `create_user_id` int DEFAULT NULL COMMENT '创建者ID',
  `reference_count` int DEFAULT '0' COMMENT '被引用次数',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：1-启用，0-禁用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_problem_number` (`problem_number`),
  KEY `fk_pool_creator` (`create_user_id`),
  CONSTRAINT `fk_pool_creator` FOREIGN KEY (`create_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池主表';

-- ----------------------------
-- Records of problem_pool
-- ----------------------------
BEGIN;
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (2, '0002', '合并两个有序链表', '简单', '链表,递归', '将两个升序链表合并为一个新的升序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。', 1000, 256, '8', '原创', 1, 2, 1, '2025-04-11 16:43:41', '2025-04-22 14:45:17');
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (3, '0003', '最长回文子串', '中等', '字符串,动态规划', '给你一个字符串 s，找到 s 中最长的回文子串。', 1500, 512, '4', '原创', 1, 3, 1, '2025-04-11 16:43:41', '2025-04-16 22:33:52');
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (4, '0004', '买卖股票的最佳时机', '简单', '数组,动态规划', '给定一个数组 prices ，它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格。你只能选择某一天买入这只股票，并选择在未来的某一个不同的日子卖出该股票。设计一个算法来计算你所能获取的最大利润。', 1000, 256, '5', '原创', 1, 1, 1, '2025-04-11 16:43:41', '2025-04-11 17:08:03');
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (5, '0005', '二叉树的层序遍历', '中等', '树,广度优先搜索', '给你一个二叉树，请你返回其按层序遍历得到的节点值。（即逐层地，从左到右访问所有节点）。', 1000, 256, '9', '原创', 1, 4, 1, '2025-04-11 16:43:41', '2025-04-23 15:03:54');
COMMIT;

-- ----------------------------
-- Table structure for problem_pool_categories
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_categories`;
CREATE TABLE `problem_pool_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类描述',
  `parent_id` int DEFAULT NULL COMMENT '父分类ID',
  `order_num` int DEFAULT '0' COMMENT '排序序号',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `problem_pool_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池分类表';

-- ----------------------------
-- Records of problem_pool_categories
-- ----------------------------
BEGIN;
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (1, '算法', '包含各种算法题目', NULL, 1, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (2, '数据结构', '包含各种数据结构题目', NULL, 2, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (3, '数学', '包含各种数学题目', NULL, 3, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (4, '动态规划', '动态规划相关题目', 1, 1, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (5, '贪心算法', '贪心算法相关题目', 1, 2, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (6, '二分查找', '二分查找相关题目', 1, 3, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (7, '数组', '数组相关题目', 2, 1, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (8, '链表', '链表相关题目', 2, 2, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (9, '树', '树相关题目', 2, 3, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (10, '图', '图相关题目', 2, 4, '2025-04-11 16:43:21', '2025-04-11 16:43:21');
COMMIT;

-- ----------------------------
-- Table structure for problem_pool_solution_code
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_solution_code`;
CREATE TABLE `problem_pool_solution_code` (
  `id` int NOT NULL AUTO_INCREMENT,
  `solution_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pool_solution_id` int NOT NULL COMMENT '题目池解决方案ID',
  `language_id` int NOT NULL COMMENT '编程语言ID',
  `standard_solution` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '具体语言实现',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1.0' COMMENT '代码版本',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_pool_solution_lang` (`pool_solution_id`,`language_id`),
  KEY `fk_pool_code_language` (`language_id`),
  KEY `idx_solution_number` (`solution_number`),
  CONSTRAINT `fk_pool_code_language` FOREIGN KEY (`language_id`) REFERENCES `solution_languages` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池解答代码表';

-- ----------------------------
-- Records of problem_pool_solution_code
-- ----------------------------
BEGIN;
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (1, '0001', 1, 4, '#include <iostream>\n#include <vector>\n#include <unordered_map>\nusing namespace std;\n\nclass Solution {\npublic:\n    vector<int> twoSum(vector<int>& nums, int target) {\n        unordered_map<int, int> map;\n        for (int i = 0; i < nums.size(); i++) {\n            int complement = target - nums[i];\n            if (map.find(complement) != map.end()) {\n                return {map[complement], i};\n            }\n            map[nums[i]] = i;\n        }\n        return {};\n    }\n};', '1.0', '2025-04-11 16:44:13', '2025-04-11 17:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (2, '0001', 1, 3, 'import java.util.HashMap;\nimport java.util.Map;\n\nclass Solution {\n    public int[] twoSum(int[] nums, int target) {\n        Map<Integer, Integer> map = new HashMap<>();\n        for (int i = 0; i < nums.length; i++) {\n            int complement = target - nums[i];\n            if (map.containsKey(complement)) {\n                return new int[] { map.get(complement), i };\n            }\n            map.put(nums[i], i);\n        }\n        return null;\n    }\n}', '1.0', '2025-04-11 16:44:13', '2025-04-11 17:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (3, '0002', 2, 4, '#include <iostream>\nusing namespace std;\n\nstruct ListNode {\n    int val;\n    ListNode *next;\n    ListNode() : val(0), next(nullptr) {}\n    ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode *next) : val(x), next(next) {}\n};\n\nclass Solution {\npublic:\n    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {\n        if (!list1) return list2;\n        if (!list2) return list1;\n        \n        if (list1->val < list2->val) {\n            list1->next = mergeTwoLists(list1->next, list2);\n            return list1;\n        } else {\n            list2->next = mergeTwoLists(list1, list2->next);\n            return list2;\n        }\n    }\n};', '1.0', '2025-04-11 16:44:13', '2025-04-11 17:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (4, '0003', 3, 4, '#include <iostream>\n#include <string>\n#include <vector>\nusing namespace std;\n\nclass Solution {\npublic:\n    string longestPalindrome(string s) {\n        int n = s.size();\n        if (n < 2) return s;\n        \n        int maxLen = 1;\n        int begin = 0;\n        vector<vector<bool>> dp(n, vector<bool>(n, false));\n        \n        // 所有单个字符都是回文\n        for (int i = 0; i < n; i++) {\n            dp[i][i] = true;\n        }\n        \n        // 检查长度为2及以上的子串\n        for (int L = 2; L <= n; L++) {\n            for (int i = 0; i < n; i++) {\n                int j = i + L - 1;\n                if (j >= n) break;\n                \n                if (s[i] != s[j]) {\n                    dp[i][j] = false;\n                } else {\n                    if (j - i < 3) {\n                        dp[i][j] = true;\n                    } else {\n                        dp[i][j] = dp[i+1][j-1];\n                    }\n                }\n                \n                if (dp[i][j] && j - i + 1 > maxLen) {\n                    maxLen = j - i + 1;\n                    begin = i;\n                }\n            }\n        }\n        \n        return s.substr(begin, maxLen);\n    }\n};', '1.0', '2025-04-11 16:44:13', '2025-04-11 17:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (5, '0004', 4, 4, '#include <iostream>\n#include <vector>\n#include <algorithm>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfit(vector<int>& prices) {\n        if (prices.empty()) return 0;\n        \n        int minPrice = prices[0];\n        int maxProfit = 0;\n        \n        for (int i = 1; i < prices.size(); i++) {\n            maxProfit = max(maxProfit, prices[i] - minPrice);\n            minPrice = min(minPrice, prices[i]);\n        }\n        \n        return maxProfit;\n    }\n};', '1.0', '2025-04-11 16:44:13', '2025-04-11 17:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (6, '0005', 5, 4, '#include <iostream>\n#include <vector>\n#include <queue>\nusing namespace std;\n\nstruct TreeNode {\n    int val;\n    TreeNode *left;\n    TreeNode *right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}\n};\n\nclass Solution {\npublic:\n    vector<vector<int>> levelOrder(TreeNode* root) {\n        vector<vector<int>> result;\n        if (!root) return result;\n        \n        queue<TreeNode*> q;\n        q.push(root);\n        \n        while (!q.empty()) {\n            int levelSize = q.size();\n            vector<int> currentLevel;\n            \n            for (int i = 0; i < levelSize; i++) {\n                TreeNode* node = q.front();\n                q.pop();\n                \n                currentLevel.push_back(node->val);\n                \n                if (node->left) q.push(node->left);\n                if (node->right) q.push(node->right);\n            }\n            \n            result.push_back(currentLevel);\n        }\n        \n        return result;\n    }\n};', '1.0', '2025-04-11 16:44:13', '2025-04-11 17:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (7, '0002', 2, 1, '// C 解决方案\nstruct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2) {\n    struct ListNode dummy;\n    struct ListNode* tail = &dummy;\n    \n    while (l1 && l2) {\n        if (l1->val <= l2->val) {\n            tail->next = l1;\n            l1 = l1->next;\n        } else {\n            tail->next = l2;\n            l2 = l2->next;\n        }\n        tail = tail->next;\n    }\n    \n    tail->next = l1 ? l1 : l2;\n    return dummy.next;\n}', '1.0', '2025-04-14 09:23:08', '2025-04-14 09:23:08');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (8, '0002', 2, 2, '# Python 解决方案\ndef mergeTwoLists(l1, l2):\n    dummy = ListNode(0)\n    tail = dummy\n    \n    while l1 and l2:\n        if l1.val <= l2.val:\n            tail.next = l1\n            l1 = l1.next\n        else:\n            tail.next = l2\n            l2 = l2.next\n        tail = tail.next\n    \n    tail.next = l1 if l1 else l2\n    return dummy.next', '1.0', '2025-04-14 09:23:19', '2025-04-14 09:23:19');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (9, '0002', 2, 3, '// Java 解决方案\npublic ListNode mergeTwoLists(ListNode l1, ListNode l2) {\n    ListNode dummy = new ListNode(0);\n    ListNode tail = dummy;\n    \n    while (l1 != null && l2 != null) {\n        if (l1.val <= l2.val) {\n            tail.next = l1;\n            l1 = l1.next;\n        } else {\n            tail.next = l2;\n            l2 = l2.next;\n        }\n        tail = tail.next;\n    }\n    \n    tail.next = (l1 != null) ? l1 : l2;\n    return dummy.next;\n}', '1.0', '2025-04-14 09:23:27', '2025-04-14 09:23:27');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (10, '0003', 3, 1, '// C 解决方案\nchar* longestPalindrome(char* s) {\n    int n = strlen(s);\n    if (n == 0) return \"\";\n    \n    int start = 0, max_len = 1;\n    \n    // 辅助函数：从中心扩展\n    for (int i = 0; i < n; i++) {\n        // 奇数长度回文\n        int left = i, right = i;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n        \n        // 偶数长度回文\n        left = i, right = i + 1;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n    }\n    \n    char* result = malloc(max_len + 1);\n    strncpy(result, s + start, max_len);\n    result[max_len] = 0;\n    return result;\n}', '1.0', '2025-04-14 09:23:38', '2025-04-14 09:23:38');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (11, '0003', 3, 3, '// Java 解决方案\npublic String longestPalindrome(String s) {\n    if (s == null || s.length() < 1) return \"\";\n    \n    int start = 0, end = 0;\n    \n    for (int i = 0; i < s.length(); i++) {\n        int len1 = expandAroundCenter(s, i, i);\n        int len2 = expandAroundCenter(s, i, i + 1);\n        int len = Math.max(len1, len2);\n        if (len > end - start) {\n            start = i - (len - 1) / 2;\n            end = i + len / 2;\n        }\n    }\n    \n    return s.substring(start, end + 1);\n}\n\nprivate int expandAroundCenter(String s, int left, int right) {\n    while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {\n        left--;\n        right++;\n    }\n    return right - left - 1;\n}', '1.0', '2025-04-14 09:24:12', '2025-04-14 09:24:12');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (12, '0004', 4, 1, '// C 解决方案\nint maxProfit(int* prices, int pricesSize) {\n    if (pricesSize <= 1) return 0;\n    \n    int minPrice = prices[0];\n    int maxProfit = 0;\n    \n    for (int i = 1; i < pricesSize; i++) {\n        if (prices[i] < minPrice) {\n            minPrice = prices[i];\n        } else if (prices[i] - minPrice > maxProfit) {\n            maxProfit = prices[i] - minPrice;\n        }\n    }\n    \n    return maxProfit;\n}', '1.0', '2025-04-14 09:24:29', '2025-04-14 09:24:29');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (13, '0004', 4, 2, '# Python 解决方案\ndef maxProfit(prices):\n    if not prices or len(prices) <= 1:\n        return 0\n        \n    min_price = float(\"inf\")\n    max_profit = 0\n    \n    for price in prices:\n        if price < min_price:\n            min_price = price\n        elif price - min_price > max_profit:\n            max_profit = price - min_price\n            \n    return max_profit', '1.0', '2025-04-14 09:24:45', '2025-04-14 09:24:45');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (14, '0004', 4, 3, '// Java 解决方案\npublic int maxProfit(int[] prices) {\n    if (prices == null || prices.length <= 1) return 0;\n    \n    int minPrice = Integer.MAX_VALUE;\n    int maxProfit = 0;\n    \n    for (int price : prices) {\n        if (price < minPrice) {\n            minPrice = price;\n        } else if (price - minPrice > maxProfit) {\n            maxProfit = price - minPrice;\n        }\n    }\n    \n    return maxProfit;\n}', '1.0', '2025-04-14 09:24:54', '2025-04-14 09:24:54');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (15, '0005', 5, 1, '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}', '1.0', '2025-04-14 09:26:01', '2025-04-14 09:26:01');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (16, '0005', 5, 2, '# Python 简化解决方案\ndef levelOrder(root):\n    # 使用队列实现二叉树层序遍历\n    # 返回二维数组表示层序遍历结果\n    pass', '1.0', '2025-04-14 09:27:11', '2025-04-14 09:27:11');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (17, '0005', 5, 3, '// Java 简化解决方案\npublic List<List<Integer>> levelOrder(TreeNode root) {\n    // 使用队列实现二叉树层序遍历\n    // 返回二维列表表示层序遍历结果\n    return new ArrayList<>();\n}', '1.0', '2025-04-14 09:28:04', '2025-04-14 09:28:04');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (18, '0003', 3, 2, '# Python 简化解决方案\ndef longestPalindrome(s):\n    # 实现寻找最长回文子串的算法\n    # 返回最长回文子串\n    pass', '1.0', '2025-04-14 09:29:05', '2025-04-14 09:29:05');
COMMIT;

-- ----------------------------
-- Table structure for problem_pool_solutions
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_solutions`;
CREATE TABLE `problem_pool_solutions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `solution_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `problem_pool_id` int NOT NULL COMMENT '题目池ID',
  `solution_approach` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通用解题思路',
  `time_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间复杂度',
  `space_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '空间复杂度',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_solution_number` (`solution_number`),
  KEY `fk_pool_solution` (`problem_pool_id`),
  KEY `idx_problem_number` (`problem_number`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池解题方案表';

-- ----------------------------
-- Records of problem_pool_solutions
-- ----------------------------
BEGIN;
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (1, '0001', '0001', 1, '使用哈希表存储数组元素和对应的索引，遍历数组时检查目标值与当前元素的差是否存在于哈希表中。', 'O(n)', 'O(n)', '2025-04-11 16:43:52', '2025-04-11 17:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (2, '0002', '0002', 2, '使用递归或迭代方法，比较两个链表的头节点，选择较小的一个作为新链表的头，然后递归处理剩余部分。', 'O(n+m)', 'O(1)', '2025-04-11 16:43:52', '2025-04-11 17:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (3, '0003', '0003', 3, '动态规划方法：利用状态转移方程 P(i,j)=(P(i+1,j−1) and S[i]==S[j])，逐步找到最长回文子串。', 'O(n²)', 'O(n²)', '2025-04-11 16:43:52', '2025-04-11 17:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (4, '0004', '0004', 4, '贪心算法：记录历史最低价格，计算当前价格与历史最低价格的差值，并更新最大利润。', 'O(n)', 'O(1)', '2025-04-11 16:43:52', '2025-04-11 17:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (5, '0005', '0005', 5, '使用队列实现广度优先搜索，逐层处理二叉树节点。', 'O(n)', 'O(n)', '2025-04-11 16:43:52', '2025-04-11 17:08:42');
COMMIT;

-- ----------------------------
-- Table structure for problem_pool_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_test_cases`;
CREATE TABLE `problem_pool_test_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `problem_pool_id` int NOT NULL COMMENT '题目池ID',
  `input` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_example` tinyint(1) DEFAULT '0' COMMENT '是否为显示样例',
  `order_num` int DEFAULT '0' COMMENT '测试用例顺序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `problem_pool_id` (`problem_pool_id`),
  KEY `idx_problem_number` (`problem_number`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池测试用例表';

-- ----------------------------
-- Records of problem_pool_test_cases
-- ----------------------------
BEGIN;
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (1, '0001', 1, '[2,7,11,15]\n9', '[0,1]', 1, 1, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (2, '0001', 1, '[3,2,4]\n6', '[1,2]', 1, 2, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (3, '0001', 1, '[3,3]\n6', '[0,1]', 0, 3, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (4, '0002', 2, '[1,2,4]\n[1,3,4]', '[1,1,2,3,4,4]', 1, 1, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (5, '0002', 2, '[]\n[]', '[]', 1, 2, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (6, '0002', 2, '[]\n[0]', '[0]', 0, 3, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (7, '0003', 3, 'babad', 'bab', 1, 1, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (8, '0003', 3, 'cbbd', 'bb', 1, 2, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (9, '0003', 3, 'a', 'a', 0, 3, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (10, '0004', 4, '[7,1,5,3,6,4]', '5', 1, 1, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (11, '0004', 4, '[7,6,4,3,1]', '0', 1, 2, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (12, '0005', 5, '[3,9,20,null,null,15,7]', '[[3],[9,20],[15,7]]', 1, 1, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (13, '0005', 5, '[1]', '[[1]]', 1, 2, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (14, '0005', 5, '[]', '[]', 0, 3, '2025-04-11 16:44:29', '2025-04-11 17:08:25');
COMMIT;

-- ----------------------------
-- Table structure for problem_pool_usage
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_usage`;
CREATE TABLE `problem_pool_usage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `problem_pool_id` int NOT NULL COMMENT '题目池ID',
  `user_id` int NOT NULL COMMENT '使用该题目的老师ID',
  `problem_id` int NOT NULL COMMENT '最终发布的题目ID',
  `is_modified` tinyint(1) DEFAULT '0' COMMENT '是否经过修改：0-直接使用，1-修改后使用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '使用时间',
  PRIMARY KEY (`id`),
  KEY `problem_pool_id` (`problem_pool_id`),
  KEY `problem_id` (`problem_id`),
  KEY `user_id` (`user_id`),
  KEY `idx_problem_number` (`problem_number`),
  CONSTRAINT `fk_usage_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`),
  CONSTRAINT `fk_usage_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池使用记录表';

-- ----------------------------
-- Records of problem_pool_usage
-- ----------------------------
BEGIN;
INSERT INTO `problem_pool_usage` (`id`, `problem_number`, `problem_pool_id`, `user_id`, `problem_id`, `is_modified`, `created_at`) VALUES (1, '0001', 1, 1, 10, 0, '2025-04-11 16:44:33');
INSERT INTO `problem_pool_usage` (`id`, `problem_number`, `problem_pool_id`, `user_id`, `problem_id`, `is_modified`, `created_at`) VALUES (2, '0002', 2, 1, 11, 0, '2025-04-11 16:44:33');
INSERT INTO `problem_pool_usage` (`id`, `problem_number`, `problem_pool_id`, `user_id`, `problem_id`, `is_modified`, `created_at`) VALUES (5, '0005', 5, 3, 14, 1, '2025-04-11 16:44:33');
COMMIT;

-- ----------------------------
-- Table structure for problem_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `problem_test_cases`;
CREATE TABLE `problem_test_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL,
  `problem_number` varchar(50) DEFAULT NULL,
  `input` text NOT NULL,
  `output` text NOT NULL,
  `is_example` tinyint(1) DEFAULT '0' COMMENT '是否为显示样例',
  `order_num` int DEFAULT '0' COMMENT '测试用例顺序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `fk_problem_test_cases` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目——题目测试样例表';

-- ----------------------------
-- Records of problem_test_cases
-- ----------------------------
BEGIN;
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (1, 1, '0001', '2 3', '5', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (2, 2, '0002', '5\n1 5 3 8 2', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (3, 3, '0003', 'hello', 'olleh', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (4, 4, '0004', '5', '120', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (5, 5, '0005', '7', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (6, 6, '0006', '5 3', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (7, 7, '0007', '5\n4 2 7 1 9', '1', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (8, 8, '0008', 'abc def', 'abcdef', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (9, 9, '0009', '6', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (10, 10, '0010', '8', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (11, 11, '0011', '5\n9 3 6 2 7', '2 3 6 7 9', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (12, 12, '0012', 'apple p', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (13, 13, '0013', 'hello world world java', 'hello java', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (14, 14, '0014', '12 18', '6', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (15, 15, '0015', '121', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (16, 16, '0016', '2 2\n1 2\n3 4\n5 6\n7 8', '6 8\n10 12', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (17, 17, '0017', 'I love programming', 'programming love I', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (18, 18, '0018', '5', '1\n1 1\n1 2 1\n1 3 3 1\n1 4 6 4 1', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (19, 19, '0019', '10 20', '11 13 17 19', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (20, 20, '0020', '6\n1 2 2 3 3 3', '1 2 3', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (21, 21, '0021', '5\n1 2 3 4 5', '15', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (22, 22, '0022', 'hello', 'olleh', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (23, 23, '0023', '6', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (24, 25, '0024', '8', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (25, 29, '0025', '1010', '10', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (27, 33, '0027', '1 1', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (32, 1, '0001', '10 20', '30', 0, 2, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (33, 1, '0001', '-5 8', '3', 0, 3, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (34, 1, '0001', '0 0', '0', 0, 4, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (35, 1, '0001', '999 1', '1000', 0, 5, '2025-04-02 12:39:37', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (38, 34, '0028', '11', '11', 0, 1, '2025-04-04 11:04:08', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (39, 34, '0028', '22', '22', 0, 2, '2025-04-04 11:04:08', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (46, 30, '0026', '6\n100 4 200 1 3 2', '4', 1, 1, '2025-04-15 16:10:35', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (47, 30, '0026', '0', '0', 0, 2, '2025-04-15 16:10:35', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (48, 30, '0026', '1\n5', '1', 0, 3, '2025-04-15 16:10:35', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (49, 30, '0026', '8\n1 3 5 2 4 7 9 6', '9', 0, 4, '2025-04-15 16:10:35', '2025-04-15 16:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (72, 38, '0029', '[3,9,20,null,null,15,7]', '[[3],[9,20],[15,7]]', 0, 0, '2025-04-16 22:24:12', '2025-04-16 22:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (73, 38, '0029', '[1]', '[[1]]', 0, 0, '2025-04-16 22:24:12', '2025-04-16 22:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (74, 38, '0029', '[]', '[]', 0, 0, '2025-04-16 22:24:12', '2025-04-16 22:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (75, 38, '0029', '4', '1', 0, 4, '2025-04-16 22:24:12', '2025-04-16 22:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (79, 42, '0030', 'babad', 'bab', 1, 1, '2025-04-16 22:33:52', '2025-04-16 22:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (80, 42, '0030', 'cbbd', 'bb', 1, 2, '2025-04-16 22:33:52', '2025-04-16 22:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (81, 42, '0030', 'a', 'a', 1, 3, '2025-04-16 22:33:52', '2025-04-18 08:27:42');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (91, 44, '0031', '[1,2,4]\n[1,3,4]', '[1,1,2,3,4,4]', 1, 1, '2025-04-22 14:45:17', '2025-04-22 14:45:17');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (92, 44, '0031', '[]\n[]', '[]', 1, 2, '2025-04-22 14:45:17', '2025-04-22 14:45:17');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (93, 44, '0031', '[]\n[0]', '[0]', 0, 3, '2025-04-22 14:45:17', '2025-04-22 14:45:17');
COMMIT;

-- ----------------------------
-- Table structure for problems
-- ----------------------------
DROP TABLE IF EXISTS `problems`;
CREATE TABLE `problems` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_number` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `difficulty` enum('简单','中等','困难') NOT NULL,
  `total_submissions` int DEFAULT '0',
  `acceptance_rate` decimal(5,2) DEFAULT '0.00',
  `tags` varchar(255) DEFAULT NULL,
  `description` text,
  `time_limit` int DEFAULT '1000' COMMENT '时间限制(ms)',
  `memory_limit` int DEFAULT '256' COMMENT '内存限制(MB)',
  `accepted_submissions` int DEFAULT '0' COMMENT '通过提交数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_problem_number` (`problem_number`),
  CONSTRAINT `check_submissions` CHECK ((`accepted_submissions` <= `total_submissions`))
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb3 COMMENT='题目——题目详细表';

-- ----------------------------
-- Records of problems
-- ----------------------------
BEGIN;
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (1, '0001', '两数相加问题', '简单', 169, 89.35, '基础,数学', '给定两个整数A和B，求它们的和。', 1000, 256, 151);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (2, '0002', '寻找最大值', '简单', 301, 84.05, '基础,数组', '给定一个整数数组，找出其中的最大值。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 253);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (3, '0003', '字符串反转', '中等', 240, 94.58, '字符串', '将一个字符串进行反转。', 1000, 256, 227);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (4, '0004', '阶乘计算', '中等', 151, 65.56, '数学,递归', '计算一个正整数的阶乘。', 1000, 256, 99);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (5, '0005', '质数判断', '困难', 314, 66.56, '数学,判断', '判断一个数是否为质数。', 1000, 256, 209);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (6, '0006', '两数相减问题', '简单', 260, 100.00, '基础,数学', '给定两个整数 C 和 D，求它们的差。', 1000, 256, 260);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (7, '0007', '求最小值', '简单', 236, 100.00, '基础,数组', '给定一个整数数组，找出其中的最小值。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 236);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (8, '0008', '字符串拼接', '中等', 476, 25.42, '字符串', '将两个字符串进行拼接。', 1000, 256, 121);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (9, '0009', '斐波那契数列计算', '中等', 138, 100.00, '数学,递归', '计算斐波那契数列的第 N 项。（斐波那契数列：0、1、1、2、3、5、8、13、21、34......，从第三项开始，每一项都等于前两项之和）', 1000, 256, 138);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (10, '0010', '偶数判断', '困难', 420, 25.24, '数学,判断', '判断一个数是否为偶数。', 1000, 256, 106);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (11, '0011', '数组排序', '简单', 988, 21.76, '数组,排序', '对给定的整数数组进行升序排序。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 215);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (12, '0012', '字符统计', '简单', 971, 31.00, '字符串', '统计一个字符串中某个字符出现的次数。', 1000, 256, 301);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (13, '0013', '字符串替换', '中等', 565, 32.21, '字符串', '将字符串中的某个子串替换为另一个子串。', 1000, 256, 182);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (14, '0014', '最大公约数计算', '中等', 206, 79.61, '数学,算法', '计算两个整数的最大公约数。', 1000, 256, 164);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (15, '0015', '回文数判断', '困难', 271, 100.00, '数学,判断', '判断一个数是否为回文数。（回文数：一个数从左到右读和从右到左读都一样）', 1000, 256, 271);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (16, '0016', '矩阵相加', '简单', 781, 48.14, '数学,数组', '给定两个相同维度的矩阵，求它们对应元素相加后的结果矩阵。第一行输入两个整数n、m表示矩阵的行数和列数，接下来n行每行m个整数表示第一个矩阵，再接下来n行每行m个整数表示第二个矩阵。', 1000, 256, 376);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (17, '0017', '单词反转', '简单', 545, 39.82, '字符串', '将一个句子中的单词顺序反转。例如，\"I am a student\" 转换为 \"student a am I\"。', 1000, 256, 217);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (18, '0018', '杨辉三角生成', '中等', 732, 19.67, '数学,算法', '生成指定行数的杨辉三角。', 1000, 256, 144);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (19, '0019', '素数筛选', '困难', 800, 23.88, '数学,算法', '在给定范围内筛选出所有的素数。', 1000, 256, 191);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (20, '0020', '数组去重', '简单', 416, 55.53, '数组', '去除整数数组中的重复元素。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 231);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (21, '0021', '数组求和', '简单', 684, 24.85, '数组', '计算给定整数数组的和。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 170);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (22, '0022', '字符串反转', '简单', 1164, 13.06, '字符串', '将一个字符串进行反转。', 1000, 256, 152);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (23, '0023', '斐波那契数列计算', '中等', 1276, 9.25, '数学,递归', '计算斐波那契数列的第 N 项。（斐波那契数列：0、1、1、2、3、5、8、13、21、34......，从第三项开始，每一项都等于前两项之和）', 1000, 256, 118);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (25, '0024', '偶数判断', '困难', 1224, 5.23, '数学,判断', '判断一个数是否为偶数。', 1000, 256, 64);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (29, '0025', '二进制转十进制', '中等', 1061, 7.16, '数学,进制转换', '将给定的二进制字符串转换为十进制数。', 1000, 256, 76);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (30, '0026', '最长连续序列1', '中等', 668, 20.66, '数组,算法,序列', '找出数组中最长的连续数字序列的长度。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。测试1', 1000, 256, 138);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (33, '0027', '测试1', '简单', 0, 0.00, '数组', '测试1111', 1000, 256, 0);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (34, '0028', 'ceshi2', '困难', 0, 0.00, '双指针,数组', '11', 1000, 256, 0);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (38, '0029', '二叉树的层序遍历1', '简单', 2, 0.00, '树,广度优先搜索', '给你一个二叉树，请你返回其按层序遍历得到的节点值。（即逐层地，从左到右访问所有节点）。', 1000, 256, 0);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (42, '0030', '最长回文子串', '中等', 0, 0.00, '字符串,动态规划', '给你一个字符串 s，找到 s 中最长的回文子串。', 1500, 512, 0);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (44, '0031', '合并两个有序链表', '简单', 0, 0.00, '链表,递归', '将两个升序链表合并为一个新的升序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。', 1000, 256, 0);
COMMIT;

-- ----------------------------
-- Table structure for solution_code
-- ----------------------------
DROP TABLE IF EXISTS `solution_code`;
CREATE TABLE `solution_code` (
  `id` int NOT NULL AUTO_INCREMENT,
  `solution_id` int NOT NULL COMMENT '主方案ID',
  `language_id` int NOT NULL COMMENT '编程语言ID',
  `standard_solution` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '具体语言实现',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '1.0' COMMENT '代码版本',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_solution_lang` (`solution_id`,`language_id`),
  KEY `fk_code_language` (`language_id`),
  CONSTRAINT `fk_code_language` FOREIGN KEY (`language_id`) REFERENCES `solution_languages` (`id`),
  CONSTRAINT `fk_code_main` FOREIGN KEY (`solution_id`) REFERENCES `solution_main` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答案——题目解答代码';

-- ----------------------------
-- Records of solution_code
-- ----------------------------
BEGIN;
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (1, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (2, 2, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (3, 3, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (4, 4, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    long long result = 1;\n    for(int i = 1; i <= n; i++) {\n        result *= i;\n    }\n    printf(\"%lld\\n\", result);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (5, 5, 1, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++) {\n        if(n % i == 0) return 0;\n    }\n    return 1;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPrime(n) ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (6, 6, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (7, 7, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], min;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) min = arr[i];\n    }\n    printf(\"%d\\n\", min);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (8, 8, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (9, 9, 1, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (10, 10, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", n % 2 == 0 ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (11, 11, 1, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (12, 12, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100], ch;\n    scanf(\"%s %c\", str, &ch);\n    int count = 0;\n    for(int i = 0; str[i]; i++) {\n        if(str[i] == ch) count++;\n    }\n    printf(\"%d\\n\", count);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (13, 13, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[1000];\n    gets(str);\n    char *token = strtok(str, \" \");\n    printf(\"%s\", token);\n    token = strtok(NULL, \" \");\n    while(token != NULL) {\n        if(strcmp(token, \"world\") != 0) {\n            printf(\" %s\", token);\n        }\n        token = strtok(NULL, \" \");\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (14, 14, 1, '#include <stdio.h>\n\nint gcd(int a, int b) {\n    return b == 0 ? a : gcd(b, a % b);\n}\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", gcd(a, b));\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (15, 15, 1, '#include <stdio.h>\n\nint isPalindrome(int n) {\n    int reversed = 0, original = n;\n    while(n > 0) {\n        reversed = reversed * 10 + n % 10;\n        n /= 10;\n    }\n    return original == reversed;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPalindrome(n) ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (16, 16, 1, '#include <stdio.h>\n\nint main() {\n    int n, m;\n    scanf(\"%d %d\", &n, &m);\n    int mat1[10][10], mat2[10][10];\n    \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat1[i][j]);\n            \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat2[i][j]);\n            \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j < m; j++)\n            printf(\"%d \", mat1[i][j] + mat2[i][j]);\n        printf(\"\\n\");\n    }\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (17, 17, 1, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (18, 18, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int triangle[30][30] = {0};\n    \n    for(int i = 0; i < n; i++) {\n        triangle[i][0] = 1;\n        for(int j = 1; j <= i; j++) {\n            triangle[i][j] = triangle[i-1][j-1] + triangle[i-1][j];\n        }\n    }\n    \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j <= i; j++) {\n            printf(\"%d \", triangle[i][j]);\n        }\n        printf(\"\\n\");\n    }\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (19, 19, 1, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (20, 20, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], unique[100], uniqueCount = 0;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n        int isUnique = 1;\n        for(int j = 0; j < uniqueCount; j++) {\n            if(arr[i] == unique[j]) {\n                isUnique = 0;\n                break;\n            }\n        }\n        if(isUnique) unique[uniqueCount++] = arr[i];\n    }\n    for(int i = 0; i < uniqueCount; i++) {\n        printf(\"%d \", unique[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (21, 21, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], sum = 0;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n        sum += arr[i];\n    }\n    printf(\"%d\\n\", sum);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (22, 22, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (23, 23, 1, '#include <stdio.h>\n\nint fibonacci(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fibonacci(n));\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (25, 25, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", (n % 2 == 0) ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (29, 29, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char binary[33];\n    scanf(\"%s\", binary);\n    int decimal = 0;\n    int len = strlen(binary);\n    for(int i = 0; i < len; i++) {\n        decimal = decimal * 2 + (binary[i] - \'0\');\n    }\n    printf(\"%d\\n\", decimal);\n    return 0;\n}', '1.0', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (38, 1, 2, 'a, b = map(int, input().split())\nprint(a + b)', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (39, 1, 3, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}\njava', '1.0', '2025-02-09 21:00:38', '2025-04-03 00:05:29');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (40, 1, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << a + b << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (41, 2, 2, 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (42, 2, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (43, 2, 4, '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (44, 3, 2, 's = input().strip()\nprint(s[::-1])', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (45, 3, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String s = new Scanner(System.in).next();\n        System.out.println(new StringBuilder(s).reverse());\n    }\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (46, 3, 4, '#include <iostream>\n#include <algorithm>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    reverse(s.begin(), s.end());\n    cout << s << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (47, 4, 2, 'n = int(input())\nfrom math import factorial\nprint(factorial(n))', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (48, 4, 3, 'import java.math.BigInteger;\nimport java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        BigInteger result = BigInteger.ONE;\n        for(int i=2; i<=n; i++){\n            result = result.multiply(BigInteger.valueOf(i));\n        }\n        System.out.println(result);\n    }\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (49, 4, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    long long fact = 1;\n    for(int i=2; i<=n; ++i) fact *= i;\n    cout << fact << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (50, 5, 2, 'def is_prime(n):\n    if n <= 1: return False\n    for i in range(2, int(n**0.5)+1):\n        if n%i == 0: return False\n    return True\n\nn = int(input())\nprint(\"是\" if is_prime(n) else \"否\")', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (51, 5, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static boolean isPrime(int n) {\n        if(n <= 1) return false;\n        for(int i=2; i*i<=n; i++)\n            if(n%i == 0) return false;\n        return true;\n    }\n    \n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        System.out.println(isPrime(n) ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (52, 5, 4, '#include <iostream>\n#include <cmath>\nusing namespace std;\n\nbool isPrime(int n) {\n    if(n <= 1) return false;\n    for(int i=2; i<=sqrt(n); ++i)\n        if(n%i == 0) return false;\n    return true;\n}\n\nint main() {\n    int n; cin >> n;\n    cout << (isPrime(n) ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:00:38', '2025-02-09 21:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (53, 6, 2, 'a, b = map(int, input().split())\nprint(a - b)', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (54, 6, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        System.out.println(a - b);\n    }\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (55, 6, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << a - b << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (56, 7, 2, 'n = int(input())\narr = list(map(int, input().split()))\nprint(min(arr))', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (57, 7, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int min = Integer.MAX_VALUE;\n        while(n-- > 0) {\n            min = Math.min(min, sc.nextInt());\n        }\n        System.out.println(min);\n    }\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (58, 7, 4, '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int min_val = INT_MAX;\n    while(n--) {\n        cin >> tmp;\n        if(tmp < min_val) min_val = tmp;\n    }\n    cout << min_val << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (59, 8, 2, 's1, s2 = input().split()\nprint(s1 + s2)', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (60, 8, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String s1 = sc.next();\n        String s2 = sc.next();\n        System.out.println(s1 + s2);\n    }\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (61, 8, 4, '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string s1, s2;\n    cin >> s1 >> s2;\n    cout << s1 + s2 << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (62, 9, 2, 'n = int(input())\na, b = 0, 1\nfor _ in range(n):\n    a, b = b, a + b\nprint(a)', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (63, 9, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        int a = 0, b = 1;\n        for(int i=0; i<n; i++) {\n            int c = a + b;\n            a = b;\n            b = c;\n        }\n        System.out.println(a);\n    }\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (64, 9, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int a = 0, b = 1;\n    for(int i=0; i<n; ++i) {\n        int c = a + b;\n        a = b;\n        b = c;\n    }\n    cout << a << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (65, 10, 2, 'n = int(input())\nprint(\"是\" if n % 2 == 0 else \"否\")', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (66, 10, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        System.out.println(n % 2 == 0 ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (67, 10, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    cout << (n % 2 == 0 ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:02:47', '2025-02-09 21:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (68, 11, 2, 'n = int(input())\narr = list(map(int, input().split()))\nfor i in range(n-1):\n    for j in range(n-i-1):\n        if arr[j] > arr[j+1]:\n            arr[j], arr[j+1] = arr[j+1], arr[j]\nprint(\" \".join(map(str, arr)))', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (69, 11, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int[] arr = new int[n];\n        for(int i=0; i<n; i++) arr[i] = sc.nextInt();\n        \n        for(int i=0; i<n-1; i++) {\n            for(int j=0; j<n-i-1; j++) {\n                if(arr[j] > arr[j+1]) {\n                    int temp = arr[j];\n                    arr[j] = arr[j+1];\n                    arr[j+1] = temp;\n                }\n            }\n        }\n        for(int num : arr) System.out.print(num + \" \");\n    }\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (70, 11, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int arr[100];\n    for(int i=0; i<n; ++i) cin >> arr[i];\n    \n    for(int i=0; i<n-1; ++i)\n        for(int j=0; j<n-i-1; ++j)\n            if(arr[j] > arr[j+1])\n                swap(arr[j], arr[j+1]);\n    \n    for(int i=0; i<n; ++i) cout << arr[i] << \" \";\n    return 0;\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (71, 12, 2, 's, c = input().split()\nprint(s.count(c))', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (72, 12, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String s = sc.next();\n        char target = sc.next().charAt(0);\n        int count = 0;\n        for(char ch : s.toCharArray()) {\n            if(ch == target) count++;\n        }\n        System.out.println(count);\n    }\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (73, 12, 4, '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string s;\n    char target;\n    cin >> s >> target;\n    int count = 0;\n    for(char c : s) {\n        if(c == target) count++;\n    }\n    cout << count << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (74, 13, 2, 's = input().split()\nprint(\" \".join([word for word in s if word != \"world\"]))', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (75, 13, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String[] words = sc.nextLine().split(\" \");\n        StringBuilder sb = new StringBuilder();\n        for(String word : words) {\n            if(!word.equals(\"world\")) {\n                sb.append(word).append(\" \");\n            }\n        }\n        System.out.println(sb.toString().trim());\n    }\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (76, 13, 4, '#include <iostream>\n#include <string>\n#include <sstream>\nusing namespace std;\n\nint main() {\n    string line, word;\n    getline(cin, line);\n    stringstream ss(line);\n    bool first = true;\n    \n    while(ss >> word) {\n        if(word != \"world\") {\n            if(!first) cout << \" \";\n            cout << word;\n            first = false;\n        }\n    }\n    return 0;\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (77, 14, 2, 'a, b = map(int, input().split())\nimport math\nprint(math.gcd(a, b))', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (78, 14, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static int gcd(int a, int b) {\n        return b == 0 ? a : gcd(b, a % b);\n    }\n    \n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        System.out.println(gcd(a, b));\n    }\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (79, 14, 4, '#include <iostream>\nusing namespace std;\n\nint gcd(int a, int b) {\n    return b == 0 ? a : gcd(b, a % b);\n}\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << gcd(a, b) << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (80, 15, 2, 'n = input()\nprint(\"是\" if n == n[::-1] else \"否\")', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (81, 15, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String n = new Scanner(System.in).next();\n        System.out.println(new StringBuilder(n).reverse().toString().equals(n) ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (82, 15, 4, '#include <iostream>\n#include <string>\n#include <algorithm>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    string rev = s;\n    reverse(rev.begin(), rev.end());\n    cout << (s == rev ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:05:55', '2025-02-09 21:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (83, 16, 2, 'n, m = map(int, input().split())\nmat1 = [list(map(int, input().split())) for _ in range(n)]\nmat2 = [list(map(int, input().split())) for _ in range(n)]\nfor i in range(n):\n    print(\" \".join(map(str, [a+b for a,b in zip(mat1[i], mat2[i])])))', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (84, 16, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int m = sc.nextInt();\n        int[][] mat1 = new int[n][m];\n        int[][] mat2 = new int[n][m];\n        \n        for(int i=0; i<n; i++)\n            for(int j=0; j<m; j++)\n                mat1[i][j] = sc.nextInt();\n        \n        for(int i=0; i<n; i++)\n            for(int j=0; j<m; j++)\n                mat2[i][j] = sc.nextInt();\n        \n        for(int i=0; i<n; i++) {\n            for(int j=0; j<m; j++)\n                System.out.print((mat1[i][j]+mat2[i][j]) + \" \");\n            System.out.println();\n        }\n    }\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (85, 16, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n, m;\n    cin >> n >> m;\n    int mat1[10][10], mat2[10][10];\n    \n    for(int i=0; i<n; ++i)\n        for(int j=0; j<m; ++j)\n            cin >> mat1[i][j];\n    \n    for(int i=0; i<n; ++i)\n        for(int j=0; j<m; ++j)\n            cin >> mat2[i][j];\n    \n    for(int i=0; i<n; ++i) {\n        for(int j=0; j<m; ++j)\n            cout << mat1[i][j] + mat2[i][j] << \" \";\n        cout << endl;\n    }\n    return 0;\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (86, 17, 2, 'print(\" \".join(input().split()[::-1]))', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (87, 17, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] words = new Scanner(System.in).nextLine().split(\" \");\n        for(int i=words.length-1; i>=0; i--)\n            System.out.print(words[i] + (i>0 ? \" \" : \"\"));\n    }\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (88, 17, 4, '#include <iostream>\n#include <sstream>\n#include <vector>\nusing namespace std;\n\nint main() {\n    string line, word;\n    vector<string> words;\n    getline(cin, line);\n    stringstream ss(line);\n    \n    while(ss >> word) words.push_back(word);\n    \n    for(int i=words.size()-1; i>=0; --i)\n        cout << words[i] << (i>0 ? \" \" : \"\");\n    return 0;\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (89, 18, 2, 'n = int(input())\ntri = [[1]*(i+1) for i in range(n)]\nfor i in range(2, n):\n    for j in range(1, i):\n        tri[i][j] = tri[i-1][j-1] + tri[i-1][j]\nfor row in tri:\n    print(\" \".join(map(str, row)))', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (90, 18, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        int[][] tri = new int[n][];\n        for(int i=0; i<n; i++) {\n            tri[i] = new int[i+1];\n            tri[i][0] = 1;\n            for(int j=1; j<i; j++)\n                tri[i][j] = tri[i-1][j-1] + tri[i-1][j];\n            tri[i][i] = 1;\n        }\n        for(int[] row : tri) {\n            for(int num : row) System.out.print(num + \" \");\n            System.out.println();\n        }\n    }\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (91, 18, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int tri[30][30] = {0};\n    \n    for(int i=0; i<n; ++i) {\n        tri[i][0] = 1;\n        for(int j=1; j<=i; ++j)\n            tri[i][j] = tri[i-1][j-1] + tri[i-1][j];\n    }\n    \n    for(int i=0; i<n; ++i) {\n        for(int j=0; j<=i; ++j)\n            cout << tri[i][j] << \" \";\n        cout << endl;\n    }\n    return 0;\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (92, 19, 2, 'def is_prime(n):\n    if n < 2: return False\n    for i in range(2, int(n**0.5)+1):\n        if n%i ==0: return False\n    return True\n\nstart, end = map(int, input().split())\nprimes = [str(i) for i in range(start, end+1) if is_prime(i)]\nprint(\" \".join(primes) if primes else \"\")', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (93, 19, 3, 'import java.util.*;\n\npublic class Main {\n    static boolean isPrime(int n) {\n        if(n < 2) return false;\n        for(int i=2; i*i<=n; i++)\n            if(n%i ==0) return false;\n        return true;\n    }\n    \n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        StringBuilder sb = new StringBuilder();\n        for(int i=a; i<=b; i++) {\n            if(isPrime(i)) sb.append(i).append(\" \");\n        }\n        System.out.println(sb.length()>0 ? sb.toString().trim() : \"\");\n    }\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (94, 19, 4, '#include <iostream>\n#include <cmath>\nusing namespace std;\n\nbool isPrime(int n) {\n    if(n <= 1) return false;\n    for(int i=2; i<=sqrt(n); ++i)\n        if(n%i == 0) return false;\n    return true;\n}\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    bool first = true;\n    for(int i=a; i<=b; ++i) {\n        if(isPrime(i)) {\n            if(!first) cout << \" \";\n            cout << i;\n            first = false;\n        }\n    }\n    return 0;\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (95, 20, 2, 'n = int(input())\narr = list(map(int, input().split()))\nseen = set()\nresult = []\nfor num in arr:\n    if num not in seen:\n        seen.add(num)\n        result.append(str(num))\nprint(\" \".join(result))', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (96, 20, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        LinkedHashSet<Integer> set = new LinkedHashSet<>();\n        while(n-- > 0) set.add(sc.nextInt());\n        for(int num : set) System.out.print(num + \" \");\n    }\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (97, 20, 4, '#include <iostream>\n#include <unordered_set>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    unordered_set<int> seen;\n    int arr[100];\n    \n    for(int i=0; i<n; ++i) {\n        cin >> tmp;\n        if(seen.insert(tmp).second) {\n            cout << tmp << \" \";\n        }\n    }\n    return 0;\n}', '1.0', '2025-02-09 21:13:51', '2025-02-09 21:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (98, 21, 2, 'n = int(input())\nprint(sum(map(int, input().split())))', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (99, 21, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int sum = 0;\n        while(n-- > 0) sum += sc.nextInt();\n        System.out.println(sum);\n    }\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (100, 21, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n, tmp, sum = 0;\n    cin >> n;\n    while(n--) {\n        cin >> tmp;\n        sum += tmp;\n    }\n    cout << sum << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (101, 22, 2, 's = input().strip()\nprint(s[::-1])', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (102, 22, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String s = new Scanner(System.in).next();\n        System.out.println(new StringBuilder(s).reverse());\n    }\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (103, 22, 4, '#include <iostream>\n#include <algorithm>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    reverse(s.begin(), s.end());\n    cout << s << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (104, 23, 2, 'n = int(input())\na, b = 0, 1\nfor _ in range(n):\n    a, b = b, a + b\nprint(a)', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (105, 23, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        int a = 0, b = 1;\n        for(int i=0; i<n; i++) {\n            int c = a + b;\n            a = b;\n            b = c;\n        }\n        System.out.println(a);\n    }\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (106, 23, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int a = 0, b = 1;\n    for(int i=0; i<n; ++i) {\n        int c = a + b;\n        a = b;\n        b = c;\n    }\n    cout << a << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (110, 25, 2, 'n = int(input())\nprint(\"是\" if n % 2 == 0 else \"否\")', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (111, 25, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        System.out.println(n % 2 == 0 ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (112, 25, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    cout << (n % 2 == 0 ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (122, 29, 2, 'print(int(input(), 2))', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (123, 29, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String binary = new Scanner(System.in).next();\n        System.out.println(Integer.parseInt(binary, 2));\n    }\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (124, 29, 4, '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    int num = 0;\n    for(char c : s)\n        num = num * 2 + (c - \'0\');\n    cout << num << endl;\n    return 0;\n}', '1.0', '2025-02-09 21:14:07', '2025-02-09 21:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (128, 33, 1, 'ccccc', '1.0', '2025-02-25 18:45:04', '2025-02-25 18:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (129, 33, 4, 'c++ccccc', '1.0', '2025-02-25 18:45:04', '2025-02-25 18:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (130, 33, 3, 'javaccccc', '1.0', '2025-02-25 18:45:04', '2025-02-25 18:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (131, 33, 2, 'pythoncccccc', '1.0', '2025-02-25 18:45:04', '2025-02-25 18:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (132, 34, 1, '', '1.0', '2025-02-25 18:49:52', '2025-02-25 18:49:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (133, 34, 2, '', '1.0', '2025-02-25 18:49:52', '2025-02-25 18:49:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (134, 34, 3, 'ceshi', '1.0', '2025-02-25 18:49:52', '2025-02-25 18:51:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (135, 34, 4, 'ceshi', '1.0', '2025-02-25 18:49:52', '2025-02-25 18:53:02');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (136, 35, 1, 'dawd', '1.0', '2025-02-25 19:00:52', '2025-02-25 19:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (137, 35, 4, 'dwada', '1.0', '2025-02-25 19:00:52', '2025-02-25 19:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (138, 35, 3, 'dwada', '1.0', '2025-02-25 19:00:52', '2025-02-25 19:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (139, 35, 2, 'dawdaw', '1.0', '2025-02-25 19:00:52', '2025-02-25 19:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (144, 37, 1, '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}\n？？？', '1.0', '2025-04-14 09:37:43', '2025-04-16 22:24:30');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (145, 37, 4, '#include <iostream>\n#include <vector>\n#include <queue>\nusing namespace std;\n\nstruct TreeNode {\n    int val;\n    TreeNode *left;\n    TreeNode *right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}\n};\n\nclass Solution {\npublic:\n    vector<vector<int>> levelOrder(TreeNode* root) {\n        vector<vector<int>> result;\n        if (!root) return result;\n        \n        queue<TreeNode*> q;\n        q.push(root);\n        \n        while (!q.empty()) {\n            int levelSize = q.size();\n            vector<int> currentLevel;\n            \n            for (int i = 0; i < levelSize; i++) {\n                TreeNode* node = q.front();\n                q.pop();\n                \n                currentLevel.push_back(node->val);\n                \n                if (node->left) q.push(node->left);\n                if (node->right) q.push(node->right);\n            }\n            \n            result.push_back(currentLevel);\n        }\n        \n        return result;\n    }\n};', '1.0', '2025-04-14 09:37:43', '2025-04-14 09:37:43');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (146, 37, 3, '// Java 简化解决方案\npublic List<List<Integer>> levelOrder(TreeNode root) {\n    // 使用队列实现二叉树层序遍历\n    // 返回二维列表表示层序遍历结果\n    return new ArrayList<>();\n}', '1.0', '2025-04-14 09:37:43', '2025-04-14 09:37:43');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (147, 37, 2, '# Python 简化解决方案\ndef levelOrder(root):\n    # 使用队列实现二叉树层序遍历\n    # 返回二维数组表示层序遍历结果\n    pass', '1.0', '2025-04-14 09:37:43', '2025-04-14 09:37:43');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (160, 41, 1, '// C 解决方案\nchar* longestPalindrome(char* s) {\n    int n = strlen(s);\n    if (n == 0) return \"\";\n    \n    int start = 0, max_len = 1;\n    \n    // 辅助函数：从中心扩展\n    for (int i = 0; i < n; i++) {\n        // 奇数长度回文\n        int left = i, right = i;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n        \n        // 偶数长度回文\n        left = i, right = i + 1;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n    }\n    \n    char* result = malloc(max_len + 1);\n    strncpy(result, s + start, max_len);\n    result[max_len] = 0;\n    return result;\n}', '1.0', '2025-04-16 22:33:52', '2025-04-16 22:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (161, 41, 4, '#include <iostream>\n#include <string>\n#include <vector>\nusing namespace std;\n\nclass Solution {\npublic:\n    string longestPalindrome(string s) {\n        int n = s.size();\n        if (n < 2) return s;\n        \n        int maxLen = 1;\n        int begin = 0;\n        vector<vector<bool>> dp(n, vector<bool>(n, false));\n        \n        // 所有单个字符都是回文\n        for (int i = 0; i < n; i++) {\n            dp[i][i] = true;\n        }\n        \n        // 检查长度为2及以上的子串\n        for (int L = 2; L <= n; L++) {\n            for (int i = 0; i < n; i++) {\n                int j = i + L - 1;\n                if (j >= n) break;\n                \n                if (s[i] != s[j]) {\n                    dp[i][j] = false;\n                } else {\n                    if (j - i < 3) {\n                        dp[i][j] = true;\n                    } else {\n                        dp[i][j] = dp[i+1][j-1];\n                    }\n                }\n                \n                if (dp[i][j] && j - i + 1 > maxLen) {\n                    maxLen = j - i + 1;\n                    begin = i;\n                }\n            }\n        }\n        \n        return s.substr(begin, maxLen);\n    }\n};', '1.0', '2025-04-16 22:33:52', '2025-04-16 22:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (162, 41, 3, '// Java 解决方案\npublic String longestPalindrome(String s) {\n    if (s == null || s.length() < 1) return \"\";\n    \n    int start = 0, end = 0;\n    \n    for (int i = 0; i < s.length(); i++) {\n        int len1 = expandAroundCenter(s, i, i);\n        int len2 = expandAroundCenter(s, i, i + 1);\n        int len = Math.max(len1, len2);\n        if (len > end - start) {\n            start = i - (len - 1) / 2;\n            end = i + len / 2;\n        }\n    }\n    \n    return s.substring(start, end + 1);\n}\n\nprivate int expandAroundCenter(String s, int left, int right) {\n    while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {\n        left--;\n        right++;\n    }\n    return right - left - 1;\n}', '1.0', '2025-04-16 22:33:52', '2025-04-16 22:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (163, 41, 2, '# Python 简化解决方案\ndef longestPalindrome(s):\n    # 实现寻找最长回文子串的算法\n    # 返回最长回文子串\n    pass', '1.0', '2025-04-16 22:33:52', '2025-04-16 22:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (168, 43, 1, '// C 解决方案\nstruct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2) {\n    struct ListNode dummy;\n    struct ListNode* tail = &dummy;\n    \n    while (l1 && l2) {\n        if (l1->val <= l2->val) {\n            tail->next = l1;\n            l1 = l1->next;\n        } else {\n            tail->next = l2;\n            l2 = l2->next;\n        }\n        tail = tail->next;\n    }\n    \n    tail->next = l1 ? l1 : l2;\n    return dummy.next;\n}', '1.0', '2025-04-22 14:45:17', '2025-04-22 14:45:17');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (169, 43, 4, '#include <iostream>\nusing namespace std;\n\nstruct ListNode {\n    int val;\n    ListNode *next;\n    ListNode() : val(0), next(nullptr) {}\n    ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode *next) : val(x), next(next) {}\n};\n\nclass Solution {\npublic:\n    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {\n        if (!list1) return list2;\n        if (!list2) return list1;\n        \n        if (list1->val < list2->val) {\n            list1->next = mergeTwoLists(list1->next, list2);\n            return list1;\n        } else {\n            list2->next = mergeTwoLists(list1, list2->next);\n            return list2;\n        }\n    }\n};', '1.0', '2025-04-22 14:45:17', '2025-04-22 14:45:17');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (170, 43, 3, '// Java 解决方案\npublic ListNode mergeTwoLists(ListNode l1, ListNode l2) {\n    ListNode dummy = new ListNode(0);\n    ListNode tail = dummy;\n    \n    while (l1 != null && l2 != null) {\n        if (l1.val <= l2.val) {\n            tail.next = l1;\n            l1 = l1.next;\n        } else {\n            tail.next = l2;\n            l2 = l2.next;\n        }\n        tail = tail.next;\n    }\n    \n    tail.next = (l1 != null) ? l1 : l2;\n    return dummy.next;\n}', '1.0', '2025-04-22 14:45:17', '2025-04-22 14:45:17');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (171, 43, 2, '# Python 解决方案\ndef mergeTwoLists(l1, l2):\n    dummy = ListNode(0)\n    tail = dummy\n    \n    while l1 and l2:\n        if l1.val <= l2.val:\n            tail.next = l1\n            l1 = l1.next\n        else:\n            tail.next = l2\n            l2 = l2.next\n        tail = tail.next\n    \n    tail.next = l1 if l1 else l2\n    return dummy.next', '1.0', '2025-04-22 14:45:17', '2025-04-22 14:45:17');
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答案——代码预设模板';

-- ----------------------------
-- Records of solution_languages
-- ----------------------------
BEGIN;
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (1, 'c', '#include <stdio.h>\n\nint main() {\n    // 你的代码\n    return 0;\n}', '2025-02-09 20:35:22');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (2, 'python', 'def solution():\n    # 你的代码\n    pass', '2025-02-09 20:40:33');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (3, 'java', 'public class Solution {\n    public static void main(String[] args) {\n        // 你的代码\n    }\n}', '2025-02-09 20:40:33');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (4, 'cpp', '#include <iostream>\nusing namespace std;\n\nint main() {\n    // 代码实现\n    return 0;\n}', '2025-02-09 20:53:23');
COMMIT;

-- ----------------------------
-- Table structure for solution_main
-- ----------------------------
DROP TABLE IF EXISTS `solution_main`;
CREATE TABLE `solution_main` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `problem_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `solution_approach` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通用解题思路',
  `time_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均时间复杂度',
  `space_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均空间复杂度',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_main_problem` (`problem_id`),
  CONSTRAINT `fk_main_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答案——题目解答方案、时空复杂度';

-- ----------------------------
-- Records of solution_main
-- ----------------------------
BEGIN;
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (1, 1, '0001', '直接读取两个整数并相加输出即可。注意使用scanf读取输入，printf输出结果。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-04-19 22:39:19');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (2, 2, '0002', '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最大值，遍历数组更新最大值。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (3, 3, '0003', '读取字符串后，从后向前遍历字符串，依次输出每个字符即可得到反转结果。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (4, 4, '0004', '使用循环从1乘到n，注意使用long long类型避免整数溢出。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (5, 5, '0005', '定义isPrime函数判断是否为质数。从2到sqrt(n)遍历，如果n能被任何数整除则不是质数。', 'O(sqrt(n))', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (6, 6, '0006', '直接读取两个整数并相减输出即可。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (7, 7, '0007', '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最小值，遍历数组更新最小值。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (8, 8, '0008', '读取两个字符串后直接拼接输出即可。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (9, 9, '0009', '使用循环计算斐波那契数列。维护两个变量记录前两个数，不断更新得到下一个数。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (10, 10, '0010', '判断一个数除以2的余数是否为0即可。使用取模运算符%。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (11, 11, '0011', '使用冒泡排序算法，通过两层循环不断比较相邻元素并交换位置，将最大的元素逐步\"冒泡\"到数组末尾。', 'O(n^2)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (12, 12, '0012', '遍历字符串，统计目标字符出现的次数。使用循环和计数器实现。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (13, 13, '0013', '使用strtok函数分割字符串，遍历所有单词，跳过\"world\"单词不输出。注意处理空格和字符串拼接。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (14, 14, '0014', '使用欧几里得算法（辗转相除法）求最大公约数。递归实现：当b为0时返回a，否则递归计算gcd(b, a%b)。', 'O(log(min(a,b)))', 'O(log(min(a,b)))', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (15, 15, '0015', '将数字反转，如果反转后的数字等于原数字，则是回文数。使用取模和除法运算逐位提取数字并重新组合。', 'O(log n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (16, 16, '0016', '使用二维数组存储两个矩阵，对应位置的元素相加即可。注意输出格式的处理。', 'O(n*m)', 'O(n*m)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (17, 17, '0017', '先将字符串按空格分割成单词数组，然后从后向前遍历数组输出单词。注意处理单词之间的空格。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (18, 18, '0018', '使用二维数组存储杨辉三角，每个数是上一行相邻两个数的和。第一列全为1，其他位置的值等于上一行的相邻两个数之和。', 'O(n^2)', 'O(n^2)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (19, 19, '0019', '在给定范围内遍历每个数，使用isPrime函数判断是否为质数。注意输出格式，数字之间需要空格分隔。', 'O((end-start)*sqrt(max(end)))', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (20, 20, '0020', '使用一个新数组存储不重复的元素。遍历原数组，对于每个元素，检查是否已经在新数组中存在，如果不存在则添加到新数组。', 'O(n^2)', 'O(n)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (21, 21, '0021', '使用一个变量sum累加数组中的每个元素。遍历一次数组即可得到总和。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (22, 22, '0022', '从字符串末尾向前遍历，依次输出每个字符即可得到反转的字符串。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (23, 23, '0023', '使用迭代方法计算斐波那契数列。维护三个变量a、b、c，其中a和b分别表示前两个数，c用于计算它们的和。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (25, 25, '0024', '判断一个数是否为偶数，只需要判断它除以2的余数是否为0。使用取模运算符%即可。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (29, 29, '0025', '从左到右遍历二进制字符串，对于每一位，将当前结果乘2再加上当前位的值。注意字符转数字需要减去字符\'0\'的ASCII值。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (33, 33, '0027', '对应题目0027', 'O(N)', 'O(1)', '2025-02-25 18:45:04', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (34, 30, '0026', '对应题目0028', '', '', '2025-02-25 18:49:52', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (35, 34, '0028', '对应题目0029', '11', '11', '2025-02-25 19:00:52', '2025-04-16 22:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (37, 38, '0029', '使用队列实现广度优先搜索，逐层处理二叉树节点。', 'O(n)', 'O(n)', '2025-04-14 09:37:43', '2025-04-16 22:54:48');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (41, 42, '0030', '动态规划方法：利用状态转移方程 P(i,j)=(P(i+1,j−1) and S[i]==S[j])，逐步找到最长回文子串。', 'O(n²)', 'O(n²)', '2025-04-16 22:33:52', '2025-04-16 22:54:48');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (43, 44, '0031', '使用递归或迭代方法，比较两个链表的头节点，选择较小的一个作为新链表的头，然后递归处理剩余部分。', 'O(n+m)', 'O(1)', '2025-04-22 14:45:17', '2025-04-23 15:04:01');
COMMIT;

-- ----------------------------
-- Table structure for student_info
-- ----------------------------
DROP TABLE IF EXISTS `student_info`;
CREATE TABLE `student_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '关联用户ID',
  `student_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学号',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '真实姓名',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '院系',
  `major` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '专业',
  `grade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '年级',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `class_id` int DEFAULT NULL COMMENT '关联班级ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_no` (`student_no`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  KEY `fk_student_class` (`class_id`),
  CONSTRAINT `fk_student_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台管理——学生管理信息表';

-- ----------------------------
-- Records of student_info
-- ----------------------------
BEGIN;
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (1, 1, '202313008218', '吴益通', '人文学院', '舞蹈学', '2023', '2025-03-04 14:44:14', '2025-03-05 09:16:48', 3);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (24, 11, '202313008221', '张伟', '理工学院', '计算机科学与技术', '2023', '2025-04-18 01:16:17', '2025-04-22 14:45:35', 1);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (25, 12, '202313008222', '李娜', '理工学院', '软件工程', '2023', '2025-04-18 01:16:17', NULL, 2);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (26, 13, '202313008223', '王强', '理工学院', '数据科学与大数据技术', '2023', '2025-04-18 01:16:17', NULL, 3);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (27, 14, '202313008224', '赵敏', '理工学院', '人工智能', '2023', '2025-04-18 01:16:17', NULL, 5);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (28, 15, '202313008225', '陈明', '理工学院', '物联网工程', '2023', '2025-04-18 01:16:17', NULL, 6);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (29, 16, '202313008226', '刘洋', '人文学院', '汉语言文学', '2023', '2025-04-18 01:16:17', NULL, 7);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (30, 17, '202313008227', '杨帆', '人文学院', '英语', '2023', '2025-04-18 01:16:17', NULL, 8);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (31, 18, '202313008228', '周杰', '人文学院', '新闻学', '2023', '2025-04-18 01:16:17', NULL, 9);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (32, 19, '202313008229', '吴丽', '人文学院', '历史学', '2023', '2025-04-18 01:16:17', NULL, 10);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (33, 20, '202313008230', '徐刚', '教育学院', '教育学', '2023', '2025-04-18 01:16:17', NULL, 1);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (34, 21, '202313008231', '马琳', '教育学院', '学前教育', '2023', '2025-04-18 01:16:17', NULL, 2);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (35, 22, '202313008232', '郭峰', '教育学院', '特殊教育', '2023', '2025-04-18 01:16:17', NULL, 3);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (36, 23, '202313008233', '何静', '体育学院', '体育教育', '2023', '2025-04-18 01:16:17', NULL, 4);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (37, 24, '202313008234', '孙宇', '体育学院', '运动训练', '2023', '2025-04-18 01:16:17', NULL, 5);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (38, 25, '202313008235', '林涛', '体育学院', '体育经济与管理', '2023', '2025-04-18 01:16:17', NULL, 6);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (39, 26, '202313008236', '朱琪', '美术学院', '美术学', '2023', '2025-04-18 01:16:17', NULL, 7);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (40, 27, '202313008237', '胡明', '美术学院', '动画', '2023', '2025-04-18 01:16:17', NULL, 8);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (41, 28, '202313008238', '冯雪', '美术学院', '视觉传达设计', '2023', '2025-04-18 01:16:17', NULL, 9);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (42, 29, '202313008239', '董芳', '舞蹈学院', '舞蹈编导', '2023', '2025-04-18 01:16:17', NULL, 10);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (43, 30, '202313008240', '蒋伟', '舞蹈学院', '舞蹈表演', '2023', '2025-04-18 01:16:17', NULL, 11);
COMMIT;

-- ----------------------------
-- Table structure for submissions
-- ----------------------------
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE `submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '提交用户ID',
  `problem_id` int NOT NULL COMMENT '题目ID',
  `problem_number` varchar(50) DEFAULT NULL,
  `code` text NOT NULL COMMENT '提交的代码',
  `language` varchar(10) NOT NULL COMMENT '编程语言',
  `runtime` int DEFAULT NULL COMMENT '运行时间(ms)',
  `memory` int DEFAULT NULL COMMENT '内存消耗(KB)',
  `error_message` text COMMENT '错误信息',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `status` enum('Pending','Accepted','Wrong Answer','Runtime Error','Compilation Error','Time Limit Exceeded','Memory Limit Exceeded','System Error','Not Accepted') DEFAULT 'Pending',
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_problem` (`user_id`,`problem_id`),
  KEY `fk_submission_problem` (`problem_id`),
  CONSTRAINT `fk_submission_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`),
  CONSTRAINT `fk_submission_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目——用户提交记录表';

-- ----------------------------
-- Records of submissions
-- ----------------------------
BEGIN;
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (1, 1, 1, '0001', 'dawdwa', 'c', 0, 632, 'Command failed: docker exec judge-d273ef5b-71fc-420c-a01d-e39ce74c6bcc bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dawdwa\n      | ^~~~~~\n', '2025-01-22 15:52:59', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (2, 1, 1, '0001', 'dwada', 'c_cpp', 0, 0, '不支持的编程语言: c_cpp', '2025-01-22 15:59:54', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (3, 1, 1, '0001', 'sdawddw', 'c', 0, 648, 'Command failed: docker exec judge-6e29f569-774a-463d-ac97-f2e050c99eea bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | sdawddw\n      | ^~~~~~~\n', '2025-01-22 16:00:09', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (4, 1, 1, '0001', 'dwadwa', 'c', 0, 632, 'Command failed: docker exec judge-b95bcccc-affd-4b1e-8d42-5870f375d7bf bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dwadwa\n      | ^~~~~~\n', '2025-01-22 16:03:09', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (5, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', NULL, NULL, '题目或测试用例不存在', '2025-01-22 16:05:37', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (6, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 968, NULL, '2025-01-22 16:06:47', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (7, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-22 16:10:04', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (8, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 920, NULL, '2025-01-22 16:12:45', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (9, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-22 16:14:48', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (10, 1, 7, '0007', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-22 16:18:03', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (11, 1, 7, '0007', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 780, NULL, '2025-01-22 16:18:42', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (12, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'cpp', 0, 736, NULL, '2025-01-23 09:11:17', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (13, 1, 6, '0006', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 10:09:15', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (14, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-8c3a65c2-9edf-45b7-8f85-eb1850574220 -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:04:00', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (15, 1, 6, '0006', '？？？', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-506c7e0d-fa9f-4826-a515-6c6e21f2994c -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:04:38', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (16, 1, 9, '0009', '1111', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-2a428ea4-b310-490e-ab83-5a6ff1f4280b -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:05:19', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (17, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 34, NULL, '2025-01-23 14:06:31', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (18, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', '', 0, 0, '不支持的编程语言: ', '2025-01-23 14:08:28', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (19, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 14:08:44', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (20, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-23 16:24:13', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (21, 1, 3, '0003', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 2, NULL, '2025-01-23 16:24:55', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (22, 1, 4, '0004', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    long long result = 1;\n    for(int i = 1; i <= n; i++) {\n        result *= i;\n    }\n    printf(\"%lld\\n\", result);\n    return 0;\n}', 'c', 0, 916, NULL, '2025-01-23 16:28:04', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (23, 1, 5, '0005', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++) {\n        if(n % i == 0) return 0;\n    }\n    return 1;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPrime(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-23 16:28:24', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (29, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 724, 'Wrong Answer\n输入: 6\n期望输出: undefined\n实际输出: ', '2025-01-25 10:06:52', 'Wrong Answer', '2025-01-25 10:06:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (30, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 732, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:09:52', 'System Error', '2025-01-25 10:09:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (31, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 24, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:10:09', 'System Error', '2025-01-25 10:10:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (32, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 704, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:12:58', 'System Error', '2025-01-25 10:13:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (33, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:14:53', 'System Error', '2025-01-25 10:14:56');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (34, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, NULL, '2025-01-25 10:16:37', 'Accepted', '2025-01-25 10:16:45');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (35, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-25 10:21:47', 'Accepted', '2025-01-25 10:21:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (36, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-25 12:18:43', 'Accepted', '2025-01-25 12:18:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (37, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 0, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-4c49472e-d895-4264-9605-d9f7561c0c28 -w /app gcc:latest tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-26 11:47:20', 'System Error', '2025-01-26 11:47:20');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (38, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 36, NULL, '2025-01-26 11:55:03', 'Accepted', '2025-01-26 11:55:10');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (39, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-26 11:57:19', 'Accepted', '2025-01-26 11:57:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (40, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'cpp', 0, 29, NULL, '2025-01-26 11:58:57', 'Accepted', '2025-01-26 11:59:04');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (41, 1, 19, '0019', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-26 12:00:42', 'Accepted', '2025-01-26 12:00:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (42, 1, 19, '0019', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 768, NULL, '2025-01-26 12:02:21', 'Accepted', '2025-01-26 12:02:29');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (43, 1, 19, '0019', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 704, NULL, '2025-01-26 12:04:13', 'Accepted', '2025-01-26 12:04:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (44, 1, 15, '0015', '#include <stdio.h>\n\nint isPalindrome(int n) {\n    int reversed = 0, original = n;\n    while(n > 0) {\n        reversed = reversed * 10 + n % 10;\n        n /= 10;\n    }\n    return original == reversed;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPalindrome(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-26 12:09:54', 'Accepted', '2025-01-26 12:10:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (45, 1, 10, '0010', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", n % 2 == 0 ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 852, NULL, '2025-01-26 12:39:17', 'Accepted', '2025-01-26 12:39:24');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (46, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:42:37', 'Wrong Answer', '2025-01-26 12:42:40');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (47, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 740, NULL, '2025-01-26 12:44:06', 'Accepted', '2025-01-26 12:44:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (48, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 660, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:46:28', 'Wrong Answer', '2025-01-26 12:46:31');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (49, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:48:22', 'Wrong Answer', '2025-01-26 12:48:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (50, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 672, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:48:42', 'Wrong Answer', '2025-01-26 12:48:46');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (51, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:49:29', 'Wrong Answer', '2025-01-26 12:49:31');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (52, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:51:51', 'Wrong Answer', '2025-01-26 12:51:54');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (53, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:13', 'Wrong Answer', '2025-01-26 12:52:17');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (54, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 652, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:21', 'Wrong Answer', '2025-01-26 12:52:23');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (55, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 684, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:54', 'Wrong Answer', '2025-01-26 12:52:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (57, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 748, NULL, '2025-01-26 12:55:29', 'Accepted', '2025-01-26 12:55:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (58, 1, 3, '0003', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 728, NULL, '2025-01-26 13:04:58', 'Accepted', '2025-01-26 13:05:05');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (59, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, 'Cannot read properties of undefined (reading \'0\')', '2025-02-05 16:43:55', 'System Error', '2025-02-05 16:43:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (60, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-02-05 16:45:48', 'System Error', '2025-02-05 16:45:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (61, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:47:35', 'Accepted', '2025-02-05 16:47:38');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (62, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:47:58', 'Accepted', '2025-02-05 16:48:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (63, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:49:49', 'Accepted', '2025-02-05 16:49:51');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (64, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 387, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 16:52:55', 'Wrong Answer', '2025-02-05 16:52:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (65, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 401, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 16:58:36', 'Wrong Answer', '2025-02-05 16:58:38');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (66, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 397, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:08:04', 'Wrong Answer', '2025-02-05 17:08:06');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (67, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 426, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:13:22', 'Wrong Answer', '2025-02-05 17:13:24');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (68, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 304, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:13:24', 'Wrong Answer', '2025-02-05 17:13:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (69, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 420, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:35:07', 'Wrong Answer', '2025-02-05 17:35:09');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (70, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 17:39:39', 'Accepted', '2025-02-05 17:39:42');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (71, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 17:40:23', 'Accepted', '2025-02-05 17:40:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (78, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 13:30:13', 'Accepted', '2025-02-06 13:30:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (79, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 13:31:52', 'Accepted', '2025-02-06 13:31:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (80, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 298, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 13:32:08', 'Wrong Answer', '2025-02-06 13:32:09');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (81, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 14:05:19', 'Accepted', '2025-02-06 14:05:22');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (82, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 404, 0, NULL, '2025-02-06 14:06:46', 'Accepted', '2025-02-06 14:06:48');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (83, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 381, 608, NULL, '2025-02-06 14:11:13', 'Accepted', '2025-02-06 14:11:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (84, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '运行时错误：\n不支持的编程语言\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-02-17 16:57:57', 'Runtime Error', '2025-02-17 16:57:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (85, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1286, 592, NULL, '2025-02-17 17:02:07', 'Accepted', '2025-02-17 17:02:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (86, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'C', 353, 680, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-03-07 16:03:48', 'Wrong Answer', '2025-03-07 16:03:51');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (87, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, NULL, '2025-04-03 08:56:05', 'System Error', '2025-04-03 08:56:05');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (88, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, NULL, '2025-04-03 08:58:58', 'System Error', '2025-04-03 08:58:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (89, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 2997, 592, NULL, '2025-04-03 09:00:32', 'Accepted', '2025-04-03 09:00:45');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (90, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1634, 592, NULL, '2025-04-04 20:08:30', 'Accepted', '2025-04-04 20:08:41');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (91, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'C', 521, 3, NULL, '2025-04-11 09:08:24', 'Accepted', '2025-04-11 09:08:28');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (92, 1, 30, '0026', '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}', 'C', 0, 0, '编译错误：\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1744703740984.c:2:25: warning: declaration of \'struct TreeNode\' will not be visible outside of this function [-Wvisibility]\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n                        ^\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1744703740984.c:5:1: warning: non-void function does not return a value [-Wreturn-type]\n}\n^\n2 warnings generated.\nUndefined symbols for architecture arm64:\n  \"_main\", referenced from:\n      <initial-undefines>\nld: symbol(s) not found for architecture arm64\nclang: error: linker command failed with exit code 1 (use -v to see invocation)\n\n\n请检查代码的语法是否正确。', '2025-04-15 15:55:39', 'System Error', '2025-04-15 15:55:41');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (93, 1, 30, '0026', '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}', 'C', 327, 592, '提交结果：答案错误\n\n测试用例：\n输入：6\n100 4 200 1 3 2\n期望输出：4\n您的输出：代码成功编译！\n\n请检查您的代码逻辑是否正确。', '2025-04-15 16:00:54', 'Wrong Answer', '2025-04-15 16:00:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (94, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1804, 600, NULL, '2025-04-16 21:52:01', 'Accepted', '2025-04-16 21:52:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (95, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'C', 0, 0, '编译错误：\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027111113.c:6:1: error: type specifier missing, defaults to \'int\'; ISO C99 and later do not support implicit int [-Wimplicit-int]\nn = int(input())\n^\nint\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027111113.c:6:5: error: expected expression\nn = int(input())\n    ^\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027111113.c:14:2: error: expected \';\' after top level declarator\n}\n ^\n ;\n3 errors generated.\n\n\n请检查代码的语法是否正确。', '2025-04-19 09:45:09', 'System Error', '2025-04-19 09:45:11');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (96, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'Python', 400, 676, '提交结果：答案错误\n\n测试用例：\n输入：5\n1 5 3 8 2\n期望输出：8\n您的输出：8\n代码成功运行！\n\n请检查您的代码逻辑是否正确。', '2025-04-19 09:46:32', 'Wrong Answer', '2025-04-19 09:46:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (97, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'Python', 60, 600, NULL, '2025-04-19 09:48:57', 'Accepted', '2025-04-19 09:49:00');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (98, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-030d7305-94ae-48cc-8876-67c16e562d4d javac /app/temp_1745027421133.java\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 09:50:19', 'Runtime Error', '2025-04-19 09:50:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (99, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, NULL, '2025-04-19 09:55:12', 'System Error', '2025-04-19 09:55:12');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (100, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, NULL, '2025-04-19 09:55:23', 'System Error', '2025-04-19 09:55:23');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (101, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027796653.java undefined:/app/temp_1745027796653.java\nError response from daemon: No such container: undefined\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 09:56:36', 'Runtime Error', '2025-04-19 09:56:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (102, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027806126.java undefined:/app/temp_1745027806126.java\nError response from daemon: No such container: undefined\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 09:56:46', 'Runtime Error', '2025-04-19 09:56:46');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (103, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-cc9ea430-b42e-4eb8-821b-e40774c80c92 javac /app/temp_1745027966145.java\n/app/temp_1745027966145.java:3: error: class Main is public, should be declared in a file named Main.java\npublic class Main {\n       ^\n1 error\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 09:59:24', 'Runtime Error', '2025-04-19 09:59:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (104, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-7097e91e-1cab-478a-8cfe-c555d95d5dbb java -cp /app temp_1745028058713 < /app/input_1745028058713.txt\n/bin/sh: /app/input_1745028058713.txt: No such file or directory\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 10:00:57', 'Runtime Error', '2025-04-19 10:00:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (105, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-63815acf-2a86-42a4-9d19-880afba25908 bash -c \"cat /app/input_1745028165148.txt | java -cp /app temp_1745028165148\"\nError: Could not find or load main class temp_1745028165148\nCaused by: java.lang.ClassNotFoundException: temp_1745028165148\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 10:02:43', 'Runtime Error', '2025-04-19 10:02:45');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (106, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 105, 888, NULL, '2025-04-19 10:06:40', 'Accepted', '2025-04-19 10:06:44');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (107, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-04-19 10:12:16', 'System Error', '2025-04-19 10:12:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (108, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-04-19 10:13:19', 'System Error', '2025-04-19 10:13:19');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (109, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 595, 612, NULL, '2025-04-19 10:16:16', 'Accepted', '2025-04-19 10:16:20');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (110, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'C', 441, 596, NULL, '2025-04-19 10:24:53', 'Accepted', '2025-04-19 10:24:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (111, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'C', 401, 588, NULL, '2025-04-19 10:25:17', 'Accepted', '2025-04-19 10:25:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (112, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'Python', 70, 628, NULL, '2025-04-19 10:31:07', 'Accepted', '2025-04-19 10:31:10');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (113, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 578, 592, NULL, '2025-04-19 10:31:22', 'Accepted', '2025-04-19 10:31:27');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (114, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-06d492de-c61c-472e-952c-198f2d6df4d1 javac /app/temp_1745029906518.java\n/app/temp_1745029906518.java:3: error: class Main is public, should be declared in a file named Main.java\npublic class Main {\n       ^\n1 error\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 10:31:45', 'Runtime Error', '2025-04-19 10:31:47');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (115, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 102, 892, NULL, '2025-04-19 10:31:55', 'Accepted', '2025-04-19 10:31:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (116, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1727, 596, NULL, '2025-04-19 10:48:36', 'Accepted', '2025-04-19 10:48:48');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (117, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    printf(\"5\");\n    return 0;\n}', 'C', 647, 600, '答案错误（隐藏用例）\n请检查您的代码逻辑是否正确。', '2025-04-20 10:12:44', 'Wrong Answer', '2025-04-20 10:12:49');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (118, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 314, 3, NULL, '2025-04-22 12:20:36', 'Accepted', '2025-04-22 12:20:48');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (119, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 280, 616, NULL, '2025-04-23 13:58:40', 'Accepted', '2025-04-23 13:58:52');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (120, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 234, 588, NULL, '2025-04-23 14:11:31', 'Accepted', '2025-04-23 14:11:43');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (121, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 225, 596, NULL, '2025-04-23 14:26:08', 'Accepted', '2025-04-23 14:26:19');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (122, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 214, 592, NULL, '2025-04-23 14:47:39', 'Accepted', '2025-04-23 14:47:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (123, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '编译错误：\n编译过程发生系统错误\n\n请检查代码的语法是否正确。', '2025-04-23 14:51:39', 'System Error', '2025-04-23 14:51:40');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (124, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '运行时错误：\n/bin/sh: /app/src/temp/463360a5-69c5-49c0-aab6-5bdb33c7b992/temp_1745420015719.out: not found\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-23 14:53:33', 'Runtime Error', '2025-04-23 14:53:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (125, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '运行时错误：\n程序执行时发生错误\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-23 14:54:31', 'Runtime Error', '2025-04-23 14:54:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (126, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1811, 736, NULL, '2025-04-23 14:55:47', 'Accepted', '2025-04-23 14:55:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (127, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'C', 295, 2, NULL, '2025-04-23 14:57:50', 'Accepted', '2025-04-23 14:57:55');
COMMIT;

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
  `expertise_level` varchar(50) DEFAULT NULL,
  `learning_goal` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb3 COMMENT='全局——用户显示资料表';

-- ----------------------------
-- Records of user_profile
-- ----------------------------
BEGIN;
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (1, 1, 'admin', '1艾垦', 'public/uploads/avatars/avatar-1741487554262-652128186.png', '男性', '2025-01-01', '柳州', '服务器Admin\n', NULL, NULL, '2025-01-23 10:25:55', '2025-03-09 10:32:34');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (8, 3, 'test', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-05 11:10:37', '2025-02-05 11:10:37');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (20, 6, 'student1', '学生1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-05 11:53:55', '2025-02-05 11:53:55');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (21, 7, 'VIP1', '会员1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-05 11:57:34', '2025-02-05 11:57:34');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (22, 8, 'student', 'student', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-03-08 10:58:41', '2025-03-08 10:58:41');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (23, 9, 'teacher', 'teacher', 'public/uploads/avatars/avatar-1743567478394-445763381.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-03-08 11:01:51', '2025-04-02 12:17:58');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (27, 11, 'johndoe', '约翰多', 'public/uploads/avatars/avatar-1744910086N-000000001.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (28, 12, 'janedoe', '简妮', 'public/uploads/avatars/avatar-1744910088N-000000002.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (29, 13, 'bobsmith', '鲍勃', 'public/uploads/avatars/avatar-1744910090N-000000003.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (30, 14, 'alicewang', '艾丽丝', 'public/uploads/avatars/avatar-1744910092N-000000004.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (31, 15, 'mikebrown', '迈克', 'public/uploads/avatars/avatar-1744910093N-000000005.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (32, 16, 'sarahlee', '莎拉', 'public/uploads/avatars/avatar-1744910094N-000000006.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-23 15:03:46');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (33, 17, 'davidzhou', '大卫', 'public/uploads/avatars/avatar-1744910096N-000000007.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (34, 18, 'lindachen', '琳达', 'public/uploads/avatars/avatar-1744910097N-000000008.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (35, 19, 'tomwilson', '汤姆', 'public/uploads/avatars/avatar-1744910098N-000000009.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (36, 20, 'emmajones', '艾玛', 'public/uploads/avatars/avatar-1744910100N-000000010.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (37, 21, 'ryankim', '瑞安', 'public/uploads/avatars/avatar-1744910102N-000000011.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (38, 22, 'sophiama', '索菲亚', 'public/uploads/avatars/avatar-1744910103N-000000012.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (39, 23, 'alexpark', '亚历克斯', 'public/uploads/avatars/avatar-1744910105N-000000013.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (40, 24, 'hannahli', '汉娜', 'public/uploads/avatars/avatar-1744910106N-000000014.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (41, 25, 'jasontan', '杰森', 'public/uploads/avatars/avatar-1744910107N-000000015.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (42, 26, 'oliviazhang', '奥利维亚', 'public/uploads/avatars/avatar-1744910109N-000000016.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (43, 27, 'williamgao', '威廉', 'public/uploads/avatars/avatar-1744910110N-000000017.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (44, 28, 'nataliewu', '娜塔莉', 'public/uploads/avatars/avatar-1744910112N-000000018.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (45, 29, 'kevinliu', '凯文', 'public/uploads/avatars/avatar-1744910113N-000000019.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`) VALUES (46, 30, 'gracezhu', '格蕾丝', 'public/uploads/avatars/avatar-1744910114N-000000020.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 01:15:56', '2025-04-18 01:15:56');
COMMIT;

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_name` enum('normal','vip','super_vip','teacher','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户角色：普通用户、会员用户、超级会员用户、教师用户、管理员用户',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色描述',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局——角色描述表';

-- ----------------------------
-- Records of user_roles
-- ----------------------------
BEGIN;
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (1, 'normal', '普通用户，基础功能访问权限', '2025-02-03 16:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (2, 'vip', '会员用户，享有更多学习资源和功能', '2025-02-03 16:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (3, 'super_vip', '超级会员用户，享有全部学习资源和特权功能', '2025-02-03 16:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (4, 'teacher', '教师用户，可以创建课程和管理学生', '2025-02-03 16:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (5, 'admin', '管理员用户，系统最高权限', '2025-02-03 16:35:24');
COMMIT;

-- ----------------------------
-- Table structure for user_visits
-- ----------------------------
DROP TABLE IF EXISTS `user_visits`;
CREATE TABLE `user_visits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '访问用户ID',
  `visit_date` date NOT NULL COMMENT '访问日期',
  `first_visit_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次访问时间',
  `visit_count` int DEFAULT '1' COMMENT '当天访问次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_date` (`user_id`,`visit_date`),
  KEY `idx_visit_date` (`visit_date`),
  CONSTRAINT `fk_visit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=382 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局——用户访问网站记录表';

-- ----------------------------
-- Records of user_visits
-- ----------------------------
BEGIN;
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (1, 1, '2025-02-05', '2025-02-05 08:45:49', 35);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (3, 3, '2025-02-05', '2025-02-05 08:45:49', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (37, 1, '2025-02-06', '2025-02-06 12:45:33', 23);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (60, 1, '2025-02-09', '2025-02-09 21:36:08', 1);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (61, 1, '2025-02-18', '2025-02-18 15:50:24', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (64, 1, '2025-02-24', '2025-02-24 14:29:17', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (71, 1, '2025-02-25', '2025-02-25 18:11:46', 11);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (82, 1, '2025-02-27', '2025-02-27 13:25:05', 10);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (92, 1, '2025-02-28', '2025-02-28 11:02:27', 22);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (114, 1, '2025-03-03', '2025-03-03 08:24:29', 5);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (119, 1, '2025-03-04', '2025-03-04 13:50:02', 4);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (123, 1, '2025-03-05', '2025-03-05 08:10:51', 19);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (142, 1, '2025-03-06', '2025-03-06 08:10:33', 10);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (152, 1, '2025-03-07', '2025-03-07 08:22:14', 17);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (169, 1, '2025-03-08', '2025-03-08 10:22:31', 12);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (171, 9, '2025-03-08', '2025-03-08 11:08:15', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (188, 1, '2025-03-09', '2025-03-09 10:33:45', 5);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (193, 1, '2025-03-10', '2025-03-10 08:30:25', 15);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (208, 1, '2025-03-13', '2025-03-13 11:09:45', 1);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (209, 1, '2025-03-28', '2025-03-28 02:14:38', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (211, 9, '2025-04-02', '2025-04-02 12:21:55', 1);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (212, 1, '2025-04-02', '2025-04-02 12:22:23', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (219, 1, '2025-04-03', '2025-04-03 00:05:09', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (226, 1, '2025-04-04', '2025-04-04 11:26:46', 6);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (232, 1, '2025-04-08', '2025-04-08 11:07:17', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (235, 1, '2025-04-10', '2025-04-10 08:56:51', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (237, 1, '2025-04-11', '2025-04-11 09:10:10', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (239, 1, '2025-04-13', '2025-04-13 13:47:47', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (241, 1, '2025-04-14', '2025-04-14 08:16:21', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (244, 1, '2025-04-15', '2025-04-15 15:55:15', 5);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (249, 1, '2025-04-16', '2025-04-16 10:00:44', 22);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (271, 1, '2025-04-17', '2025-04-17 00:14:30', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (273, 1, '2025-04-18', '2025-04-18 00:23:09', 21);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (294, 1, '2025-04-19', '2025-04-19 09:44:40', 38);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (332, 1, '2025-04-20', '2025-04-20 01:51:46', 4);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (336, 1, '2025-04-21', '2025-04-21 11:07:18', 4);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (340, 1, '2025-04-22', '2025-04-22 03:19:13', 15);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (355, 1, '2025-04-23', '2025-04-23 13:47:59', 27);
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT '1',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('normal','vip','super_vip','teacher','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '用户角色',
  `role_expire_time` timestamp NULL DEFAULT NULL COMMENT '角色过期时间（针对会员）',
  `refresh_token` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_phone` (`phone`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局——用户隐私信息表';

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (1, 'admin', '$2b$10$SMRZ1RWfh.lR1YqyYgsw6uwnPyLnScDXqN3RMGVr3iGSAmXmm6ex2', 'admin@example.com', NULL, '2025-01-22 12:15:35', 1, NULL, 'admin', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NDUzMTE4NDQsImV4cCI6MTc0NTkxNjY0NCwiYXVkIjoiQUlyZXZpZXctY2xpZW50IiwiaXNzIjoiQUlyZXZpZXcifQ.bnawTxPN_ziGoAo6kOm0QYcqjNp9iO4HG3uB2PN9krQ');
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (3, 'test', 'test123', '123@qq.com', NULL, '2025-01-24 10:03:39', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (6, 'student1', '$2b$10$kti7yxUgaM9A3Mngg4VAk.aXB0F/4cd7MFTq0MYMgT42HiYSXvWsK', 'xuesheng@qq.com', NULL, '2025-02-05 11:53:55', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (7, 'VIP1', '$2b$10$pw2KRFpKOgR8SDm/si.UmuCVI0k5Yv5pbX8cv30D2KM7T8XooJETK', 'vip1@qq.com', NULL, '2025-02-05 11:57:34', 1, NULL, 'vip', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (8, 'student', '$2b$10$nru7E2W1IQkM2bjMQmBlhuv19FAsdRYRvaWngRwHj4dGgWHCQz8vm', '13377238689@163.com', NULL, '2025-03-08 10:58:41', 1, NULL, 'normal', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NDUzMDQ5MDksImV4cCI6MTc0NTkwOTcwOSwiYXVkIjoiQUlyZXZpZXctY2xpZW50IiwiaXNzIjoiQUlyZXZpZXcifQ.NYPsBJedQLvTGVX__K7WtLsEh9CXRbzSl0LfGL3ifYw');
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (9, 'teacher', '$2b$10$jrVuQ6u6D89wzZpD4eVyQ.OTyVmHFmiH0LSKDLF9usHnCQJdQh3ae', '17324042932@163.com', '17324042932', '2025-03-08 11:01:51', 1, NULL, 'teacher', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NDUzMDQ5MTgsImV4cCI6MTc0NTkwOTcxOCwiYXVkIjoiQUlyZXZpZXctY2xpZW50IiwiaXNzIjoiQUlyZXZpZXcifQ.YdGzbJvQEhswoEqA_2JPNnnCs-mlGNsP_JOdouOPCRo');
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (11, 'johndoe', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'johndoe@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'admin', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (12, 'janedoe', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'janedoe@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (13, 'bobsmith', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'bobsmith@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (14, 'alicewang', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'alicewang@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (15, 'mikebrown', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'mikebrown@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (16, 'sarahlee', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'sarahlee@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'super_vip', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (17, 'davidzhou', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'davidzhou@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (18, 'lindachen', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'lindachen@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (19, 'tomwilson', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'tomwilson@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (20, 'emmajones', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'emmajones@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (21, 'ryankim', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'ryankim@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'admin', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (22, 'sophiama', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'sophiama@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'super_vip', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (23, 'alexpark', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'alexpark@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (24, 'hannahli', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'hannahli@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (25, 'jasontan', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'jasontan@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (26, 'oliviazhang', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'oliviazhang@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (27, 'williamgao', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'williamgao@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (28, 'nataliewu', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'nataliewu@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (29, 'kevinliu', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'kevinliu@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'super_vip', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (30, 'gracezhu', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'gracezhu@example.com', NULL, '2025-04-18 01:15:40', 1, NULL, 'normal', NULL, NULL);
COMMIT;

-- ----------------------------
-- View structure for problem_stats
-- ----------------------------
DROP VIEW IF EXISTS `problem_stats`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `problem_stats` AS select `p`.`problem_number` AS `problem_number`,count(distinct `s`.`id`) AS `total_submissions`,count(distinct (case when (`s`.`status` = 'Accepted') then `s`.`id` end)) AS `accepted_submissions`,round(((count(distinct (case when (`s`.`status` = 'Accepted') then `s`.`id` end)) * 100.0) / nullif(count(distinct `s`.`id`),0)),2) AS `acceptance_rate` from (`problems` `p` left join `submissions` `s` on((`p`.`problem_number` = `s`.`problem_id`))) group by `p`.`problem_number`;

SET FOREIGN_KEY_CHECKS = 1;
