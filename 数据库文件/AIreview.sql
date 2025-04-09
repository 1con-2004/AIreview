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

 Date: 04/04/2025 17:24:39
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='班级信息表';

-- ----------------------------
-- Records of classes
-- ----------------------------
BEGIN;
INSERT INTO `classes` (`id`, `class_name`) VALUES (1, '2023级计算机科学与技术1班');
INSERT INTO `classes` (`id`, `class_name`) VALUES (2, '舞蹈学');
INSERT INTO `classes` (`id`, `class_name`) VALUES (3, '舞蹈学2班');
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂文件表';

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
INSERT INTO `classrooms` (`id`, `classroom_code`, `teacher_id`, `title`, `description`, `status`, `created_at`, `updated_at`) VALUES (1, 'BWXHW', 1, 'JAVA', 'JAVA', 0, '2025-03-06 08:11:19', '2025-04-03 10:24:35');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of communities
-- ----------------------------
BEGIN;
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (1, '官方社区', 'official', '官方技术交流与公告发布', 'https://www.svgrepo.com/show/303388/java-4-logo.svg', NULL, NULL, NULL, '2025-01-21 18:05:10', 2, 1, NULL, '2025-01-22 12:27:37');
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (2, '算法学习社区', 'official', '一起学习数据结构与算法', 'https://www.svgrepo.com/show/353528/c.svg', NULL, NULL, NULL, '2025-01-21 18:05:10', 2, 1, NULL, '2025-01-22 12:27:37');
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (3, '前端技术社区', 'class', '前端开发技术交流', 'https://www.svgrepo.com/show/303494/vue-9-logo.svg', NULL, NULL, NULL, '2025-01-21 18:05:10', 2, 1, NULL, '2025-01-22 12:27:37');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of community_members
-- ----------------------------
BEGIN;
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (1, 1, 1, 'owner', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (2, 1, 2, 'admin', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (3, 1, 3, 'member', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (4, 1, 4, 'member', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (5, 2, 1, 'owner', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (6, 2, 2, 'admin', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (7, 2, 3, 'member', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (8, 3, 2, 'owner', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (9, 3, 3, 'admin', '2025-01-22 12:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (10, 3, 4, 'member', '2025-01-22 12:04:33', NULL, 1);
COMMIT;

-- ----------------------------
-- Table structure for community_posts
-- ----------------------------
DROP TABLE IF EXISTS `community_posts`;
CREATE TABLE `community_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `community_id` int NOT NULL,
  `user_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `view_count` int DEFAULT '0',
  `like_count` int DEFAULT '0',
  `comment_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `community_id` (`community_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `community_posts_ibfk_1` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `community_posts_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of community_posts
-- ----------------------------
BEGIN;
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (1, 1, 1, 'AI代码审查平台使用指南', '欢迎使用AI代码审查平台！本文将详细介绍平台的主要功能和使用方法。\n\n1. 代码提交与审查\n2. 社区互动功能\n3. 常见问题解答\n4. 最佳实践分享', 2580, 426, 85, '2025-01-21 10:00:00', '2025-01-22 09:30:00');
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (2, 1, 1, '2025年编程语言发展趋势分析', '根据最新的TIOBE指数和GitHub统计数据，我们来分析2025年各大编程语言的发展趋势：\n\n1. Python继续领跑AI/ML领域\n2. Rust在系统编程领域崭露头角\n3. TypeScript成为前端开发标配\n4. Go语言在云原生领域大放异彩', 3890, 658, 129, '2025-01-21 11:00:00', '2025-01-22 09:30:00');
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (3, 1, 1, 'AI辅助编程工具大比拼', 'GitHub Copilot vs Cursor vs Codeium，哪个更适合你？\n\n详细对比：\n1. 代码补全准确度\n2. 响应速度\n3. 对各语言的支持程度\n4. 价格对比\n5. 用户体验', 4420, 767, 155, '2025-01-21 14:00:00', '2025-01-22 09:30:00');
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (4, 1, 1, '新手入门：如何开始你的编程之旅', '给编程新手的一些建议：\n\n1. 选择适合的编程语言\n2. 学习路线规划\n3. 实践项目推荐\n4. 常见误区避免', 468, 89, 23, '2025-01-21 15:00:00', '2025-01-22 09:30:00');
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (5, 1, 1, '代码规范与最佳实践分享', '良好的代码规范可以提高代码质量和可维护性：\n\n1. 命名规范\n2. 注释规范\n3. 代码结构\n4. 常见反模式', 356, 67, 15, '2025-01-21 16:00:00', '2025-01-22 09:30:00');
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (6, 1, 1, '每周技术分享：Docker容器化实践', 'Docker容器化应用实战指南：\n\n1. Dockerfile最佳实践\n2. 多容器应用编排\n3. 性能优化技巧\n4. 常见问题解决', 289, 45, 12, '2025-01-21 17:00:00', '2025-01-22 09:30:00');
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (7, 1, 1, '编程工具推荐：提高生产力的VSCode插件', '精选VSCode插件推荐：\n\n1. 代码补全增强\n2. Git集成工具\n3. 代码质量检查\n4. 主题美化插件', 578, 98, 34, '2025-01-21 18:00:00', '2025-01-22 09:30:00');
INSERT INTO `community_posts` (`id`, `community_id`, `user_id`, `title`, `content`, `view_count`, `like_count`, `comment_count`, `created_at`, `updated_at`) VALUES (8, 1, 1, '云原生技术探讨：Kubernetes入门指南', 'Kubernetes基础知识和实践指南：\n\n1. 核心概念解析\n2. 部署策略\n3. 服务发现\n4. 监控方案', 645, 112, 28, '2025-01-21 19:00:00', '2025-01-22 09:30:00');
COMMIT;

-- ----------------------------
-- Table structure for group_members
-- ----------------------------
DROP TABLE IF EXISTS `group_members`;
CREATE TABLE `group_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL COMMENT '班级ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `join_time` datetime NOT NULL COMMENT '加入时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_user` (`group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `classroom_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `group_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='班级成员表';

-- ----------------------------
-- Records of group_members
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_activities
-- ----------------------------
DROP TABLE IF EXISTS `learning_activities`;
CREATE TABLE `learning_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `activity_type` enum('problem_view','solution_view','submission','problem_complete') NOT NULL COMMENT '活动类型',
  `problem_id` varchar(10) NOT NULL COMMENT '题目ID',
  `additional_info` json DEFAULT NULL COMMENT '额外信息',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `learning_activities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=262 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of learning_activities
-- ----------------------------
BEGIN;
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (1, 1, 'solution_view', '0002', NULL, '2025-01-24 16:14:37');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (2, 1, 'solution_view', '0003', NULL, '2025-01-24 16:16:49');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (3, 1, 'solution_view', '0002', NULL, '2025-01-24 16:16:52');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (4, 1, 'solution_view', '0003', NULL, '2025-01-24 16:35:45');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (5, 1, 'solution_view', '0003', NULL, '2025-01-24 16:48:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (6, 1, 'solution_view', '0003', NULL, '2025-01-24 16:56:26');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (7, 1, 'solution_view', '0003', NULL, '2025-01-24 17:00:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (8, 1, 'solution_view', '0002', NULL, '2025-01-24 17:19:45');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (9, 1, 'solution_view', '0001', NULL, '2025-01-24 18:00:31');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (10, 1, 'solution_view', '0001', NULL, '2025-01-25 09:06:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (11, 1, 'solution_view', '0009', NULL, '2025-01-25 09:25:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (12, 1, 'solution_view', '0009', NULL, '2025-01-25 09:26:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (13, 1, 'solution_view', '0009', NULL, '2025-01-25 09:27:47');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (14, 1, 'solution_view', '0009', NULL, '2025-01-25 09:36:07');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (15, 1, 'solution_view', '0009', NULL, '2025-01-25 09:36:09');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (16, 1, 'solution_view', '0009', NULL, '2025-01-25 09:36:09');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (17, 1, 'solution_view', '0009', NULL, '2025-01-25 09:40:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (18, 1, 'solution_view', '0009', NULL, '2025-01-25 09:45:37');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (19, 1, 'solution_view', '0009', NULL, '2025-01-25 09:52:03');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (20, 1, 'solution_view', '0009', NULL, '2025-01-25 09:52:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (21, 1, 'solution_view', '0009', NULL, '2025-01-25 09:54:06');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (22, 1, 'solution_view', '0009', NULL, '2025-01-25 09:54:52');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (23, 1, 'solution_view', '0009', NULL, '2025-01-25 09:55:37');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (24, 1, 'solution_view', '0009', NULL, '2025-01-25 09:56:31');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (25, 1, 'solution_view', '0009', NULL, '2025-01-25 09:59:09');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (26, 1, 'solution_view', '0009', NULL, '2025-01-25 10:12:46');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (27, 1, 'solution_view', '0009', NULL, '2025-01-25 10:16:28');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (28, 1, 'solution_view', '0009', NULL, '2025-01-25 10:18:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (29, 1, 'solution_view', '0009', NULL, '2025-01-25 10:18:17');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (30, 1, 'solution_view', '0009', NULL, '2025-01-25 10:21:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (31, 1, 'solution_view', '0009', NULL, '2025-01-25 10:21:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (32, 1, 'solution_view', '0009', NULL, '2025-01-25 10:21:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (33, 1, 'solution_view', '0009', NULL, '2025-01-25 10:21:29');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (34, 1, 'solution_view', '0010', NULL, '2025-01-25 12:17:20');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (35, 1, 'solution_view', '0001', NULL, '2025-01-25 12:18:15');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (36, 1, 'solution_view', '0011', NULL, '2025-01-25 12:18:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (37, 1, 'solution_view', '0001', NULL, '2025-01-25 12:20:17');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (38, 1, 'solution_view', '0004', NULL, '2025-01-25 12:27:28');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (39, 1, 'solution_view', '0004', NULL, '2025-01-25 12:30:13');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (40, 1, 'solution_view', '0004', NULL, '2025-01-25 12:30:15');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (41, 1, 'solution_view', '0004', NULL, '2025-01-25 12:30:15');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (42, 1, 'solution_view', '0004', NULL, '2025-01-25 12:30:24');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (43, 1, 'solution_view', '0004', NULL, '2025-01-25 12:30:24');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (44, 1, 'solution_view', '0004', NULL, '2025-01-25 12:30:38');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (45, 1, 'solution_view', '0001', NULL, '2025-01-26 11:11:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (46, 1, 'solution_view', '0001', NULL, '2025-01-26 11:27:24');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (47, 1, 'solution_view', '0001', NULL, '2025-01-26 11:35:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (48, 1, 'solution_view', '0001', NULL, '2025-01-26 11:40:20');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (49, 1, 'solution_view', '0011', NULL, '2025-01-26 11:40:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (50, 1, 'solution_view', '0011', NULL, '2025-01-26 11:40:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (51, 1, 'solution_view', '0011', NULL, '2025-01-26 11:42:10');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (52, 1, 'solution_view', '0011', NULL, '2025-01-26 11:42:35');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (53, 1, 'solution_view', '0011', NULL, '2025-01-26 11:44:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (54, 1, 'solution_view', '0011', NULL, '2025-01-26 11:44:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (55, 1, 'solution_view', '0011', NULL, '2025-01-26 11:44:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (56, 1, 'solution_view', '0011', NULL, '2025-01-26 11:46:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (57, 1, 'solution_view', '0011', NULL, '2025-01-26 11:47:46');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (58, 1, 'solution_view', '0011', NULL, '2025-01-26 11:47:50');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (59, 1, 'solution_view', '0011', NULL, '2025-01-26 11:47:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (60, 1, 'solution_view', '0011', NULL, '2025-01-26 11:47:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (61, 1, 'solution_view', '0011', NULL, '2025-01-26 11:47:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (62, 1, 'solution_view', '0011', NULL, '2025-01-26 11:47:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (63, 1, 'solution_view', '0011', NULL, '2025-01-26 11:49:18');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (64, 1, 'solution_view', '0011', NULL, '2025-01-26 11:49:43');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (65, 1, 'solution_view', '0011', NULL, '2025-01-26 11:53:50');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (66, 1, 'solution_view', '0011', NULL, '2025-01-26 11:54:40');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (67, 1, 'solution_view', '0011', NULL, '2025-01-26 11:56:43');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (68, 1, 'solution_view', '0011', NULL, '2025-01-26 11:58:18');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (69, 1, 'solution_view', '0011', NULL, '2025-01-26 11:58:21');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (70, 1, 'solution_view', '0011', NULL, '2025-01-26 11:59:54');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (71, 1, 'solution_view', '0011', NULL, '2025-01-26 11:59:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (72, 1, 'solution_view', '0011', NULL, '2025-01-26 11:59:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (73, 1, 'solution_view', '0019', NULL, '2025-01-26 12:00:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (74, 1, 'solution_view', '0019', NULL, '2025-01-26 12:01:44');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (75, 1, 'solution_view', '0019', NULL, '2025-01-26 12:01:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (76, 1, 'solution_view', '0019', NULL, '2025-01-26 12:01:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (77, 1, 'solution_view', '0019', NULL, '2025-01-26 12:03:39');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (78, 1, 'solution_view', '0019', NULL, '2025-01-26 12:03:43');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (79, 1, 'solution_view', '0019', NULL, '2025-01-26 12:03:43');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (80, 1, 'solution_view', '0019', NULL, '2025-01-26 12:04:46');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (81, 1, 'solution_view', '0019', NULL, '2025-01-26 12:04:55');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (82, 1, 'solution_view', '0001', NULL, '2025-01-26 12:04:59');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (83, 1, 'solution_view', '0001', NULL, '2025-01-26 12:05:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (84, 1, 'solution_view', '0001', NULL, '2025-01-26 12:05:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (85, 1, 'solution_view', '0004', NULL, '2025-01-26 12:05:20');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (86, 1, 'solution_view', '0004', NULL, '2025-01-26 12:06:47');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (87, 1, 'solution_view', '0004', NULL, '2025-01-26 12:06:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (88, 1, 'solution_view', '0004', NULL, '2025-01-26 12:07:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (89, 1, 'solution_view', '0004', NULL, '2025-01-26 12:07:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (90, 1, 'solution_view', '0004', NULL, '2025-01-26 12:07:16');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (91, 1, 'solution_view', '0004', NULL, '2025-01-26 12:07:17');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (92, 1, 'solution_view', '0004', NULL, '2025-01-26 12:08:38');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (93, 1, 'solution_view', '0004', NULL, '2025-01-26 12:08:40');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (94, 1, 'solution_view', '0004', NULL, '2025-01-26 12:08:40');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (95, 1, 'solution_view', '0015', NULL, '2025-01-26 12:09:18');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (96, 1, 'solution_view', '0015', NULL, '2025-01-26 12:11:03');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (97, 1, 'solution_view', '0015', NULL, '2025-01-26 12:11:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (98, 1, 'solution_view', '0015', NULL, '2025-01-26 12:11:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (99, 1, 'solution_view', '0015', NULL, '2025-01-26 12:12:52');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (100, 1, 'solution_view', '0015', NULL, '2025-01-26 12:12:55');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (101, 1, 'solution_view', '0015', NULL, '2025-01-26 12:12:55');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (102, 1, 'solution_view', '0015', NULL, '2025-01-26 12:18:54');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (103, 1, 'solution_view', '0015', NULL, '2025-01-26 12:19:17');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (104, 1, 'solution_view', '0015', NULL, '2025-01-26 12:20:30');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (105, 1, 'solution_view', '0015', NULL, '2025-01-26 12:20:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (106, 1, 'solution_view', '0015', NULL, '2025-01-26 12:20:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (107, 1, 'solution_view', '0015', NULL, '2025-01-26 12:22:44');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (108, 1, 'solution_view', '0015', NULL, '2025-01-26 12:22:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (109, 1, 'solution_view', '0015', NULL, '2025-01-26 12:22:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (110, 1, 'solution_view', '0015', NULL, '2025-01-26 12:25:18');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (111, 1, 'solution_view', '0003', NULL, '2025-01-26 12:25:41');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (112, 1, 'solution_view', '0003', NULL, '2025-01-26 12:26:39');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (113, 1, 'solution_view', '0003', NULL, '2025-01-26 12:27:54');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (114, 1, 'solution_view', '0003', NULL, '2025-01-26 12:28:10');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (115, 1, 'solution_view', '0003', NULL, '2025-01-26 12:28:10');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (116, 1, 'solution_view', '0003', NULL, '2025-01-26 12:29:13');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (117, 1, 'solution_view', '0003', NULL, '2025-01-26 12:29:17');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (118, 1, 'solution_view', '0003', NULL, '2025-01-26 12:29:17');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (119, 1, 'solution_view', '0003', NULL, '2025-01-26 12:29:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (120, 1, 'solution_view', '0003', NULL, '2025-01-26 12:29:54');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (121, 1, 'solution_view', '0003', NULL, '2025-01-26 12:31:23');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (122, 1, 'solution_view', '0003', NULL, '2025-01-26 12:33:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (123, 1, 'solution_view', '0003', NULL, '2025-01-26 12:33:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (124, 1, 'solution_view', '0003', NULL, '2025-01-26 12:33:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (125, 1, 'solution_view', '0003', NULL, '2025-01-26 12:34:41');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (126, 1, 'solution_view', '0003', NULL, '2025-01-26 12:34:47');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (127, 1, 'solution_view', '0003', NULL, '2025-01-26 12:34:47');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (128, 1, 'solution_view', '0003', NULL, '2025-01-26 12:37:10');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (129, 1, 'solution_view', '0003', NULL, '2025-01-26 12:37:13');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (130, 1, 'solution_view', '0003', NULL, '2025-01-26 12:37:13');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (131, 1, 'solution_view', '0010', NULL, '2025-01-26 12:39:09');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (132, 1, 'solution_view', '0017', NULL, '2025-01-26 12:42:29');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (133, 1, 'solution_view', '0017', NULL, '2025-01-26 12:45:29');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (134, 1, 'solution_view', '0017', NULL, '2025-01-26 12:45:35');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (135, 1, 'solution_view', '0017', NULL, '2025-01-26 12:45:35');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (136, 1, 'solution_view', '0017', NULL, '2025-01-26 12:45:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (137, 1, 'solution_view', '0017', NULL, '2025-01-26 12:47:42');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (138, 1, 'solution_view', '0017', NULL, '2025-01-26 12:49:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (139, 1, 'solution_view', '0017', NULL, '2025-01-26 13:00:30');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (140, 1, 'solution_view', '0017', NULL, '2025-01-26 13:00:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (141, 1, 'solution_view', '0017', NULL, '2025-01-26 13:00:49');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (142, 1, 'solution_view', '0017', NULL, '2025-01-26 13:04:24');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (143, 1, 'solution_view', '0017', NULL, '2025-01-26 13:04:44');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (144, 1, 'solution_view', '0003', NULL, '2025-01-26 13:04:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (145, 1, 'solution_view', '0001', NULL, '2025-01-26 13:09:45');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (146, 1, 'solution_view', '0001', NULL, '2025-01-26 13:15:03');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (147, 1, 'solution_view', '0001', NULL, '2025-01-27 10:15:29');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (148, 1, 'solution_view', '0001', NULL, '2025-01-27 10:16:10');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (149, 1, 'solution_view', '0001', NULL, '2025-01-27 10:16:10');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (150, 1, 'solution_view', '0001', NULL, '2025-02-03 11:37:27');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (151, 1, 'solution_view', '0001', NULL, '2025-02-03 11:41:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (152, 1, 'solution_view', '0001', NULL, '2025-02-03 11:46:29');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (153, 1, 'solution_view', '0001', NULL, '2025-02-03 11:49:57');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (154, 1, 'solution_view', '0001', NULL, '2025-02-03 11:55:37');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (155, 1, 'solution_view', '0001', NULL, '2025-02-03 12:13:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (156, 1, 'solution_view', '0001', NULL, '2025-02-05 13:44:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (157, 1, 'solution_view', '0001', NULL, '2025-02-05 13:44:05');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (158, 1, 'solution_view', '0001', NULL, '2025-02-05 13:44:05');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (159, 1, 'solution_view', '0001', NULL, '2025-02-05 13:45:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (160, 1, 'solution_view', '0001', NULL, '2025-02-05 13:46:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (161, 1, 'solution_view', '0001', NULL, '2025-02-05 13:47:05');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (162, 1, 'solution_view', '0001', NULL, '2025-02-05 13:47:05');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (163, 1, 'solution_view', '0001', NULL, '2025-02-05 13:47:30');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (164, 1, 'solution_view', '0001', NULL, '2025-02-05 13:48:10');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (165, 1, 'solution_view', '0001', NULL, '2025-02-05 13:48:55');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (166, 1, 'solution_view', '0001', NULL, '2025-02-05 13:49:14');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (167, 1, 'solution_view', '0001', NULL, '2025-02-05 13:49:14');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (168, 1, 'solution_view', '0001', NULL, '2025-02-05 13:50:34');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (169, 1, 'solution_view', '0001', NULL, '2025-02-05 13:50:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (170, 1, 'solution_view', '0001', NULL, '2025-02-05 13:50:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (171, 1, 'solution_view', '0001', NULL, '2025-02-05 13:51:31');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (172, 1, 'solution_view', '0001', NULL, '2025-02-05 13:51:37');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (173, 1, 'solution_view', '0001', NULL, '2025-02-05 13:51:37');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (174, 1, 'solution_view', '0001', NULL, '2025-02-05 13:51:47');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (175, 1, 'solution_view', '0001', NULL, '2025-02-05 13:51:47');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (176, 1, 'solution_view', '0001', NULL, '2025-02-05 13:53:19');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (177, 1, 'solution_view', '0001', NULL, '2025-02-05 13:53:23');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (178, 1, 'solution_view', '0001', NULL, '2025-02-05 13:54:32');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (179, 1, 'solution_view', '0001', NULL, '2025-02-05 13:54:36');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (180, 1, 'solution_view', '0001', NULL, '2025-02-05 13:54:36');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (181, 1, 'solution_view', '0001', NULL, '2025-02-05 13:55:06');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (182, 1, 'solution_view', '0001', NULL, '2025-02-05 13:55:55');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (183, 1, 'solution_view', '0001', NULL, '2025-02-05 13:56:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (184, 1, 'solution_view', '0001', NULL, '2025-02-05 13:56:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (185, 1, 'solution_view', '0001', NULL, '2025-02-05 13:57:16');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (186, 1, 'solution_view', '0001', NULL, '2025-02-05 13:58:24');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (187, 1, 'solution_view', '0001', NULL, '2025-02-05 13:58:24');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (188, 1, 'solution_view', '0001', NULL, '2025-02-05 13:58:24');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (189, 1, 'solution_view', '0001', NULL, '2025-02-05 13:59:50');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (190, 1, 'solution_view', '0001', NULL, '2025-02-05 13:59:59');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (191, 1, 'solution_view', '0001', NULL, '2025-02-05 14:00:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (192, 1, 'solution_view', '0001', NULL, '2025-02-05 14:00:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (193, 1, 'solution_view', '0001', NULL, '2025-02-05 14:00:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (194, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:09');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (195, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (196, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (197, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:31');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (198, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:31');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (199, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:35');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (200, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:35');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (201, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:48');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (202, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (203, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (204, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (205, 1, 'solution_view', '0001', NULL, '2025-02-05 14:04:51');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (206, 1, 'solution_view', '0001', NULL, '2025-02-05 14:05:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (207, 1, 'solution_view', '0001', NULL, '2025-02-05 14:06:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (208, 1, 'solution_view', '0001', NULL, '2025-02-05 14:06:46');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (209, 1, 'solution_view', '0001', NULL, '2025-02-05 14:06:50');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (210, 1, 'solution_view', '0001', NULL, '2025-02-05 14:06:50');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (211, 1, 'solution_view', '0001', NULL, '2025-02-05 14:06:58');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (212, 1, 'solution_view', '0001', NULL, '2025-02-05 14:06:58');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (213, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:20');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (214, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:38');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (215, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:41');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (216, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:42');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (217, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:55');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (218, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:55');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (219, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:56');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (220, 1, 'solution_view', '0001', NULL, '2025-02-05 14:07:56');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (221, 1, 'solution_view', '0001', NULL, '2025-02-05 14:12:38');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (222, 1, 'solution_view', '0001', NULL, '2025-02-05 14:13:45');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (223, 1, 'solution_view', '0001', NULL, '2025-02-05 14:13:49');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (224, 1, 'solution_view', '0001', NULL, '2025-02-05 14:13:49');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (225, 1, 'solution_view', '0001', NULL, '2025-02-05 14:15:01');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (226, 1, 'solution_view', '0001', NULL, '2025-02-05 14:15:11');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (227, 1, 'solution_view', '0001', NULL, '2025-02-05 14:16:42');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (228, 1, 'solution_view', '0001', NULL, '2025-02-05 14:16:42');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (229, 1, 'solution_view', '0001', NULL, '2025-02-05 14:16:42');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (230, 1, 'solution_view', '0001', NULL, '2025-02-05 14:17:40');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (231, 1, 'solution_view', '0001', NULL, '2025-02-05 14:17:46');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (232, 1, 'solution_view', '0001', NULL, '2025-02-05 14:17:46');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (233, 1, 'solution_view', '0001', NULL, '2025-02-05 14:19:28');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (234, 1, 'solution_view', '0001', NULL, '2025-02-05 14:19:34');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (235, 1, 'solution_view', '0001', NULL, '2025-02-05 14:19:34');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (236, 1, 'solution_view', '0001', NULL, '2025-02-05 14:20:58');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (237, 1, 'solution_view', '0001', NULL, '2025-02-05 14:21:03');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (238, 1, 'solution_view', '0001', NULL, '2025-02-05 14:21:03');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (239, 1, 'solution_view', '0001', NULL, '2025-02-05 14:21:04');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (240, 1, 'solution_view', '0001', NULL, '2025-02-05 14:21:04');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (241, 1, 'solution_view', '0001', NULL, '2025-02-05 14:22:00');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (242, 1, 'solution_view', '0001', NULL, '2025-02-05 14:22:08');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (243, 1, 'solution_view', '0001', NULL, '2025-02-05 14:22:53');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (244, 1, 'solution_view', '0001', NULL, '2025-02-05 14:22:56');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (245, 1, 'solution_view', '0001', NULL, '2025-02-05 14:22:56');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (246, 1, 'solution_view', '0001', NULL, '2025-02-05 14:23:54');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (247, 1, 'solution_view', '0001', NULL, '2025-02-05 14:23:58');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (248, 1, 'solution_view', '0001', NULL, '2025-02-05 14:23:58');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (249, 1, 'solution_view', '0001', NULL, '2025-02-05 14:24:01');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (250, 1, 'solution_view', '0001', NULL, '2025-02-05 14:24:01');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (251, 1, 'solution_view', '0001', NULL, '2025-02-05 14:24:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (252, 1, 'solution_view', '0001', NULL, '2025-02-05 14:24:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (253, 1, 'solution_view', '0001', NULL, '2025-02-05 14:25:09');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (254, 1, 'solution_view', '0001', NULL, '2025-02-05 14:25:13');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (255, 1, 'solution_view', '0001', NULL, '2025-02-05 14:25:13');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (256, 1, 'solution_view', '0001', NULL, '2025-02-05 14:26:02');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (257, 1, 'solution_view', '0001', NULL, '2025-02-05 14:26:05');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (258, 1, 'solution_view', '0001', NULL, '2025-02-05 14:26:05');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (259, 1, 'solution_view', '0001', NULL, '2025-02-05 14:27:12');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (260, 1, 'solution_view', '0001', NULL, '2025-02-05 14:27:17');
INSERT INTO `learning_activities` (`id`, `user_id`, `activity_type`, `problem_id`, `additional_info`, `created_at`) VALUES (261, 1, 'solution_view', '0001', NULL, '2025-02-05 14:27:17');
COMMIT;

-- ----------------------------
-- Table structure for learning_path_problems
-- ----------------------------
DROP TABLE IF EXISTS `learning_path_problems`;
CREATE TABLE `learning_path_problems` (
  `id` int NOT NULL AUTO_INCREMENT,
  `path_id` int NOT NULL,
  `problem_id` int NOT NULL,
  `order_index` int NOT NULL DEFAULT '0',
  `section` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_path_problem` (`path_id`,`problem_id`),
  KEY `idx_path_id` (`path_id`),
  KEY `idx_problem_id` (`problem_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of learning_path_problems
-- ----------------------------
BEGIN;
INSERT INTO `learning_path_problems` (`id`, `path_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (1, 1, 1, 1, NULL, '2025-02-06 21:52:24');
INSERT INTO `learning_path_problems` (`id`, `path_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (2, 1, 2, 2, NULL, '2025-02-06 21:52:24');
INSERT INTO `learning_path_problems` (`id`, `path_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (3, 1, 3, 3, NULL, '2025-02-06 21:52:24');
INSERT INTO `learning_path_problems` (`id`, `path_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (4, 1, 4, 4, NULL, '2025-02-06 21:52:24');
INSERT INTO `learning_path_problems` (`id`, `path_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (5, 1, 5, 5, NULL, '2025-02-06 21:52:24');
COMMIT;

-- ----------------------------
-- Table structure for learning_path_progress
-- ----------------------------
DROP TABLE IF EXISTS `learning_path_progress`;
CREATE TABLE `learning_path_progress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `path_id` int NOT NULL,
  `completed_problems` text,
  `last_problem_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_path` (`user_id`,`path_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_path_id` (`path_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of learning_path_progress
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_plan_problems
-- ----------------------------
DROP TABLE IF EXISTS `learning_plan_problems`;
CREATE TABLE `learning_plan_problems` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int NOT NULL COMMENT '学习计划ID',
  `problem_id` int NOT NULL COMMENT '题目ID',
  `order_index` int NOT NULL COMMENT '题目顺序',
  `section` varchar(100) DEFAULT NULL COMMENT '所属章节',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_problem_id` (`problem_id`),
  CONSTRAINT `fk_lpp_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `learning_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_lpp_problem_id` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学习计划-题目关联表';

-- ----------------------------
-- Records of learning_plan_problems
-- ----------------------------
BEGIN;
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (1, 4, 16, 1, '基础查询', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (2, 4, 20, 2, '基础查询', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (3, 4, 21, 3, '聚合函数', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (5, 4, 30, 5, '高级查询', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (6, 5, 1, 1, '基础运算', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (7, 5, 6, 2, '基础运算', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (8, 5, 21, 3, '基础运算', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (9, 5, 2, 4, '数组基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (10, 5, 7, 5, '数组基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (11, 5, 11, 6, '数组基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (12, 5, 3, 7, '字符串基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (13, 5, 12, 8, '字符串基础', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (15, 5, 10, 10, '条件判断', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (16, 6, 5, 1, '数学进阶', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (17, 6, 15, 2, '数学进阶', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (18, 6, 19, 3, '数学进阶', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (19, 6, 18, 4, '动态规划', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (20, 6, 23, 5, '动态规划', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (21, 6, 30, 6, '动态规划', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (23, 6, 29, 8, '数据结构', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (24, 6, 13, 9, '字符串处理', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (25, 6, 14, 10, '算法思维', '2025-02-03 11:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (31, 2, 18, 1, '动态规划', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (32, 2, 23, 2, '动态规划', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (33, 2, 30, 3, '动态规划', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (34, 2, 13, 4, '字符串处理', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (35, 2, 14, 5, '算法思维', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (36, 3, 5, 1, '数学进阶', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (37, 3, 15, 2, '数学进阶', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (38, 3, 19, 3, '数学进阶', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (40, 3, 29, 5, '数据结构', '2025-02-03 11:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (47, 1, 1, 1, '基础算法', '2025-02-27 16:30:28');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (48, 1, 2, 2, '基础算法', '2025-02-27 16:30:28');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (49, 1, 3, 3, '字符串处理', '2025-02-27 16:30:28');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (50, 1, 4, 4, '数学问题', '2025-02-27 16:30:28');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (51, 1, 5, 5, '数学问题', '2025-02-27 16:30:28');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (52, 1, 7, 6, '最小值', '2025-02-27 16:30:28');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (53, 1, 8, 7, '字符串', '2025-02-27 16:30:28');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (60, 9, 1, 1, '算法', '2025-02-28 11:28:14');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (83, 10, 2, 1, '测试', '2025-02-28 14:52:59');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (87, 11, 9, 1, '数据', '2025-02-28 15:05:57');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `order_index`, `section`, `created_at`) VALUES (89, 12, 11, 1, '数组', '2025-02-28 15:06:13');
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
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (1, '面试经典 150 题', '通过所有面试高频考点并掌握所有知识点', '/icons/1740723442948-632588890.png', '面试必刷', '中等', 30, '[\"涵盖 150 道经典面试高频题\",\"采用分类式题目，让入门更轻松\",\"适合有 6 个月以上刷题经验的用户\",\"建议每天完成 3-4 道题目\"]', '2025-02-03 11:19:23', '2025-02-28 14:17:22', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (2, '动态规划（基础版）', '更细的知识点拆分，让入门更轻松', '/icons/algorithm.png', '算法入门', '简单', 15, '[\"系统学习动态规划基础\",\"从易到难的题目编排\",\"配套详细的解题思路\",\"适合算法学习初期的用户\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (3, 'LeetCode 热题 100', '力扣最受刷题发烧友欢迎的 100 题', '/icons/hot.png', '热门精选', '中等', 25, '[\"精选最热门的 100 道题目\",\"覆盖多个算法知识点\",\"题目难度分布合理\",\"适合系统提升算法能力\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (4, 'SQL 50 题', '面试必刷的 SQL 精选题目', '/icons/sql.png', 'SQL专题', '中等', 20, '[\"覆盖 SQL 常见面试题型\",\"从基础到高级查询\",\"包含多表联查和性能优化\",\"适合数据库开发岗位面试\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (5, '编程入门 100 题', '为编程新手量身打造的入门题集', '/icons/beginner.png', '入门推荐', '简单', 40, '[\"从零开始的编程入门\",\"循序渐进的难度安排\",\"详细的解题思路讲解\",\"适合编程初学者\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (6, '会员专享题集', '精心筛选的高质量面试题集', '/icons/premium.png', '会员专享', '困难', 35, '[\"高质量算法面试题\",\"大厂常考题目精选\",\"面试真题解析\",\"适合准备大厂面试的用户\"]', '2025-02-03 11:19:23', '2025-02-05 13:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (9, '这是一个测试的学习计划', '这是一个测试的学习计划', NULL, '算法', NULL, 30, '[\"高质量算法面试题\",\"大厂常考题目精选\",\"面试真题解析\",\"适合准备大厂面试的用户\"]', '2025-02-28 11:28:14', '2025-02-28 14:54:43', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (10, '这是一个测试的2学习计划', '这是一个测试的2学习计划', '/icons/1740723537937-580837172.png', '算法', '简单', 30, '[\"高质量算法面试题\",\"大厂常考题目精选\",\"面试真题解析\",\"适合准备大厂面试的用户\"]', '2025-02-28 14:18:43', '2025-02-28 14:54:41', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (11, '测试的学习计划3', '测试的学习计划333', '/icons/1740723860419-733532137.png', '面试', NULL, 25, '[\"高质量算法面试题\",\"大厂常考题目精选\",\"面试真题解析\",\"适合准备大厂面试的用户\"]', '2025-02-28 14:24:20', '2025-02-28 15:05:54', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (12, '这是一个测试的学习计划3', '这是一个测试的学习计划3', '/icons/1740724063499-979748825.png', 'SQL', NULL, 23, '[\"高质量算法面试题\",\"大厂常考题目精选\",\"面试真题解析\",\"适合准备大厂面试的用户\"]', '2025-02-28 14:27:43', '2025-02-28 15:06:11', 1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of posts
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for practice_plans
-- ----------------------------
DROP TABLE IF EXISTS `practice_plans`;
CREATE TABLE `practice_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `plan_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '计划名称',
  `daily_goal` int DEFAULT '1' COMMENT '每日目标题数',
  `focus_areas` json DEFAULT NULL COMMENT '重点练习领域',
  `difficulty_preference` json DEFAULT NULL COMMENT '难度偏好设置',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_plan_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of practice_plans
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_set_categories
-- ----------------------------
DROP TABLE IF EXISTS `problem_set_categories`;
CREATE TABLE `problem_set_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '分类描述',
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类图标',
  `parent_id` int DEFAULT NULL COMMENT '父分类ID',
  `sort_order` int DEFAULT '0' COMMENT '排序权重',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `problem_set_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of problem_set_categories
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_set_category_relations
-- ----------------------------
DROP TABLE IF EXISTS `problem_set_category_relations`;
CREATE TABLE `problem_set_category_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_set_id` int NOT NULL COMMENT '题集ID',
  `category_id` int NOT NULL COMMENT '分类ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_set_category` (`problem_set_id`,`category_id`),
  KEY `idx_category_id` (`category_id`),
  CONSTRAINT `fk_relation_category` FOREIGN KEY (`category_id`) REFERENCES `problem_set_categories` (`id`),
  CONSTRAINT `fk_relation_problem_set` FOREIGN KEY (`problem_set_id`) REFERENCES `problem_sets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of problem_set_category_relations
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_set_items
-- ----------------------------
DROP TABLE IF EXISTS `problem_set_items`;
CREATE TABLE `problem_set_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_set_id` int NOT NULL COMMENT '题集ID',
  `problem_id` int NOT NULL COMMENT '题目ID',
  `order_index` int DEFAULT '0' COMMENT '题目在题集中的顺序',
  `note` text COLLATE utf8mb4_unicode_ci COMMENT '题目说明或提示',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_set_problem` (`problem_set_id`,`problem_id`),
  KEY `idx_problem_id` (`problem_id`),
  CONSTRAINT `fk_problem_set` FOREIGN KEY (`problem_set_id`) REFERENCES `problem_sets` (`id`),
  CONSTRAINT `fk_set_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of problem_set_items
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_set_logs
-- ----------------------------
DROP TABLE IF EXISTS `problem_set_logs`;
CREATE TABLE `problem_set_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_set_id` int NOT NULL COMMENT '题集ID',
  `operator_id` int NOT NULL COMMENT '操作者ID',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `detail` text COLLATE utf8mb4_unicode_ci COMMENT '操作详情',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作IP',
  PRIMARY KEY (`id`),
  KEY `idx_problem_set_id` (`problem_set_id`),
  KEY `idx_operator_id` (`operator_id`),
  CONSTRAINT `fk_log_operator` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_log_problem_set` FOREIGN KEY (`problem_set_id`) REFERENCES `problem_sets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of problem_set_logs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_set_tags
-- ----------------------------
DROP TABLE IF EXISTS `problem_set_tags`;
CREATE TABLE `problem_set_tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签名称',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签描述',
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签图标',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tag_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of problem_set_tags
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_sets
-- ----------------------------
DROP TABLE IF EXISTS `problem_sets`;
CREATE TABLE `problem_sets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题集标题',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '题集描述',
  `cover_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片URL',
  `type` enum('recommended','learning_plan','premium') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题集类型：推荐、学习计划、会员专享',
  `difficulty` enum('easy','medium','hard') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '难度等级',
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签，逗号分隔',
  `problem_count` int DEFAULT '0' COMMENT '包含的题目数量',
  `view_count` int DEFAULT '0' COMMENT '浏览次数',
  `favorite_count` int DEFAULT '0' COMMENT '收藏次数',
  `completion_count` int DEFAULT '0' COMMENT '完成人数',
  `sort_order` int DEFAULT '0' COMMENT '排序权重',
  `is_featured` tinyint(1) DEFAULT '0' COMMENT '是否推荐',
  `is_hot` tinyint(1) DEFAULT '0' COMMENT '是否热门',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL COMMENT '创建者ID',
  `updated_by` int DEFAULT NULL COMMENT '最后修改者ID',
  `is_public` tinyint(1) DEFAULT '1' COMMENT '是否公开',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '管理员备注',
  PRIMARY KEY (`id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_updated_by` (`updated_by`),
  KEY `idx_type_status` (`type`,`status`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `fk_problem_set_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_problem_set_updater` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of problem_sets
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for problem_solutions
-- ----------------------------
DROP TABLE IF EXISTS `problem_solutions`;
CREATE TABLE `problem_solutions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `standard_solution` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标准答案代码',
  `solution_language` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '答案使用的编程语言',
  `solution_approach` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '解题思路',
  `time_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间复杂度',
  `space_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '空间复杂度',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_solution_problem` (`problem_id`),
  CONSTRAINT `fk_solution_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of problem_solutions
-- ----------------------------
BEGIN;
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', '直接读取两个整数并相加输出即可。注意使用scanf读取输入，printf输出结果。', 'O(1)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (2, 2, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'c', '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最大值，遍历数组更新最大值。', 'O(n)', 'O(n)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (3, 3, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', '读取字符串后，从后向前遍历字符串，依次输出每个字符即可得到反转结果。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (4, 4, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    long long result = 1;\n    for(int i = 1; i <= n; i++) {\n        result *= i;\n    }\n    printf(\"%lld\\n\", result);\n    return 0;\n}', 'c', '使用循环从1乘到n，注意使用long long类型避免整数溢出。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (5, 5, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++) {\n        if(n % i == 0) return 0;\n    }\n    return 1;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPrime(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', '定义isPrime函数判断是否为质数。从2到sqrt(n)遍历，如果n能被任何数整除则不是质数。', 'O(sqrt(n))', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (6, 6, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', '直接读取两个整数并相减输出即可。', 'O(1)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (7, 7, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], min;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) min = arr[i];\n    }\n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最小值，遍历数组更新最小值。', 'O(n)', 'O(n)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (8, 8, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', '读取两个字符串后直接拼接输出即可。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (9, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', '使用循环计算斐波那契数列。维护两个变量记录前两个数，不断更新得到下一个数。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (10, 10, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", n % 2 == 0 ? \"是\" : \"否\");\n    return 0;\n}', 'c', '判断一个数除以2的余数是否为0即可。使用取模运算符%。', 'O(1)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (11, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', '使用冒泡排序算法，通过两层循环不断比较相邻元素并交换位置，将最大的元素逐步\"冒泡\"到数组末尾。', 'O(n^2)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (12, 12, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100], ch;\n    scanf(\"%s %c\", str, &ch);\n    int count = 0;\n    for(int i = 0; str[i]; i++) {\n        if(str[i] == ch) count++;\n    }\n    printf(\"%d\\n\", count);\n    return 0;\n}', 'c', '遍历字符串，统计目标字符出现的次数。使用循环和计数器实现。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (13, 13, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[1000];\n    gets(str);\n    char *token = strtok(str, \" \");\n    printf(\"%s\", token);\n    token = strtok(NULL, \" \");\n    while(token != NULL) {\n        if(strcmp(token, \"world\") != 0) {\n            printf(\" %s\", token);\n        }\n        token = strtok(NULL, \" \");\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', '使用strtok函数分割字符串，遍历所有单词，跳过\"world\"单词不输出。注意处理空格和字符串拼接。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (14, 14, '#include <stdio.h>\n\nint gcd(int a, int b) {\n    return b == 0 ? a : gcd(b, a % b);\n}\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", gcd(a, b));\n    return 0;\n}', 'c', '使用欧几里得算法（辗转相除法）求最大公约数。递归实现：当b为0时返回a，否则递归计算gcd(b, a%b)。', 'O(log(min(a,b)))', 'O(log(min(a,b)))', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (15, 15, '#include <stdio.h>\n\nint isPalindrome(int n) {\n    int reversed = 0, original = n;\n    while(n > 0) {\n        reversed = reversed * 10 + n % 10;\n        n /= 10;\n    }\n    return original == reversed;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPalindrome(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', '将数字反转，如果反转后的数字等于原数字，则是回文数。使用取模和除法运算逐位提取数字并重新组合。', 'O(log n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (16, 16, '#include <stdio.h>\n\nint main() {\n    int n, m;\n    scanf(\"%d %d\", &n, &m);\n    int mat1[10][10], mat2[10][10];\n    \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat1[i][j]);\n            \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat2[i][j]);\n            \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j < m; j++)\n            printf(\"%d \", mat1[i][j] + mat2[i][j]);\n        printf(\"\\n\");\n    }\n    return 0;\n}', 'c', '使用二维数组存储两个矩阵，对应位置的元素相加即可。注意输出格式的处理。', 'O(n*m)', 'O(n*m)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (17, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', '先将字符串按空格分割成单词数组，然后从后向前遍历数组输出单词。注意处理单词之间的空格。', 'O(n)', 'O(n)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (18, 18, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int triangle[30][30] = {0};\n    \n    for(int i = 0; i < n; i++) {\n        triangle[i][0] = 1;\n        for(int j = 1; j <= i; j++) {\n            triangle[i][j] = triangle[i-1][j-1] + triangle[i-1][j];\n        }\n    }\n    \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j <= i; j++) {\n            printf(\"%d \", triangle[i][j]);\n        }\n        printf(\"\\n\");\n    }\n    return 0;\n}', 'c', '使用二维数组存储杨辉三角，每个数是上一行相邻两个数的和。第一列全为1，其他位置的值等于上一行的相邻两个数之和。', 'O(n^2)', 'O(n^2)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (19, 19, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', '在给定范围内遍历每个数，使用isPrime函数判断是否为质数。注意输出格式，数字之间需要空格分隔。', 'O((end-start)*sqrt(max(end)))', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (20, 20, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], unique[100], uniqueCount = 0;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n        int isUnique = 1;\n        for(int j = 0; j < uniqueCount; j++) {\n            if(arr[i] == unique[j]) {\n                isUnique = 0;\n                break;\n            }\n        }\n        if(isUnique) unique[uniqueCount++] = arr[i];\n    }\n    for(int i = 0; i < uniqueCount; i++) {\n        printf(\"%d \", unique[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', '使用一个新数组存储不重复的元素。遍历原数组，对于每个元素，检查是否已经在新数组中存在，如果不存在则添加到新数组。', 'O(n^2)', 'O(n)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (21, 21, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], sum = 0;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n        sum += arr[i];\n    }\n    printf(\"%d\\n\", sum);\n    return 0;\n}', 'c', '使用一个变量sum累加数组中的每个元素。遍历一次数组即可得到总和。', 'O(n)', 'O(n)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (22, 22, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', '从字符串末尾向前遍历，依次输出每个字符即可得到反转的字符串。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (23, 23, '#include <stdio.h>\n\nint fibonacci(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fibonacci(n));\n    return 0;\n}', 'c', '使用迭代方法计算斐波那契数列。维护三个变量a、b、c，其中a和b分别表示前两个数，c用于计算它们的和。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (25, 25, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", (n % 2 == 0) ? \"是\" : \"否\");\n    return 0;\n}', 'c', '判断一个数是否为偶数，只需要判断它除以2的余数是否为0。使用取模运算符%即可。', 'O(1)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (29, 29, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char binary[33];\n    scanf(\"%s\", binary);\n    int decimal = 0;\n    int len = strlen(binary);\n    for(int i = 0; i < len; i++) {\n        decimal = decimal * 2 + (binary[i] - \'0\');\n    }\n    printf(\"%d\\n\", decimal);\n    return 0;\n}', 'c', '从左到右遍历二进制字符串，对于每一位，将当前结果乘2再加上当前位的值。注意字符转数字需要减去字符\'0\'的ASCII值。', 'O(n)', 'O(1)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
INSERT INTO `problem_solutions` (`id`, `problem_id`, `standard_solution`, `solution_language`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (30, 30, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[1000];\n    for(int i = 0; i < n; i++)\n        scanf(\"%d\", &arr[i]);\n    \n    int max_len = 1, curr_len = 1;\n    for(int i = 1; i < n; i++) {\n        if(arr[i] == arr[i-1] + 1)\n            curr_len++;\n        else {\n            if(curr_len > max_len)\n                max_len = curr_len;\n            curr_len = 1;\n        }\n    }\n    if(curr_len > max_len)\n        max_len = curr_len;\n    \n    printf(\"%d\\n\", max_len);\n    return 0;\n}', 'c', '遍历数组，用curr_len记录当前连续序列的长度，用max_len记录最长连续序列的长度。如果当前数字比前一个数字大1，则curr_len加1，否则更新max_len并重置curr_len。', 'O(n)', 'O(n)', '2025-01-23 08:58:07', '2025-01-23 08:58:07');
COMMIT;

-- ----------------------------
-- Table structure for problem_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `problem_test_cases`;
CREATE TABLE `problem_test_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL,
  `input` text NOT NULL,
  `output` text NOT NULL,
  `is_example` tinyint(1) DEFAULT '0' COMMENT '是否为显示样例',
  `order_num` int DEFAULT '0' COMMENT '测试用例顺序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `problem_id` (`problem_id`),
  CONSTRAINT `fk_problem_test_cases` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of problem_test_cases
-- ----------------------------
BEGIN;
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (1, 1, '2 3', '5', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (2, 2, '5\n1 5 3 8 2', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (3, 3, 'hello', 'olleh', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (4, 4, '5', '120', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (5, 5, '7', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (6, 6, '5 3', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (7, 7, '5\n4 2 7 1 9', '1', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (8, 8, 'abc def', 'abcdef', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (9, 9, '6', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (10, 10, '8', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (11, 11, '5\n9 3 6 2 7', '2 3 6 7 9', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (12, 12, 'apple p', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (13, 13, 'hello world world java', 'hello java', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (14, 14, '12 18', '6', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (15, 15, '121', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (16, 16, '2 2\n1 2\n3 4\n5 6\n7 8', '6 8\n10 12', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (17, 17, 'I love programming', 'programming love I', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (18, 18, '5', '1\n1 1\n1 2 1\n1 3 3 1\n1 4 6 4 1', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (19, 19, '10 20', '11 13 17 19', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (20, 20, '6\n1 2 2 3 3 3', '1 2 3', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (21, 21, '5\n1 2 3 4 5', '15', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (22, 22, 'hello', 'olleh', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (23, 23, '6', '8', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (24, 25, '8', '是', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (25, 29, '1010', '10', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (26, 30, '6\n100 4 200 1 3 2', '4', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (27, 33, '1 1', '2', 1, 1, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (32, 1, '10 20', '30', 0, 2, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (33, 1, '-5 8', '3', 0, 3, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (34, 1, '0 0', '0', 0, 4, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (35, 1, '999 1', '1000', 0, 5, '2025-04-02 12:39:37', '2025-04-02 12:39:37');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (38, 34, '11', '11', 0, 1, '2025-04-04 11:04:08', '2025-04-04 11:04:08');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (39, 34, '22', '22', 0, 2, '2025-04-04 11:04:08', '2025-04-04 11:04:08');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (42, 37, '33', '44', 1, 1, '2025-04-04 11:14:59', '2025-04-04 11:14:59');
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of problems
-- ----------------------------
BEGIN;
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (1, '0001', '两数相加问题', '简单', 156, 91.03, '基础,数学', '给定两个整数A和B，求它们的和。', 1000, 256, 142);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (2, '0002', '寻找最大值', '简单', 279, 87.46, '基础,数组', '给定一个整数数组，找出其中的最大值。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 244);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (3, '0003', '字符串反转', '中等', 240, 94.58, '字符串', '将一个字符串进行反转。', 1000, 256, 227);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (4, '0004', '阶乘计算', '中等', 151, 65.56, '数学,递归', '计算一个正整数的阶乘。', 1000, 256, 99);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (5, '0005', '质数判断', '困难', 314, 66.56, '数学,判断', '判断一个数是否为质数。', 1000, 256, 209);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (6, '0006', '两数相减问题', '简单', 260, 100.00, '基础,数学', '给定两个整数 C 和 D，求它们的差。', 1000, 256, 260);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (7, '0007', '求最小值', '简单', 236, 100.00, '基础,数组', '给定一个整数数组，找出其中的最小值。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 236);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (8, '0008', '字符串拼接', '中等', 475, 25.26, '字符串', '将两个字符串进行拼接。', 1000, 256, 120);
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
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (30, '0026', '最长连续序列1', '中等', 666, 20.72, '数组,算法,序列', '找出数组中最长的连续数字序列的长度。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。测试1', 1000, 256, 138);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (33, '0027', '测试1', '简单', 0, 0.00, '数组', '测试1111', 1000, 256, 0);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (34, '0028', 'ceshi2', '困难', 0, 0.00, '双指针,数组', '11', 1000, 256, 0);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (37, '0029', '测试用例3', '困难', 0, 0.00, '测试', '这是测试用例3', 1000, 256, 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (140, 36, 1, 'c', '1.0', '2025-04-04 11:13:32', '2025-04-04 11:13:32');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (141, 36, 4, 'cpp', '1.0', '2025-04-04 11:13:32', '2025-04-04 11:13:32');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (142, 36, 3, 'java', '1.0', '2025-04-04 11:13:32', '2025-04-04 11:13:32');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (143, 36, 2, 'python', '1.0', '2025-04-04 11:13:32', '2025-04-04 11:13:32');
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

-- ----------------------------
-- Table structure for solution_main
-- ----------------------------
DROP TABLE IF EXISTS `solution_main`;
CREATE TABLE `solution_main` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `solution_approach` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通用解题思路',
  `time_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均时间复杂度',
  `space_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均空间复杂度',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_main_problem` (`problem_id`),
  CONSTRAINT `fk_main_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of solution_main
-- ----------------------------
BEGIN;
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (1, 1, '直接读取两个整数并相加输出即可。注意使用scanf读取输入，printf输出结果。1', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-24 15:02:09');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (2, 2, '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最大值，遍历数组更新最大值。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (3, 3, '读取字符串后，从后向前遍历字符串，依次输出每个字符即可得到反转结果。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (4, 4, '使用循环从1乘到n，注意使用long long类型避免整数溢出。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (5, 5, '定义isPrime函数判断是否为质数。从2到sqrt(n)遍历，如果n能被任何数整除则不是质数。', 'O(sqrt(n))', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (6, 6, '直接读取两个整数并相减输出即可。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (7, 7, '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最小值，遍历数组更新最小值。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (8, 8, '读取两个字符串后直接拼接输出即可。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (9, 9, '使用循环计算斐波那契数列。维护两个变量记录前两个数，不断更新得到下一个数。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (10, 10, '判断一个数除以2的余数是否为0即可。使用取模运算符%。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (11, 11, '使用冒泡排序算法，通过两层循环不断比较相邻元素并交换位置，将最大的元素逐步\"冒泡\"到数组末尾。', 'O(n^2)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (12, 12, '遍历字符串，统计目标字符出现的次数。使用循环和计数器实现。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (13, 13, '使用strtok函数分割字符串，遍历所有单词，跳过\"world\"单词不输出。注意处理空格和字符串拼接。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (14, 14, '使用欧几里得算法（辗转相除法）求最大公约数。递归实现：当b为0时返回a，否则递归计算gcd(b, a%b)。', 'O(log(min(a,b)))', 'O(log(min(a,b)))', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (15, 15, '将数字反转，如果反转后的数字等于原数字，则是回文数。使用取模和除法运算逐位提取数字并重新组合。', 'O(log n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (16, 16, '使用二维数组存储两个矩阵，对应位置的元素相加即可。注意输出格式的处理。', 'O(n*m)', 'O(n*m)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (17, 17, '先将字符串按空格分割成单词数组，然后从后向前遍历数组输出单词。注意处理单词之间的空格。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (18, 18, '使用二维数组存储杨辉三角，每个数是上一行相邻两个数的和。第一列全为1，其他位置的值等于上一行的相邻两个数之和。', 'O(n^2)', 'O(n^2)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (19, 19, '在给定范围内遍历每个数，使用isPrime函数判断是否为质数。注意输出格式，数字之间需要空格分隔。', 'O((end-start)*sqrt(max(end)))', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (20, 20, '使用一个新数组存储不重复的元素。遍历原数组，对于每个元素，检查是否已经在新数组中存在，如果不存在则添加到新数组。', 'O(n^2)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (21, 21, '使用一个变量sum累加数组中的每个元素。遍历一次数组即可得到总和。', 'O(n)', 'O(n)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (22, 22, '从字符串末尾向前遍历，依次输出每个字符即可得到反转的字符串。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (23, 23, '使用迭代方法计算斐波那契数列。维护三个变量a、b、c，其中a和b分别表示前两个数，c用于计算它们的和。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (25, 25, '判断一个数是否为偶数，只需要判断它除以2的余数是否为0。使用取模运算符%即可。', 'O(1)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (29, 29, '从左到右遍历二进制字符串，对于每一位，将当前结果乘2再加上当前位的值。注意字符转数字需要减去字符\'0\'的ASCII值。', 'O(n)', 'O(1)', '2025-02-09 20:35:22', '2025-02-09 20:35:22');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (33, 33, '对应题目0027', 'O(N)', 'O(1)', '2025-02-25 18:45:04', '2025-04-04 11:30:47');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (34, 30, '对应题目0028', '', '', '2025-02-25 18:49:52', '2025-04-04 11:30:52');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (35, 34, '对应题目0029', '11', '11', '2025-02-25 19:00:52', '2025-04-04 11:30:57');
INSERT INTO `solution_main` (`id`, `problem_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (36, 37, '测试用例3', 'n', '1', '2025-04-04 11:13:32', '2025-04-04 11:13:32');
COMMIT;

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
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (3, 7, '202313008222', '里里', '', '', '', '2025-03-04 15:42:17', '2025-03-10 08:48:14', 3);
COMMIT;

-- ----------------------------
-- Table structure for submissions
-- ----------------------------
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE `submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '提交用户ID',
  `problem_id` int NOT NULL COMMENT '题目ID',
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
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of submissions
-- ----------------------------
BEGIN;
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (1, 1, 1, 'dawdwa', 'c', 0, 632, 'Command failed: docker exec judge-d273ef5b-71fc-420c-a01d-e39ce74c6bcc bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dawdwa\n      | ^~~~~~\n', '2025-01-22 15:52:59', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (2, 1, 1, 'dwada', 'c_cpp', 0, 0, '不支持的编程语言: c_cpp', '2025-01-22 15:59:54', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (3, 1, 1, 'sdawddw', 'c', 0, 648, 'Command failed: docker exec judge-6e29f569-774a-463d-ac97-f2e050c99eea bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | sdawddw\n      | ^~~~~~~\n', '2025-01-22 16:00:09', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (4, 1, 1, 'dwadwa', 'c', 0, 632, 'Command failed: docker exec judge-b95bcccc-affd-4b1e-8d42-5870f375d7bf bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dwadwa\n      | ^~~~~~\n', '2025-01-22 16:03:09', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (5, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', NULL, NULL, '题目或测试用例不存在', '2025-01-22 16:05:37', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (6, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 968, NULL, '2025-01-22 16:06:47', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (7, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-22 16:10:04', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (8, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 920, NULL, '2025-01-22 16:12:45', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (9, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-22 16:14:48', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (10, 1, 7, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-22 16:18:03', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (11, 1, 7, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 780, NULL, '2025-01-22 16:18:42', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (12, 1, 2, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'cpp', 0, 736, NULL, '2025-01-23 09:11:17', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (13, 1, 6, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 10:09:15', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (14, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-8c3a65c2-9edf-45b7-8f85-eb1850574220 -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:04:00', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (15, 1, 6, '？？？', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-506c7e0d-fa9f-4826-a515-6c6e21f2994c -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:04:38', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (16, 1, 9, '1111', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-2a428ea4-b310-490e-ab83-5a6ff1f4280b -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:05:19', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (17, 1, 8, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 34, NULL, '2025-01-23 14:06:31', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (18, 1, 8, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', '', 0, 0, '不支持的编程语言: ', '2025-01-23 14:08:28', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (19, 1, 8, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 14:08:44', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (20, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-23 16:24:13', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (21, 1, 3, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 2, NULL, '2025-01-23 16:24:55', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (22, 1, 4, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    long long result = 1;\n    for(int i = 1; i <= n; i++) {\n        result *= i;\n    }\n    printf(\"%lld\\n\", result);\n    return 0;\n}', 'c', 0, 916, NULL, '2025-01-23 16:28:04', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (23, 1, 5, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++) {\n        if(n % i == 0) return 0;\n    }\n    return 1;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPrime(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-23 16:28:24', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (29, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 724, 'Wrong Answer\n输入: 6\n期望输出: undefined\n实际输出: ', '2025-01-25 10:06:52', 'Wrong Answer', '2025-01-25 10:06:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (30, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 732, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:09:52', 'System Error', '2025-01-25 10:09:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (31, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 24, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:10:09', 'System Error', '2025-01-25 10:10:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (32, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 704, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:12:58', 'System Error', '2025-01-25 10:13:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (33, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:14:53', 'System Error', '2025-01-25 10:14:56');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (34, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, NULL, '2025-01-25 10:16:37', 'Accepted', '2025-01-25 10:16:45');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (35, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-25 10:21:47', 'Accepted', '2025-01-25 10:21:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (36, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-25 12:18:43', 'Accepted', '2025-01-25 12:18:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (37, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 0, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-4c49472e-d895-4264-9605-d9f7561c0c28 -w /app gcc:latest tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-26 11:47:20', 'System Error', '2025-01-26 11:47:20');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (38, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 36, NULL, '2025-01-26 11:55:03', 'Accepted', '2025-01-26 11:55:10');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (39, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-26 11:57:19', 'Accepted', '2025-01-26 11:57:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (40, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'cpp', 0, 29, NULL, '2025-01-26 11:58:57', 'Accepted', '2025-01-26 11:59:04');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (41, 1, 19, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-26 12:00:42', 'Accepted', '2025-01-26 12:00:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (42, 1, 19, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 768, NULL, '2025-01-26 12:02:21', 'Accepted', '2025-01-26 12:02:29');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (43, 1, 19, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 704, NULL, '2025-01-26 12:04:13', 'Accepted', '2025-01-26 12:04:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (44, 1, 15, '#include <stdio.h>\n\nint isPalindrome(int n) {\n    int reversed = 0, original = n;\n    while(n > 0) {\n        reversed = reversed * 10 + n % 10;\n        n /= 10;\n    }\n    return original == reversed;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPalindrome(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-26 12:09:54', 'Accepted', '2025-01-26 12:10:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (45, 1, 10, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", n % 2 == 0 ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 852, NULL, '2025-01-26 12:39:17', 'Accepted', '2025-01-26 12:39:24');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (46, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:42:37', 'Wrong Answer', '2025-01-26 12:42:40');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (47, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 740, NULL, '2025-01-26 12:44:06', 'Accepted', '2025-01-26 12:44:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (48, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 660, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:46:28', 'Wrong Answer', '2025-01-26 12:46:31');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (49, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:48:22', 'Wrong Answer', '2025-01-26 12:48:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (50, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 672, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:48:42', 'Wrong Answer', '2025-01-26 12:48:46');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (51, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:49:29', 'Wrong Answer', '2025-01-26 12:49:31');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (52, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:51:51', 'Wrong Answer', '2025-01-26 12:51:54');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (53, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:13', 'Wrong Answer', '2025-01-26 12:52:17');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (54, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 652, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:21', 'Wrong Answer', '2025-01-26 12:52:23');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (55, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 684, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:54', 'Wrong Answer', '2025-01-26 12:52:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (57, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 748, NULL, '2025-01-26 12:55:29', 'Accepted', '2025-01-26 12:55:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (58, 1, 3, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 728, NULL, '2025-01-26 13:04:58', 'Accepted', '2025-01-26 13:05:05');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (59, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, 'Cannot read properties of undefined (reading \'0\')', '2025-02-05 16:43:55', 'System Error', '2025-02-05 16:43:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (60, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-02-05 16:45:48', 'System Error', '2025-02-05 16:45:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (61, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:47:35', 'Accepted', '2025-02-05 16:47:38');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (62, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:47:58', 'Accepted', '2025-02-05 16:48:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (63, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:49:49', 'Accepted', '2025-02-05 16:49:51');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (64, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 387, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 16:52:55', 'Wrong Answer', '2025-02-05 16:52:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (65, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 401, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 16:58:36', 'Wrong Answer', '2025-02-05 16:58:38');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (66, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 397, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:08:04', 'Wrong Answer', '2025-02-05 17:08:06');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (67, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 426, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:13:22', 'Wrong Answer', '2025-02-05 17:13:24');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (68, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 304, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:13:24', 'Wrong Answer', '2025-02-05 17:13:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (69, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 420, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:35:07', 'Wrong Answer', '2025-02-05 17:35:09');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (70, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 17:39:39', 'Accepted', '2025-02-05 17:39:42');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (71, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 17:40:23', 'Accepted', '2025-02-05 17:40:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (78, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 13:30:13', 'Accepted', '2025-02-06 13:30:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (79, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 13:31:52', 'Accepted', '2025-02-06 13:31:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (80, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 298, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 13:32:08', 'Wrong Answer', '2025-02-06 13:32:09');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (81, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 14:05:19', 'Accepted', '2025-02-06 14:05:22');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (82, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 404, 0, NULL, '2025-02-06 14:06:46', 'Accepted', '2025-02-06 14:06:48');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (83, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 381, 608, NULL, '2025-02-06 14:11:13', 'Accepted', '2025-02-06 14:11:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (84, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '运行时错误：\n不支持的编程语言\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-02-17 16:57:57', 'Runtime Error', '2025-02-17 16:57:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (85, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1286, 592, NULL, '2025-02-17 17:02:07', 'Accepted', '2025-02-17 17:02:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (86, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'C', 353, 680, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-03-07 16:03:48', 'Wrong Answer', '2025-03-07 16:03:51');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (87, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, NULL, '2025-04-03 08:56:05', 'System Error', '2025-04-03 08:56:05');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (88, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, NULL, '2025-04-03 08:58:58', 'System Error', '2025-04-03 08:58:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (89, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 2997, 592, NULL, '2025-04-03 09:00:32', 'Accepted', '2025-04-03 09:00:45');
COMMIT;

-- ----------------------------
-- Table structure for submissions_backup
-- ----------------------------
DROP TABLE IF EXISTS `submissions_backup`;
CREATE TABLE `submissions_backup` (
  `id` int NOT NULL DEFAULT '0',
  `user_id` int NOT NULL COMMENT '提交用户ID',
  `problem_id` int NOT NULL COMMENT '题目ID',
  `code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提交的代码',
  `language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '编程语言',
  `runtime` int DEFAULT NULL COMMENT '运行时间(ms)',
  `memory` int DEFAULT NULL COMMENT '内存消耗(KB)',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '错误信息',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `new_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of submissions_backup
-- ----------------------------
BEGIN;
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (1, 1, 1, 'dawdwa', 'c', 0, 632, 'Command failed: docker exec judge-d273ef5b-71fc-420c-a01d-e39ce74c6bcc bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dawdwa\n      | ^~~~~~\n', '2025-01-22 15:52:59', 'Runtime Error', 'Runtime Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (2, 1, 1, 'dwada', 'c_cpp', 0, 0, '不支持的编程语言: c_cpp', '2025-01-22 15:59:54', 'System Error', 'System Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (3, 1, 1, 'sdawddw', 'c', 0, 648, 'Command failed: docker exec judge-6e29f569-774a-463d-ac97-f2e050c99eea bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | sdawddw\n      | ^~~~~~~\n', '2025-01-22 16:00:09', 'Runtime Error', 'Runtime Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (4, 1, 1, 'dwadwa', 'c', 0, 632, 'Command failed: docker exec judge-b95bcccc-affd-4b1e-8d42-5870f375d7bf bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dwadwa\n      | ^~~~~~\n', '2025-01-22 16:03:09', 'Runtime Error', 'Runtime Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (5, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', NULL, NULL, '题目或测试用例不存在', '2025-01-22 16:05:37', 'System Error', 'System Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (6, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 968, NULL, '2025-01-22 16:06:47', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (7, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-22 16:10:04', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (8, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 920, NULL, '2025-01-22 16:12:45', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (9, 1, 7, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-22 16:14:48', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (10, 1, 7, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-22 16:18:03', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (11, 1, 7, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 780, NULL, '2025-01-22 16:18:42', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (12, 1, 2, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'cpp', 0, 736, NULL, '2025-01-23 09:11:17', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (13, 1, 6, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 10:09:15', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (14, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-8c3a65c2-9edf-45b7-8f85-eb1850574220 -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:04:00', 'System Error', 'System Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (15, 1, 6, '？？？', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-506c7e0d-fa9f-4826-a515-6c6e21f2994c -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:04:38', 'System Error', 'System Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (16, 1, 9, '1111', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-2a428ea4-b310-490e-ab83-5a6ff1f4280b -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 14:05:19', 'System Error', 'System Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (17, 1, 8, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 34, NULL, '2025-01-23 14:06:31', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (18, 1, 8, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', '', 0, 0, '不支持的编程语言: ', '2025-01-23 14:08:28', 'System Error', 'System Error', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (19, 1, 8, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 14:08:44', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (20, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-23 16:24:13', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (21, 1, 3, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 2, NULL, '2025-01-23 16:24:55', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (22, 1, 4, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    long long result = 1;\n    for(int i = 1; i <= n; i++) {\n        result *= i;\n    }\n    printf(\"%lld\\n\", result);\n    return 0;\n}', 'c', 0, 916, NULL, '2025-01-23 16:28:04', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (23, 1, 5, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++) {\n        if(n % i == 0) return 0;\n    }\n    return 1;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPrime(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-23 16:28:24', 'Accepted', 'Accepted', NULL);
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (29, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 724, 'Wrong Answer\n输入: 6\n期望输出: undefined\n实际输出: ', '2025-01-25 10:06:52', NULL, 'Not Accepted', '2025-01-25 10:06:55');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (30, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 732, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:09:52', NULL, 'System Error', '2025-01-25 10:09:55');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (31, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 24, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:10:09', NULL, 'System Error', '2025-01-25 10:10:13');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (32, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 704, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:12:58', NULL, 'System Error', '2025-01-25 10:13:01');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (33, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 10:14:53', NULL, 'System Error', '2025-01-25 10:14:56');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (34, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, NULL, '2025-01-25 10:16:37', NULL, 'Accepted', '2025-01-25 10:16:45');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (35, 1, 9, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-25 10:21:47', NULL, 'Accepted', '2025-01-25 10:21:55');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (36, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-25 12:18:43', NULL, 'Accepted', '2025-01-25 12:18:50');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (37, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 0, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-4c49472e-d895-4264-9605-d9f7561c0c28 -w /app gcc:latest tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-26 11:47:20', NULL, 'System Error', '2025-01-26 11:47:20');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (38, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 36, NULL, '2025-01-26 11:55:03', NULL, 'Accepted', '2025-01-26 11:55:10');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (39, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-26 11:57:19', NULL, 'Accepted', '2025-01-26 11:57:26');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (40, 1, 11, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'cpp', 0, 29, NULL, '2025-01-26 11:58:57', NULL, 'Accepted', '2025-01-26 11:59:04');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (41, 1, 19, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-26 12:00:42', NULL, 'Accepted', '2025-01-26 12:00:50');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (42, 1, 19, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 768, NULL, '2025-01-26 12:02:21', NULL, 'Accepted', '2025-01-26 12:02:29');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (43, 1, 19, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 704, NULL, '2025-01-26 12:04:13', NULL, 'Accepted', '2025-01-26 12:04:21');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (44, 1, 15, '#include <stdio.h>\n\nint isPalindrome(int n) {\n    int reversed = 0, original = n;\n    while(n > 0) {\n        reversed = reversed * 10 + n % 10;\n        n /= 10;\n    }\n    return original == reversed;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPalindrome(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-26 12:09:54', NULL, 'Accepted', '2025-01-26 12:10:01');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (45, 1, 10, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", n % 2 == 0 ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 852, NULL, '2025-01-26 12:39:17', NULL, 'Accepted', '2025-01-26 12:39:24');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (46, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:42:37', NULL, 'Not Accepted', '2025-01-26 12:42:40');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (47, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 740, NULL, '2025-01-26 12:44:06', NULL, 'Accepted', '2025-01-26 12:44:13');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (48, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 660, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:46:28', NULL, 'Not Accepted', '2025-01-26 12:46:31');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (49, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:48:22', NULL, 'Not Accepted', '2025-01-26 12:48:26');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (50, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 672, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:48:42', NULL, 'Not Accepted', '2025-01-26 12:48:46');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (51, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 12:49:29', NULL, 'Not Accepted', '2025-01-26 12:49:31');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (52, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:51:51', NULL, 'Not Accepted', '2025-01-26 12:51:54');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (53, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:13', NULL, 'Not Accepted', '2025-01-26 12:52:17');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (54, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 652, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:21', NULL, 'Not Accepted', '2025-01-26 12:52:23');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (55, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 684, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 12:52:54', NULL, 'Not Accepted', '2025-01-26 12:52:58');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (57, 1, 17, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 748, NULL, '2025-01-26 12:55:29', NULL, 'Accepted', '2025-01-26 12:55:36');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (58, 1, 3, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 728, NULL, '2025-01-26 13:04:58', NULL, 'Accepted', '2025-01-26 13:05:05');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (59, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, 'Cannot read properties of undefined (reading \'0\')', '2025-02-05 16:43:55', NULL, 'System Error', '2025-02-05 16:43:57');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (60, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-02-05 16:45:48', NULL, 'System Error', '2025-02-05 16:45:50');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (61, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:47:35', NULL, 'Accepted', '2025-02-05 16:47:38');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (62, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:47:58', NULL, 'Accepted', '2025-02-05 16:48:01');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (63, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-05 16:49:49', NULL, 'Accepted', '2025-02-05 16:49:51');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (64, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 387, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 16:52:55', NULL, 'Not Accepted', '2025-02-05 16:52:57');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (65, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 401, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 16:58:36', NULL, 'Not Accepted', '2025-02-05 16:58:38');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (66, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 397, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:08:04', NULL, 'Not Accepted', '2025-02-05 17:08:06');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (67, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 426, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:13:22', NULL, 'Not Accepted', '2025-02-05 17:13:24');
INSERT INTO `submissions_backup` (`id`, `user_id`, `problem_id`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `new_status`, `status`, `completed_at`) VALUES (68, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 304, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-05 17:13:24', NULL, 'Not Accepted', '2025-02-05 17:13:26');
COMMIT;

-- ----------------------------
-- Table structure for teacher_messages
-- ----------------------------
DROP TABLE IF EXISTS `teacher_messages`;
CREATE TABLE `teacher_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL COMMENT '课堂ID',
  `teacher_id` int NOT NULL COMMENT '教师ID',
  `teacher_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '教师姓名',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '留言内容',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `is_pinned` tinyint(1) DEFAULT '0' COMMENT '是否置顶',
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_teacher_id` (`teacher_id`),
  CONSTRAINT `fk_message_session` FOREIGN KEY (`session_id`) REFERENCES `classroom_sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='老师留言表';

-- ----------------------------
-- Records of teacher_messages
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for test_cases
-- ----------------------------
DROP TABLE IF EXISTS `test_cases`;
CREATE TABLE `test_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `input` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '测试输入',
  `expected_output` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '期望输出',
  `is_example` tinyint(1) DEFAULT '0' COMMENT '是否为示例测试用例',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_testcase_problem` (`problem_id`),
  CONSTRAINT `fk_testcase_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of test_cases
-- ----------------------------
BEGIN;
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (1, 1, '2 3', '5', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (2, 1, '10 20', '30', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (3, 1, '-5 8', '3', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (4, 2, '5\n1 5 3 8 2', '8', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (5, 2, '5\n10 20 30 40 50', '50', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (6, 2, '3\n-1 -5 -3', '-1', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (7, 3, 'hello', 'olleh', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (8, 3, 'programming', 'gnimmargorp', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (9, 3, '12345', '54321', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (10, 4, '5', '120', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (11, 4, '3', '6', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (12, 4, '6', '720', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (13, 5, '7', '是', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (14, 5, '4', '否', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (15, 5, '13', '是', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (16, 6, '5 3', '2', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (17, 6, '10 7', '3', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (18, 6, '20 5', '15', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (19, 7, '5\n4 2 7 1 9', '1', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (20, 7, '3\n10 5 8', '5', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (21, 7, '4\n15 3 9 2', '2', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (22, 8, 'abc def', 'abcdef', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (23, 8, 'hello world', 'helloworld', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (24, 8, '123 456', '123456', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (25, 9, '6', '8', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (26, 9, '7', '13', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (27, 9, '8', '21', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (28, 10, '8', '是', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (29, 10, '15', '否', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (30, 10, '100', '是', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (31, 11, '5\n9 3 6 2 7', '2 3 6 7 9', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (32, 11, '5\n5 2 8 1 9', '1 2 5 8 9', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (33, 11, '3\n7 3 1', '1 3 7', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (34, 12, 'apple p', '2', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (35, 12, 'hello l', '2', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (36, 12, 'programming m', '2', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (37, 13, 'hello world world java', 'hello java', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (38, 13, 'good morning morning evening', 'good evening', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (39, 13, 'programming is fun fun interesting', 'programming is interesting', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (40, 14, '12 18', '6', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (41, 14, '25 35', '5', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (42, 14, '48 64', '16', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (43, 15, '121', '是', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (44, 15, '123', '否', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (45, 15, '12321', '是', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (46, 16, '2 2\n1 2\n3 4\n5 6\n7 8', '6 8\n10 12', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (47, 16, '2 2\n1 1\n1 1\n2 2\n2 2', '3 3\n3 3', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (48, 16, '2 2\n0 1\n2 3\n1 2\n3 4', '1 3\n5 7', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (49, 17, 'I love programming', 'programming love I', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (50, 17, 'Hello World', 'World Hello', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (51, 17, 'Good Morning Everyone', 'Everyone Morning Good', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (52, 18, '5', '1\n1 1\n1 2 1\n1 3 3 1\n1 4 6 4 1', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (53, 18, '3', '1\n1 1\n1 2 1', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (54, 18, '4', '1\n1 1\n1 2 1\n1 3 3 1', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (55, 19, '10 20', '11 13 17 19', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (56, 19, '20 30', '23 29', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (57, 19, '1 10', '2 3 5 7', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (58, 20, '6\n1 2 2 3 3 3', '1 2 3', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (59, 20, '5\n4 4 4 5 5', '4 5', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (60, 20, '6\n1 1 2 2 3 3', '1 2 3', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (61, 21, '5\n1 2 3 4 5', '15', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (62, 21, '3\n10 20 30', '60', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (63, 21, '4\n2 4 6 8', '20', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (64, 22, 'hello', 'olleh', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (65, 22, 'world', 'dlrow', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (66, 22, '12345', '54321', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (67, 23, '6', '8', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (68, 23, '7', '13', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (69, 23, '8', '21', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (73, 25, '8', '是', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (74, 25, '15', '否', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (75, 25, '100', '是', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (85, 29, '1010', '10', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (86, 29, '1100', '12', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (87, 29, '1111', '15', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (88, 30, '6\n100 4 200 1 3 2', '4', 1, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (89, 30, '5\n1 2 3 4 5', '5', 0, '2025-01-23 08:42:32');
INSERT INTO `test_cases` (`id`, `problem_id`, `input`, `expected_output`, `is_example`, `created_at`) VALUES (90, 30, '9\n0 3 7 2 5 8 4 6 1', '9', 0, '2025-01-23 08:42:32');
COMMIT;

-- ----------------------------
-- Table structure for user_learning_plan_progress
-- ----------------------------
DROP TABLE IF EXISTS `user_learning_plan_progress`;
CREATE TABLE `user_learning_plan_progress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `plan_id` int NOT NULL COMMENT '学习计划ID',
  `started_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `last_problem_id` int DEFAULT NULL COMMENT '最后做的题目ID',
  `completed_problems` int DEFAULT '0' COMMENT '已完成题目数',
  `total_problems` int DEFAULT '0' COMMENT '总题目数',
  `status` enum('not_started','in_progress','completed') DEFAULT 'not_started' COMMENT '进度状态',
  `completed_at` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_plan` (`user_id`,`plan_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_plan_id` (`plan_id`),
  CONSTRAINT `fk_ulpp_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `learning_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ulpp_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户-学习计划进度表';

-- ----------------------------
-- Records of user_learning_plan_progress
-- ----------------------------
BEGIN;
INSERT INTO `user_learning_plan_progress` (`id`, `user_id`, `plan_id`, `started_at`, `last_problem_id`, `completed_problems`, `total_problems`, `status`, `completed_at`, `created_at`, `updated_at`) VALUES (1, 1, 1, '2025-02-03 11:19:23', 3, 3, 10, 'in_progress', NULL, '2025-02-03 11:19:23', '2025-02-03 11:19:23');
INSERT INTO `user_learning_plan_progress` (`id`, `user_id`, `plan_id`, `started_at`, `last_problem_id`, `completed_problems`, `total_problems`, `status`, `completed_at`, `created_at`, `updated_at`) VALUES (2, 1, 2, '2025-02-03 11:19:23', NULL, 0, 5, 'not_started', NULL, '2025-02-03 11:19:23', '2025-02-03 11:19:23');
INSERT INTO `user_learning_plan_progress` (`id`, `user_id`, `plan_id`, `started_at`, `last_problem_id`, `completed_problems`, `total_problems`, `status`, `completed_at`, `created_at`, `updated_at`) VALUES (3, 1, 3, '2025-02-03 11:19:23', 2, 2, 10, 'in_progress', NULL, '2025-02-03 11:19:23', '2025-02-03 11:19:23');
INSERT INTO `user_learning_plan_progress` (`id`, `user_id`, `plan_id`, `started_at`, `last_problem_id`, `completed_problems`, `total_problems`, `status`, `completed_at`, `created_at`, `updated_at`) VALUES (4, 1, 4, '2025-02-03 11:19:23', NULL, 0, 5, 'not_started', NULL, '2025-02-03 11:19:23', '2025-02-03 11:19:23');
INSERT INTO `user_learning_plan_progress` (`id`, `user_id`, `plan_id`, `started_at`, `last_problem_id`, `completed_problems`, `total_problems`, `status`, `completed_at`, `created_at`, `updated_at`) VALUES (5, 1, 5, '2025-02-03 11:19:23', 1, 1, 10, 'in_progress', NULL, '2025-02-03 11:19:23', '2025-02-03 11:19:23');
INSERT INTO `user_learning_plan_progress` (`id`, `user_id`, `plan_id`, `started_at`, `last_problem_id`, `completed_problems`, `total_problems`, `status`, `completed_at`, `created_at`, `updated_at`) VALUES (6, 1, 6, '2025-02-03 11:19:23', NULL, 0, 10, 'not_started', NULL, '2025-02-03 11:19:23', '2025-02-03 11:19:23');
COMMIT;

-- ----------------------------
-- Table structure for user_problem_set_progress
-- ----------------------------
DROP TABLE IF EXISTS `user_problem_set_progress`;
CREATE TABLE `user_problem_set_progress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `problem_set_id` int NOT NULL COMMENT '题集ID',
  `completed_problems` int DEFAULT '0' COMMENT '已完成题目数',
  `last_problem_id` int DEFAULT NULL COMMENT '最后做的题目ID',
  `started_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `last_active_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后活动时间',
  `is_completed` tinyint(1) DEFAULT '0' COMMENT '是否完成',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_set` (`user_id`,`problem_set_id`),
  KEY `idx_problem_set_id` (`problem_set_id`),
  CONSTRAINT `fk_progress_set` FOREIGN KEY (`problem_set_id`) REFERENCES `problem_sets` (`id`),
  CONSTRAINT `fk_progress_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of user_problem_set_progress
-- ----------------------------
BEGIN;
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=306 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户通过的题目表';

-- ----------------------------
-- Records of user_problem_status
-- ----------------------------
BEGIN;
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (1, 1, 7, 'Accepted', '2025-01-22 16:39:17', '2025-01-22 16:39:17', NULL, NULL, 0, NULL, NULL, 0, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (2, 1, 2, 'Accepted', '2025-01-23 09:11:27', '2025-01-24 16:14:37', NULL, NULL, 0, NULL, NULL, 1, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (3, 1, 6, 'Accepted', '2025-01-23 10:09:25', '2025-01-23 10:09:25', NULL, NULL, 0, NULL, NULL, 0, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (4, 1, 8, 'Accepted', '2025-01-23 14:06:41', '2025-01-23 14:06:41', NULL, NULL, 0, NULL, NULL, 0, '2025-02-05 13:14:33');
INSERT INTO `user_problem_status` (`id`, `user_id`, `problem_id`, `status`, `created_at`, `updated_at`, `first_submission_time`, `last_submission_time`, `submission_count`, `average_execution_time`, `average_memory_usage`, `viewed_solution`, `completed_at`) VALUES (6, 1, 1, 'Accepted', '2025-01-23 16:24:22', '2025-04-03 09:00:45', NULL, NULL, 12, 2997.45, NULL, 1, '2025-02-05 13:14:33');
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
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `created_at`, `updated_at`) VALUES (23, 9, 'teacher', 'teacher', 'public/uploads/avatars/avatar-1743567478394-445763381.png', NULL, NULL, NULL, NULL, '2025-03-08 11:01:51', '2025-04-02 12:17:58');
COMMIT;

-- ----------------------------
-- Table structure for user_role_relations
-- ----------------------------
DROP TABLE IF EXISTS `user_role_relations`;
CREATE TABLE `user_role_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户ID',
  `role_id` int NOT NULL COMMENT '角色ID',
  `expire_time` timestamp NULL DEFAULT NULL COMMENT '角色过期时间（针对会员）',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`),
  KEY `idx_role_id` (`role_id`),
  CONSTRAINT `fk_user_role_role` FOREIGN KEY (`role_id`) REFERENCES `user_roles` (`id`),
  CONSTRAINT `fk_user_role_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of user_role_relations
-- ----------------------------
BEGIN;
INSERT INTO `user_role_relations` (`id`, `user_id`, `role_id`, `expire_time`, `created_at`, `updated_at`) VALUES (1, 1, 5, NULL, '2025-02-03 16:27:56', '2025-02-03 16:27:56');
INSERT INTO `user_role_relations` (`id`, `user_id`, `role_id`, `expire_time`, `created_at`, `updated_at`) VALUES (2, 2, 1, NULL, '2025-02-03 16:27:56', '2025-02-03 16:27:56');
INSERT INTO `user_role_relations` (`id`, `user_id`, `role_id`, `expire_time`, `created_at`, `updated_at`) VALUES (3, 3, 1, NULL, '2025-02-03 16:27:56', '2025-02-03 16:27:56');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=230 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户访问记录表';

-- ----------------------------
-- Records of user_visits
-- ----------------------------
BEGIN;
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (1, 1, '2025-02-05', '2025-02-05 08:45:49', 35);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (2, 2, '2025-02-05', '2025-02-05 08:45:49', 1);
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
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (226, 1, '2025-04-04', '2025-04-04 11:26:46', 4);
COMMIT;

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
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`) VALUES (9, 'teacher', '$2b$10$jrVuQ6u6D89wzZpD4eVyQ.OTyVmHFmiH0LSKDLF9usHnCQJdQh3ae', '17324042932@163.com', '17324042932', '2025-03-08 11:01:51', 1, NULL, 'teacher', NULL);
COMMIT;

-- ----------------------------
-- View structure for problem_stats
-- ----------------------------
DROP VIEW IF EXISTS `problem_stats`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `problem_stats` AS select `p`.`problem_number` AS `problem_number`,count(distinct `s`.`id`) AS `total_submissions`,count(distinct (case when (`s`.`status` = 'Accepted') then `s`.`id` end)) AS `accepted_submissions`,round(((count(distinct (case when (`s`.`status` = 'Accepted') then `s`.`id` end)) * 100.0) / nullif(count(distinct `s`.`id`),0)),2) AS `acceptance_rate` from (`problems` `p` left join `submissions` `s` on((`p`.`problem_number` = `s`.`problem_id`))) group by `p`.`problem_number`;

-- ----------------------------
-- View structure for problem_success_rates
-- ----------------------------
DROP VIEW IF EXISTS `problem_success_rates`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `problem_success_rates` AS select `ups`.`problem_id` AS `problem_id`,count(0) AS `total_attempts`,sum((case when (`ups`.`status` = 'Accepted') then 1 else 0 end)) AS `accepted_count`,round(((sum((case when (`ups`.`status` = 'Accepted') then 1 else 0 end)) * 100.0) / nullif(count(0),0)),2) AS `success_rate` from `user_problem_status` `ups` group by `ups`.`problem_id`;

-- ----------------------------
-- View structure for user_learning_overview
-- ----------------------------
DROP VIEW IF EXISTS `user_learning_overview`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `user_learning_overview` AS select `u`.`id` AS `user_id`,`u`.`username` AS `username`,count(distinct `s`.`problem_id`) AS `total_problems_solved`,(avg((case when (`s`.`status` = 'AC') then 1 else 0 end)) * 100) AS `success_rate`,max(`aa`.`overall_score`) AS `latest_ability_score`,max(`rls`.`daily_practice_time`) AS `max_daily_practice_time` from (((`users` `u` left join `submissions` `s` on((`u`.`id` = `s`.`user_id`))) left join `ability_assessments` `aa` on((`u`.`id` = `aa`.`user_id`))) left join `recent_learning_stats` `rls` on((`u`.`id` = `rls`.`user_id`))) group by `u`.`id`,`u`.`username`;

-- ----------------------------
-- View structure for v_knowledge_mastery
-- ----------------------------
DROP VIEW IF EXISTS `v_knowledge_mastery`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_knowledge_mastery` AS select `knowledge_mastery_details`.`user_id` AS `user_id`,count(0) AS `total_knowledge_points`,avg(`knowledge_mastery_details`.`mastery_level`) AS `avg_mastery` from `knowledge_mastery_details` group by `knowledge_mastery_details`.`user_id`;

-- ----------------------------
-- View structure for v_learning_days
-- ----------------------------
DROP VIEW IF EXISTS `v_learning_days`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_learning_days` AS select `learning_records`.`user_id` AS `user_id`,count(distinct cast(`learning_records`.`created_at` as date)) AS `learning_days` from `learning_records` group by `learning_records`.`user_id`;

-- ----------------------------
-- View structure for v_learning_path_stats
-- ----------------------------
DROP VIEW IF EXISTS `v_learning_path_stats`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_learning_path_stats` AS select `u`.`id` AS `user_id`,`u`.`username` AS `username`,`lp`.`id` AS `path_id`,`lp`.`path_name` AS `path_name`,`lp`.`description` AS `path_description`,`lp`.`current_stage` AS `current_stage`,`lp`.`total_stages` AS `total_stages`,round(((`lp`.`current_stage` / `lp`.`total_stages`) * 100),2) AS `progress`,`lp`.`is_completed` AS `is_completed`,`lp`.`created_at` AS `start_date`,`lp`.`updated_at` AS `last_updated` from (`users` `u` left join `learning_paths` `lp` on((`u`.`id` = `lp`.`user_id`))) where (`lp`.`updated_at` = (select max(`learning_paths`.`updated_at`) from `learning_paths` where (`learning_paths`.`user_id` = `u`.`id`)));

-- ----------------------------
-- Procedure structure for cleanup_old_data
-- ----------------------------
DROP PROCEDURE IF EXISTS `cleanup_old_data`;
delimiter ;;
CREATE PROCEDURE `cleanup_old_data`()
BEGIN
    -- 删除30天前的实时数据
    DELETE FROM recent_learning_stats 
    WHERE stats_date < DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for create_new_learning_path
-- ----------------------------
DROP PROCEDURE IF EXISTS `create_new_learning_path`;
delimiter ;;
CREATE PROCEDURE `create_new_learning_path`(IN p_user_id INT,
    IN p_stages TEXT,
    IN p_suggestion TEXT)
BEGIN
    -- 1. 将该用户现有的活跃路径设置为非活跃
    UPDATE learning_paths 
    SET status = 'inactive' 
    WHERE user_id = p_user_id 
    AND status = 'active';
    
    -- 2. 插入新的学习路径
    INSERT INTO learning_paths (
        user_id, 
        stages, 
        progress, 
        created_at, 
        suggestion,
        status
    ) VALUES (
        p_user_id,
        p_stages,
        0,
        NOW(),
        p_suggestion,
        'active'
    );
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for get_learning_path_problems
-- ----------------------------
DROP PROCEDURE IF EXISTS `get_learning_path_problems`;
delimiter ;;
CREATE PROCEDURE `get_learning_path_problems`(IN p_user_id INT)
BEGIN
    SELECT 
        p.*,
        COALESCE(psr.success_rate, 0) as success_rate,
        CASE WHEN ups.status = 'Accepted' THEN true ELSE false END as completed,
        lps.stage_order,
        kp.name as knowledge_point
    FROM learning_paths lp
    JOIN learning_path_stages lps ON lp.id = lps.learning_path_id
    JOIN problems p ON lps.problem_id = p.problem_number
    LEFT JOIN problem_success_rates psr ON p.problem_number = psr.problem_id
    LEFT JOIN user_problem_status ups ON p.problem_number = ups.problem_id AND ups.user_id = p_user_id
    LEFT JOIN knowledge_points kp ON p.knowledge_point_id = kp.id
    WHERE lp.user_id = p_user_id AND lp.status = 'active'
    ORDER BY lps.stage_order;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for record_learning_activity
-- ----------------------------
DROP PROCEDURE IF EXISTS `record_learning_activity`;
delimiter ;;
CREATE PROCEDURE `record_learning_activity`(IN p_user_id INT,
    IN p_activity_type VARCHAR(50),
    IN p_problem_id VARCHAR(10),
    IN p_additional_info JSON)
BEGIN
    INSERT INTO learning_activities (user_id, activity_type, problem_id, additional_info)
    VALUES (p_user_id, p_activity_type, p_problem_id, p_additional_info);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for update_ability_assessment
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_ability_assessment`;
delimiter ;;
CREATE PROCEDURE `update_ability_assessment`(IN p_user_id INT)
BEGIN
    DECLARE v_learning_efficiency DECIMAL(4,2);
    DECLARE v_knowledge_application DECIMAL(4,2);
    DECLARE v_overall_score DECIMAL(4,2);
    
    -- 计算学习效率（基于平均解题时间和提交次数）
    SELECT 
        AVG(
            CASE 
                WHEN solution_time <= 300 AND submission_count <= 2 THEN 100
                WHEN solution_time <= 600 AND submission_count <= 3 THEN 85
                WHEN solution_time <= 900 AND submission_count <= 4 THEN 70
                ELSE 55
            END
        ) INTO v_learning_efficiency
    FROM user_problem_status
    WHERE user_id = p_user_id 
    AND status = 'completed'
    AND solution_time IS NOT NULL;
    
    -- 计算知识应用能力（基于知识点掌握度和题目难度）
    SELECT 
        AVG(mastery_level) INTO v_knowledge_application
    FROM knowledge_mastery_details
    WHERE user_id = p_user_id;
    
    -- 计算总体评分（学习效率占40%，知识应用能力占60%）
    SET v_overall_score = (v_learning_efficiency * 0.4) + (v_knowledge_application * 0.6);
    
    -- 插入或更新能力评估记录
    INSERT INTO ability_assessments 
        (user_id, learning_efficiency, knowledge_application, overall_score, assessment_date)
    VALUES 
        (p_user_id, v_learning_efficiency, v_knowledge_application, v_overall_score, CURDATE())
    ON DUPLICATE KEY UPDATE
        learning_efficiency = v_learning_efficiency,
        knowledge_application = v_knowledge_application,
        overall_score = v_overall_score;
        
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for update_learning_potential
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_learning_potential`;
delimiter ;;
CREATE PROCEDURE `update_learning_potential`(IN p_user_id INT)
BEGIN
    -- 声明所有变量
    DECLARE v_problem_solving DECIMAL(5,2);
    DECLARE v_learning_speed DECIMAL(5,2);
    DECLARE v_knowledge_coverage DECIMAL(5,2);
    DECLARE v_practice_consistency DECIMAL(5,2);
    
    -- 计算解题能力（基于成功提交率）
    SELECT 
        COALESCE((COUNT(CASE WHEN status = 'AC' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0)), 0)
    INTO v_problem_solving
    FROM submissions
    WHERE user_id = p_user_id
    AND created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
    
    -- 计算学习速度（基于平均解题时间）
    SELECT 
        COALESCE(100 - AVG(TIMESTAMPDIFF(MINUTE, created_at, submit_time)), 0)
    INTO v_learning_speed
    FROM submissions
    WHERE user_id = p_user_id
    AND status = 'AC'
    AND created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
    
    -- 计算知识覆盖度
    SELECT 
        COALESCE((COUNT(DISTINCT p.type) * 100.0 / NULLIF((SELECT COUNT(DISTINCT type) FROM problems), 0)), 0)
    INTO v_knowledge_coverage
    FROM submissions s
    JOIN problems p ON s.problem_id = p.id
    WHERE s.user_id = p_user_id
    AND s.status = 'AC';
    
    -- 计算练习持续性
    SELECT 
        COALESCE((COUNT(DISTINCT DATE(created_at)) * 100.0 / 30), 0)
    INTO v_practice_consistency
    FROM submissions
    WHERE user_id = p_user_id
    AND created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
    
    -- 插入或更新分析结果
    INSERT INTO learning_potential_analysis
    (user_id, analysis_date, problem_solving, learning_speed, knowledge_coverage, practice_consistency, analysis_text)
    VALUES
    (p_user_id, CURRENT_DATE, 
     v_problem_solving,
     v_learning_speed,
     v_knowledge_coverage,
     v_practice_consistency,
     CONCAT('基于最近30天的学习数据分析：\n',
            '解题能力: ', v_problem_solving, '%\n',
            '学习速度: ', v_learning_speed, '%\n',
            '知识覆盖: ', v_knowledge_coverage, '%\n',
            '练习持续性: ', v_practice_consistency, '%'))
    ON DUPLICATE KEY UPDATE
    problem_solving = VALUES(problem_solving),
    learning_speed = VALUES(learning_speed),
    knowledge_coverage = VALUES(knowledge_coverage),
    practice_consistency = VALUES(practice_consistency),
    analysis_text = VALUES(analysis_text);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for update_problem_stats
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_problem_stats`;
delimiter ;;
CREATE PROCEDURE `update_problem_stats`()
BEGIN
    UPDATE problems p
    JOIN problem_stats ps ON p.problem_number = ps.problem_number
    SET 
        p.total_submissions = ps.total_submissions,
        p.acceptance_rate = ps.acceptance_rate;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for update_user_ability_assessment
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_user_ability_assessment`;
delimiter ;;
CREATE PROCEDURE `update_user_ability_assessment`(IN p_user_id INT)
BEGIN
    DECLARE v_learning_efficiency DECIMAL(4,2);
    DECLARE v_knowledge_application DECIMAL(4,2);
    
    -- 计算学习效率（基于最近30天的提交记录）
    SELECT 
        (COUNT(CASE WHEN status = 'AC' THEN 1 END) / COUNT(*)) * 100 
    INTO v_learning_efficiency
    FROM submissions 
    WHERE user_id = p_user_id 
    AND created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);
    
    -- 计算知识应用能力（基于不同类型题目的解决情况）
    SELECT 
        (COUNT(DISTINCT p.type) / (SELECT COUNT(DISTINCT type) FROM problems)) * 100
    INTO v_knowledge_application
    FROM submissions s
    JOIN problems p ON s.problem_id = p.id
    WHERE s.user_id = p_user_id 
    AND s.status = 'AC';
    
    -- 插入新的能力评估记录
    INSERT INTO ability_assessments 
        (user_id, learning_efficiency, knowledge_application, overall_score, assessment_date)
    VALUES 
        (p_user_id, 
         v_learning_efficiency, 
         v_knowledge_application, 
         (v_learning_efficiency + v_knowledge_application) / 2,
         CURRENT_DATE);
END
;;
delimiter ;

-- ----------------------------
-- Event structure for cleanup_event
-- ----------------------------
DROP EVENT IF EXISTS `cleanup_event`;
delimiter ;;
CREATE EVENT `cleanup_event`
ON SCHEDULE
EVERY '1' DAY STARTS '2025-01-25 09:21:12'
DO CALL cleanup_old_data()
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
