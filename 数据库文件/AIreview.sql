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

 Date: 21/04/2025 09:14:14
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂——课堂讨论表';

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂——课堂文件表';

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课堂——课堂留言表';

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
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb3;

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
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb3;

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
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb3;

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
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学习计划-题目关联表';

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
-- Table structure for problem_pool
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool`;
CREATE TABLE `problem_pool` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_number` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '题目标题',
  `difficulty` enum('简单','中等','困难') COLLATE utf8mb4_general_ci NOT NULL COMMENT '难度等级',
  `tags` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签，多个标签用逗号分隔',
  `description` text COLLATE utf8mb4_general_ci COMMENT '题目描述',
  `time_limit` int DEFAULT '1000' COMMENT '时间限制(ms)',
  `memory_limit` int DEFAULT '256' COMMENT '内存限制(MB)',
  `category` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '题目分类，如算法、数据结构等',
  `source` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '题目来源',
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
-- Table structure for problem_pool_categories
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_categories`;
CREATE TABLE `problem_pool_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类描述',
  `parent_id` int DEFAULT NULL COMMENT '父分类ID',
  `order_num` int DEFAULT '0' COMMENT '排序序号',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `problem_pool_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池分类表';

-- ----------------------------
-- Table structure for problem_pool_solution_code
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_solution_code`;
CREATE TABLE `problem_pool_solution_code` (
  `id` int NOT NULL AUTO_INCREMENT,
  `solution_number` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for problem_pool_solutions
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_solutions`;
CREATE TABLE `problem_pool_solutions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `solution_number` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `problem_number` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
-- Table structure for problem_pool_test_cases
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_test_cases`;
CREATE TABLE `problem_pool_test_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_number` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `problem_pool_id` int NOT NULL COMMENT '题目池ID',
  `input` text COLLATE utf8mb4_general_ci NOT NULL,
  `output` text COLLATE utf8mb4_general_ci NOT NULL,
  `is_example` tinyint(1) DEFAULT '0' COMMENT '是否为显示样例',
  `order_num` int DEFAULT '0' COMMENT '测试用例顺序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `problem_pool_id` (`problem_pool_id`),
  KEY `idx_problem_number` (`problem_number`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='题目池测试用例表';

-- ----------------------------
-- Table structure for problem_pool_usage
-- ----------------------------
DROP TABLE IF EXISTS `problem_pool_usage`;
CREATE TABLE `problem_pool_usage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_number` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目——题目测试样例表';

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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb3 COMMENT='题目——题目详细表';

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
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答案——题目解答代码';

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
-- Table structure for solution_main
-- ----------------------------
DROP TABLE IF EXISTS `solution_main`;
CREATE TABLE `solution_main` (
  `id` int NOT NULL AUTO_INCREMENT,
  `problem_id` int NOT NULL COMMENT '题目ID',
  `problem_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `solution_approach` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通用解题思路',
  `time_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均时间复杂度',
  `space_complexity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '平均空间复杂度',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_main_problem` (`problem_id`),
  CONSTRAINT `fk_main_problem` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答案——题目解答方案、时空复杂度';

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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='后台管理——学生管理信息表';

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
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目——用户提交记录表';

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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3 COMMENT='全局——用户显示资料表';

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
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局——用户访问网站记录表';

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
  `refresh_token` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_phone` (`phone`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局——用户隐私信息表';

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
-- Procedure structure for populate_problem_category_relations
-- ----------------------------
DROP PROCEDURE IF EXISTS `populate_problem_category_relations`;
delimiter ;;
CREATE PROCEDURE `populate_problem_category_relations`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE problem_id INT;
    DECLARE problem_tags VARCHAR(255);
    DECLARE tag_cursor CURSOR FOR SELECT id, tags FROM problems WHERE tags IS NOT NULL AND tags != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    TRUNCATE TABLE problem_category_relations;
    
    OPEN tag_cursor;
    
    read_loop: LOOP
        FETCH tag_cursor INTO problem_id, problem_tags;
        IF done THEN
            LEAVE read_loop;
        END IF;
        BEGIN
            DECLARE tag_name VARCHAR(50);
            DECLARE tag_position INT;
            DECLARE tag_length INT;
            DECLARE remaining_tags VARCHAR(255);
            
            SET remaining_tags = problem_tags;
            
            tag_loop: WHILE LENGTH(remaining_tags) > 0 DO
                SET tag_position = LOCATE(',', remaining_tags);
                
                IF tag_position > 0 THEN
                    SET tag_name = TRIM(SUBSTRING(remaining_tags, 1, tag_position - 1));
                    SET remaining_tags = SUBSTRING(remaining_tags, tag_position + 1);
                ELSE
                    SET tag_name = TRIM(remaining_tags);
                    SET remaining_tags = '';
                END IF;
                INSERT IGNORE INTO problem_category_relations (problem_id, category_id)
                SELECT problem_id, id FROM problem_categories WHERE name = tag_name;
            END WHILE tag_loop;
        END;
    END LOOP;
    
    CLOSE tag_cursor;
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

-- ----------------------------
-- Triggers structure for table problem_pool_usage
-- ----------------------------
DROP TRIGGER IF EXISTS `after_pool_usage_insert`;
delimiter ;;
CREATE TRIGGER `AIreview`.`after_pool_usage_insert` AFTER INSERT ON `problem_pool_usage` FOR EACH ROW BEGIN
    UPDATE problem_pool
    SET reference_count = reference_count + 1
    WHERE id = NEW.problem_pool_id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table problems
-- ----------------------------
DROP TRIGGER IF EXISTS `update_problem_categories`;
delimiter ;;
CREATE TRIGGER `AIreview`.`update_problem_categories` AFTER UPDATE ON `problems` FOR EACH ROW BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tag_name VARCHAR(50);
    DECLARE tag_position INT;
    DECLARE remaining_tags VARCHAR(255);
    IF NEW.tags <> OLD.tags OR (NEW.tags IS NOT NULL AND OLD.tags IS NULL) OR (NEW.tags IS NULL AND OLD.tags IS NOT NULL) THEN
        DELETE FROM problem_category_relations WHERE problem_id = NEW.id;
        IF NEW.tags IS NOT NULL AND NEW.tags <> '' THEN
            SET remaining_tags = NEW.tags;
            
            tag_loop: WHILE LENGTH(remaining_tags) > 0 DO
                SET tag_position = LOCATE(',', remaining_tags);
                
                IF tag_position > 0 THEN
                    SET tag_name = TRIM(SUBSTRING(remaining_tags, 1, tag_position - 1));
                    SET remaining_tags = SUBSTRING(remaining_tags, tag_position + 1);
                ELSE
                    SET tag_name = TRIM(remaining_tags);
                    SET remaining_tags = '';
                END IF;
                INSERT IGNORE INTO problem_category_relations (problem_id, category_id)
                SELECT NEW.id, id FROM problem_categories WHERE name = tag_name;
            END WHILE tag_loop;
        END IF;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table problems
-- ----------------------------
DROP TRIGGER IF EXISTS `insert_problem_categories`;
delimiter ;;
CREATE TRIGGER `AIreview`.`insert_problem_categories` AFTER INSERT ON `problems` FOR EACH ROW BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tag_name VARCHAR(50);
    DECLARE tag_position INT;
    DECLARE remaining_tags VARCHAR(255);
    IF NEW.tags IS NOT NULL AND NEW.tags <> '' THEN
        SET remaining_tags = NEW.tags;
        
        tag_loop: WHILE LENGTH(remaining_tags) > 0 DO
            SET tag_position = LOCATE(',', remaining_tags);
            
            IF tag_position > 0 THEN
                SET tag_name = TRIM(SUBSTRING(remaining_tags, 1, tag_position - 1));
                SET remaining_tags = SUBSTRING(remaining_tags, tag_position + 1);
            ELSE
                SET tag_name = TRIM(remaining_tags);
                SET remaining_tags = '';
            END IF;
            INSERT IGNORE INTO problem_category_relations (problem_id, category_id)
            SELECT NEW.id, id FROM problem_categories WHERE name = tag_name;
        END WHILE tag_loop;
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
