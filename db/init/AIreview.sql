/*
 Navicat Premium Dump SQL

 Source Server         : Docker下的数据库(3307)
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3307
 Source Schema         : AIreview

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 21/05/2025 15:53:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for analytics_events
-- ----------------------------
DROP TABLE IF EXISTS `analytics_events`;
CREATE TABLE `analytics_events` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `event_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `page_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `element_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `element_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timestamp` bigint NOT NULL,
  `metadata` json DEFAULT NULL,
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_analytics_events_event_type` (`event_type`),
  KEY `idx_analytics_events_user_id` (`user_id`),
  KEY `idx_analytics_events_timestamp` (`timestamp`),
  KEY `idx_analytics_events_page_name` (`page_name`)
) ENGINE=InnoDB AUTO_INCREMENT=950 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of analytics_events
-- ----------------------------
BEGIN;
COMMIT;

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
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (1, 1, 1, 'hi', '2025-03-06 17:48:31');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (2, 1, 1, 'hi', '2025-03-06 17:56:20');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (3, 1, 1, 'hi', '2025-03-06 17:58:56');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (4, 1, 1, 'hi', '2025-03-06 17:58:58');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (5, 1, 1, '你好', '2025-03-06 18:02:01');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (6, 1, 1, '1', '2025-04-23 00:18:55');
INSERT INTO `classroom_discussions` (`id`, `classroom_id`, `user_id`, `content`, `created_at`) VALUES (7, 1, 1, '2', '2025-04-23 00:22:20');
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
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (12, 1, '未命名.txt', '1e84cab125320e1c916497db5ec05c1a.txt', 15, 'txt', '2025-03-06 17:46:48');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (13, 1, '测试头像.png', '6cc347e6bb7c4b6841f8ed5b96b426bd.png', 11592, 'png', '2025-03-06 17:47:06');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (14, 1, '测试表格.xlsx', '319c7bdc36009a4113481bfcf5e2e4a3.xlsx', 9313, 'xlsx', '2025-03-06 17:47:12');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (15, 1, '测试头像PDF.pdf', '4ba56be06d58e59261e7a41b7d42c9bb.pdf', 13417, 'pdf', '2025-03-06 17:47:17');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (16, 1, '测试表格.xlsx', 'b89cc1e3f96f60e621d8129d42da90bc.xlsx', 9313, 'xlsx', '2025-03-06 17:47:29');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (17, 1, '测试word.docx', '9687d8a258e02dae0924cd0bce5708a0.docx', 10174, 'docx', '2025-03-06 17:47:35');
INSERT INTO `classroom_files` (`id`, `classroom_id`, `file_name`, `file_path`, `file_size`, `file_type`, `upload_time`) VALUES (18, 1, '测试头像4.png', 'dd5c9916fc67e50926e86dd6737d649a.png', 7537, 'png', '2025-04-23 00:18:18');
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
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (1, 1, 'JAVA的开发基础：C语言', '2025-03-06 16:12:03');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (2, 1, '这是最新的逻辑', '2025-03-06 18:16:41');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (3, 1, '新1', '2025-03-06 18:16:46');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (4, 1, '新2', '2025-03-06 18:16:48');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (5, 1, '新3', '2025-03-06 18:16:51');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (6, 1, '新4', '2025-03-06 18:16:55');
INSERT INTO `classroom_messages` (`id`, `classroom_id`, `content`, `created_at`) VALUES (7, 1, '1', '2025-04-22 22:45:46');
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
INSERT INTO `classrooms` (`id`, `classroom_code`, `teacher_id`, `title`, `description`, `status`, `created_at`, `updated_at`) VALUES (1, 'BWXHW', 1, 'JAVA', 'JAVA', 1, '2025-03-06 16:11:19', '2025-04-25 22:03:27');
COMMIT;

-- ----------------------------
-- Table structure for code_style_complexity
-- ----------------------------
DROP TABLE IF EXISTS `code_style_complexity`;
CREATE TABLE `code_style_complexity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `submission_id` int NOT NULL,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `analysis_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` int NOT NULL,
  `suggestion_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `submission_id` (`submission_id`),
  CONSTRAINT `code_style_complexity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `code_style_complexity_ibfk_2` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`id`),
  CONSTRAINT `code_style_complexity_chk_1` CHECK ((`score` between 0 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of code_style_complexity
-- ----------------------------
BEGIN;
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (1, 1, 132, '0001', '无法解析AI返回的JSON数据。原始响应: ```json\n{\n  \"analysis\": {\n    \"时间复杂度\": \"该代码包含输入和输出操作，以及一个简单的加法运算。所有操作的时间复杂度均为O(1)，因为它们不依赖于输入或输出的大小。\",\n    \"空间复杂度\": \"代码中没有使用额外的数组或数据结构，除了基本的输入输出和变量存储。因此，空间复杂度为O(1)。\",\n    \"嵌套深度\": \"代码中没有任何循环或条件语句，因此嵌套深度为0。\"\n  },\n  \"score\": 90,\n  \"suggestion\": \"由于代码非常简单，没有改进建议。代码已经是最优的。\"\n}\n```...', 67, '由于技术原因，无法提供详细分析。请重试或选择其他分析类型。', '2025-05-01 14:01:35', '2025-05-01 14:01:35');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (2, 1, 132, '0001', '{\"时间复杂度\":\"代码中的主要算法是打印字符串 \\\"Hello, World!\\\"，这是一个常数时间操作，因此时间复杂度为 O(1)。\",\"空间复杂度\":\"代码没有使用任何额外的数组或栈，所有操作都是在栈上完成的，因此空间复杂度为 O(1)。\",\"嵌套深度\":\"代码中没有循环、条件语句或其他嵌套结构，只有一个函数调用和返回语句，因此嵌套深度为 0。\"}', 100, '代码非常简洁，已经是最高效的形式。没有进一步优化的空间。', '2025-04-30 14:01:35', '2025-04-30 14:01:35');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (3, 1, 132, '0001', '{\"时间复杂度\":\"该代码的主要操作是读取两个整数并计算它们的差值，这两个操作都是O(1)时间复杂度。因此，整个程序的时间复杂度是O(1)。\",\"空间复杂度\":\"该代码没有使用额外的数组、栈或其他数据结构，它只使用了几个局部变量。因此，空间复杂度是O(1)。\",\"嵌套深度\":\"该代码中没有循环或条件语句，只有一个简单的if-else结构，但是在这个例子中可以视为没有嵌套，因为它只包含一行代码。因此，嵌套深度为0。\"}', 33, '该代码已经是最高效的，没有改进空间。', '2025-04-29 14:01:35', '2025-04-29 14:01:35');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (4, 1, 132, '0001', '{\"时间复杂度\":\"该代码的时间复杂度为O(1)，因为它只包含几个基本操作：读取两个整数和打印一个整数。这些操作的时间不会随着输入规模的增长而增长。\",\"空间复杂度\":\"该代码的空间复杂度也为O(1)，因为它只使用了固定数量的变量（a和b），不依赖于输入规模。\",\"算法选择\":\"该代码选择了一个非常简单的算法来执行减法操作。对于这个特定的问题，这是一个高效的算法，因为它直接计算两个数的差值。\",\"代码结构复杂度\":\"代码结构非常简单，只有一个main函数，没有循环、递归或复杂的条件语句。嵌套层数为0，因此代码结构复杂度也很低。\"}', 100, '该代码已经非常高效和简洁，不需要进一步的改进。', '2025-04-28 14:01:35', '2025-04-28 14:01:35');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (5, 1, 134, '0001', '{\"1. 时间复杂度\":\"该代码的时间复杂度为O(1)，因为它包含的操作都是常数时间操作，如输入和输出。没有任何循环或递归调用。\",\"2. 空间复杂度\":\"该代码的空间复杂度也为O(1)，因为它只使用了固定数量的变量，不依赖于输入大小或任何动态分配的数据结构。\",\"3. 算法选择\":\"对于简单的加法运算，代码选择了合适的算法。没有使用复杂的数据结构或算法，这是高效的。\",\"4. 代码结构复杂度\":\"代码结构非常简单，只有一个main函数，没有循环、条件语句或嵌套结构。复杂度为O(1)。\"}', 100, '代码已经非常高效和简洁，没有明显的改进空间。如果需要处理更复杂的问题，可能需要考虑增加代码的复杂度。', '2025-04-27 14:01:35', '2025-04-27 14:01:35');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (6, 1, 137, '0001', '{\"1. 时间复杂度\":\"该代码的时间复杂度为O(1)，因为它包含的操作都是常数时间的操作，即读取两个整数和打印一个整数。\",\"2. 空间复杂度\":\"该代码的空间复杂度为O(1)，因为它在运行过程中只使用了固定数量的变量，不依赖于输入大小。\",\"3. 算法选择\":\"该代码选择的算法非常适合问题，它直接计算两个整数的和并输出结果，这是最简单且最高效的方法。\",\"4. 代码结构复杂度\":\"代码结构非常简单，只有一个main函数，没有循环、条件语句或嵌套结构，结构复杂度为O(1)。\"}', 100, '代码已经非常高效和简洁，无需改进。', '2025-05-02 15:39:19', '2025-05-02 15:39:19');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (7, 1, 138, '0001', '{\"1. 时间复杂度\":\"该代码中包含的主要操作是读取两个整数和打印一个整数，这两个操作的时间复杂度都是O(1)。整个程序的时间复杂度也是O(1)，因为它只执行了固定数量的操作。\",\"2. 空间复杂度\":\"该代码的空间复杂度是O(1)，因为它使用了固定数量的变量（a和b），不依赖于输入大小或任何数据结构。\",\"3. 算法选择\":\"对于这个简单的任务，代码选择的算法是高效的。它直接读取输入并计算输出，没有使用复杂的数据结构或算法。\",\"4. 代码结构复杂度\":\"代码结构非常简单，只有一个main函数，其中包含几个基本操作。没有循环、递归或复杂的控制流结构。代码结构复杂度为O(1)。\"}', 100, '该代码已经非常高效且结构简单，无需进一步改进。', '2025-05-02 15:39:35', '2025-05-02 15:39:35');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (8, 1, 139, '0001', '{\"1. 时间复杂度\":\"该代码的时间复杂度为O(1)，因为它只执行了固定数量的操作，即读取两个整数和打印一个整数。\",\"2. 空间复杂度\":\"该代码的空间复杂度也为O(1)，因为它使用了固定数量的变量，不依赖于输入或输出的大小。\",\"3. 算法选择\":\"该代码选择了最简单的算法来解决两个整数相加的问题，这是适合问题的，并且是高效的。\",\"4. 代码结构复杂度\":\"代码结构非常简单，只有一个main函数，没有循环或复杂的条件语句，嵌套层数为0，因此结构复杂度为O(1)。\"}', 100, '该代码已经非常高效和简洁，无需改进。', '2025-05-02 23:04:35', '2025-05-02 23:04:35');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (9, 1, 140, '0001', '1. 时间复杂度: 代码中只有一个简单的算术运算，因此时间复杂度为 O(1)。\n2. 空间复杂度: 代码中没有使用额外的数据结构，只有几个变量，因此空间复杂度为 O(1)。\n3. 算法选择: 代码非常简单，直接使用了输入的值进行计算，适合问题且高效。\n4. 代码结构复杂度: 代码只有一个简单的赋值和打印操作，结构非常简单，没有嵌套，因此结构复杂度为 O(1)。', 100, '代码已经非常高效和简洁，无需改进。', '2025-05-02 23:08:45', '2025-05-02 23:08:45');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (10, 1, 141, '0018', '{\"时间复杂度\":\"代码中主要算法的时间复杂度为O(n^2)。这是因为在主循环中，外层循环执行n次，内层循环最多也执行n次。因此，总的时间复杂度为n * n，即O(n^2)。\",\"空间复杂度\":\"代码的空间复杂度为O(n^2)，因为它使用了一个二维数组triangle[30][30]来存储三角形的数值。这个数组的大小与输入的n成正比，因此空间复杂度为O(n^2)。\",\"算法选择\":\"代码中使用的算法是标准的杨辉三角算法，适合于生成杨辉三角的问题。算法本身是高效的，因为它在计算每个元素时只依赖于上一行的两个元素，没有重复计算。\",\"代码结构复杂度\":\"代码结构相对简单，包含两个嵌套的for循环和两个printf语句。没有复杂的嵌套或条件语句。\"}', 88, '代码结构已经很好，但可以考虑以下几点改进：\n- 使用动态内存分配而不是固定大小的数组，以适应更大的n值。\n- 对于输出部分，可以考虑使用动态打印，而不是先计算整个数组再打印，以减少内存占用。', '2025-05-03 13:11:39', '2025-05-03 13:11:39');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (11, 1, 142, '0018', '{\"时间复杂度\":\"该代码中的主要算法是计算三角形的每一行的数字，这是一个动态规划问题。时间复杂度为O(n^2)，其中n是输入的数字。这是因为对于每一行，有一个嵌套循环，外层循环执行n次，内层循环最多执行n次。\",\"空间复杂度\":\"代码中定义了一个二维数组triangle[30][30]，用于存储三角形的每一行。这个数组的大小是固定的，与输入的n大小无关。因此，空间复杂度为O(1)，因为数组的大小不随输入大小而变化。\",\"算法选择\":\"该代码选择了动态规划算法来计算三角形的每一行，这是一个适合该问题的算法。动态规划通常用于解决具有重叠子问题和最优子结构的问题，这正是计算三角形的每一行所需。该算法是高效的，因为它避免了重复计算。\",\"代码结构复杂度\":\"代码结构相对简单。它由三个主要的循环组成，嵌套在一个main函数中。循环的嵌套层数为2，但代码的嵌套结构并不复杂，因为它只包含简单的循环和条件语句。\"}', 88, '代码结构简单，算法选择合适，但可以考虑以下改进：\n- 在读取输入时，可以检查n是否在合理的范围内（例如，0 <= n <= 30），以避免潜在的数组越界问题。\n- 可以优化输出部分，减少不必要的空格和换行符。', '2025-05-03 13:20:32', '2025-05-03 13:20:32');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (12, 1, 143, '0001', '1. 时间复杂度: 代码中的主要算法是两个整数的加法，时间复杂度为 O(1)，因为无论输入大小如何，执行加法操作所需的时间都是常数。\n2. 空间复杂度: 代码没有使用任何额外的数据结构，除了输入的两个整数和用于存储它们的结果的变量，因此空间复杂度为 O(1)。\n3. 算法选择: 对于简单的加法操作，选择的算法是高效的，没有使用任何复杂的数据结构或算法。\n4. 代码结构复杂度: 代码非常简单，只有一个变量赋值和一个打印语句，没有循环或条件语句，结构复杂度为 O(1)。', 100, '代码已经非常高效和简洁，无需改进。', '2025-05-03 13:21:00', '2025-05-03 13:21:00');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (13, 1, 144, '0001', '{\"时间复杂度\":\"该代码的时间复杂度为O(1)，因为它包含的操作数是固定的，即读取两个整数和打印一个整数，这些操作与输入数据的大小无关。\",\"空间复杂度\":\"该代码的空间复杂度也为O(1)，因为它在运行过程中只使用了固定数量的变量，没有使用数组或动态数据结构。\",\"算法选择\":\"对于这个简单的加法问题，代码选择的算法是高效的。它直接执行了加法操作，没有使用任何复杂的算法或数据结构。\",\"代码结构复杂度\":\"代码结构非常简单，只有一个main函数，其中包含几个变量声明、输入和输出操作。没有循环、递归或复杂的控制流结构。\"}', 100, '代码已经非常高效和简洁，没有明显的改进空间。如果需要处理更复杂的问题，可以考虑增加注释或使用更复杂的控制流结构以提高代码的可读性。', '2025-05-03 13:22:19', '2025-05-03 13:22:19');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (14, 1, 145, '0001', 'The provided Java code snippet is a simple program that reads two integers from the user and prints their sum. Here is the analysis for each dimension:\n\n1. **Time Complexity**: The time complexity of this code is O(1) because it performs a constant number of operations, regardless of the input size. It reads two integers and prints their sum, which are both O(1) operations.\n\n2. **Space Complexity**: The space complexity is also O(1) as the code only uses a fixed amount of space for two integer variables and the Scanner object. There are no dynamic data structures like arrays or lists that grow with input size.\n\n3. **Algorithm Choice**: The algorithm chosen is appropriate for the problem. It is a straightforward approach to summing two numbers and printing the result. It is efficient for this specific task as there is no need for more complex algorithms.\n\n4. **Code Structure Complexity**: The code structure is very simple. It consists of a single main method with a minimal number of statements. There are no nested loops or complex control structures.\n', 100, 'The code is already optimized for its purpose. However, for readability and maintainability, it would be beneficial to include comments explaining the purpose of the code and the Scanner usage.', '2025-05-03 13:23:21', '2025-05-03 13:23:21');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (15, 1, 146, '0001', '{\"时间复杂度\":\"该代码的时间复杂度为 O(1)，因为它只执行了几个基本的操作，如读取两个整数和打印一个结果。没有循环或递归，因此操作次数与输入规模无关。\",\"空间复杂度\":\"空间复杂度也是 O(1)，因为代码中只使用了固定数量的变量（a、b 和 scanner），不依赖于输入规模。\",\"算法选择\":\"该代码选择了非常简单的算法，只用于读取两个整数并将它们的和打印出来。对于这个特定的问题，这是一个高效的选择，因为问题很简单，不需要更复杂的算法。\",\"代码结构复杂度\":\"代码结构非常简单，只有一个主函数 main，其中只有一个循环和两个变量。没有嵌套的循环或条件语句，因此结构复杂度很低。\"}', 100, '代码非常简单，没有改进的必要。如果需要处理更复杂的问题，可以考虑增加代码的复杂度和算法的选择。', '2025-05-03 13:23:41', '2025-05-03 13:23:41');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (16, 1, 147, '0002', '{\"时间复杂度\":\"该代码的时间复杂度为O(n)，其中n是输入的整数数量。代码中有一个while循环，该循环会执行n次，每次循环都会读取一个整数并与当前最大值进行比较。\",\"空间复杂度\":\"该代码的空间复杂度为O(1)，因为它只使用了固定数量的额外空间，包括一个整数变量max和一个Scanner对象。\",\"算法选择\":\"对于寻找最大值的问题，该代码选择的算法是高效的。它不需要对整个数组进行排序或多次遍历，只需一次遍历即可找到最大值。\",\"代码结构复杂度\":\"代码结构简单，只有一个while循环和一个if语句。嵌套层数为1，整体结构清晰。\"}', 95, '代码已经很高效且结构简单，没有明显的改进空间。如果需要处理更复杂的数据结构或需要额外的功能，可以考虑扩展代码的功能。', '2025-05-03 13:24:07', '2025-05-03 13:24:07');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (17, 1, 149, '0002', '{\"时间复杂度\":\"该代码的时间复杂度为O(n)，其中n为输入的整数个数。在while循环中，每次读取一个整数并与当前最大值比较，这个过程会执行n次。\",\"空间复杂度\":\"该代码的空间复杂度为O(1)，因为它只使用了固定数量的变量，不依赖于输入规模。\",\"算法选择\":\"该代码选择了简单的线性搜索算法来找到最大值，这对于单次遍历的问题来说是合适的，并且是高效的。\",\"代码结构复杂度\":\"代码结构简单，包含一个while循环和一个if语句，嵌套层数为1，整体结构简单明了。\"}', 100, '代码结构已经非常清晰和高效，没有明显的改进空间。如果需要处理大量数据或者需要优化性能，可以考虑使用并行处理或者更高效的数据结构。', '2025-05-03 13:32:25', '2025-05-03 13:32:25');
INSERT INTO `code_style_complexity` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (18, 1, 150, '0002', '{\"时间复杂度\":\"该代码的时间复杂度为O(n)，其中n是输入的数量。代码中有一个while循环，该循环执行n次，每次执行常数时间的操作（读取输入和更新最大值）。\",\"空间复杂度\":\"该代码的空间复杂度为O(1)，因为它只使用了固定数量的额外空间（变量max和Scanner对象）。\",\"算法选择\":\"对于寻找一组整数中的最大值的问题，该代码选择了一个简单直接的方法，即遍历所有输入并维护当前的最大值。这是一个适合问题的算法，因为它能够以线性时间找到最大值，这在大多数情况下是高效的。\",\"代码结构复杂度\":\"代码结构相对简单，只有一个while循环和一个if语句。没有复杂的嵌套或递归，因此代码结构复杂度较低。\"}', 90, '虽然代码已经足够高效，但可以考虑添加一些错误处理，例如检查输入是否为正整数。此外，如果输入非常大，可以考虑使用更高效的数据结构，如优先队列，但这可能会增加空间复杂度。', '2025-05-03 13:38:49', '2025-05-03 13:38:49');
COMMIT;

-- ----------------------------
-- Table structure for code_style_logic
-- ----------------------------
DROP TABLE IF EXISTS `code_style_logic`;
CREATE TABLE `code_style_logic` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `submission_id` int NOT NULL,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `analysis_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` int NOT NULL,
  `suggestion_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `submission_id` (`submission_id`),
  CONSTRAINT `code_style_logic_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `code_style_logic_ibfk_2` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`id`),
  CONSTRAINT `code_style_logic_chk_1` CHECK ((`score` between 0 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of code_style_logic
-- ----------------------------
BEGIN;
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (1, 1, 132, '0001', '该代码片段非常简单，主要逻辑如下：\n\n1. 条件判断逻辑：代码中没有条件判断语句，因此此维度评分为25分。\n2. 循环逻辑：代码中没有循环语句，因此此维度评分为25分。\n3. 函数调用逻辑：代码中调用了scanf和printf函数，参数传递正确，逻辑合理，此维度评分为25分。\n4. 代码整体逻辑连贯性：代码逻辑清晰，从输入两个整数到输出它们的和，实现了题目的要求，此维度评分为25分。\n', 75, '由于代码非常简单，没有太多改进空间。如果需要处理更复杂的逻辑，可能需要考虑增加更多的条件判断和循环语句，以及更复杂的函数调用和参数处理。', '2025-05-01 14:01:35', '2025-05-01 14:01:35');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (2, 1, 132, '0001', '该代码的逻辑连通性分析如下：\n\n1. 条件判断逻辑：代码中没有条件判断语句，因此此维度得分为25分。\n\n2. 循环逻辑：代码中没有循环语句，因此此维度得分为25分。\n\n3. 函数调用逻辑：代码中调用了scanf和printf函数，这两个函数的调用关系合理，参数传递正确，因此此维度得分为25分。\n\n4. 代码整体逻辑连贯性：代码的功能是从标准输入读取两个整数，然后输出它们的差。虽然代码简单，但整体逻辑连贯，实现清晰，因此此维度得分为25分。\n\n总分：25 + 25 + 25 + 25 = 100分', 100, '代码功能简单，没有改进空间。如果需要增加功能，例如处理更多的输入或输出，需要进一步扩展代码逻辑。', '2025-04-30 14:01:35', '2025-04-30 14:01:35');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (3, 1, 132, '0001', '该代码的逻辑连通性分析如下：\n\n1. 条件判断逻辑：代码中没有条件判断语句，因此此维度得分为25分。\n\n2. 循环逻辑：代码中没有循环语句，因此此维度得分为25分。\n\n3. 函数调用逻辑：代码中调用了scanf和printf函数，这两个函数的调用关系合理，参数传递正确，因此此维度得分为25分。\n\n4. 代码整体逻辑连贯性：代码的功能是从标准输入读取两个整数，然后输出它们的差。虽然代码简单，但整体逻辑连贯，实现清晰，因此此维度得分为25分。\n\n总分：25 + 25 + 25 + 25 = 100分', 75, '代码功能简单，没有改进空间。如果需要增加功能，例如处理更多的输入或输出，需要进一步扩展代码逻辑。', '2025-04-29 14:01:35', '2025-04-29 14:01:35');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (4, 1, 134, '0001', '该代码片段非常简单，主要包含以下逻辑：\n\n1. 条件判断逻辑：代码中没有条件判断语句，因此这部分得分为25分。\n2. 循环逻辑：代码中没有循环语句，因此这部分得分为25分。\n3. 函数调用逻辑：代码中使用了scanf和printf函数，这些函数的调用关系合理，参数传递正确，因此这部分得分为25分。\n4. 代码整体逻辑连贯性：代码从输入两个整数，计算它们的和，然后输出结果，逻辑非常清晰且连贯，因此这部分得分为25分。\n\n总结来说，代码逻辑简单直接，没有复杂的逻辑判断或循环结构，因此每个维度的得分都是满分。', 100, '对于这样的简单代码，没有特别的改进建议。如果需要处理更复杂的情况，可能需要考虑增加条件判断和循环逻辑。', '2025-04-28 14:01:35', '2025-04-28 14:01:35');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (5, 1, 137, '0001', '该代码片段的逻辑连通性分析如下:\n\n1. 条件判断逻辑:\n   - 代码中没有使用任何条件判断语句，因此不存在条件判断逻辑的合理性或边界情况处理问题。\n\n2. 循环逻辑:\n   - 代码中没有使用循环语句，因此不存在循环逻辑的评估问题。\n\n3. 函数调用逻辑:\n   - 代码中调用了`scanf`和`printf`函数，这些函数的使用是合理的，参数传递也是正确的。\n\n4. 代码整体逻辑连贯性:\n   - 代码的功能非常简单，从标准输入读取两个整数，然后计算它们的和并输出结果。整体逻辑连贯，实现清晰。\n', 75, '代码非常简单，如果需要改进，可以考虑添加错误处理逻辑，例如检查`scanf`函数的返回值以确认是否成功读取了两个整数。', '2025-05-02 15:39:13', '2025-05-02 15:39:13');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (6, 1, 138, '0001', '{\"1. 条件判断逻辑\":\"该代码中没有条件判断语句，因此无法评估条件判断逻辑的合理性。\",\"2. 循环逻辑\":\"该代码中没有循环语句，因此无法评估循环逻辑的合理性。\",\"3. 函数调用逻辑\":\"代码中调用了scanf和printf函数，这些函数用于输入输出，调用关系合理，参数传递正确。\",\"4. 代码整体逻辑连贯性\":\"代码逻辑简单，读取两个整数并输出它们的和，整体逻辑连贯，能够实现题目要求。\"}', 75, '代码逻辑简单，无需改进。如果需要处理更复杂的逻辑，可能需要考虑增加条件判断和循环语句。', '2025-05-02 15:39:29', '2025-05-02 15:39:29');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (7, 1, 139, '0001', 'The code snippet provided is very simple and lacks conditional or loop logic, which is why the scores for condition judgment logic and loop logic are both 0. The function call logic score is also 0 as there are no function calls. The main function reads two integers and prints their sum, which is a clear and straightforward task. The overall logic is coherent and achieves the task of adding two numbers. However, the code is not very robust as it does not handle invalid input or potential overflow issues. The code is also missing any comments or documentation, which would be helpful for readability and maintenance. Here is the breakdown:\n\n1. **Condition Judgment Logic:** 0/25 - No condition judgment logic is present.\n2. **Loop Logic:** 0/25 - No loop logic is present.\n3. **Function Call Logic:** 0/25 - No function calls are present.\n4. **Overall Logic Coherence:** 25/25 - The code clearly adds two numbers and prints the result.\n', 25, 'To improve the code, consider adding input validation to ensure that the user enters two integers and that the sum does not overflow. Also, adding comments to explain the purpose of the code and the logic behind it would enhance readability and maintainability.', '2025-05-02 23:04:31', '2025-05-02 23:04:31');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (8, 1, 140, '0001', '该代码片段包含一个简单的输入处理和输出操作。\n\n1. 条件判断逻辑：代码中没有条件判断语句，因此此维度得分为25分。\n\n2. 循环逻辑：代码中没有循环语句，因此此维度得分为25分。\n\n3. 函数调用逻辑：代码中使用了`map`函数，参数传递正确，但未使用函数调用，因此此维度得分为20分。\n\n4. 代码整体逻辑连贯性：代码逻辑清晰，实现了输入两个整数并输出它们的差值，但功能单一，因此此维度得分为20分。', 75, '为了提高代码的复用性和可读性，可以考虑将输入处理和计算逻辑封装成函数。', '2025-05-02 23:08:41', '2025-05-02 23:08:41');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (9, 1, 141, '0018', '{\"条件判断逻辑\":\"代码中存在一个条件判断语句，即读取用户输入的整数n，并存储在变量n中。这个条件判断逻辑是合理的，因为它确保了程序能够接收用户输入。边界情况如n为负数或超过数组大小的情况没有在代码中显式处理，但考虑到数组的初始化和循环条件，可以推断出代码能够处理n为0或1的边界情况。\",\"循环逻辑\":\"代码中有两个嵌套循环。外层循环负责遍历行，内层循环负责计算三角形的每个元素。循环条件和循环体的逻辑是正确的，它们按照组合数学中的杨辉三角规则计算元素值。\",\"函数调用逻辑\":\"代码中没有使用任何函数调用，因此这一维度不适用。\",\"代码整体逻辑连贯性\":\"代码整体逻辑连贯，能够清晰地实现打印杨辉三角的功能。从读取输入到初始化数组，再到填充和打印数组，每个步骤都有明确的逻辑关系。\"}', 95, '尽管代码逻辑正确，但以下是一些可能的改进建议：\n- 对于用户输入，可以添加检查以确保n是一个非负整数，并且不超过数组的大小限制。\n- 可以考虑使用动态内存分配来创建一个大小为n的二维数组，这样就不需要预设数组大小为30x30。\n- 可以添加注释来解释代码中的每个步骤，提高代码的可读性。', '2025-05-03 13:11:28', '2025-05-03 13:11:28');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (10, 1, 142, '0018', '该代码是一个计算杨辉三角的简单程序。以下是针对四个维度的分析：\n\n1. 条件判断逻辑：代码中有一个条件判断语句 `if(j == i)`，用于控制打印最后一个数字时不加空格。这个条件判断逻辑是合理的，能够正确处理边界情况，因为当索引j等于索引i时，说明是行尾，不需要加空格。\n\n2. 循环逻辑：外层循环用于遍历行，内层循环用于遍历列。循环条件和循环体的逻辑都是正确的。外层循环确保了遍历了所有行，内层循环确保了每一行中的数字都是按照杨辉三角的规则计算的。\n\n3. 函数调用逻辑：代码中没有函数调用，只有主函数 `main()`。因此，这一维度不适用。\n\n4. 代码整体逻辑连贯性：代码整体逻辑连贯，从输入行数n开始，通过两层循环构建杨辉三角，然后按照特定格式输出。各个部分之间的逻辑关系清晰，实现了题目的要求。\n', 95, '虽然代码已经很好地实现了要求，但可以考虑添加注释来提高代码的可读性。例如，在循环体内添加说明杨辉三角计算规则的注释。', '2025-05-03 13:20:24', '2025-05-03 13:20:24');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (11, 1, 143, '0001', '该代码片段包含一个简单的逻辑，它读取用户输入的两个整数，并将它们相加打印出来。\n\n1. 条件判断逻辑：代码中没有条件判断语句，因此这一维度得分为25分。\n2. 循环逻辑：代码中没有循环语句，因此这一维度得分为25分。\n3. 函数调用逻辑：代码中使用了map和int函数，这些函数调用合理且参数传递正确，因此这一维度得分为25分。\n4. 代码整体逻辑连贯性：代码的逻辑非常简单直接，从读取输入到计算和输出结果，逻辑连贯，因此这一维度得分为25分。', 75, '由于代码非常简单，改进空间有限。如果需要改进，可以考虑增加错误处理，例如检查输入是否为整数，或者处理非预期输入的情况。', '2025-05-03 13:20:54', '2025-05-03 13:20:54');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (12, 1, 145, '0001', '该代码的逻辑连通性分析如下：\n\n1. 条件判断逻辑：代码中没有条件判断语句，因此这一维度得分为25分。\n\n2. 循环逻辑：代码中没有循环语句，因此这一维度得分为25分。\n\n3. 函数调用逻辑：代码中调用了Scanner类的nextInt()方法和System.out.println()方法，这些调用是合理的，参数传递也是正确的，因此这一维度得分为25分。\n\n4. 代码整体逻辑连贯性：代码从读取两个整数输入到计算它们的和并输出，逻辑连贯，实现清晰，因此这一维度得分为25分。\n\n总分：25 + 25 + 25 + 25 = 100分', 100, '代码逻辑已经非常清晰和合理，无需改进。', '2025-05-03 13:23:13', '2025-05-03 13:23:13');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (13, 1, 146, '0001', '{\"条件判断逻辑\":\"该代码段中没有条件判断语句，因此无法评估条件判断逻辑的合理性。\",\"循环逻辑\":\"该代码段中没有循环语句，因此无法评估循环逻辑的合理性。\",\"函数调用逻辑\":\"代码中调用了Scanner类的nextInt()方法和System.out.println()方法，这些调用在逻辑上是合理的，参数传递也是正确的。\",\"代码整体逻辑连贯性\":\"代码整体逻辑连贯，从读取两个整数到计算它们的和，最后输出结果，逻辑上是一致的。\"}', 75, '虽然代码逻辑上没有问题，但可以考虑以下几点改进：\n- 添加异常处理，以处理用户输入非整数的情况。\n- 在输出结果之前，可以添加一些描述性文本，以增强用户体验。', '2025-05-03 13:23:32', '2025-05-03 13:23:32');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (14, 1, 147, '0002', 'The code is designed to find the maximum number from a series of integers input by the user. The analysis of the four dimensions is as follows:\n\n1. **Condition Judgment Logic**: The condition `while(n-- > 0)` is used to iterate through the input numbers. This condition is appropriate as it will continue to loop until `n` is decremented to 0, ensuring that all input numbers are processed. The condition handles the boundary case where there are no numbers to process (i.e., `n` is initially 0) correctly by not entering the loop. The `Math.max` function is used to compare and update the maximum value, which is a reasonable choice for this task.\n\n2. **Loop Logic**: The loop is used correctly to process each input number and update the maximum value. The loop condition ensures that the loop will terminate after the last number is processed. The loop body contains only one statement, which is updating the maximum value, making the logic straightforward and easy to follow.\n\n3. **Function Call Logic**: The code makes use of the `Math.max` function to compare and update the maximum value. The parameters passed to the function are correct and the function is used appropriately. There are no other function calls in the code.\n\n4. **Overall Logic Coherence**: The code is straightforward and its logic is easy to follow. It starts by reading the number of integers to be processed, then iterates through the input numbers to find the maximum, and finally prints the result. The code is clear in its purpose and the logic is coherent throughout.\n', 100, 'The code is already well-structured and efficient for its purpose. However, if the requirement were to handle negative numbers differently or to provide more user feedback, additional logic could be added. For example, adding a check for the first input number to handle the case where all numbers are the same or to handle an empty input could be considered.', '2025-05-03 13:24:01', '2025-05-03 13:24:01');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (15, 1, 149, '0002', 'The provided Java code is designed to find the maximum integer from a series of integers input by the user. The code has the following logical components:\n\n1. **Condition Judgment Logic**: The code uses a while loop to continuously read integers until the user inputs 0, which is the condition to terminate the loop. This condition is reasonable as it allows the user to define the end of input. The condition is also clear and straightforward, ensuring that the code can handle various boundary cases such as a single integer input or a series of integers.\n\n2. **Loop Logic**: The while loop is used to read integers one by one until the user inputs 0. The loop condition `n-- > 0` is logical and correctly decrements the value of `n` after each iteration. The loop body only contains a single statement updating the `max` variable, which is efficient. However, the loop does not handle the case where the user inputs negative numbers before reaching 0, which could potentially lead to incorrect results if `max` is updated before the first non-negative integer is encountered.\n\n3. **Function Call Logic**: The code does not call any external functions, but it does use the `Math.max` method within the loop. This method is used correctly to update the `max` variable with the maximum value seen so far. The parameters passed to `Math.max` are correct and appropriate.\n\n4. **Overall Logic Coherence**: The code is straightforward and coherent. It reads a series of integers, keeps track of the maximum value, and outputs it. The logic is clear, and the code follows a linear flow without any unnecessary complexity or ambiguity.\n', 95, 'While the code is well-structured, consider adding input validation to handle cases where the user inputs negative numbers before reaching 0. This could be done by checking the input condition within the loop and resetting `max` to the current input if it is negative.', '2025-05-03 13:32:19', '2025-05-03 13:32:19');
INSERT INTO `code_style_logic` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (16, 1, 150, '0002', 'The code is designed to find the maximum integer from a sequence of integers provided by the user. Here\'s the analysis for each dimension:\n\n1. **Condition Judgment Logic**: The code contains a single condition judgment logic within the while loop. The condition `n-- > 0` is used to ensure that the loop runs the correct number of times, decrementing `n` each time. This is a reasonable condition as it guarantees that the loop will terminate after `n` iterations. The boundary case where `n` is 0 is handled correctly, as the loop will not execute and the program will proceed to print the current maximum value.\n\n2. **Loop Logic**: The loop is used to read `n` integers from the user. The loop continues as long as `n` is greater than 0, and it decrements `n` each iteration. This is a reasonable use of a loop to process a sequence of inputs. The loop condition and body logic are correct.\n\n3. **Function Call Logic**: The code uses the `Math.max()` function to find the maximum value between the current maximum and the next integer read from the scanner. The function is called correctly with two integer arguments. There are no other function calls in the code, which is appropriate for this simple task.\n\n4. **Overall Logic Coherence**: The code is straightforward and achieves its goal of finding the maximum integer in a sequence. The logic is clear and the code is easy to follow. The sequence of operations from reading the input to finding and printing the maximum value is logically coherent.\n', 100, 'The code is already well-structured and efficient for its purpose. No suggestions for improvement are necessary.', '2025-05-03 13:38:43', '2025-05-03 13:38:43');
COMMIT;

-- ----------------------------
-- Table structure for code_style_naming
-- ----------------------------
DROP TABLE IF EXISTS `code_style_naming`;
CREATE TABLE `code_style_naming` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `submission_id` int NOT NULL,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `analysis_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` int NOT NULL,
  `suggestion_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `submission_id` (`submission_id`),
  CONSTRAINT `code_style_naming_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `code_style_naming_ibfk_2` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`id`),
  CONSTRAINT `code_style_naming_chk_1` CHECK ((`score` between 0 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of code_style_naming
-- ----------------------------
BEGIN;
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (1, 1, 132, '0001', '### 变量命名规则遵循度\n变量命名遵循了驼峰命名法（camelCase），这是C语言中常见的变量命名规范。\n\n### 变量命名表意性\n变量`a`和`b`仅用来表示输入的两个整数，命名较为简单，但不具有很强的表意性，可以考虑使用更具描述性的名称。\n\n### 函数命名规范性\n函数`main`是C语言的入口函数，命名符合规范，能够准确描述其作为程序入口点的功能。\n\n### 命名一致性\n代码中变量名和函数名的大小写使用一致，符合驼峰命名法。\n', 75, '### 改进建议\n- 变量命名：考虑使用更具描述性的名称，例如将`a`和`b`改为`firstNumber`和`secondNumber`，这样更能反映其作为输入整数的用途。\n', '2025-05-01 14:01:35', '2025-05-01 14:01:35');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (2, 1, 132, '0001', '变量命名：变量 `a` 和 `b` 遵循了驼峰命名法（camelCase），命名规范。变量命名表意性方面，`a` 和 `b` 未能明确表达其用途，仅能看出它们可能是整数类型。函数命名：`main` 函数符合C语言规范，是程序的入口函数，命名准确描述了其功能。命名一致性：代码中变量名、函数名大小写使用一致，命名风格一致。', 80, '对于变量 `a` 和 `b`，可以考虑增加前缀或后缀来明确它们的用途，例如 `firstNumber` 和 `secondNumber`。这样可以在不查看代码内部的情况下，更好地理解它们的含义。', '2025-04-30 14:01:35', '2025-04-30 14:01:35');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (3, 1, 132, '0001', '变量命名：变量 `a` 和 `b` 遵循了驼峰命名法（camelCase），命名规范。变量命名表意性方面，`a` 和 `b` 未能明确表达其用途，仅能看出它们可能是整数类型。函数命名：`main` 函数符合C语言规范，是程序的入口函数，命名准确描述了其功能。命名一致性：代码中变量名、函数名大小写使用一致，命名风格一致。', 75, '对于变量 `a` 和 `b`，可以考虑增加前缀或后缀来明确它们的用途，例如 `firstNumber` 和 `secondNumber`。这样可以在不查看代码内部的情况下，更好地理解它们的含义。', '2025-04-29 14:01:35', '2025-04-29 14:01:35');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (4, 1, 134, '0001', '变量命名规范性分析:\n\n1. 变量命名规则遵循度：代码中的变量a和b遵循了驼峰命名法（camelCase），符合常见的命名规则，得分25分。\n\n2. 变量命名表意性：变量a和b分别代表两个整数输入，命名具有一定的表意性，得分20分。\n\n3. 函数命名规范性：main函数是C语言的入口函数，命名规范，得分25分。\n\n4. 命名一致性：代码中变量名和函数名的大小写一致，命名保持了一致性，得分25分。\n\n总分：95分', 95, '代码中的变量命名已经非常规范，没有明显的改进空间。如果需要进一步优化，可以考虑增加一些注释来解释变量和函数的具体用途，以增强代码的可读性。', '2025-04-28 14:01:35', '2025-04-28 14:01:35');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (5, 1, 137, '0001', '变量命名规范性分析:\n\n1. 变量命名规则遵循度：代码中的变量\'a\'和\'b\'遵循了驼峰命名法（camelCase），这是常见的命名规则，因此得分较高。\n\n2. 变量命名表意性：变量\'a\'和\'b\'分别表示两个整数输入，命名具有一定的表意性，但不够具体，可以进一步改进。\n\n3. 函数命名规范性：函数\'main\'是标准的C语言程序入口函数，命名符合规范，得分较高。\n\n4. 命名一致性：代码中变量名和函数名的大小写使用一致，命名一致性良好。\n', 90, '为了提高代码的可读性和可维护性，建议对变量\'a\'和\'b\'的命名进行改进，使其更具体地描述变量的用途，例如使用\'aNumber\'和\'bNumber\'。', '2025-05-02 15:39:07', '2025-05-02 15:39:07');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (6, 1, 138, '0001', '详细分析文本，使用Markdown格式\n\n## 变量命名规则遵循度\n变量命名使用了驼峰命名法（camelCase），例如 `a` 和 `b`，符合常见的命名规则。\n\n## 变量命名表意性\n变量 `a` 和 `b` 虽然使用了驼峰命名法，但没有表达其用途和含义，无法直接从变量名了解其代表的是两个整数。\n\n## 函数命名规范性\n函数 `main` 是程序的入口点，命名符合规范，且准确描述了函数的功能。\n\n## 命名一致性\n代码中变量名和函数名的大小写使用一致，符合命名一致性要求。\n', 65, '改进建议，使用Markdown格式\n\n* 变量命名应增加表意性，例如将 `a` 和 `b` 改为 `firstNumber` 和 `secondNumber`，以更清晰地表达其代表的含义。\n* 可以考虑在注释中说明变量的用途，以便于阅读和维护代码。', '2025-05-02 15:39:24', '2025-05-02 15:39:24');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (7, 1, 139, '0001', '代码中的变量命名规范性分析如下：\n\n1. 变量命名规则遵循度：变量 `a` 和 `b` 使用了驼峰命名法（camelCase），符合常见的命名规则，得分为25分。\n2. 变量命名表意性：变量 `a` 和 `b` 的命名较为直观，但未明确指出它们代表的数值类型或具体用途，得分为20分。\n3. 函数命名规范性：`main` 函数的命名符合C语言的标准，准确描述了它是程序的入口点，得分为25分。\n4. 命名一致性：代码中变量名和函数名的大小写使用一致，得分为25分。\n\n总分：95分', 95, '为了提高代码的可读性和可维护性，建议对变量 `a` 和 `b` 的命名进行改进，使其更具体地反映它们的用途，例如使用 `num1` 和 `num2` 来代替 `a` 和 `b`。', '2025-05-02 23:04:26', '2025-05-02 23:04:26');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (8, 1, 140, '0001', '1. 变量命名规则遵循度：代码中的变量a和b都遵循了驼峰命名法（camelCase），符合常见的Python变量命名规则。\n2. 变量命名表意性：变量a和b直接反映了它们的作用，即接受输入的两个整数。\n3. 函数命名规范性：代码中没有使用函数，因此这一维度不适用。\n4. 命名一致性：代码中变量名和函数名的大小写使用一致，符合Python的命名规范。', 75, '由于代码中没有使用函数，函数命名规范性这一维度不适用。建议在需要使用函数时，使用清晰且描述性的函数名，例如将print(a - b)的部分封装成一个函数，命名为print_difference(a, b)以提高代码的可读性和可维护性。', '2025-05-02 23:08:38', '2025-05-02 23:08:38');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (9, 1, 141, '0018', '1. 变量命名规则遵循度：变量命名基本遵循驼峰命名法，例如n、triangle。这符合常见的命名规则，得分为25分。\n2. 变量命名表意性：变量n表示三角形的行数，triangle表示一个二维数组，命名清晰，得分为25分。\n3. 函数命名规范性：main函数是C语言的入口函数，命名符合规范，得分为25分。\n4. 命名一致性：代码中变量名、函数名的大小写使用一致，得分为25分。', 100, '代码中的变量和函数命名已经非常规范，无需改进。', '2025-05-03 13:11:19', '2025-05-03 13:11:19');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (10, 1, 142, '0018', '1. 变量命名规则遵循度：变量名遵循了驼峰命名法，例如 `n`、`triangle`，符合常见的命名规则，得分25分。\n2. 变量命名表意性：变量名 `n` 表示用户输入的数字，`triangle` 表示三角形的数值数组，表意清晰，得分25分。\n3. 函数命名规范性：函数 `main` 是标准的程序入口函数，命名准确，得分25分。\n4. 命名一致性：代码中变量名、函数名的大小写使用一致，得分25分。', 100, '代码中的变量和函数命名规范，无需改进。', '2025-05-03 13:20:16', '2025-05-03 13:20:16');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (11, 1, 143, '0001', '该代码段中的变量命名规范性分析如下：\n\n1. 变量命名规则遵循度：代码中使用了基本的变量命名，变量a和b都遵循了驼峰命名法（camelCase），这是Python中常见的命名规范，得分25分。\n2. 变量命名表意性：变量a和b没有明确的意义，仅从命名上看不出它们的具体用途，得分15分。\n3. 函数命名规范性：代码中没有使用函数，得分25分。\n4. 命名一致性：代码中的变量和函数命名在大小写和缩写上保持一致，得分25分。\n\n总分：80分', 80, '为了提高代码的可读性和可维护性，建议对变量进行更具有描述性的命名，例如将变量a和b命名为\'num1\'和\'num2\'，以表示它们是两个输入数字。', '2025-05-03 13:20:47', '2025-05-03 13:20:47');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (12, 1, 144, '0001', '{\"变量命名规则遵循度\":\"变量a和b遵循了驼峰命名法（camelCase），这是C++中常见的命名规则，满分25分。\",\"变量命名表意性\":\"变量a和b直接使用a和b命名，虽然不够表意，但在这种简单的情况下可以接受，满分20分。\",\"函数命名规范性\":\"main函数是C++程序的入口点，命名符合规范，满分25分。\",\"命名一致性\":\"代码中变量名和函数名的大小写一致，命名保持一致，满分25分。\"}', 90, '为了提高代码的可读性和可维护性，建议对变量进行更具体的命名，例如将a和b命名为number1和number2，以更清晰地表达它们的用途。', '2025-05-03 13:22:06', '2025-05-03 13:22:06');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (13, 1, 145, '0001', '代码中的变量命名规范如下：\n\n1. 变量命名规则遵循度：变量命名遵循驼峰命名法（camelCase），如`scanner`、`a`、`b`，符合常见的命名规则，得分为25分。\n2. 变量命名表意性：变量名`scanner`表示扫描器，`a`和`b`表示两个整数输入，能够清晰表达其用途和含义，得分为25分。\n3. 函数命名规范性：`main`函数命名规范，是Java中的主函数标准命名，能够准确描述函数的功能，得分为25分。\n4. 命名一致性：代码中变量名、函数名的大小写和缩写使用一致，得分为25分。\n\n总分：25 + 25 + 25 + 25 = 100分。', 100, '代码中的变量和函数命名已经非常规范，无需改进。', '2025-05-03 13:23:06', '2025-05-03 13:23:06');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (14, 1, 146, '0001', '1. 变量命名规则遵循度：变量命名遵循驼峰命名法（camelCase），符合Java的命名规范，得分为25分。\n2. 变量命名表意性：变量a和b分别表示用户输入的两个整数，命名清晰，得分为25分。\n3. 函数命名规范性：main函数是Java程序的入口，命名规范，得分为25分。\n4. 命名一致性：代码中变量名、函数名的大小写、缩写等保持一致，得分为25分。', 100, '代码命名规范，无需改进。', '2025-05-03 13:23:26', '2025-05-03 13:23:26');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (15, 1, 147, '0002', '1. 变量命名规则遵循度：变量命名遵循驼峰命名法（camelCase），例如`sc`、`n`、`max`，符合Java的命名规范，得分为25分。\n2. 变量命名表意性：变量`sc`表示Scanner对象，`n`表示输入的整数个数，`max`表示最大值，命名清晰，得分为25分。\n3. 函数命名规范性：函数`main`是Java程序的入口点，命名规范，得分为25分。\n4. 命名一致性：代码中变量名、函数名的大小写和缩写一致，得分为25分。', 100, '代码的变量命名和函数命名已经非常规范，无需改进。', '2025-05-03 13:23:48', '2025-05-03 13:23:48');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (16, 1, 148, '0002', '{\"变量命名规则遵循度\":\"变量命名遵循驼峰命名法，如`sc`、`n`、`max`等，符合Java中的命名规范。\",\"变量命名表意性\":\"变量命名具有一定的表意性，如`sc`表示扫描器，`n`表示输入的次数，`max`表示最大值。\",\"函数命名规范性\":\"函数命名符合规范，`main`是Java程序的入口点，命名准确。\",\"命名一致性\":\"代码中变量名、函数名的大小写、缩写等保持一致。\"}', 95, '尽管代码的变量和函数命名已经非常规范，但可以考虑在变量命名中加入一些描述性的词语，如将`max`改为`maxValue`，以进一步增强代码的可读性。', '2025-05-03 13:31:18', '2025-05-03 13:31:18');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (17, 1, 149, '0002', '1. 变量命名规则遵循度：代码中的变量命名遵循了驼峰命名法（camelCase），例如`sc`、`n`、`max`，符合常见的命名规则，得分25分。\n2. 变量命名表意性：变量`sc`表示Scanner对象，`n`表示输入的次数，`max`表示最大值，命名清晰且表意明确，得分25分。\n3. 函数命名规范性：函数`main`是Java程序的入口，命名规范且能准确描述其功能，得分25分。\n4. 命名一致性：代码中的变量名、函数名大小写和缩写使用一致，得分25分。', 100, '代码的命名规范性和表意性都很好，无需改进。', '2025-05-03 13:32:06', '2025-05-03 13:32:06');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (18, 1, 150, '0002', '详细分析文本，使用Markdown格式\n### 变量命名规则遵循度\n代码中的变量命名遵循了驼峰命名法（camelCase），例如 `sc`、`n` 和 `max`，这是Java中常用的命名规范，所以在这方面的得分是25分。\n\n### 变量命名表意性\n变量名 `sc` 表示扫描器，`n` 表示输入的次数，`max` 表示最大值，这些变量名都能清晰地表达其用途和含义，因此在这方面的得分也是25分。\n\n### 函数命名规范性\n代码中只有一个函数 `main`，它是Java程序的入口点，命名是规范的，并且准确描述了函数的功能，所以在这方面的得分是25分。\n\n### 命名一致性\n代码中变量名和函数名的大小写使用一致，没有出现大小写不一致或缩写不一致的情况，所以在这方面的得分也是25分。', 75, '代码中的变量和函数命名已经非常规范，没有明显的改进空间。如果要在变量命名上进一步提升，可以考虑为常量使用全大写字母和下划线分隔的命名方式，如 `MAX_VALUE`，以区分常量和变量。', '2025-05-03 13:38:31', '2025-05-03 13:38:31');
INSERT INTO `code_style_naming` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (19, 1, 151, '0002', '1. 变量命名规则遵循度：变量命名遵循了驼峰命名法（camelCase），例如`sc`、`n`、`max`，符合常见的命名规则，得分25分。\n2. 变量命名表意性：变量`sc`表示Scanner对象，`n`表示输入的次数，`max`表示最大值，命名清晰表达其用途和含义，得分25分。\n3. 函数命名规范性：函数`main`是Java程序的入口点，命名规范且准确描述了函数的功能，得分25分。\n4. 命名一致性：代码中变量名、函数名的大小写和缩写保持一致，得分25分。', 100, '代码的变量和函数命名已经非常规范，无需改进。', '2025-05-03 13:46:04', '2025-05-03 13:46:04');
COMMIT;

-- ----------------------------
-- Table structure for code_style_readability
-- ----------------------------
DROP TABLE IF EXISTS `code_style_readability`;
CREATE TABLE `code_style_readability` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `submission_id` int NOT NULL,
  `problem_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `analysis_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` int NOT NULL,
  `suggestion_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `submission_id` (`submission_id`),
  CONSTRAINT `code_style_readability_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `code_style_readability_ibfk_2` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`id`),
  CONSTRAINT `code_style_readability_chk_1` CHECK ((`score` between 0 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of code_style_readability
-- ----------------------------
BEGIN;
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (1, 1, 132, '0001', '该代码的可读性分析如下：\n\n1. 注释完整性：代码中没有注释，这不利于理解代码的功能和逻辑。对于简单的代码段，注释可能不是必需的，但对于复杂的逻辑或者重要的功能实现，注释是非常必要的。\n\n2. 代码布局：代码的缩进和换行都符合C语言的规范，代码结构清晰，易于阅读。\n\n3. 函数和类设计：代码中只有一个main函数，命名清晰，功能单一，即从标准输入读取两个整数并输出它们的和。由于代码非常简单，没有使用类，因此这一维度评价为满分。', 20, '建议添加必要的注释，以解释代码的功能和逻辑，提高代码的可维护性和可读性。', '2025-05-01 14:01:35', '2025-05-01 14:01:35');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (2, 1, 132, '0001', '{\"注释完整性\":\"代码中没有注释，对于非显而易见的逻辑或函数功能缺乏解释。\",\"代码布局\":\"代码缩进和换行规范，易于阅读。\",\"函数和类设计\":\"代码中没有使用函数或类，无法评估这一维度。\",\"代码简洁性\":\"代码简洁，逻辑简单明了，没有不必要的复杂性。\"}', 60, '建议添加必要的注释，以解释代码的功能和逻辑，提高代码的可维护性和可读性。', '2025-04-30 14:01:35', '2025-04-30 14:01:35');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (3, 1, 132, '0001', '{\"注释完整性\":\"代码中没有注释，对于非显而易见的逻辑或函数功能缺乏解释。\",\"代码布局\":\"代码缩进和换行规范，易于阅读。\",\"函数和类设计\":\"代码中没有使用函数或类，无法评估这一维度。\",\"代码简洁性\":\"代码简洁，逻辑简单明了，没有不必要的复杂性。\"}', 50, '为了提高代码的可读性和可维护性，建议添加注释来解释关键逻辑和函数功能。', '2025-04-29 14:01:35', '2025-04-29 14:01:35');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (4, 1, 134, '0001', '{\"注释完整性\":\"代码中缺少必要的注释，没有解释变量用途、函数功能以及关键逻辑。\",\"代码布局\":\"代码布局规范，缩进和换行使用得当，易于阅读。\",\"函数和类设计\":\"代码中只有一个main函数，命名清晰，功能单一，即读取两个整数并输出它们的和。\",\"代码简洁性\":\"代码简洁，没有不必要的复杂性，直接实现了功能。\"}', 60, '为了提高代码的可读性和可维护性，建议添加注释来解释代码的功能和逻辑。', '2025-04-28 14:01:35', '2025-04-28 14:01:35');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (5, 1, 137, '0001', 'The code provided is a simple C program that reads two integers from the standard input and prints their sum to the standard output. The analysis is as follows:\n\n1. **Comment Integrity**: The code lacks comments. There are no explanations of the purpose of the program, the variables used, or the logic behind the code. This makes it difficult for someone unfamiliar with the code to understand its functionality.\n\n2. **Code Layout**: The code has proper indentation and uses consistent spacing, which is good for readability. However, the use of the `INT` type instead of `int` could be considered a minor layout issue as it is not standard practice.\n\n3. **Function and Class Design**: The code only contains a `main` function, which is the entry point of a C program. The function is named correctly, but it does not have any parameters or return values other than the required `int`. There are no classes in this code.\n\n4. **Code Simplicity**: The code is very simple and straightforward. It does not have any unnecessary complexity. However, it could be considered less simple due to the lack of error checking or input validation.\n', 40, 'To improve the code, add comments explaining the purpose of the program, the variables, and the logic. Use standard variable and function names. Consider adding error checking and input validation to make the program more robust.', '2025-05-02 15:39:29', '2025-05-02 15:39:29');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (6, 1, 139, '0001', '{\"注释完整性\":\"代码中缺少必要的注释。没有解释scanf和printf函数的作用，也没有说明变量的用途。\",\"代码布局\":\"代码布局规范，使用了适当的缩进和换行，易于阅读。\",\"函数和类设计\":\"代码中只有一个main函数，命名清晰，功能单一，即读取两个整数并输出它们的和。\",\"代码简洁性\":\"代码简洁明了，没有不必要的复杂性，但可以进一步优化，例如使用常量或宏定义代替硬编码的数字。\"}', 45, '增加注释以解释代码的功能和逻辑，提高代码的可读性和可维护性。考虑使用宏定义或常量来代替硬编码的数字，使代码更加灵活和易于修改。', '2025-05-02 23:04:40', '2025-05-02 23:04:40');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (7, 1, 140, '0001', 'The provided code snippet is a simple Python program that reads two integers from the standard input, computes their difference, and prints the result. Here are the assessments for the four dimensions:\n\n1. **Comment Integrity (0/25)**: There are no comments in the code. It\'s a single-line script with no complex logic, so comments are not strictly necessary. However, for readability and maintainability, it would be beneficial to add a brief comment explaining the purpose of the program.\n\n2. **Code Layout (24/25)**: The code is well-formatted with proper indentation and a single line per statement. It would be a minor improvement to add a newline after the `input()` function call to make the print statement more visually distinct.\n\n3. **Function and Class Design (21/25)**: The code does not contain any functions or classes, so this dimension is not applicable. However, if the code were to include functions or classes, it would be important to name them clearly and ensure that they have a single responsibility.\n\n4. **Code Simplicity (24/25)**: The code is straightforward and performs a single task efficiently. It is not overly complex, but it lacks the use of functions or variables to make the code more flexible or reusable. Adding a function to encapsulate the logic could be a step towards improving simplicity.\n', 69, 'To enhance the code, consider the following suggestions:\n\n- Add a comment to describe the program\'s functionality.\n- Use a function to encapsulate the logic, which could make the code more modular and reusable.\n- Add a newline after the `input()` function call to improve readability.', '2025-05-02 23:08:52', '2025-05-02 23:08:52');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (8, 1, 141, '0018', '{\"注释完整性\":\"代码中缺少必要的注释，没有解释变量n的作用，没有说明三角形的性质以及如何填充数组triangle，也没有解释打印输出的目的。\",\"代码布局\":\"代码缩进和换行规范，易于阅读。\",\"函数和类设计\":\"代码中没有使用函数和类，因此这一维度不适用。\",\"代码简洁性\":\"代码简洁，逻辑清晰，没有不必要的复杂性。\"}', 60, '建议添加注释，解释代码中的关键部分，如变量n的作用、三角形的性质、数组的填充逻辑以及打印输出的目的。', '2025-05-03 13:11:44', '2025-05-03 13:11:44');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (9, 1, 142, '0018', '{\"注释完整性\":\"代码中缺少必要的注释，没有解释变量、数组和循环的作用，以及函数的功能。这使得代码的可读性大大降低。\",\"代码布局\":\"代码的缩进和换行使用得很好，易于阅读。\",\"函数和类设计\":\"代码中只有一个main函数，命名清晰，功能单一，没有使用类。\",\"代码简洁性\":\"代码相对简洁，但可以进一步优化，例如使用动态数组而不是静态数组来减少内存浪费。\"}', 60, '增加必要的注释来解释代码逻辑和变量用途。考虑使用动态数组以减少内存使用。', '2025-05-03 13:20:38', '2025-05-03 13:20:38');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (10, 1, 143, '0001', 'The code provided is a simple Python script that reads two integers from standard input, adds them together, and prints the result. Here\'s the analysis based on the four dimensions:\n\n1. **Comment Integrity**: The code lacks comments, which makes it hard for someone unfamiliar with the code to understand its purpose and functionality. Comments explaining the logic behind reading input, converting it to integers, adding them, and printing the result would be beneficial.\n\n2. **Code Layout**: The code is well-formatted with proper indentation and spacing, making it easy to read. The use of clear variable names and a single print statement contributes to its readability.\n\n3. **Function and Class Design**: The code does not contain any functions or classes. However, the main logic is encapsulated in a single expression, which is straightforward and easy to understand. There are no complex structures that could benefit from being broken down into functions or classes.\n\n4. **Code Simplicity**: The code is concise and straightforward. It performs a single task without any unnecessary complexity. However, adding comments to explain the steps would enhance its simplicity for new users.\n', 75, 'To improve the code, consider adding comments to explain the purpose of each step. This will make the code more accessible to others and maintainable in the future.', '2025-05-03 13:21:09', '2025-05-03 13:21:09');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (11, 1, 145, '0001', '{\"注释完整性\":\"代码中缺少必要的注释，没有解释变量用途、函数功能和关键逻辑，这使得代码难以理解。\",\"代码布局\":\"代码的缩进和换行规范，易于阅读。\",\"函数和类设计\":\"代码只包含一个main函数，命名清晰，功能单一，即读取两个整数并输出它们的和。\",\"代码简洁性\":\"代码简洁明了，没有不必要的复杂性，但缺少了异常处理和资源关闭的逻辑。\"}', 60, '建议添加注释来解释代码逻辑和功能，同时考虑异常处理和资源管理，以提高代码的健壮性和可维护性。', '2025-05-03 13:23:25', '2025-05-03 13:23:25');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (12, 1, 146, '0001', '{\"注释完整性\":\"代码中没有注释，无法了解函数和代码块的作用，使得可读性大大降低。\",\"代码布局\":\"代码缩进和换行符合Java规范，易于阅读。\",\"函数和类设计\":\"代码中只有一个main函数，命名清晰，功能单一，明确。\",\"代码简洁性\":\"代码简洁，没有不必要的复杂性，但缺少注释使得理解逻辑变得困难。\"}', 40, '添加必要的注释来解释代码的功能和逻辑，提高代码的可读性。', '2025-05-03 13:23:45', '2025-05-03 13:23:45');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (13, 1, 147, '0002', '{\"注释完整性\":\"代码中没有注释，这使得理解代码逻辑和函数功能变得困难。\",\"代码布局\":\"代码缩进和换行规范，易于阅读。\",\"函数和类设计\":\"类和函数命名清晰，功能单一明确。\",\"代码简洁性\":\"代码简洁明了，没有不必要的复杂性。\"}', 75, '尽管代码布局和设计良好，但添加必要的注释将大大提高代码的可读性和可维护性。', '2025-05-03 13:24:13', '2025-05-03 13:24:13');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (14, 1, 149, '0002', '该代码的可读性如下：\n\n1. 注释完整性：代码中几乎没有注释，关键逻辑如变量max的作用和while循环的功能没有解释，使得新读者难以理解代码的工作原理。\n2. 代码布局：代码缩进和换行使用得当，逻辑结构清晰，易于阅读。\n3. 函数和类设计：类名Solution和main函数的命名较为清晰，功能单一明确。\n4. 代码简洁性：代码非常简洁，没有不必要的复杂性，逻辑直接且高效。', 55, '为了提高代码的可读性，建议添加必要的注释来解释关键逻辑和变量作用。', '2025-05-03 13:32:30', '2025-05-03 13:32:30');
INSERT INTO `code_style_readability` (`id`, `user_id`, `submission_id`, `problem_number`, `analysis_text`, `score`, `suggestion_text`, `created_at`, `updated_at`) VALUES (15, 1, 150, '0002', '该代码的可读性分析如下：\n\n1. **注释完整性**：代码中没有注释，这会使得理解代码逻辑变得困难，尤其是对于不熟悉算法的人来说。注释对于解释关键逻辑和函数功能是非常重要的。\n\n2. **代码布局**：代码的缩进和换行使用得当，使得代码结构清晰，易于阅读。\n\n3. **函数和类设计**：代码中只有一个类`Main`和一个静态方法`main`，命名清晰。方法的功能单一，明确地找出输入序列中的最大值。\n\n4. **代码简洁性**：代码简洁明了，没有不必要的复杂性。但是，由于缺乏注释，对于不熟悉算法的人来说，可能难以理解其工作原理。', 55, '为了提高代码的可读性，建议添加以下改进：\n\n- 在代码中添加必要的注释，解释算法的逻辑和关键步骤。\n- 考虑将查找最大值的逻辑放入一个单独的函数中，以提高代码的可重用性和可读性。', '2025-05-03 13:38:57', '2025-05-03 13:38:57');
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
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (1, '官方社区', 'official', '官方技术交流与公告发布', 'https://www.svgrepo.com/show/303388/java-4-logo.svg', NULL, NULL, NULL, '2025-01-22 02:05:10', 1, 1, NULL, '2025-04-18 09:02:02');
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (2, '算法学习社区', 'official', '一起学习数据结构与算法', 'https://www.svgrepo.com/show/353528/c.svg', NULL, NULL, NULL, '2025-01-22 02:05:10', 1, 1, NULL, '2025-04-18 09:02:02');
INSERT INTO `communities` (`id`, `name`, `type`, `description`, `cover_image`, `school`, `college`, `class_name`, `created_at`, `created_by`, `status`, `announcement`, `announcement_updated_at`) VALUES (3, '前端技术社区', 'class', '前端开发技术交流', 'https://www.svgrepo.com/show/303494/vue-9-logo.svg', NULL, NULL, NULL, '2025-01-22 02:05:10', 1, 1, NULL, '2025-04-18 09:02:02');
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
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (1, 1, '官方社区', '欢迎来到AI代码审查平台！我们致力于帮助开发者提升代码质量。', '2025-01-22 02:05:24');
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (2, 1, '官方社区', '新功能上线：现在支持多种编程语言的代码审查！', '2025-01-22 02:05:24');
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (3, 2, '算法学习社区', '每周五晚8点在线算法讲解，欢迎参加！', '2025-01-22 02:05:24');
INSERT INTO `community_announcements` (`id`, `community_id`, `community_name`, `announcement`, `announcement_updated_at`) VALUES (4, 3, '前端技术社区', '前端框架专题讨论：Vue3 vs React18性能对比', '2025-01-22 02:05:24');
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
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (1, 1, 1, 'owner', '2025-01-22 20:04:33', NULL, 1);
INSERT INTO `community_members` (`id`, `community_id`, `user_id`, `role`, `joined_at`, `invited_by`, `status`) VALUES (3, 1, 3, 'member', '2025-01-22 20:04:33', NULL, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=244 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of learning_path_directions
-- ----------------------------
BEGIN;
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (235, 1, '序列', 'https://search.bilibili.com/all?keyword=编程%E5%BA%8F%E5%88%97', '序列编程教学视频集锦', '哔哩哔哩', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (236, 1, '序列', 'https://www.douyin.com/search/编程%E5%BA%8F%E5%88%97', '序列相关短视频教程', '抖音', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (237, 1, '序列', 'https://so.csdn.net/so/search?q=编程%E5%BA%8F%E5%88%97', '序列学习资料大全', 'CSDN', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (238, 1, '字符串', 'https://search.bilibili.com/all?keyword=编程%E5%AD%97%E7%AC%A6%E4%B8%B2', '字符串编程教学视频集锦', '哔哩哔哩', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (239, 1, '字符串', 'https://www.douyin.com/search/编程%E5%AD%97%E7%AC%A6%E4%B8%B2', '字符串相关短视频教程', '抖音', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (240, 1, '字符串', 'https://so.csdn.net/so/search?q=编程%E5%AD%97%E7%AC%A6%E4%B8%B2', '字符串学习资料大全', 'CSDN', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (241, 1, '递归', 'https://search.bilibili.com/all?keyword=编程%E9%80%92%E5%BD%92', '递归编程教学视频集锦', '哔哩哔哩', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (242, 1, '递归', 'https://www.douyin.com/search/编程%E9%80%92%E5%BD%92', '递归相关短视频教程', '抖音', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
INSERT INTO `learning_path_directions` (`id`, `user_id`, `tag`, `url`, `title`, `source`, `created_at`, `updated_at`) VALUES (243, 1, '递归', 'https://so.csdn.net/so/search?q=编程%E9%80%92%E5%BD%92', '递归学习资料大全', 'CSDN', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
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
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of learning_path_recommend
-- ----------------------------
BEGIN;
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (140, 1, '序列', '0026', '最长连续序列1', '2025-05-03 11:53:37', '2025-05-03 11:53:37');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (141, 1, '序列', '0026', '最长连续序列1', '2025-05-03 11:53:37', '2025-05-03 11:53:37');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (142, 1, '递归', '0004', '阶乘计算', '2025-05-03 11:53:39', '2025-05-03 11:53:39');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (143, 1, '递归', '0009', '斐波那契数列计算', '2025-05-03 11:53:39', '2025-05-03 11:53:39');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (144, 1, '字符串', '0003', '字符串反转', '2025-05-03 11:53:42', '2025-05-03 11:53:42');
INSERT INTO `learning_path_recommend` (`id`, `user_id`, `tag`, `problem_number`, `title`, `created_at`, `updated_at`) VALUES (145, 1, '字符串', '0013', '字符串替换', '2025-05-03 11:53:42', '2025-05-03 11:53:42');
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
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Records of learning_path_weakness_analysis
-- ----------------------------
BEGIN;
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (113, 1, '递归', '🌟 递归核心思路 🌟\n- 重复调用自身函数解决问题\n- 分解问题为更小、更简单的子问题\n\n🔍 关键点\n- 明确递归终止条件\n- 每次递归调用都向终止条件靠近\n- 避免无限递归\n\n📝 常见解题技巧\n- 分析问题结构，确定递归方式\n- 设定递归函数参数\n- 使用递归树可视化递归过程\n- 转换为迭代方法（如有必要）\n\n🎯 要点总结\n- **终止条件**：确保递归能结束\n- **递归分解**：将大问题拆成小问题\n- **参数传递**：正确传递参数给递归调用\n- **可视化**：绘制递归树理解递归过程', '2025-05-03 11:53:26', '2025-05-03 11:53:26');
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (114, 1, '字符串', '🎯 **核心思路**：\n- 字符串是字符序列，用于存储文本信息。\n- 操作包括拼接、查找、替换、长度计算等。\n\n🔍 **关键点**：\n- **索引**：从0开始，正向递增。\n- **长度**：`len()`函数获取。\n- **拼接**：`+`操作符或`str.join()`方法。\n\n📋 **常见解题技巧**：\n- 使用循环遍历字符串。\n- 利用字符串方法如`split()`, `find()`, `replace()`。\n- 理解字符串不可变特性，避免不必要的复制。\n- 使用字符串格式化方法如`format()`或f-string。\n\n🌟 **要点总结**：\n- 索引从0开始\n- 长度用`len()`\n- 拼接用`+`或`join()`\n- 循环遍历\n- 字符串方法丰富\n- 注意不可变性', '2025-05-03 11:53:27', '2025-05-03 11:53:27');
INSERT INTO `learning_path_weakness_analysis` (`id`, `user_id`, `tag`, `idea`, `created_at`, `updated_at`) VALUES (115, 1, '序列', '🔍 **序列核心思路**：\n- **理解序列**：序列是一组有序的数据集合，如数组、链表等。\n- **遍历序列**：使用循环结构，如for、while等，逐个访问序列中的元素。\n\n🔧 **关键点**：\n- **索引**：使用索引访问序列中的元素，如`arr[0]`获取第一个元素。\n- **长度**：了解序列长度，如`len(arr)`获取数组长度。\n- **迭代**：迭代时注意边界条件，避免越界错误。\n\n🎯 **常见解题技巧**：\n- **排序**：使用排序算法对序列进行排序，如冒泡、选择等。\n- **搜索**：使用线性或二分搜索在序列中查找特定元素。\n- **遍历**：使用嵌套循环处理序列中的每一对元素。\n\n👩‍💻 **要点总结**：\n- 理解序列的基本概念。\n- 掌握索引和长度属性。\n- 迭代时注意边界和错误处理。\n- 熟练运用排序、搜索和遍历技巧。', '2025-05-03 11:53:28', '2025-05-03 11:53:28');
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
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学习计划-题目关联表';

-- ----------------------------
-- Records of learning_plan_problems
-- ----------------------------
BEGIN;
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (1, 4, 16, '0016', 1, '基础查询', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (2, 4, 20, '0020', 2, '基础查询', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (3, 4, 21, '0021', 3, '聚合函数', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (5, 4, 30, '0026', 5, '高级查询', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (6, 5, 1, '0001', 1, '基础运算', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (7, 5, 6, '0006', 2, '基础运算', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (8, 5, 21, '0021', 3, '基础运算', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (9, 5, 2, '0002', 4, '数组基础', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (10, 5, 7, '0007', 5, '数组基础', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (11, 5, 11, '0011', 6, '数组基础', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (12, 5, 3, '0003', 7, '字符串基础', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (13, 5, 12, '0012', 8, '字符串基础', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (15, 5, 10, '0010', 10, '条件判断', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (16, 6, 5, '0005', 1, '数学进阶', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (17, 6, 15, '0015', 2, '数学进阶', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (18, 6, 19, '0019', 3, '数学进阶', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (19, 6, 18, '0018', 4, '动态规划', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (20, 6, 23, '0023', 5, '动态规划', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (21, 6, 30, '0026', 6, '动态规划', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (23, 6, 29, '0025', 8, '数据结构', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (24, 6, 13, '0013', 9, '字符串处理', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (25, 6, 14, '0014', 10, '算法思维', '2025-02-03 19:19:23');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (36, 3, 5, '0005', 1, '数学进阶', '2025-02-03 19:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (37, 3, 15, '0015', 2, '数学进阶', '2025-02-03 19:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (38, 3, 19, '0019', 3, '数学进阶', '2025-02-03 19:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (40, 3, 29, '0025', 5, '数据结构', '2025-02-03 19:33:12');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (102, 2, 18, '0018', 1, '动态规划', '2025-05-01 15:18:32');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (103, 2, 23, '0023', 2, '动态规划', '2025-05-01 15:18:32');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (104, 2, 30, '0026', 3, '动态规划', '2025-05-01 15:18:32');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (105, 2, 13, '0013', 4, '字符串处理', '2025-05-01 15:18:32');
INSERT INTO `learning_plan_problems` (`id`, `plan_id`, `problem_id`, `problem_number`, `order_index`, `section`, `created_at`) VALUES (106, 2, 14, '0014', 5, '算法思维', '2025-05-01 15:18:32');
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学习计划主表';

-- ----------------------------
-- Records of learning_plans
-- ----------------------------
BEGIN;
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (2, '动态规划（基础版）', '更细的知识点拆分，让入门更轻松', '/icons/algorithm.png', '算法入门', NULL, 15, '[\"系统学习动态规划基础\",\"从易到难的题目编排\",\"配套详细的解题思路\",\"适合算法学习初期的用户\"]', '2025-02-03 19:19:23', '2025-05-01 15:18:32', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (3, 'LeetCode 热题 100', '力扣最受刷题发烧友欢迎的 100 题', '/icons/hot.png', '热门精选', '中等', 25, '[\"精选最热门的 100 道题目\",\"覆盖多个算法知识点\",\"题目难度分布合理\",\"适合系统提升算法能力\"]', '2025-02-03 19:19:23', '2025-02-05 21:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (4, 'SQL 50 题', '面试必刷的 SQL 精选题目', '/icons/sql.png', 'SQL专题', '中等', 20, '[\"覆盖 SQL 常见面试题型\",\"从基础到高级查询\",\"包含多表联查和性能优化\",\"适合数据库开发岗位面试\"]', '2025-02-03 19:19:23', '2025-02-05 21:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (5, '编程入门 100 题', '为编程新手量身打造的入门题集', '/icons/beginner.png', '入门推荐', '简单', 40, '[\"从零开始的编程入门\",\"循序渐进的难度安排\",\"详细的解题思路讲解\",\"适合编程初学者\"]', '2025-02-03 19:19:23', '2025-02-05 21:23:10', 1);
INSERT INTO `learning_plans` (`id`, `title`, `description`, `icon`, `tag`, `difficulty_level`, `estimated_days`, `points`, `created_at`, `updated_at`, `user_id`) VALUES (6, '会员专享题集', '精心筛选的高质量面试题集', '/icons/premium.png', '会员专享', '困难', 35, '[\"高质量算法面试题\",\"大厂常考题目精选\",\"面试真题解析\",\"适合准备大厂面试的用户\"]', '2025-02-03 19:19:23', '2025-02-05 21:23:10', 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3 COMMENT='题目分类总表';

-- ----------------------------
-- Records of problem_categories
-- ----------------------------
BEGIN;
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (1, '数据结构', '与数据结构相关的算法题', NULL, 0, 1, 'data-structure', 'structure', '2025-04-18 16:30:41', '2025-04-18 16:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (2, '算法技巧', '常见算法技巧与思想', NULL, 0, 1, 'algorithm', 'algorithm', '2025-04-18 16:30:41', '2025-04-18 16:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (3, '数学', '数学相关的问题', NULL, 0, 1, 'math', 'calculator', '2025-04-18 16:30:41', '2025-04-18 16:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (4, '基础编程', '基础编程能力考察', NULL, 0, 1, 'basic', 'code', '2025-04-18 16:30:41', '2025-04-18 16:30:41');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (17, '数组', '数组类型的问题', 1, 0, 2, 'array', 'array', '2025-04-18 16:30:56', '2025-04-18 16:30:56');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (18, '字符串', '字符串操作相关问题', 4, 0, 2, 'string', 'string', '2025-04-18 16:31:06', '2025-04-18 16:31:06');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (19, '排序', '排序算法相关问题', 2, 0, 2, 'sorting', 'sort', '2025-04-18 16:31:09', '2025-04-18 16:31:09');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (20, '双指针', '双指针技巧相关问题', 2, 0, 2, 'two-pointers', 'pointers', '2025-04-18 16:31:12', '2025-04-18 16:31:12');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (21, '递归', '递归相关问题', 3, 0, 2, 'recursion', 'recursion', '2025-04-18 16:31:15', '2025-04-18 16:31:15');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (22, '进制转换', '进制转换相关问题', 3, 0, 2, 'base-conversion', 'conversion', '2025-04-18 16:31:18', '2025-04-18 16:31:18');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (23, '判断', '逻辑判断相关问题', 3, 0, 2, 'judgement', 'judge', '2025-04-18 16:31:21', '2025-04-18 16:31:21');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (24, '算法', '通用算法实现相关问题', 2, 0, 2, 'algorithm-impl', 'implement', '2025-04-18 16:31:24', '2025-04-18 16:31:24');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (25, '序列', '序列相关问题', 1, 0, 2, 'sequence', 'sequence', '2025-04-18 16:31:27', '2025-04-18 16:31:27');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (26, '树', '树结构相关问题', 1, 0, 2, 'tree', 'tree', '2025-04-18 16:31:30', '2025-04-18 16:31:30');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (27, '广度优先搜索', '图的广度优先搜索算法', 2, 0, 2, 'bfs', 'search', '2025-04-18 16:31:33', '2025-04-18 16:31:33');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (28, '动态规划', '动态规划相关问题', 2, 0, 2, 'dynamic-programming', 'dp', '2025-04-18 16:31:36', '2025-04-18 16:31:36');
INSERT INTO `problem_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `level`, `slug`, `icon`, `created_at`, `updated_at`) VALUES (29, '基础', '基础编程概念和实践', 4, 0, 2, 'basic-concepts', '', '2025-04-18 16:31:44', '2025-05-04 11:24:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb3 COMMENT='题目分类与题目之间关联表';

-- ----------------------------
-- Records of problem_category_relations
-- ----------------------------
BEGIN;
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (1, 1, 29, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (2, 1, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (3, 2, 29, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (4, 2, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (5, 3, 18, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (6, 4, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (7, 4, 21, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (8, 5, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (9, 5, 23, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (10, 6, 29, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (11, 6, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (12, 7, 29, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (13, 7, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (14, 8, 18, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (15, 9, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (16, 9, 21, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (17, 10, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (18, 10, 23, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (19, 11, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (20, 11, 19, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (21, 12, 18, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (22, 13, 18, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (23, 14, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (24, 14, 24, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (25, 15, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (26, 15, 23, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (27, 16, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (28, 16, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (29, 17, 18, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (30, 18, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (31, 18, 24, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (32, 19, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (33, 19, 24, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (34, 20, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (35, 21, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (36, 22, 18, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (37, 23, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (38, 23, 21, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (39, 25, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (40, 25, 23, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (41, 29, 3, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (42, 29, 22, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (43, 30, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (44, 30, 24, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (45, 30, 25, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (46, 33, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (47, 34, 20, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (48, 34, 17, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (49, 38, 26, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (50, 38, 27, '2025-04-18 16:32:18');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (53, 43, 26, '2025-04-20 19:05:04');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (54, 43, 27, '2025-04-20 19:05:04');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (56, 51, 26, '2025-05-03 15:29:05');
INSERT INTO `problem_category_relations` (`id`, `problem_id`, `category_id`, `created_at`) VALUES (57, 51, 27, '2025-05-03 15:29:05');
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
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (2, '0002', '合并两个有序链表', '简单', '链表,递归', '将两个升序链表合并为一个新的升序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。', 1000, 256, '8', '原创', 1, 2, 1, '2025-04-12 00:43:41', '2025-04-22 22:45:17');
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (3, '0003', '最长回文子串', '中等', '字符串,动态规划', '给你一个字符串 s，找到 s 中最长的回文子串。', 1500, 512, '4', '原创', 1, 3, 1, '2025-04-12 00:43:41', '2025-04-17 06:33:52');
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (4, '0004', '买卖股票的最佳时机', '简单', '数组,动态规划', '给定一个数组 prices ，它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格。你只能选择某一天买入这只股票，并选择在未来的某一个不同的日子卖出该股票。设计一个算法来计算你所能获取的最大利润。', 1000, 256, '5', '原创', 1, 1, 1, '2025-04-12 00:43:41', '2025-04-12 01:08:03');
INSERT INTO `problem_pool` (`id`, `problem_number`, `title`, `difficulty`, `tags`, `description`, `time_limit`, `memory_limit`, `category`, `source`, `create_user_id`, `reference_count`, `status`, `created_at`, `updated_at`) VALUES (5, '0005', '二叉树的层序遍历', '中等', '树,广度优先搜索', '给你一个二叉树，请你返回其按层序遍历得到的节点值。（即逐层地，从左到右访问所有节点）。', 1000, 256, '9', '原创', 1, 14, 1, '2025-04-12 00:43:41', '2025-05-04 12:00:12');
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
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (1, '算法', '包含各种算法题目', NULL, 1, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (2, '数据结构', '包含各种数据结构题目', NULL, 2, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (3, '数学', '包含各种数学题目', NULL, 3, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (4, '动态规划', '动态规划相关题目', 1, 1, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (5, '贪心算法', '贪心算法相关题目', 1, 2, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (6, '二分查找', '二分查找相关题目', 1, 3, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (7, '数组', '数组相关题目', 2, 1, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (8, '链表', '链表相关题目', 2, 2, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (9, '树', '树相关题目', 2, 3, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
INSERT INTO `problem_pool_categories` (`id`, `name`, `description`, `parent_id`, `order_num`, `created_at`, `updated_at`) VALUES (10, '图', '图相关题目', 2, 4, '2025-04-12 00:43:21', '2025-04-12 00:43:21');
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
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (1, '0001', 1, 4, '#include <iostream>\n#include <vector>\n#include <unordered_map>\nusing namespace std;\n\nclass Solution {\npublic:\n    vector<int> twoSum(vector<int>& nums, int target) {\n        unordered_map<int, int> map;\n        for (int i = 0; i < nums.size(); i++) {\n            int complement = target - nums[i];\n            if (map.find(complement) != map.end()) {\n                return {map[complement], i};\n            }\n            map[nums[i]] = i;\n        }\n        return {};\n    }\n};', '1.0', '2025-04-12 00:44:13', '2025-04-12 01:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (2, '0001', 1, 3, 'import java.util.HashMap;\nimport java.util.Map;\n\nclass Solution {\n    public int[] twoSum(int[] nums, int target) {\n        Map<Integer, Integer> map = new HashMap<>();\n        for (int i = 0; i < nums.length; i++) {\n            int complement = target - nums[i];\n            if (map.containsKey(complement)) {\n                return new int[] { map.get(complement), i };\n            }\n            map.put(nums[i], i);\n        }\n        return null;\n    }\n}', '1.0', '2025-04-12 00:44:13', '2025-04-12 01:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (3, '0002', 2, 4, '#include <iostream>\nusing namespace std;\n\nstruct ListNode {\n    int val;\n    ListNode *next;\n    ListNode() : val(0), next(nullptr) {}\n    ListNode(int x) : val(x), next(nullptr) {}\n    ListNode(int x, ListNode *next) : val(x), next(next) {}\n};\n\nclass Solution {\npublic:\n    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {\n        if (!list1) return list2;\n        if (!list2) return list1;\n        \n        if (list1->val < list2->val) {\n            list1->next = mergeTwoLists(list1->next, list2);\n            return list1;\n        } else {\n            list2->next = mergeTwoLists(list1, list2->next);\n            return list2;\n        }\n    }\n};', '1.0', '2025-04-12 00:44:13', '2025-04-12 01:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (4, '0003', 3, 4, '#include <iostream>\n#include <string>\n#include <vector>\nusing namespace std;\n\nclass Solution {\npublic:\n    string longestPalindrome(string s) {\n        int n = s.size();\n        if (n < 2) return s;\n        \n        int maxLen = 1;\n        int begin = 0;\n        vector<vector<bool>> dp(n, vector<bool>(n, false));\n        \n        // 所有单个字符都是回文\n        for (int i = 0; i < n; i++) {\n            dp[i][i] = true;\n        }\n        \n        // 检查长度为2及以上的子串\n        for (int L = 2; L <= n; L++) {\n            for (int i = 0; i < n; i++) {\n                int j = i + L - 1;\n                if (j >= n) break;\n                \n                if (s[i] != s[j]) {\n                    dp[i][j] = false;\n                } else {\n                    if (j - i < 3) {\n                        dp[i][j] = true;\n                    } else {\n                        dp[i][j] = dp[i+1][j-1];\n                    }\n                }\n                \n                if (dp[i][j] && j - i + 1 > maxLen) {\n                    maxLen = j - i + 1;\n                    begin = i;\n                }\n            }\n        }\n        \n        return s.substr(begin, maxLen);\n    }\n};', '1.0', '2025-04-12 00:44:13', '2025-04-12 01:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (5, '0004', 4, 4, '#include <iostream>\n#include <vector>\n#include <algorithm>\nusing namespace std;\n\nclass Solution {\npublic:\n    int maxProfit(vector<int>& prices) {\n        if (prices.empty()) return 0;\n        \n        int minPrice = prices[0];\n        int maxProfit = 0;\n        \n        for (int i = 1; i < prices.size(); i++) {\n            maxProfit = max(maxProfit, prices[i] - minPrice);\n            minPrice = min(minPrice, prices[i]);\n        }\n        \n        return maxProfit;\n    }\n};', '1.0', '2025-04-12 00:44:13', '2025-04-12 01:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (6, '0005', 5, 4, '#include <iostream>\n#include <vector>\n#include <queue>\nusing namespace std;\n\nstruct TreeNode {\n    int val;\n    TreeNode *left;\n    TreeNode *right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}\n};\n\nclass Solution {\npublic:\n    vector<vector<int>> levelOrder(TreeNode* root) {\n        vector<vector<int>> result;\n        if (!root) return result;\n        \n        queue<TreeNode*> q;\n        q.push(root);\n        \n        while (!q.empty()) {\n            int levelSize = q.size();\n            vector<int> currentLevel;\n            \n            for (int i = 0; i < levelSize; i++) {\n                TreeNode* node = q.front();\n                q.pop();\n                \n                currentLevel.push_back(node->val);\n                \n                if (node->left) q.push(node->left);\n                if (node->right) q.push(node->right);\n            }\n            \n            result.push_back(currentLevel);\n        }\n        \n        return result;\n    }\n};', '1.0', '2025-04-12 00:44:13', '2025-04-12 01:08:47');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (7, '0002', 2, 1, '// C 解决方案\nstruct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2) {\n    struct ListNode dummy;\n    struct ListNode* tail = &dummy;\n    \n    while (l1 && l2) {\n        if (l1->val <= l2->val) {\n            tail->next = l1;\n            l1 = l1->next;\n        } else {\n            tail->next = l2;\n            l2 = l2->next;\n        }\n        tail = tail->next;\n    }\n    \n    tail->next = l1 ? l1 : l2;\n    return dummy.next;\n}', '1.0', '2025-04-14 17:23:08', '2025-04-14 17:23:08');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (8, '0002', 2, 2, '# Python 解决方案\ndef mergeTwoLists(l1, l2):\n    dummy = ListNode(0)\n    tail = dummy\n    \n    while l1 and l2:\n        if l1.val <= l2.val:\n            tail.next = l1\n            l1 = l1.next\n        else:\n            tail.next = l2\n            l2 = l2.next\n        tail = tail.next\n    \n    tail.next = l1 if l1 else l2\n    return dummy.next', '1.0', '2025-04-14 17:23:19', '2025-04-14 17:23:19');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (9, '0002', 2, 3, '// Java 解决方案\npublic ListNode mergeTwoLists(ListNode l1, ListNode l2) {\n    ListNode dummy = new ListNode(0);\n    ListNode tail = dummy;\n    \n    while (l1 != null && l2 != null) {\n        if (l1.val <= l2.val) {\n            tail.next = l1;\n            l1 = l1.next;\n        } else {\n            tail.next = l2;\n            l2 = l2.next;\n        }\n        tail = tail.next;\n    }\n    \n    tail.next = (l1 != null) ? l1 : l2;\n    return dummy.next;\n}', '1.0', '2025-04-14 17:23:27', '2025-04-14 17:23:27');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (10, '0003', 3, 1, '// C 解决方案\nchar* longestPalindrome(char* s) {\n    int n = strlen(s);\n    if (n == 0) return \"\";\n    \n    int start = 0, max_len = 1;\n    \n    // 辅助函数：从中心扩展\n    for (int i = 0; i < n; i++) {\n        // 奇数长度回文\n        int left = i, right = i;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n        \n        // 偶数长度回文\n        left = i, right = i + 1;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n    }\n    \n    char* result = malloc(max_len + 1);\n    strncpy(result, s + start, max_len);\n    result[max_len] = 0;\n    return result;\n}', '1.0', '2025-04-14 17:23:38', '2025-04-14 17:23:38');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (11, '0003', 3, 3, '// Java 解决方案\npublic String longestPalindrome(String s) {\n    if (s == null || s.length() < 1) return \"\";\n    \n    int start = 0, end = 0;\n    \n    for (int i = 0; i < s.length(); i++) {\n        int len1 = expandAroundCenter(s, i, i);\n        int len2 = expandAroundCenter(s, i, i + 1);\n        int len = Math.max(len1, len2);\n        if (len > end - start) {\n            start = i - (len - 1) / 2;\n            end = i + len / 2;\n        }\n    }\n    \n    return s.substring(start, end + 1);\n}\n\nprivate int expandAroundCenter(String s, int left, int right) {\n    while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {\n        left--;\n        right++;\n    }\n    return right - left - 1;\n}', '1.0', '2025-04-14 17:24:12', '2025-04-14 17:24:12');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (12, '0004', 4, 1, '// C 解决方案\nint maxProfit(int* prices, int pricesSize) {\n    if (pricesSize <= 1) return 0;\n    \n    int minPrice = prices[0];\n    int maxProfit = 0;\n    \n    for (int i = 1; i < pricesSize; i++) {\n        if (prices[i] < minPrice) {\n            minPrice = prices[i];\n        } else if (prices[i] - minPrice > maxProfit) {\n            maxProfit = prices[i] - minPrice;\n        }\n    }\n    \n    return maxProfit;\n}', '1.0', '2025-04-14 17:24:29', '2025-04-14 17:24:29');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (13, '0004', 4, 2, '# Python 解决方案\ndef maxProfit(prices):\n    if not prices or len(prices) <= 1:\n        return 0\n        \n    min_price = float(\"inf\")\n    max_profit = 0\n    \n    for price in prices:\n        if price < min_price:\n            min_price = price\n        elif price - min_price > max_profit:\n            max_profit = price - min_price\n            \n    return max_profit', '1.0', '2025-04-14 17:24:45', '2025-04-14 17:24:45');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (14, '0004', 4, 3, '// Java 解决方案\npublic int maxProfit(int[] prices) {\n    if (prices == null || prices.length <= 1) return 0;\n    \n    int minPrice = Integer.MAX_VALUE;\n    int maxProfit = 0;\n    \n    for (int price : prices) {\n        if (price < minPrice) {\n            minPrice = price;\n        } else if (price - minPrice > maxProfit) {\n            maxProfit = price - minPrice;\n        }\n    }\n    \n    return maxProfit;\n}', '1.0', '2025-04-14 17:24:54', '2025-04-14 17:24:54');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (15, '0005', 5, 1, '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}', '1.0', '2025-04-14 17:26:01', '2025-04-14 17:26:01');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (16, '0005', 5, 2, '# Python 简化解决方案\ndef levelOrder(root):\n    # 使用队列实现二叉树层序遍历\n    # 返回二维数组表示层序遍历结果\n    pass', '1.0', '2025-04-14 17:27:11', '2025-04-14 17:27:11');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (17, '0005', 5, 3, '// Java 简化解决方案\npublic List<List<Integer>> levelOrder(TreeNode root) {\n    // 使用队列实现二叉树层序遍历\n    // 返回二维列表表示层序遍历结果\n    return new ArrayList<>();\n}', '1.0', '2025-04-14 17:28:04', '2025-04-14 17:28:04');
INSERT INTO `problem_pool_solution_code` (`id`, `solution_number`, `pool_solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (18, '0003', 3, 2, '# Python 简化解决方案\ndef longestPalindrome(s):\n    # 实现寻找最长回文子串的算法\n    # 返回最长回文子串\n    pass', '1.0', '2025-04-14 17:29:05', '2025-04-14 17:29:05');
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
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (1, '0001', '0001', 1, '使用哈希表存储数组元素和对应的索引，遍历数组时检查目标值与当前元素的差是否存在于哈希表中。', 'O(n)', 'O(n)', '2025-04-12 00:43:52', '2025-04-12 01:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (2, '0002', '0002', 2, '使用递归或迭代方法，比较两个链表的头节点，选择较小的一个作为新链表的头，然后递归处理剩余部分。', 'O(n+m)', 'O(1)', '2025-04-12 00:43:52', '2025-04-12 01:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (3, '0003', '0003', 3, '动态规划方法：利用状态转移方程 P(i,j)=(P(i+1,j−1) and S[i]==S[j])，逐步找到最长回文子串。', 'O(n²)', 'O(n²)', '2025-04-12 00:43:52', '2025-04-12 01:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (4, '0004', '0004', 4, '贪心算法：记录历史最低价格，计算当前价格与历史最低价格的差值，并更新最大利润。', 'O(n)', 'O(1)', '2025-04-12 00:43:52', '2025-04-12 01:08:42');
INSERT INTO `problem_pool_solutions` (`id`, `solution_number`, `problem_number`, `problem_pool_id`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (5, '0005', '0005', 5, '使用队列实现广度优先搜索，逐层处理二叉树节点。', 'O(n)', 'O(n)', '2025-04-12 00:43:52', '2025-04-12 01:08:42');
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
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (1, '0001', 1, '[2,7,11,15]\n9', '[0,1]', 1, 1, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (2, '0001', 1, '[3,2,4]\n6', '[1,2]', 1, 2, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (3, '0001', 1, '[3,3]\n6', '[0,1]', 0, 3, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (4, '0002', 2, '[1,2,4]\n[1,3,4]', '[1,1,2,3,4,4]', 1, 1, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (5, '0002', 2, '[]\n[]', '[]', 1, 2, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (6, '0002', 2, '[]\n[0]', '[0]', 0, 3, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (7, '0003', 3, 'babad', 'bab', 1, 1, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (8, '0003', 3, 'cbbd', 'bb', 1, 2, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (9, '0003', 3, 'a', 'a', 0, 3, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (10, '0004', 4, '[7,1,5,3,6,4]', '5', 1, 1, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (11, '0004', 4, '[7,6,4,3,1]', '0', 1, 2, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (12, '0005', 5, '[3,9,20,null,null,15,7]', '[[3],[9,20],[15,7]]', 1, 1, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (13, '0005', 5, '[1]', '[[1]]', 1, 2, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
INSERT INTO `problem_pool_test_cases` (`id`, `problem_number`, `problem_pool_id`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (14, '0005', 5, '[]', '[]', 0, 3, '2025-04-12 00:44:29', '2025-04-12 01:08:25');
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
INSERT INTO `problem_pool_usage` (`id`, `problem_number`, `problem_pool_id`, `user_id`, `problem_id`, `is_modified`, `created_at`) VALUES (1, '0001', 1, 1, 10, 0, '2025-04-12 00:44:33');
INSERT INTO `problem_pool_usage` (`id`, `problem_number`, `problem_pool_id`, `user_id`, `problem_id`, `is_modified`, `created_at`) VALUES (2, '0002', 2, 1, 11, 0, '2025-04-12 00:44:33');
INSERT INTO `problem_pool_usage` (`id`, `problem_number`, `problem_pool_id`, `user_id`, `problem_id`, `is_modified`, `created_at`) VALUES (5, '0005', 5, 3, 14, 1, '2025-04-12 00:44:33');
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
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目——题目测试样例表';

-- ----------------------------
-- Records of problem_test_cases
-- ----------------------------
BEGIN;
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (1, 1, '0001', '2 3', '5', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (2, 2, '0002', '5\n1 5 3 8 2', '8', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (3, 3, '0003', 'hello', 'olleh', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (4, 4, '0004', '5', '120', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (5, 5, '0005', '7', '是', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (6, 6, '0006', '5 3', '2', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (7, 7, '0007', '5\n4 2 7 1 9', '1', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (8, 8, '0008', 'abc def', 'abcdef', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (9, 9, '0009', '6', '8', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (10, 10, '0010', '8', '是', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (11, 11, '0011', '5\n9 3 6 2 7', '2 3 6 7 9', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (12, 12, '0012', 'apple p', '2', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (13, 13, '0013', 'hello world world java', 'hello java', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (14, 14, '0014', '12 18', '6', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (15, 15, '0015', '121', '是', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (16, 16, '0016', '2 2\n1 2\n3 4\n5 6\n7 8', '6 8\n10 12', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (17, 17, '0017', 'I love programming', 'programming love I', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (18, 18, '0018', '5', '1\n1 1\n1 2 1\n1 3 3 1\n1 4 6 4 1', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (19, 19, '0019', '10 20', '11 13 17 19', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (20, 20, '0020', '6\n1 2 2 3 3 3', '1 2 3', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (21, 21, '0021', '5\n1 2 3 4 5', '15', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (22, 22, '0022', 'hello', 'olleh', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (23, 23, '0023', '6', '8', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (24, 25, '0024', '8', '是', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (25, 29, '0025', '1010', '10', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (27, 33, '0027', '1 1', '2', 1, 1, '2025-04-02 20:39:37', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (32, 1, '0001', '10 20', '30', 1, 2, '2025-04-02 20:39:37', '2025-04-29 02:06:25');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (33, 1, '0001', '-5 8', '3', 1, 3, '2025-04-02 20:39:37', '2025-04-29 02:07:04');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (34, 1, '0001', '0 0', '0', 1, 4, '2025-04-02 20:39:37', '2025-04-29 02:13:30');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (35, 1, '0001', '999 1', '1000', 1, 5, '2025-04-02 20:39:37', '2025-04-29 02:18:20');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (38, 34, '0028', '11', '11', 0, 1, '2025-04-04 19:04:08', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (39, 34, '0028', '22', '22', 0, 2, '2025-04-04 19:04:08', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (46, 30, '0026', '6\n100 4 200 1 3 2', '4', 1, 1, '2025-04-16 00:10:35', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (47, 30, '0026', '0', '0', 0, 2, '2025-04-16 00:10:35', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (48, 30, '0026', '1\n5', '1', 0, 3, '2025-04-16 00:10:35', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (49, 30, '0026', '8\n1 3 5 2 4 7 9 6', '9', 0, 4, '2025-04-16 00:10:35', '2025-04-16 00:29:19');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (72, 38, '0029', '[3,9,20,null,null,15,7]', '[[3],[9,20],[15,7]]', 0, 0, '2025-04-17 06:24:12', '2025-04-17 06:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (73, 38, '0029', '[1]', '[[1]]', 0, 0, '2025-04-17 06:24:12', '2025-04-17 06:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (74, 38, '0029', '[]', '[]', 0, 0, '2025-04-17 06:24:12', '2025-04-17 06:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (75, 38, '0029', '4', '1', 0, 4, '2025-04-17 06:24:12', '2025-04-17 06:54:48');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (109, 51, '0031', '[3,9,20,null,null,15,7]', '[[3],[9,20],[15,7]]', 1, 1, '2025-05-03 15:29:05', '2025-05-04 11:38:51');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (110, 51, '0031', '[1]', '[[1]]', 1, 2, '2025-05-03 15:29:05', '2025-05-04 11:38:51');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (111, 51, '0031', '[]', '[]', 0, 3, '2025-05-03 15:29:05', '2025-05-04 11:38:51');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (135, 42, '0030', 'babad', 'bab', 0, 1, '2025-05-04 11:53:01', '2025-05-04 12:13:36');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (136, 42, '0030', 'cbbd', 'bb', 0, 2, '2025-05-04 11:53:01', '2025-05-04 12:13:36');
INSERT INTO `problem_test_cases` (`id`, `problem_id`, `problem_number`, `input`, `output`, `is_example`, `order_num`, `created_at`, `updated_at`) VALUES (137, 42, '0030', 'a', 'a', 0, 3, '2025-05-04 11:53:01', '2025-05-04 12:13:36');
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
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb3 COMMENT='题目——题目详细表';

-- ----------------------------
-- Records of problems
-- ----------------------------
BEGIN;
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (1, '0001', '两数相加问题', '简单', 185, 86.49, '基础,数学', '给定两个整数A和B，求它们的和。', 1000, 256, 160);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (2, '0002', '寻找最大值', '简单', 306, 83.01, '基础,数组', '给定一个整数数组，找出其中的最大值。第一行输入一个整数n表示数组长度，第二行输入n个整数表示数组元素。', 1000, 256, 254);
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
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (16, '0016', '矩阵相加', '简单', 782, 48.08, '数学,数组', '给定两个相同维度的矩阵，求它们对应元素相加后的结果矩阵。第一行输入两个整数n、m表示矩阵的行数和列数，接下来n行每行m个整数表示第一个矩阵，再接下来n行每行m个整数表示第二个矩阵。', 1000, 256, 376);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (17, '0017', '单词反转', '简单', 545, 39.82, '字符串', '将一个句子中的单词顺序反转。例如，\"I am a student\" 转换为 \"student a am I\"。', 1000, 256, 217);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (18, '0018', '杨辉三角生成', '中等', 734, 19.75, '数学,算法', '生成指定行数的杨辉三角。', 1000, 256, 145);
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
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (42, '0030', '最长回文子串', '中等', 0, 0.00, '字符串,动态规划,标签', '给你一个字符串 s，找到 s 中最长的回文子串。', 1500, 512, 0);
INSERT INTO `problems` (`id`, `problem_number`, `title`, `difficulty`, `total_submissions`, `acceptance_rate`, `tags`, `description`, `time_limit`, `memory_limit`, `accepted_submissions`) VALUES (51, '0031', '二叉树的层序遍历', '中等', 0, 0.00, '树,广度优先搜索', '给你一个二叉树，请你返回其按层序遍历得到的节点值。（即逐层地，从左到右访问所有节点）。', 1000, 256, 0);
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
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答案——题目解答代码';

-- ----------------------------
-- Records of solution_code
-- ----------------------------
BEGIN;
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (1, 1, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (2, 2, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (3, 3, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (4, 4, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    long long result = 1;\n    for(int i = 1; i <= n; i++) {\n        result *= i;\n    }\n    printf(\"%lld\\n\", result);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (5, 5, 1, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++) {\n        if(n % i == 0) return 0;\n    }\n    return 1;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPrime(n) ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (6, 6, 1, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (7, 7, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], min;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) min = arr[i];\n    }\n    printf(\"%d\\n\", min);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (8, 8, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (9, 9, 1, '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (10, 10, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", n % 2 == 0 ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (11, 11, 1, '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (12, 12, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100], ch;\n    scanf(\"%s %c\", str, &ch);\n    int count = 0;\n    for(int i = 0; str[i]; i++) {\n        if(str[i] == ch) count++;\n    }\n    printf(\"%d\\n\", count);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (13, 13, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[1000];\n    gets(str);\n    char *token = strtok(str, \" \");\n    printf(\"%s\", token);\n    token = strtok(NULL, \" \");\n    while(token != NULL) {\n        if(strcmp(token, \"world\") != 0) {\n            printf(\" %s\", token);\n        }\n        token = strtok(NULL, \" \");\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (14, 14, 1, '#include <stdio.h>\n\nint gcd(int a, int b) {\n    return b == 0 ? a : gcd(b, a % b);\n}\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", gcd(a, b));\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (15, 15, 1, '#include <stdio.h>\n\nint isPalindrome(int n) {\n    int reversed = 0, original = n;\n    while(n > 0) {\n        reversed = reversed * 10 + n % 10;\n        n /= 10;\n    }\n    return original == reversed;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPalindrome(n) ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (16, 16, 1, '#include <stdio.h>\n\nint main() {\n    int n, m;\n    scanf(\"%d %d\", &n, &m);\n    int mat1[10][10], mat2[10][10];\n    \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat1[i][j]);\n            \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat2[i][j]);\n            \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j < m; j++)\n            printf(\"%d \", mat1[i][j] + mat2[i][j]);\n        printf(\"\\n\");\n    }\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (17, 17, 1, '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (18, 18, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int triangle[30][30] = {0};\n    \n    for(int i = 0; i < n; i++) {\n        triangle[i][0] = 1;\n        for(int j = 1; j <= i; j++) {\n            triangle[i][j] = triangle[i-1][j-1] + triangle[i-1][j];\n        }\n    }\n    \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j <= i; j++) {\n            printf(\"%d \", triangle[i][j]);\n        }\n        printf(\"\\n\");\n    }\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (19, 19, 1, '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (20, 20, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], unique[100], uniqueCount = 0;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n        int isUnique = 1;\n        for(int j = 0; j < uniqueCount; j++) {\n            if(arr[i] == unique[j]) {\n                isUnique = 0;\n                break;\n            }\n        }\n        if(isUnique) unique[uniqueCount++] = arr[i];\n    }\n    for(int i = 0; i < uniqueCount; i++) {\n        printf(\"%d \", unique[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (21, 21, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], sum = 0;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n        sum += arr[i];\n    }\n    printf(\"%d\\n\", sum);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (22, 22, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (23, 23, 1, '#include <stdio.h>\n\nint fibonacci(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fibonacci(n));\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (25, 25, 1, '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", (n % 2 == 0) ? \"是\" : \"否\");\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (29, 29, 1, '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char binary[33];\n    scanf(\"%s\", binary);\n    int decimal = 0;\n    int len = strlen(binary);\n    for(int i = 0; i < len; i++) {\n        decimal = decimal * 2 + (binary[i] - \'0\');\n    }\n    printf(\"%d\\n\", decimal);\n    return 0;\n}', '1.0', '2025-02-10 04:35:22', '2025-02-10 04:35:22');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (38, 1, 2, 'a, b = map(int, input().split())\nprint(a + b)', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (39, 1, 3, '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}\njava', '1.0', '2025-02-10 05:00:38', '2025-04-03 08:05:29');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (40, 1, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << a + b << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (41, 2, 2, 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (42, 2, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (43, 2, 4, '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (44, 3, 2, 's = input().strip()\nprint(s[::-1])', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (45, 3, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String s = new Scanner(System.in).next();\n        System.out.println(new StringBuilder(s).reverse());\n    }\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (46, 3, 4, '#include <iostream>\n#include <algorithm>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    reverse(s.begin(), s.end());\n    cout << s << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (47, 4, 2, 'n = int(input())\nfrom math import factorial\nprint(factorial(n))', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (48, 4, 3, 'import java.math.BigInteger;\nimport java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        BigInteger result = BigInteger.ONE;\n        for(int i=2; i<=n; i++){\n            result = result.multiply(BigInteger.valueOf(i));\n        }\n        System.out.println(result);\n    }\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (49, 4, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    long long fact = 1;\n    for(int i=2; i<=n; ++i) fact *= i;\n    cout << fact << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (50, 5, 2, 'def is_prime(n):\n    if n <= 1: return False\n    for i in range(2, int(n**0.5)+1):\n        if n%i == 0: return False\n    return True\n\nn = int(input())\nprint(\"是\" if is_prime(n) else \"否\")', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (51, 5, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static boolean isPrime(int n) {\n        if(n <= 1) return false;\n        for(int i=2; i*i<=n; i++)\n            if(n%i == 0) return false;\n        return true;\n    }\n    \n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        System.out.println(isPrime(n) ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (52, 5, 4, '#include <iostream>\n#include <cmath>\nusing namespace std;\n\nbool isPrime(int n) {\n    if(n <= 1) return false;\n    for(int i=2; i<=sqrt(n); ++i)\n        if(n%i == 0) return false;\n    return true;\n}\n\nint main() {\n    int n; cin >> n;\n    cout << (isPrime(n) ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:00:38', '2025-02-10 05:00:38');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (53, 6, 2, 'a, b = map(int, input().split())\nprint(a - b)', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (54, 6, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        System.out.println(a - b);\n    }\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (55, 6, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << a - b << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (56, 7, 2, 'n = int(input())\narr = list(map(int, input().split()))\nprint(min(arr))', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (57, 7, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int min = Integer.MAX_VALUE;\n        while(n-- > 0) {\n            min = Math.min(min, sc.nextInt());\n        }\n        System.out.println(min);\n    }\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (58, 7, 4, '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int min_val = INT_MAX;\n    while(n--) {\n        cin >> tmp;\n        if(tmp < min_val) min_val = tmp;\n    }\n    cout << min_val << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (59, 8, 2, 's1, s2 = input().split()\nprint(s1 + s2)', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (60, 8, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String s1 = sc.next();\n        String s2 = sc.next();\n        System.out.println(s1 + s2);\n    }\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (61, 8, 4, '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string s1, s2;\n    cin >> s1 >> s2;\n    cout << s1 + s2 << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (62, 9, 2, 'n = int(input())\na, b = 0, 1\nfor _ in range(n):\n    a, b = b, a + b\nprint(a)', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (63, 9, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        int a = 0, b = 1;\n        for(int i=0; i<n; i++) {\n            int c = a + b;\n            a = b;\n            b = c;\n        }\n        System.out.println(a);\n    }\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (64, 9, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int a = 0, b = 1;\n    for(int i=0; i<n; ++i) {\n        int c = a + b;\n        a = b;\n        b = c;\n    }\n    cout << a << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (65, 10, 2, 'n = int(input())\nprint(\"是\" if n % 2 == 0 else \"否\")', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (66, 10, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        System.out.println(n % 2 == 0 ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (67, 10, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    cout << (n % 2 == 0 ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:02:47', '2025-02-10 05:02:47');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (68, 11, 2, 'n = int(input())\narr = list(map(int, input().split()))\nfor i in range(n-1):\n    for j in range(n-i-1):\n        if arr[j] > arr[j+1]:\n            arr[j], arr[j+1] = arr[j+1], arr[j]\nprint(\" \".join(map(str, arr)))', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (69, 11, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int[] arr = new int[n];\n        for(int i=0; i<n; i++) arr[i] = sc.nextInt();\n        \n        for(int i=0; i<n-1; i++) {\n            for(int j=0; j<n-i-1; j++) {\n                if(arr[j] > arr[j+1]) {\n                    int temp = arr[j];\n                    arr[j] = arr[j+1];\n                    arr[j+1] = temp;\n                }\n            }\n        }\n        for(int num : arr) System.out.print(num + \" \");\n    }\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (70, 11, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int arr[100];\n    for(int i=0; i<n; ++i) cin >> arr[i];\n    \n    for(int i=0; i<n-1; ++i)\n        for(int j=0; j<n-i-1; ++j)\n            if(arr[j] > arr[j+1])\n                swap(arr[j], arr[j+1]);\n    \n    for(int i=0; i<n; ++i) cout << arr[i] << \" \";\n    return 0;\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (71, 12, 2, 's, c = input().split()\nprint(s.count(c))', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (72, 12, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String s = sc.next();\n        char target = sc.next().charAt(0);\n        int count = 0;\n        for(char ch : s.toCharArray()) {\n            if(ch == target) count++;\n        }\n        System.out.println(count);\n    }\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (73, 12, 4, '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string s;\n    char target;\n    cin >> s >> target;\n    int count = 0;\n    for(char c : s) {\n        if(c == target) count++;\n    }\n    cout << count << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (74, 13, 2, 's = input().split()\nprint(\" \".join([word for word in s if word != \"world\"]))', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (75, 13, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String[] words = sc.nextLine().split(\" \");\n        StringBuilder sb = new StringBuilder();\n        for(String word : words) {\n            if(!word.equals(\"world\")) {\n                sb.append(word).append(\" \");\n            }\n        }\n        System.out.println(sb.toString().trim());\n    }\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (76, 13, 4, '#include <iostream>\n#include <string>\n#include <sstream>\nusing namespace std;\n\nint main() {\n    string line, word;\n    getline(cin, line);\n    stringstream ss(line);\n    bool first = true;\n    \n    while(ss >> word) {\n        if(word != \"world\") {\n            if(!first) cout << \" \";\n            cout << word;\n            first = false;\n        }\n    }\n    return 0;\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (77, 14, 2, 'a, b = map(int, input().split())\nimport math\nprint(math.gcd(a, b))', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (78, 14, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static int gcd(int a, int b) {\n        return b == 0 ? a : gcd(b, a % b);\n    }\n    \n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        System.out.println(gcd(a, b));\n    }\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (79, 14, 4, '#include <iostream>\nusing namespace std;\n\nint gcd(int a, int b) {\n    return b == 0 ? a : gcd(b, a % b);\n}\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << gcd(a, b) << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (80, 15, 2, 'n = input()\nprint(\"是\" if n == n[::-1] else \"否\")', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (81, 15, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String n = new Scanner(System.in).next();\n        System.out.println(new StringBuilder(n).reverse().toString().equals(n) ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (82, 15, 4, '#include <iostream>\n#include <string>\n#include <algorithm>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    string rev = s;\n    reverse(rev.begin(), rev.end());\n    cout << (s == rev ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:05:55', '2025-02-10 05:05:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (83, 16, 2, 'n, m = map(int, input().split())\nmat1 = [list(map(int, input().split())) for _ in range(n)]\nmat2 = [list(map(int, input().split())) for _ in range(n)]\nfor i in range(n):\n    print(\" \".join(map(str, [a+b for a,b in zip(mat1[i], mat2[i])])))', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (84, 16, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int m = sc.nextInt();\n        int[][] mat1 = new int[n][m];\n        int[][] mat2 = new int[n][m];\n        \n        for(int i=0; i<n; i++)\n            for(int j=0; j<m; j++)\n                mat1[i][j] = sc.nextInt();\n        \n        for(int i=0; i<n; i++)\n            for(int j=0; j<m; j++)\n                mat2[i][j] = sc.nextInt();\n        \n        for(int i=0; i<n; i++) {\n            for(int j=0; j<m; j++)\n                System.out.print((mat1[i][j]+mat2[i][j]) + \" \");\n            System.out.println();\n        }\n    }\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (85, 16, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n, m;\n    cin >> n >> m;\n    int mat1[10][10], mat2[10][10];\n    \n    for(int i=0; i<n; ++i)\n        for(int j=0; j<m; ++j)\n            cin >> mat1[i][j];\n    \n    for(int i=0; i<n; ++i)\n        for(int j=0; j<m; ++j)\n            cin >> mat2[i][j];\n    \n    for(int i=0; i<n; ++i) {\n        for(int j=0; j<m; ++j)\n            cout << mat1[i][j] + mat2[i][j] << \" \";\n        cout << endl;\n    }\n    return 0;\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (86, 17, 2, 'print(\" \".join(input().split()[::-1]))', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (87, 17, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] words = new Scanner(System.in).nextLine().split(\" \");\n        for(int i=words.length-1; i>=0; i--)\n            System.out.print(words[i] + (i>0 ? \" \" : \"\"));\n    }\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (88, 17, 4, '#include <iostream>\n#include <sstream>\n#include <vector>\nusing namespace std;\n\nint main() {\n    string line, word;\n    vector<string> words;\n    getline(cin, line);\n    stringstream ss(line);\n    \n    while(ss >> word) words.push_back(word);\n    \n    for(int i=words.size()-1; i>=0; --i)\n        cout << words[i] << (i>0 ? \" \" : \"\");\n    return 0;\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (89, 18, 2, 'n = int(input())\ntri = [[1]*(i+1) for i in range(n)]\nfor i in range(2, n):\n    for j in range(1, i):\n        tri[i][j] = tri[i-1][j-1] + tri[i-1][j]\nfor row in tri:\n    print(\" \".join(map(str, row)))', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (90, 18, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        int[][] tri = new int[n][];\n        for(int i=0; i<n; i++) {\n            tri[i] = new int[i+1];\n            tri[i][0] = 1;\n            for(int j=1; j<i; j++)\n                tri[i][j] = tri[i-1][j-1] + tri[i-1][j];\n            tri[i][i] = 1;\n        }\n        for(int[] row : tri) {\n            for(int num : row) System.out.print(num + \" \");\n            System.out.println();\n        }\n    }\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (91, 18, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int tri[30][30] = {0};\n    \n    for(int i=0; i<n; ++i) {\n        tri[i][0] = 1;\n        for(int j=1; j<=i; ++j)\n            tri[i][j] = tri[i-1][j-1] + tri[i-1][j];\n    }\n    \n    for(int i=0; i<n; ++i) {\n        for(int j=0; j<=i; ++j)\n            cout << tri[i][j] << \" \";\n        cout << endl;\n    }\n    return 0;\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (92, 19, 2, 'def is_prime(n):\n    if n < 2: return False\n    for i in range(2, int(n**0.5)+1):\n        if n%i ==0: return False\n    return True\n\nstart, end = map(int, input().split())\nprimes = [str(i) for i in range(start, end+1) if is_prime(i)]\nprint(\" \".join(primes) if primes else \"\")', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (93, 19, 3, 'import java.util.*;\n\npublic class Main {\n    static boolean isPrime(int n) {\n        if(n < 2) return false;\n        for(int i=2; i*i<=n; i++)\n            if(n%i ==0) return false;\n        return true;\n    }\n    \n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        StringBuilder sb = new StringBuilder();\n        for(int i=a; i<=b; i++) {\n            if(isPrime(i)) sb.append(i).append(\" \");\n        }\n        System.out.println(sb.length()>0 ? sb.toString().trim() : \"\");\n    }\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (94, 19, 4, '#include <iostream>\n#include <cmath>\nusing namespace std;\n\nbool isPrime(int n) {\n    if(n <= 1) return false;\n    for(int i=2; i<=sqrt(n); ++i)\n        if(n%i == 0) return false;\n    return true;\n}\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    bool first = true;\n    for(int i=a; i<=b; ++i) {\n        if(isPrime(i)) {\n            if(!first) cout << \" \";\n            cout << i;\n            first = false;\n        }\n    }\n    return 0;\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (95, 20, 2, 'n = int(input())\narr = list(map(int, input().split()))\nseen = set()\nresult = []\nfor num in arr:\n    if num not in seen:\n        seen.add(num)\n        result.append(str(num))\nprint(\" \".join(result))', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (96, 20, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        LinkedHashSet<Integer> set = new LinkedHashSet<>();\n        while(n-- > 0) set.add(sc.nextInt());\n        for(int num : set) System.out.print(num + \" \");\n    }\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (97, 20, 4, '#include <iostream>\n#include <unordered_set>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    unordered_set<int> seen;\n    int arr[100];\n    \n    for(int i=0; i<n; ++i) {\n        cin >> tmp;\n        if(seen.insert(tmp).second) {\n            cout << tmp << \" \";\n        }\n    }\n    return 0;\n}', '1.0', '2025-02-10 05:13:51', '2025-02-10 05:13:51');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (98, 21, 2, 'n = int(input())\nprint(sum(map(int, input().split())))', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (99, 21, 3, 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int sum = 0;\n        while(n-- > 0) sum += sc.nextInt();\n        System.out.println(sum);\n    }\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (100, 21, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n, tmp, sum = 0;\n    cin >> n;\n    while(n--) {\n        cin >> tmp;\n        sum += tmp;\n    }\n    cout << sum << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (101, 22, 2, 's = input().strip()\nprint(s[::-1])', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (102, 22, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String s = new Scanner(System.in).next();\n        System.out.println(new StringBuilder(s).reverse());\n    }\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (103, 22, 4, '#include <iostream>\n#include <algorithm>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    reverse(s.begin(), s.end());\n    cout << s << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (104, 23, 2, 'n = int(input())\na, b = 0, 1\nfor _ in range(n):\n    a, b = b, a + b\nprint(a)', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (105, 23, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        int a = 0, b = 1;\n        for(int i=0; i<n; i++) {\n            int c = a + b;\n            a = b;\n            b = c;\n        }\n        System.out.println(a);\n    }\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (106, 23, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    int a = 0, b = 1;\n    for(int i=0; i<n; ++i) {\n        int c = a + b;\n        a = b;\n        b = c;\n    }\n    cout << a << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (110, 25, 2, 'n = int(input())\nprint(\"是\" if n % 2 == 0 else \"否\")', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (111, 25, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        int n = new Scanner(System.in).nextInt();\n        System.out.println(n % 2 == 0 ? \"是\" : \"否\");\n    }\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (112, 25, 4, '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;\n    cout << (n % 2 == 0 ? \"是\" : \"否\") << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (122, 29, 2, 'print(int(input(), 2))', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (123, 29, 3, 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        String binary = new Scanner(System.in).next();\n        System.out.println(Integer.parseInt(binary, 2));\n    }\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (124, 29, 4, '#include <iostream>\n#include <string>\nusing namespace std;\n\nint main() {\n    string s;\n    cin >> s;\n    int num = 0;\n    for(char c : s)\n        num = num * 2 + (c - \'0\');\n    cout << num << endl;\n    return 0;\n}', '1.0', '2025-02-10 05:14:07', '2025-02-10 05:14:07');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (128, 33, 1, 'ccccc', '1.0', '2025-02-26 02:45:04', '2025-02-26 02:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (129, 33, 4, 'c++ccccc', '1.0', '2025-02-26 02:45:04', '2025-02-26 02:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (130, 33, 3, 'javaccccc', '1.0', '2025-02-26 02:45:04', '2025-02-26 02:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (131, 33, 2, 'pythoncccccc', '1.0', '2025-02-26 02:45:04', '2025-02-26 02:59:54');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (132, 34, 1, '', '1.0', '2025-02-26 02:49:52', '2025-02-26 02:49:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (133, 34, 2, '', '1.0', '2025-02-26 02:49:52', '2025-02-26 02:49:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (134, 34, 3, 'ceshi', '1.0', '2025-02-26 02:49:52', '2025-02-26 02:51:55');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (135, 34, 4, 'ceshi', '1.0', '2025-02-26 02:49:52', '2025-02-26 02:53:02');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (136, 35, 1, 'dawd', '1.0', '2025-02-26 03:00:52', '2025-02-26 03:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (137, 35, 4, 'dwada', '1.0', '2025-02-26 03:00:52', '2025-02-26 03:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (138, 35, 3, 'dwada', '1.0', '2025-02-26 03:00:52', '2025-02-26 03:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (139, 35, 2, 'dawdaw', '1.0', '2025-02-26 03:00:52', '2025-02-26 03:00:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (144, 37, 1, '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}\n？？？', '1.0', '2025-04-14 17:37:43', '2025-04-17 06:24:30');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (145, 37, 4, '#include <iostream>\n#include <vector>\n#include <queue>\nusing namespace std;\n\nstruct TreeNode {\n    int val;\n    TreeNode *left;\n    TreeNode *right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}\n};\n\nclass Solution {\npublic:\n    vector<vector<int>> levelOrder(TreeNode* root) {\n        vector<vector<int>> result;\n        if (!root) return result;\n        \n        queue<TreeNode*> q;\n        q.push(root);\n        \n        while (!q.empty()) {\n            int levelSize = q.size();\n            vector<int> currentLevel;\n            \n            for (int i = 0; i < levelSize; i++) {\n                TreeNode* node = q.front();\n                q.pop();\n                \n                currentLevel.push_back(node->val);\n                \n                if (node->left) q.push(node->left);\n                if (node->right) q.push(node->right);\n            }\n            \n            result.push_back(currentLevel);\n        }\n        \n        return result;\n    }\n};', '1.0', '2025-04-14 17:37:43', '2025-04-14 17:37:43');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (146, 37, 3, '// Java 简化解决方案\npublic List<List<Integer>> levelOrder(TreeNode root) {\n    // 使用队列实现二叉树层序遍历\n    // 返回二维列表表示层序遍历结果\n    return new ArrayList<>();\n}', '1.0', '2025-04-14 17:37:43', '2025-04-14 17:37:43');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (147, 37, 2, '# Python 简化解决方案\ndef levelOrder(root):\n    # 使用队列实现二叉树层序遍历\n    # 返回二维数组表示层序遍历结果\n    pass', '1.0', '2025-04-14 17:37:43', '2025-04-14 17:37:43');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (160, 41, 1, '// C 解决方案\nchar* longestPalindrome(char* s) {\n    int n = strlen(s);\n    if (n == 0) return \"\";\n    \n    int start = 0, max_len = 1;\n    \n    // 辅助函数：从中心扩展\n    for (int i = 0; i < n; i++) {\n        // 奇数长度回文\n        int left = i, right = i;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n        \n        // 偶数长度回文\n        left = i, right = i + 1;\n        while (left >= 0 && right < n && s[left] == s[right]) {\n            if (right - left + 1 > max_len) {\n                max_len = right - left + 1;\n                start = left;\n            }\n            left--;\n            right++;\n        }\n    }\n    \n    char* result = malloc(max_len + 1);\n    strncpy(result, s + start, max_len);\n    result[max_len] = 0;\n    return result;\n}', '1.0', '2025-04-17 06:33:52', '2025-04-17 06:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (161, 41, 4, '#include <iostream>\n#include <string>\n#include <vector>\nusing namespace std;\n\nclass Solution {\npublic:\n    string longestPalindrome(string s) {\n        int n = s.size();\n        if (n < 2) return s;\n        \n        int maxLen = 1;\n        int begin = 0;\n        vector<vector<bool>> dp(n, vector<bool>(n, false));\n        \n        // 所有单个字符都是回文\n        for (int i = 0; i < n; i++) {\n            dp[i][i] = true;\n        }\n        \n        // 检查长度为2及以上的子串\n        for (int L = 2; L <= n; L++) {\n            for (int i = 0; i < n; i++) {\n                int j = i + L - 1;\n                if (j >= n) break;\n                \n                if (s[i] != s[j]) {\n                    dp[i][j] = false;\n                } else {\n                    if (j - i < 3) {\n                        dp[i][j] = true;\n                    } else {\n                        dp[i][j] = dp[i+1][j-1];\n                    }\n                }\n                \n                if (dp[i][j] && j - i + 1 > maxLen) {\n                    maxLen = j - i + 1;\n                    begin = i;\n                }\n            }\n        }\n        \n        return s.substr(begin, maxLen);\n    }\n};', '1.0', '2025-04-17 06:33:52', '2025-04-17 06:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (162, 41, 3, '// Java 解决方案\npublic String longestPalindrome(String s) {\n    if (s == null || s.length() < 1) return \"\";\n    \n    int start = 0, end = 0;\n    \n    for (int i = 0; i < s.length(); i++) {\n        int len1 = expandAroundCenter(s, i, i);\n        int len2 = expandAroundCenter(s, i, i + 1);\n        int len = Math.max(len1, len2);\n        if (len > end - start) {\n            start = i - (len - 1) / 2;\n            end = i + len / 2;\n        }\n    }\n    \n    return s.substring(start, end + 1);\n}\n\nprivate int expandAroundCenter(String s, int left, int right) {\n    while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {\n        left--;\n        right++;\n    }\n    return right - left - 1;\n}', '1.0', '2025-04-17 06:33:52', '2025-04-17 06:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (163, 41, 2, '# Python 简化解决方案\ndef longestPalindrome(s):\n    # 实现寻找最长回文子串的算法\n    # 返回最长回文子串\n    pass', '1.0', '2025-04-17 06:33:52', '2025-04-17 06:33:52');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (196, 50, 1, '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}', '1.0', '2025-05-03 15:29:05', '2025-05-03 15:29:05');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (197, 50, 4, '#include <iostream>\n#include <vector>\n#include <queue>\nusing namespace std;\n\nstruct TreeNode {\n    int val;\n    TreeNode *left;\n    TreeNode *right;\n    TreeNode() : val(0), left(nullptr), right(nullptr) {}\n    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}\n    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}\n};\n\nclass Solution {\npublic:\n    vector<vector<int>> levelOrder(TreeNode* root) {\n        vector<vector<int>> result;\n        if (!root) return result;\n        \n        queue<TreeNode*> q;\n        q.push(root);\n        \n        while (!q.empty()) {\n            int levelSize = q.size();\n            vector<int> currentLevel;\n            \n            for (int i = 0; i < levelSize; i++) {\n                TreeNode* node = q.front();\n                q.pop();\n                \n                currentLevel.push_back(node->val);\n                \n                if (node->left) q.push(node->left);\n                if (node->right) q.push(node->right);\n            }\n            \n            result.push_back(currentLevel);\n        }\n        \n        return result;\n    }\n};', '1.0', '2025-05-03 15:29:05', '2025-05-03 15:29:05');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (198, 50, 3, '// Java 简化解决方案\npublic List<List<Integer>> levelOrder(TreeNode root) {\n    // 使用队列实现二叉树层序遍历\n    // 返回二维列表表示层序遍历结果\n    return new ArrayList<>();\n}', '1.0', '2025-05-03 15:29:05', '2025-05-03 15:29:05');
INSERT INTO `solution_code` (`id`, `solution_id`, `language_id`, `standard_solution`, `version`, `created_at`, `updated_at`) VALUES (199, 50, 2, '# Python 简化解决方案\ndef levelOrder(root):\n    # 使用队列实现二叉树层序遍历\n    # 返回二维数组表示层序遍历结果\n    pass', '1.0', '2025-05-03 15:29:05', '2025-05-03 15:29:05');
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
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (1, 'c', '#include <stdio.h>\n\nint main() {\n    // 你的代码\n    return 0;\n}', '2025-02-10 04:35:22');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (2, 'python', 'def solution():\n    # 你的代码\n    pass', '2025-02-10 04:40:33');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (3, 'java', 'public class Solution {\n    public static void main(String[] args) {\n        // 你的代码\n    }\n}', '2025-02-10 04:40:33');
INSERT INTO `solution_languages` (`id`, `language_name`, `code_template`, `created_at`) VALUES (4, 'cpp', '#include <iostream>\nusing namespace std;\n\nint main() {\n    // 代码实现\n    return 0;\n}', '2025-02-10 04:53:23');
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
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='答案——题目解答方案、时空复杂度';

-- ----------------------------
-- Records of solution_main
-- ----------------------------
BEGIN;
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (1, 1, '0001', '直接读取两个整数并相加输出即可。注意使用scanf读取输入，printf输出结果。', 'O(1)', 'O(1)', '2025-02-10 04:35:22', '2025-04-20 06:39:19');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (2, 2, '0002', '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最大值，遍历数组更新最大值。', 'O(n)', 'O(n)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (3, 3, '0003', '读取字符串后，从后向前遍历字符串，依次输出每个字符即可得到反转结果。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (4, 4, '0004', '使用循环从1乘到n，注意使用long long类型避免整数溢出。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (5, 5, '0005', '定义isPrime函数判断是否为质数。从2到sqrt(n)遍历，如果n能被任何数整除则不是质数。', 'O(sqrt(n))', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (6, 6, '0006', '直接读取两个整数并相减输出即可。', 'O(1)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (7, 7, '0007', '先读取数组长度，然后依次读取数组元素。用一个变量记录当前最小值，遍历数组更新最小值。', 'O(n)', 'O(n)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (8, 8, '0008', '读取两个字符串后直接拼接输出即可。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (9, 9, '0009', '使用循环计算斐波那契数列。维护两个变量记录前两个数，不断更新得到下一个数。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (10, 10, '0010', '判断一个数除以2的余数是否为0即可。使用取模运算符%。', 'O(1)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (11, 11, '0011', '使用冒泡排序算法，通过两层循环不断比较相邻元素并交换位置，将最大的元素逐步\"冒泡\"到数组末尾。', 'O(n^2)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (12, 12, '0012', '遍历字符串，统计目标字符出现的次数。使用循环和计数器实现。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (13, 13, '0013', '使用strtok函数分割字符串，遍历所有单词，跳过\"world\"单词不输出。注意处理空格和字符串拼接。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (14, 14, '0014', '使用欧几里得算法（辗转相除法）求最大公约数。递归实现：当b为0时返回a，否则递归计算gcd(b, a%b)。', 'O(log(min(a,b)))', 'O(log(min(a,b)))', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (15, 15, '0015', '将数字反转，如果反转后的数字等于原数字，则是回文数。使用取模和除法运算逐位提取数字并重新组合。', 'O(log n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (16, 16, '0016', '使用二维数组存储两个矩阵，对应位置的元素相加即可。注意输出格式的处理。', 'O(n*m)', 'O(n*m)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (17, 17, '0017', '先将字符串按空格分割成单词数组，然后从后向前遍历数组输出单词。注意处理单词之间的空格。', 'O(n)', 'O(n)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (18, 18, '0018', '使用二维数组存储杨辉三角，每个数是上一行相邻两个数的和。第一列全为1，其他位置的值等于上一行的相邻两个数之和。', 'O(n^2)', 'O(n^2)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (19, 19, '0019', '在给定范围内遍历每个数，使用isPrime函数判断是否为质数。注意输出格式，数字之间需要空格分隔。', 'O((end-start)*sqrt(max(end)))', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (20, 20, '0020', '使用一个新数组存储不重复的元素。遍历原数组，对于每个元素，检查是否已经在新数组中存在，如果不存在则添加到新数组。', 'O(n^2)', 'O(n)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (21, 21, '0021', '使用一个变量sum累加数组中的每个元素。遍历一次数组即可得到总和。', 'O(n)', 'O(n)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (22, 22, '0022', '从字符串末尾向前遍历，依次输出每个字符即可得到反转的字符串。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (23, 23, '0023', '使用迭代方法计算斐波那契数列。维护三个变量a、b、c，其中a和b分别表示前两个数，c用于计算它们的和。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (25, 25, '0024', '判断一个数是否为偶数，只需要判断它除以2的余数是否为0。使用取模运算符%即可。', 'O(1)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (29, 29, '0025', '从左到右遍历二进制字符串，对于每一位，将当前结果乘2再加上当前位的值。注意字符转数字需要减去字符\'0\'的ASCII值。', 'O(n)', 'O(1)', '2025-02-10 04:35:22', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (33, 33, '0027', '对应题目0027', 'O(N)', 'O(1)', '2025-02-26 02:45:04', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (34, 30, '0026', '对应题目0028', '', '', '2025-02-26 02:49:52', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (35, 34, '0028', '对应题目0029', '11', '11', '2025-02-26 03:00:52', '2025-04-17 06:44:58');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (37, 38, '0029', '使用队列实现广度优先搜索，逐层处理二叉树节点。', 'O(n)', 'O(n)', '2025-04-14 17:37:43', '2025-04-17 06:54:48');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (41, 42, '0030', '动态规划方法：利用状态转移方程 P(i,j)=(P(i+1,j−1) and S[i]==S[j])，逐步找到最长回文子串。', 'O(n²)', 'O(n²)', '2025-04-17 06:33:52', '2025-04-17 06:54:48');
INSERT INTO `solution_main` (`id`, `problem_id`, `problem_number`, `solution_approach`, `time_complexity`, `space_complexity`, `created_at`, `updated_at`) VALUES (50, 51, '0031', '使用队列实现广度优先搜索，逐层处理二叉树节点。', 'O(n)', 'O(n)', '2025-05-03 15:29:05', '2025-05-04 11:38:51');
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
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (1, 1, '202313008218', '吴益通', '人文学院', '舞蹈学', '2023', '2025-03-04 22:44:14', '2025-03-05 17:16:48', 3);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (24, 11, '202313008221', '张伟', '理工学院', '计算机科学与技术', '2023', '2025-04-18 09:16:17', '2025-04-22 22:45:35', 1);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (25, 12, '202313008222', '李娜', '理工学院', '软件工程', '2023', '2025-04-18 09:16:17', NULL, 2);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (26, 13, '202313008223', '王强', '理工学院', '数据科学与大数据技术', '2023', '2025-04-18 09:16:17', NULL, 3);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (27, 14, '202313008224', '赵敏', '理工学院', '人工智能', '2023', '2025-04-18 09:16:17', NULL, 5);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (28, 15, '202313008225', '陈明', '理工学院', '物联网工程', '2023', '2025-04-18 09:16:17', NULL, 6);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (30, 17, '202313008227', '杨帆', '人文学院', '英语', '2023', '2025-04-18 09:16:17', NULL, 8);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (31, 18, '202313008228', '周杰', '人文学院', '新闻学', '2023', '2025-04-18 09:16:17', NULL, 9);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (32, 19, '202313008229', '吴丽', '人文学院', '历史学', '2023', '2025-04-18 09:16:17', NULL, 10);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (33, 20, '202313008230', '徐刚', '教育学院', '教育学', '2023', '2025-04-18 09:16:17', NULL, 1);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (34, 21, '202313008231', '马琳', '教育学院', '学前教育', '2023', '2025-04-18 09:16:17', NULL, 2);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (35, 22, '202313008232', '郭峰', '教育学院', '特殊教育', '2023', '2025-04-18 09:16:17', NULL, 3);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (36, 23, '202313008233', '何静', '体育学院', '体育教育', '2023', '2025-04-18 09:16:17', NULL, 4);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (37, 24, '202313008234', '孙宇', '体育学院', '运动训练', '2023', '2025-04-18 09:16:17', NULL, 5);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (38, 25, '202313008235', '林涛', '体育学院', '体育经济与管理', '2023', '2025-04-18 09:16:17', NULL, 6);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (39, 26, '202313008236', '朱琪', '美术学院', '美术学', '2023', '2025-04-18 09:16:17', NULL, 7);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (40, 27, '202313008237', '胡明', '美术学院', '动画', '2023', '2025-04-18 09:16:17', NULL, 8);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (41, 28, '202313008238', '冯雪', '美术学院', '视觉传达设计', '2023', '2025-04-18 09:16:17', NULL, 9);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (42, 29, '202313008239', '董芳', '舞蹈学院', '舞蹈编导', '2023', '2025-04-18 09:16:17', NULL, 10);
INSERT INTO `student_info` (`id`, `user_id`, `student_no`, `real_name`, `department`, `major`, `grade`, `created_at`, `updated_at`, `class_id`) VALUES (43, 30, '202313008240', '蒋伟', '舞蹈学院', '舞蹈表演', '2023', '2025-04-18 09:16:17', NULL, 11);
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
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目——用户提交记录表';

-- ----------------------------
-- Records of submissions
-- ----------------------------
BEGIN;
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (1, 1, 1, '0001', 'dawdwa', 'c', 0, 632, 'Command failed: docker exec judge-d273ef5b-71fc-420c-a01d-e39ce74c6bcc bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dawdwa\n      | ^~~~~~\n', '2025-01-22 23:52:59', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (2, 1, 1, '0001', 'dwada', 'c_cpp', 0, 0, '不支持的编程语言: c_cpp', '2025-01-22 23:59:54', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (3, 1, 1, '0001', 'sdawddw', 'c', 0, 648, 'Command failed: docker exec judge-6e29f569-774a-463d-ac97-f2e050c99eea bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | sdawddw\n      | ^~~~~~~\n', '2025-01-23 00:00:09', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (4, 1, 1, '0001', 'dwadwa', 'c', 0, 632, 'Command failed: docker exec judge-b95bcccc-affd-4b1e-8d42-5870f375d7bf bash -c \"gcc -o /app/solution /app/solution.c && /app/solution < /app/input.txt\"\n/app/solution.c:1:1: error: expected \'=\', \',\', \';\', \'asm\' or \'__attribute__\' at end of input\n    1 | dwadwa\n      | ^~~~~~\n', '2025-01-23 00:03:09', 'Runtime Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (5, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', NULL, NULL, '题目或测试用例不存在', '2025-01-23 00:05:37', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (6, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 968, NULL, '2025-01-23 00:06:47', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (7, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-23 00:10:04', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (8, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 920, NULL, '2025-01-23 00:12:45', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (9, 1, 7, '0007', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int n;\n    cin >> n;  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        cin >> arr[i];\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    cout << min << endl;\n    return 0;\n}', 'cpp', 0, 912, NULL, '2025-01-23 00:14:48', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (10, 1, 7, '0007', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-23 00:18:03', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (11, 1, 7, '0007', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);  // 读取数组大小\n    \n    int arr[100];  // 假设数组最大长度为100\n    \n    // 读取数组元素\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    \n    // 找最小值\n    int min = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] < min) {\n            min = arr[i];\n        }\n    }\n    \n    printf(\"%d\\n\", min);\n    return 0;\n}', 'c', 0, 780, NULL, '2025-01-23 00:18:42', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (12, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'cpp', 0, 736, NULL, '2025-01-23 17:11:17', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (13, 1, 6, '0006', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 18:09:15', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (14, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-8c3a65c2-9edf-45b7-8f85-eb1850574220 -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 22:04:00', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (15, 1, 6, '0006', '？？？', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-506c7e0d-fa9f-4826-a515-6c6e21f2994c -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 22:04:38', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (16, 1, 9, '0009', '1111', '', NULL, NULL, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-2a428ea4-b310-490e-ab83-5a6ff1f4280b -w /app python:3.9-slim tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-23 22:05:19', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (17, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 34, NULL, '2025-01-23 22:06:31', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (18, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', '', 0, 0, '不支持的编程语言: ', '2025-01-23 22:08:28', 'System Error', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (19, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'c', 0, 720, NULL, '2025-01-23 22:08:44', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (20, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-24 00:24:13', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (21, 1, 3, '0003', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 2, NULL, '2025-01-24 00:24:55', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (22, 1, 4, '0004', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    long long result = 1;\n    for(int i = 1; i <= n; i++) {\n        result *= i;\n    }\n    printf(\"%lld\\n\", result);\n    return 0;\n}', 'c', 0, 916, NULL, '2025-01-24 00:28:04', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (23, 1, 5, '0005', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++) {\n        if(n % i == 0) return 0;\n    }\n    return 1;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPrime(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-24 00:28:24', 'Accepted', NULL);
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (29, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 724, 'Wrong Answer\n输入: 6\n期望输出: undefined\n实际输出: ', '2025-01-25 18:06:52', 'Wrong Answer', '2025-01-25 18:06:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (30, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'cpp', 0, 732, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 18:09:52', 'System Error', '2025-01-25 18:09:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (31, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 24, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 18:10:09', 'System Error', '2025-01-25 18:10:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (32, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 704, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 18:12:58', 'System Error', '2025-01-25 18:13:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (33, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, 'Wrong Answer\n输入: 6\n期望输出: 8\n实际输出: ', '2025-01-25 18:14:53', 'System Error', '2025-01-25 18:14:56');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (34, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 708, NULL, '2025-01-25 18:16:37', 'Accepted', '2025-01-25 18:16:45');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (35, 1, 9, '0009', '#include <stdio.h>\n\nint fib(int n) {\n    if(n <= 1) return n;\n    int a = 0, b = 1, c;\n    for(int i = 2; i <= n; i++) {\n        c = a + b;\n        a = b;\n        b = c;\n    }\n    return b;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\\n\", fib(n));\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-25 18:21:47', 'Accepted', '2025-01-25 18:21:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (36, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-25 20:18:43', 'Accepted', '2025-01-25 20:18:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (37, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 0, 'Command failed: docker run -d --network none --cpus=1 --memory=512m --name=judge-4c49472e-d895-4264-9605-d9f7561c0c28 -w /app gcc:latest tail -f /dev/null\ndocker: Cannot connect to the Docker daemon at unix:///Users/apple/.docker/run/docker.sock. Is the docker daemon running?.\nSee \'docker run --help\'.\n', '2025-01-26 19:47:20', 'System Error', '2025-01-26 19:47:20');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (38, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 36, NULL, '2025-01-26 19:55:03', 'Accepted', '2025-01-26 19:55:10');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (39, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 716, NULL, '2025-01-26 19:57:19', 'Accepted', '2025-01-26 19:57:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (40, 1, 11, '0011', '#include <stdio.h>\n\nvoid bubbleSort(int arr[], int n) {\n    for(int i = 0; i < n-1; i++) {\n        for(int j = 0; j < n-i-1; j++) {\n            if(arr[j] > arr[j+1]) {\n                int temp = arr[j];\n                arr[j] = arr[j+1];\n                arr[j+1] = temp;\n            }\n        }\n    }\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100];\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    bubbleSort(arr, n);\n    for(int i = 0; i < n; i++) {\n        printf(\"%d \", arr[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'cpp', 0, 29, NULL, '2025-01-26 19:58:57', 'Accepted', '2025-01-26 19:59:04');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (41, 1, 19, '0019', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 1, NULL, '2025-01-26 20:00:42', 'Accepted', '2025-01-26 20:00:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (42, 1, 19, '0019', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 768, NULL, '2025-01-26 20:02:21', 'Accepted', '2025-01-26 20:02:29');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (43, 1, 19, '0019', '#include <stdio.h>\n\nint isPrime(int n) {\n    if(n <= 1) return 0;\n    for(int i = 2; i * i <= n; i++)\n        if(n % i == 0) return 0;\n    return 1;\n}\n\nint main() {\n    int start, end;\n    scanf(\"%d %d\", &start, &end);\n    int first = 1;\n    for(int i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            if(!first) printf(\" \");\n            printf(\"%d\", i);\n            first = 0;\n        }\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 704, NULL, '2025-01-26 20:04:13', 'Accepted', '2025-01-26 20:04:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (44, 1, 15, '0015', '#include <stdio.h>\n\nint isPalindrome(int n) {\n    int reversed = 0, original = n;\n    while(n > 0) {\n        reversed = reversed * 10 + n % 10;\n        n /= 10;\n    }\n    return original == reversed;\n}\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", isPalindrome(n) ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 712, NULL, '2025-01-26 20:09:54', 'Accepted', '2025-01-26 20:10:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (45, 1, 10, '0010', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%s\\n\", n % 2 == 0 ? \"是\" : \"否\");\n    return 0;\n}', 'c', 0, 852, NULL, '2025-01-26 20:39:17', 'Accepted', '2025-01-26 20:39:24');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (46, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 20:42:37', 'Wrong Answer', '2025-01-26 20:42:40');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (47, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 740, NULL, '2025-01-26 20:44:06', 'Accepted', '2025-01-26 20:44:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (48, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 660, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 20:46:28', 'Wrong Answer', '2025-01-26 20:46:31');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (49, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 20:48:22', 'Wrong Answer', '2025-01-26 20:48:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (50, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 672, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 20:48:42', 'Wrong Answer', '2025-01-26 20:48:46');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (51, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 668, 'Wrong Answer\n输入: I love programming\n期望输出: programming love I\n实际输出: ', '2025-01-26 20:49:29', 'Wrong Answer', '2025-01-26 20:49:31');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (52, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    gets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 20:51:51', 'Wrong Answer', '2025-01-26 20:51:54');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (53, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 664, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 20:52:13', 'Wrong Answer', '2025-01-26 20:52:17');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (54, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 652, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 20:52:21', 'Wrong Answer', '2025-01-26 20:52:23');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (55, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 684, '提交结果：答案错误\n\n测试用例：\n输入：I love programming\n期望输出：programming love I\n您的输出：(无输出)\n\n请检查您的代码逻辑是否正确。', '2025-01-26 20:52:54', 'Wrong Answer', '2025-01-26 20:52:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (57, 1, 17, '0017', '#include <stdio.h>\n#include <string.h>\n\nvoid reverseWords(char *s) {\n    char words[100][100];\n    int wordCount = 0;\n    char *token = strtok(s, \" \");\n    while(token != NULL) {\n        strcpy(words[wordCount++], token);\n        token = strtok(NULL, \" \");\n    }\n    for(int i = wordCount-1; i >= 0; i--) {\n        printf(\"%s\", words[i]);\n        if(i > 0) printf(\" \");\n    }\n    printf(\"\\n\");\n}\n\nint main() {\n    char s[1000];\n    fgets(s, 1000, stdin);\n    reverseWords(s);\n    return 0;\n}', 'c', 0, 748, NULL, '2025-01-26 20:55:29', 'Accepted', '2025-01-26 20:55:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (58, 1, 3, '0003', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str[100];\n    scanf(\"%s\", str);\n    int len = strlen(str);\n    for(int i = len-1; i >= 0; i--) {\n        printf(\"%c\", str[i]);\n    }\n    printf(\"\\n\");\n    return 0;\n}', 'c', 0, 728, NULL, '2025-01-26 21:04:58', 'Accepted', '2025-01-26 21:05:05');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (59, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, 'Cannot read properties of undefined (reading \'0\')', '2025-02-06 00:43:55', 'System Error', '2025-02-06 00:43:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (60, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-02-06 00:45:48', 'System Error', '2025-02-06 00:45:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (61, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 00:47:35', 'Accepted', '2025-02-06 00:47:38');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (62, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 00:47:58', 'Accepted', '2025-02-06 00:48:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (63, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 00:49:49', 'Accepted', '2025-02-06 00:49:51');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (64, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 387, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 00:52:55', 'Wrong Answer', '2025-02-06 00:52:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (65, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 401, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 00:58:36', 'Wrong Answer', '2025-02-06 00:58:38');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (66, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 397, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 01:08:04', 'Wrong Answer', '2025-02-06 01:08:06');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (67, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 426, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 01:13:22', 'Wrong Answer', '2025-02-06 01:13:24');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (68, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 304, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 01:13:24', 'Wrong Answer', '2025-02-06 01:13:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (69, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 420, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 01:35:07', 'Wrong Answer', '2025-02-06 01:35:09');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (70, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 01:39:39', 'Accepted', '2025-02-06 01:39:42');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (71, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 01:40:23', 'Accepted', '2025-02-06 01:40:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (78, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 21:30:13', 'Accepted', '2025-02-06 21:30:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (79, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 21:31:52', 'Accepted', '2025-02-06 21:31:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (80, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'c', 298, 0, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-02-06 21:32:08', 'Wrong Answer', '2025-02-06 21:32:09');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (81, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 0, 0, NULL, '2025-02-06 22:05:19', 'Accepted', '2025-02-06 22:05:22');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (82, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 404, 0, NULL, '2025-02-06 22:06:46', 'Accepted', '2025-02-06 22:06:48');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (83, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'c', 381, 608, NULL, '2025-02-06 22:11:13', 'Accepted', '2025-02-06 22:11:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (84, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '运行时错误：\n不支持的编程语言\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-02-18 00:57:57', 'Runtime Error', '2025-02-18 00:57:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (85, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1286, 592, NULL, '2025-02-18 01:02:07', 'Accepted', '2025-02-18 01:02:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (86, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'C', 353, 680, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-03-08 00:03:48', 'Wrong Answer', '2025-03-08 00:03:51');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (87, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, NULL, '2025-04-03 16:56:05', 'System Error', '2025-04-03 16:56:05');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (88, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, NULL, '2025-04-03 16:58:58', 'System Error', '2025-04-03 16:58:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (89, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 2997, 592, NULL, '2025-04-03 17:00:32', 'Accepted', '2025-04-03 17:00:45');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (90, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1634, 592, NULL, '2025-04-05 04:08:30', 'Accepted', '2025-04-05 04:08:41');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (91, 1, 8, '0008', '#include <stdio.h>\n#include <string.h>\n\nint main() {\n    char str1[100], str2[100];\n    scanf(\"%s %s\", str1, str2);\n    printf(\"%s%s\\n\", str1, str2);\n    return 0;\n}', 'C', 521, 3, NULL, '2025-04-11 17:08:24', 'Accepted', '2025-04-11 17:08:28');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (92, 1, 30, '0026', '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}', 'C', 0, 0, '编译错误：\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1744703740984.c:2:25: warning: declaration of \'struct TreeNode\' will not be visible outside of this function [-Wvisibility]\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n                        ^\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1744703740984.c:5:1: warning: non-void function does not return a value [-Wreturn-type]\n}\n^\n2 warnings generated.\nUndefined symbols for architecture arm64:\n  \"_main\", referenced from:\n      <initial-undefines>\nld: symbol(s) not found for architecture arm64\nclang: error: linker command failed with exit code 1 (use -v to see invocation)\n\n\n请检查代码的语法是否正确。', '2025-04-15 23:55:39', 'System Error', '2025-04-15 23:55:41');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (93, 1, 30, '0026', '// C 简化解决方案\nint** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {\n    // 实现二叉树层序遍历的C语言代码\n    // 返回层序遍历结果\n}', 'C', 327, 592, '提交结果：答案错误\n\n测试用例：\n输入：6\n100 4 200 1 3 2\n期望输出：4\n您的输出：代码成功编译！\n\n请检查您的代码逻辑是否正确。', '2025-04-16 00:00:54', 'Wrong Answer', '2025-04-16 00:00:58');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (94, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1804, 600, NULL, '2025-04-17 05:52:01', 'Accepted', '2025-04-17 05:52:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (95, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'C', 0, 0, '编译错误：\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027111113.c:6:1: error: type specifier missing, defaults to \'int\'; ISO C99 and later do not support implicit int [-Wimplicit-int]\nn = int(input())\n^\nint\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027111113.c:6:5: error: expected expression\nn = int(input())\n    ^\n/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027111113.c:14:2: error: expected \';\' after top level declarator\n}\n ^\n ;\n3 errors generated.\n\n\n请检查代码的语法是否正确。', '2025-04-19 17:45:09', 'System Error', '2025-04-19 17:45:11');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (96, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'Python', 400, 676, '提交结果：答案错误\n\n测试用例：\n输入：5\n1 5 3 8 2\n期望输出：8\n您的输出：8\n代码成功运行！\n\n请检查您的代码逻辑是否正确。', '2025-04-19 17:46:32', 'Wrong Answer', '2025-04-19 17:46:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (97, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'Python', 60, 600, NULL, '2025-04-19 17:48:57', 'Accepted', '2025-04-19 17:49:00');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (98, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-030d7305-94ae-48cc-8876-67c16e562d4d javac /app/temp_1745027421133.java\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 17:50:19', 'Runtime Error', '2025-04-19 17:50:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (99, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, NULL, '2025-04-19 17:55:12', 'System Error', '2025-04-19 17:55:12');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (100, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, NULL, '2025-04-19 17:55:23', 'System Error', '2025-04-19 17:55:23');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (101, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027796653.java undefined:/app/temp_1745027796653.java\nError response from daemon: No such container: undefined\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 17:56:36', 'Runtime Error', '2025-04-19 17:56:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (102, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/temp/temp_1745027806126.java undefined:/app/temp_1745027806126.java\nError response from daemon: No such container: undefined\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 17:56:46', 'Runtime Error', '2025-04-19 17:56:46');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (103, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-cc9ea430-b42e-4eb8-821b-e40774c80c92 javac /app/temp_1745027966145.java\n/app/temp_1745027966145.java:3: error: class Main is public, should be declared in a file named Main.java\npublic class Main {\n       ^\n1 error\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 17:59:24', 'Runtime Error', '2025-04-19 17:59:26');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (104, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-7097e91e-1cab-478a-8cfe-c555d95d5dbb java -cp /app temp_1745028058713 < /app/input_1745028058713.txt\n/bin/sh: /app/input_1745028058713.txt: No such file or directory\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 18:00:57', 'Runtime Error', '2025-04-19 18:00:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (105, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-63815acf-2a86-42a4-9d19-880afba25908 bash -c \"cat /app/input_1745028165148.txt | java -cp /app temp_1745028165148\"\nError: Could not find or load main class temp_1745028165148\nCaused by: java.lang.ClassNotFoundException: temp_1745028165148\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 18:02:43', 'Runtime Error', '2025-04-19 18:02:45');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (106, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 105, 888, NULL, '2025-04-19 18:06:40', 'Accepted', '2025-04-19 18:06:44');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (107, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-04-19 18:12:16', 'System Error', '2025-04-19 18:12:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (108, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 0, 0, '系统错误：判题过程出现异常，请稍后重试。', '2025-04-19 18:13:19', 'System Error', '2025-04-19 18:13:19');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (109, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 595, 612, NULL, '2025-04-19 18:16:16', 'Accepted', '2025-04-19 18:16:20');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (110, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'C', 441, 596, NULL, '2025-04-19 18:24:53', 'Accepted', '2025-04-19 18:24:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (111, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'C', 401, 588, NULL, '2025-04-19 18:25:17', 'Accepted', '2025-04-19 18:25:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (112, 1, 2, '0002', 'n = int(input())\narr = list(map(int, input().split()))\nprint(max(arr))', 'Python', 70, 628, NULL, '2025-04-19 18:31:07', 'Accepted', '2025-04-19 18:31:10');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (113, 1, 2, '0002', '#include <iostream>\n#include <climits>\nusing namespace std;\n\nint main() {\n    int n, tmp;\n    cin >> n;\n    int max_val = INT_MIN;\n    while(n--) {\n        cin >> tmp;\n        if(tmp > max_val) max_val = tmp;\n    }\n    cout << max_val << endl;\n    return 0;\n}', 'C++', 578, 592, NULL, '2025-04-19 18:31:22', 'Accepted', '2025-04-19 18:31:27');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (114, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-06d492de-c61c-472e-952c-198f2d6df4d1 javac /app/temp_1745029906518.java\n/app/temp_1745029906518.java:3: error: class Main is public, should be declared in a file named Main.java\npublic class Main {\n       ^\n1 error\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-19 18:31:45', 'Runtime Error', '2025-04-19 18:31:47');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (115, 1, 2, '0002', 'import java.util.*;\n\nclass Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 102, 892, NULL, '2025-04-19 18:31:55', 'Accepted', '2025-04-19 18:31:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (116, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1727, 596, NULL, '2025-04-19 18:48:36', 'Accepted', '2025-04-19 18:48:48');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (117, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    printf(\"5\");\n    return 0;\n}', 'C', 647, 600, '答案错误（隐藏用例）\n请检查您的代码逻辑是否正确。', '2025-04-20 18:12:44', 'Wrong Answer', '2025-04-20 18:12:49');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (118, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 314, 3, NULL, '2025-04-22 20:20:36', 'Accepted', '2025-04-22 20:20:48');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (119, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 280, 616, NULL, '2025-04-23 21:58:40', 'Accepted', '2025-04-23 21:58:52');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (120, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 234, 588, NULL, '2025-04-23 22:11:31', 'Accepted', '2025-04-23 22:11:43');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (121, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 225, 596, NULL, '2025-04-23 22:26:08', 'Accepted', '2025-04-23 22:26:19');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (122, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 214, 592, NULL, '2025-04-23 22:47:39', 'Accepted', '2025-04-23 22:47:50');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (123, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '编译错误：\n编译过程发生系统错误\n\n请检查代码的语法是否正确。', '2025-04-23 22:51:39', 'System Error', '2025-04-23 22:51:40');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (124, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '运行时错误：\n/bin/sh: /app/src/temp/463360a5-69c5-49c0-aab6-5bdb33c7b992/temp_1745420015719.out: not found\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-23 22:53:33', 'Runtime Error', '2025-04-23 22:53:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (125, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '运行时错误：\n程序执行时发生错误\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-04-23 22:54:31', 'Runtime Error', '2025-04-23 22:54:36');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (126, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1811, 736, NULL, '2025-04-23 22:55:47', 'Accepted', '2025-04-23 22:55:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (127, 1, 2, '0002', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int arr[100], max;\n    for(int i = 0; i < n; i++) {\n        scanf(\"%d\", &arr[i]);\n    }\n    max = arr[0];\n    for(int i = 1; i < n; i++) {\n        if(arr[i] > max) max = arr[i];\n    }\n    printf(\"%d\\n\", max);\n    return 0;\n}', 'C', 295, 2, NULL, '2025-04-23 22:57:50', 'Accepted', '2025-04-23 22:57:55');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (128, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1496, 35, NULL, '2025-04-29 02:24:56', 'Accepted', '2025-04-29 02:25:08');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (129, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1303, 820, NULL, '2025-04-30 20:30:58', 'Accepted', '2025-04-30 20:31:09');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (130, 1, 16, '0016', '#include <stdio.h>\n\nint main() {\n    int n, m;\n    scanf(\"%d %d\", &n, &m);\n    int mat1[10][10], mat2[10][10];\n    \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat1[i][j]);\n            \n    for(int i = 0; i < n; i++)\n        for(int j = 0; j < m; j++)\n            scanf(\"%d\", &mat2[i][j]);\n            \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j < m; j++)\n            printf(\"%d \", mat1[i][j] + mat2[i][j]);\n        printf(\"\\n\");\n    }\n    return 0;\n}', 'C', 241, 728, '提交结果：答案错误\n\n测试用例：\n输入：2 2\n1 2\n3 4\n5 6\n7 8\n期望输出：6 8\n10 12\n您的输出：6 8 \n10 12\n\n请检查您的代码逻辑是否正确。', '2025-05-01 10:42:45', 'Wrong Answer', '2025-05-01 10:42:49');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (131, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1287, 728, NULL, '2025-05-01 13:44:59', 'Accepted', '2025-05-01 13:45:12');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (132, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'C', 578, 1, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-05-01 18:57:34', 'Wrong Answer', '2025-05-01 18:57:39');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (133, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a - b);\n    return 0;\n}', 'C', 301, 724, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-05-01 23:08:26', 'Wrong Answer', '2025-05-01 23:08:30');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (134, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1416, 740, NULL, '2025-05-01 23:22:20', 'Accepted', '2025-05-01 23:22:32');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (135, 1, 1, '0001', '#include <stdio.h>\n\nINT  main() {\n    // 列出两个变量\n    double a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '编译错误：\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c:8:1: error: unknown type name \'INT\'\n    8 | INT  main() {\n      | ^~~\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c: In function \'main\':\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c:11:13: warning: format \'%d\' expects argument of type \'int *\', but argument 2 has type \'double *\' [-Wformat=]\n   11 |     scanf(\"%d %d\", &a, &b);\n      |            ~^      ~~\n      |             |      |\n      |             int *  double *\n      |            %le\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c:11:16: warning: format \'%d\' expects argument of type \'int *\', but argument 3 has type \'double *\' [-Wformat=]\n   11 |     scanf(\"%d %d\", &a, &b);\n      |               ~^       ~~\n      |                |       |\n      |                int *   double *\n      |               %le\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c:12:14: warning: format \'%d\' expects argument of type \'int\', but argument 2 has type \'double\' [-Wformat=]\n   12 |     printf(\"%d\\n\", a + b);\n      |             ~^     ~~~~~\n      |              |       |\n      |              int     double\n      |             %f\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c: At top level:\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c:17:5: error: redefinition of \'main\'\n   17 | int main() {\n      |     ^~~~\n/app/src/temp/01686bca-cdfd-41a8-8129-745a1e3ec8f0/temp_1746166616702.c:8:6: note: previous definition of \'main\' with type \'int()\'\n    8 | INT  main() {\n      |      ^~~~\n\n\n请检查代码的语法是否正确。', '2025-05-02 14:16:55', 'System Error', '2025-05-02 14:16:57');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (136, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1412, 736, NULL, '2025-05-02 14:17:25', 'Accepted', '2025-05-02 14:17:37');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (137, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1636, 820, NULL, '2025-05-02 15:38:48', 'Accepted', '2025-05-02 15:39:01');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (138, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    INT a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 0, 0, '编译错误：\n/app/src/temp/4db2ed5e-1de6-43a7-b2d2-ab96264712c4/temp_1746171556457.c: In function \'main\':\n/app/src/temp/4db2ed5e-1de6-43a7-b2d2-ab96264712c4/temp_1746171556457.c:4:5: error: unknown type name \'INT\'\n    4 |     INT a, b;\n      |     ^~~\n\n\n请检查代码的语法是否正确。', '2025-05-02 15:39:15', 'System Error', '2025-05-02 15:39:16');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (139, 1, 1, '0001', '#include <stdio.h>\n\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\\n\", a + b);\n    return 0;\n}', 'C', 1497, 736, NULL, '2025-05-02 23:04:10', 'Accepted', '2025-05-02 23:04:21');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (140, 1, 1, '0001', 'a, b = map(int, input().split())\nprint(a - b)', 'Python', 276, 9, '提交结果：答案错误\n\n测试用例：\n输入：2 3\n期望输出：5\n您的输出：-1\n\n请检查您的代码逻辑是否正确。', '2025-05-02 23:08:30', 'Wrong Answer', '2025-05-02 23:08:34');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (141, 1, 18, '0018', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int triangle[30][30] = {0};\n    \n    for(int i = 0; i < n; i++) {\n        triangle[i][0] = 1;\n        for(int j = 1; j <= i; j++) {\n            triangle[i][j] = triangle[i-1][j-1] + triangle[i-1][j];\n        }\n    }\n    \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j <= i; j++) {\n            printf(\"%d \", triangle[i][j]);\n        }\n        printf(\"\\n\");\n    }\n    return 0;\n}', 'C', 273, 36, '提交结果：答案错误\n\n测试用例：\n输入：5\n期望输出：1\n1 1\n1 2 1\n1 3 3 1\n1 4 6 4 1\n您的输出：1 \n1 1 \n1 2 1 \n1 3 3 1 \n1 4 6 4 1\n\n请检查您的代码逻辑是否正确。', '2025-05-03 13:11:10', 'Wrong Answer', '2025-05-03 13:11:13');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (142, 1, 18, '0018', '#include <stdio.h>\n\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    int triangle[30][30] = {0};\n    \n    for(int i = 0; i < n; i++) {\n        triangle[i][0] = 1;\n        for(int j = 1; j <= i; j++) {\n            triangle[i][j] = triangle[i-1][j-1] + triangle[i-1][j];\n        }\n    }\n    \n    for(int i = 0; i < n; i++) {\n        for(int j = 0; j <= i; j++) {\n            if(j == i) {\n                printf(\"%d\", triangle[i][j]); // 最后一个数字不加空格\n            } else {\n                printf(\"%d \", triangle[i][j]); // 非最后一个数字加空格\n            }\n        }\n        printf(\"\\n\");\n    }\n    return 0;\n}', 'C', 264, 952, NULL, '2025-05-03 13:20:07', 'Accepted', '2025-05-03 13:20:11');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (143, 1, 1, '0001', 'a, b = map(int, input().split())\nprint(a + b)', 'Python', 945, 9, NULL, '2025-05-03 13:20:29', 'Accepted', '2025-05-03 13:20:41');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (144, 1, 1, '0001', '#include <iostream>\nusing namespace std;\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << a + b << endl;\n    return 0;\n}', 'C++', 2069, 29, NULL, '2025-05-03 13:21:44', 'Accepted', '2025-05-03 13:21:56');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (145, 1, 1, '0001', 'import java.util.Scanner;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner scanner = new Scanner(System.in);\n        int a = scanner.nextInt();\n        int b = scanner.nextInt();\n        System.out.println(a + b);\n        scanner.close();\n    }\n}    ', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /app/src/temp/4c3614b2-3344-4b5a-b8f3-491fb9a98a83/temp_1746249779754.java judge-88e6eb19-85bb-4525-b823-a00f0424ca09:/app/temp_1746249779754.java\nlstat /app/src/temp/4c3614b2-3344-4b5a-b8f3-491fb9a98a83/temp_1746249779754.java: no such file or directory\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-05-03 13:22:58', 'Runtime Error', '2025-05-03 13:22:59');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (146, 1, 1, '0001', 'import java.util.Scanner;\n\npublic static void main(String[] args) {\n        Scanner scanner = new Scanner(System.in);\n        int a = scanner.nextInt();\n        int b = scanner.nextInt();\n        System.out.println(a + b);\n        scanner.close();\n    }\n', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /app/src/temp/4ee1122b-0d88-42bc-acb5-3696c4aac2ec/temp_1746249802001.java judge-3cadecf6-5d6a-42a5-9b89-4bc2e5777937:/app/temp_1746249802001.java\nlstat /app/src/temp/4ee1122b-0d88-42bc-acb5-3696c4aac2ec/temp_1746249802001.java: no such file or directory\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-05-03 13:23:20', 'Runtime Error', '2025-05-03 13:23:22');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (147, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /app/src/temp/682674aa-8e95-4182-bcf9-df86c8e02655/temp_1746249820909.java judge-7b80cf1e-bc6d-4fb7-b85e-8fcf00607ea7:/app/temp_1746249820909.java\nlstat /app/src/temp/682674aa-8e95-4182-bcf9-df86c8e02655/temp_1746249820909.java: no such file or directory\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-05-03 13:23:39', 'Runtime Error', '2025-05-03 13:23:41');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (148, 1, 2, '0002', 'import java.util.*;\n\npublic class Solution {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /app/src/temp/fa5e3003-cd51-4a1b-8371-7706b63050df/temp_1746250271907.java judge-6c906839-58b9-4903-b60b-1d369d8f7eb0:/app/temp_1746250271907.java\nlstat /app/src/temp/fa5e3003-cd51-4a1b-8371-7706b63050df/temp_1746250271907.java: no such file or directory\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-05-03 13:31:10', 'Runtime Error', '2025-05-03 13:31:12');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (149, 1, 2, '0002', 'import java.util.*;\n\npublic class Solution {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker cp /app/src/temp/3e70e432-1942-444e-964a-07baff3734ab/temp_1746250320303.java judge-6380e26d-7638-4e33-ae0d-97c9e36c54f0:/app/temp_1746250320303.java\nlstat /app/src/temp/3e70e432-1942-444e-964a-07baff3734ab/temp_1746250320303.java: no such file or directory\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-05-03 13:31:58', 'Runtime Error', '2025-05-03 13:32:00');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (150, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 0, 0, '运行时错误：\nCommand failed: docker exec judge-ede9c665-04bc-447b-9c95-76945059bd26 javac /app/src/temp/27f16607-e032-4572-b26e-d4cb3b071e08/temp_1746250702373.java\n/app/src/temp/27f16607-e032-4572-b26e-d4cb3b071e08/temp_1746250702373.java:3: error: class Main is public, should be declared in a file named Main.java\npublic class Main {\n       ^\n1 error\n\n\n请检查代码是否存在数组越界、空指针等问题。', '2025-05-03 13:38:21', 'Runtime Error', '2025-05-03 13:38:23');
INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `problem_number`, `code`, `language`, `runtime`, `memory`, `error_message`, `created_at`, `status`, `completed_at`) VALUES (151, 1, 2, '0002', 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = sc.nextInt();\n        int max = Integer.MIN_VALUE;\n        while(n-- > 0) {\n            max = Math.max(max, sc.nextInt());\n        }\n        System.out.println(max);\n    }\n}', 'Java', 2267, 1, NULL, '2025-05-03 13:45:54', 'Accepted', '2025-05-03 13:45:57');
COMMIT;

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `nickname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `display_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatar_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gender` enum('男性','女性') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `location` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bio` mediumtext COLLATE utf8mb4_general_ci,
  `expertise_level` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `learning_goal` mediumtext COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `remembered_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='全局——用户显示资料表';

-- ----------------------------
-- Records of user_profile
-- ----------------------------
BEGIN;
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (1, 1, 'admin', '管理员1', 'public/uploads/avatars/avatar-1746248957138-989689086.png', '男性', '2024-01-01', '桂林', '测试通过个人资料修改个性签名', NULL, NULL, '2025-01-23 18:25:55', '2025-05-21 15:51:27', '123456');
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (8, 3, 'test', 'test', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-05 19:10:37', '2025-02-05 19:10:37', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (20, 6, 'student1', '学生1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-05 19:53:55', '2025-02-05 19:53:55', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (21, 7, 'VIP1', '会员1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-05 19:57:34', '2025-02-05 19:57:34', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (22, 8, 'student', 'student', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-03-08 18:58:41', '2025-03-08 18:58:41', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (23, 9, 'teacher', 'teacher', 'public/uploads/avatars/avatar-1743567478394-445763381.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-03-08 19:01:51', '2025-04-02 20:17:58', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (27, 11, 'johndoe', '约翰多', 'public/uploads/avatars/avatar-1744910086N-000000001.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (28, 12, 'janedoe', '简妮', 'public/uploads/avatars/avatar-1744910088N-000000002.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (29, 13, 'bobsmith', '鲍勃', 'public/uploads/avatars/avatar-1744910090N-000000003.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (30, 14, 'alicewang', '艾丽丝', 'public/uploads/avatars/avatar-1744910092N-000000004.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (31, 15, 'mikebrown', '迈克', 'public/uploads/avatars/avatar-1744910093N-000000005.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (33, 17, 'davidzhou', '大卫', 'public/uploads/avatars/avatar-1744910096N-000000007.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (34, 18, 'lindachen', '琳达', 'public/uploads/avatars/avatar-1744910097N-000000008.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (35, 19, 'tomwilson', '汤姆', 'public/uploads/avatars/avatar-1744910098N-000000009.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (36, 20, 'emmajones', '艾玛', 'public/uploads/avatars/avatar-1744910100N-000000010.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (37, 21, 'ryankim', '瑞安', 'public/uploads/avatars/avatar-1744910102N-000000011.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (38, 22, 'sophiama', '索菲亚', 'public/uploads/avatars/avatar-1744910103N-000000012.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (39, 23, 'alexpark', '亚历克斯', 'public/uploads/avatars/avatar-1744910105N-000000013.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (40, 24, 'hannahli', '汉娜', 'public/uploads/avatars/avatar-1744910106N-000000014.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (41, 25, 'jasontan', '杰森', 'public/uploads/avatars/avatar-1744910107N-000000015.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (42, 26, 'oliviazhang', '奥利维亚', 'public/uploads/avatars/avatar-1744910109N-000000016.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (43, 27, 'williamgao', '威廉', 'public/uploads/avatars/avatar-1744910110N-000000017.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (44, 28, 'nataliewu', '娜塔莉', 'public/uploads/avatars/avatar-1744910112N-000000018.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (45, 29, 'kevinliu', '凯文', 'public/uploads/avatars/avatar-1744910113N-000000019.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
INSERT INTO `user_profile` (`id`, `user_id`, `nickname`, `display_name`, `avatar_url`, `gender`, `birth_date`, `location`, `bio`, `expertise_level`, `learning_goal`, `created_at`, `updated_at`, `remembered_password`) VALUES (46, 30, 'gracezhu', '格蕾丝', 'public/uploads/avatars/avatar-1744910114N-000000020.png', NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-18 09:15:56', '2025-04-18 09:15:56', NULL);
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
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (1, 'normal', '普通用户，基础功能访问权限', '2025-02-04 00:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (2, 'vip', '会员用户，享有更多学习资源和功能', '2025-02-04 00:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (3, 'super_vip', '超级会员用户，享有全部学习资源和特权功能', '2025-02-04 00:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (4, 'teacher', '教师用户，可以创建课程和管理学生', '2025-02-04 00:35:24');
INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`) VALUES (5, 'admin', '管理员用户，系统最高权限', '2025-02-04 00:35:24');
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
) ENGINE=InnoDB AUTO_INCREMENT=503 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局——用户访问网站记录表';

-- ----------------------------
-- Records of user_visits
-- ----------------------------
BEGIN;
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (1, 1, '2025-02-05', '2025-02-05 16:45:49', 35);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (3, 3, '2025-02-05', '2025-02-05 16:45:49', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (37, 1, '2025-02-06', '2025-02-06 20:45:33', 23);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (60, 1, '2025-02-09', '2025-02-10 05:36:08', 1);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (61, 1, '2025-02-18', '2025-02-18 23:50:24', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (64, 1, '2025-02-24', '2025-02-24 22:29:17', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (71, 1, '2025-02-25', '2025-02-26 02:11:46', 11);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (82, 1, '2025-02-27', '2025-02-27 21:25:05', 10);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (92, 1, '2025-02-28', '2025-02-28 19:02:27', 22);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (114, 1, '2025-03-03', '2025-03-03 16:24:29', 5);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (119, 1, '2025-03-04', '2025-03-04 21:50:02', 4);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (123, 1, '2025-03-05', '2025-03-05 16:10:51', 19);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (142, 1, '2025-03-06', '2025-03-06 16:10:33', 10);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (152, 1, '2025-03-07', '2025-03-07 16:22:14', 17);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (169, 1, '2025-03-08', '2025-03-08 18:22:31', 12);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (171, 9, '2025-03-08', '2025-03-08 19:08:15', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (188, 1, '2025-03-09', '2025-03-09 18:33:45', 5);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (193, 1, '2025-03-10', '2025-03-10 16:30:25', 15);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (208, 1, '2025-03-13', '2025-03-13 19:09:45', 1);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (209, 1, '2025-03-28', '2025-03-28 10:14:38', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (211, 9, '2025-04-02', '2025-04-02 20:21:55', 1);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (212, 1, '2025-04-02', '2025-04-02 20:22:23', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (219, 1, '2025-04-03', '2025-04-03 08:05:09', 7);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (226, 1, '2025-04-04', '2025-04-04 19:26:46', 6);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (232, 1, '2025-04-08', '2025-04-08 19:07:17', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (235, 1, '2025-04-10', '2025-04-10 16:56:51', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (237, 1, '2025-04-11', '2025-04-11 17:10:10', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (239, 1, '2025-04-13', '2025-04-13 21:47:47', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (241, 1, '2025-04-14', '2025-04-14 16:16:21', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (244, 1, '2025-04-15', '2025-04-15 23:55:15', 5);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (249, 1, '2025-04-16', '2025-04-16 18:00:44', 22);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (271, 1, '2025-04-17', '2025-04-17 08:14:30', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (273, 1, '2025-04-18', '2025-04-18 08:23:09', 21);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (294, 1, '2025-04-19', '2025-04-19 17:44:40', 38);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (332, 1, '2025-04-20', '2025-04-20 09:51:46', 4);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (336, 1, '2025-04-21', '2025-04-21 19:07:18', 4);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (340, 1, '2025-04-22', '2025-04-22 11:19:13', 15);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (355, 1, '2025-04-23', '2025-04-23 21:47:59', 27);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (382, 1, '2025-04-25', '2025-04-25 21:49:26', 2);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (384, 1, '2025-04-26', '2025-04-26 10:01:58', 13);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (397, 1, '2025-04-27', '2025-04-27 19:25:03', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (400, 1, '2025-04-28', '2025-04-28 08:22:30', 3);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (403, 1, '2025-04-29', '2025-04-29 12:51:09', 13);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (416, 1, '2025-04-30', '2025-04-30 16:19:17', 11);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (427, 1, '2025-05-01', '2025-05-01 09:33:15', 18);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (445, 1, '2025-05-02', '2025-05-02 00:01:39', 33);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (478, 1, '2025-05-03', '2025-05-03 08:23:36', 17);
INSERT INTO `user_visits` (`id`, `user_id`, `visit_date`, `first_visit_time`, `visit_count`) VALUES (495, 1, '2025-05-04', '2025-05-04 11:11:01', 8);
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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局——用户隐私信息表';

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (1, 'admin', '$2b$10$PjmK0hqAFEdEIZJhuZq7FOREba7AGBISkiRba7j7tBU2hV4lEuzBa', 'admin@example.co', NULL, '2025-01-22 20:15:35', 1, NULL, 'admin', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NDYzMzUyOTksImV4cCI6MTc0Njk0MDA5OSwiYXVkIjoiQUlyZXZpZXctY2xpZW50IiwiaXNzIjoiQUlyZXZpZXcifQ.SQVU403DMG8sAS-T-HLp6rv9E5OBn0bhG-16Vx_mMxY');
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (3, 'test', 'test123', '123@qq.com', NULL, '2025-01-24 18:03:39', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (6, 'student1', '$2b$10$kti7yxUgaM9A3Mngg4VAk.aXB0F/4cd7MFTq0MYMgT42HiYSXvWsK', 'xuesheng@qq.com', NULL, '2025-02-05 19:53:55', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (7, 'VIP1', '$2b$10$pw2KRFpKOgR8SDm/si.UmuCVI0k5Yv5pbX8cv30D2KM7T8XooJETK', 'vip1@qq.com', NULL, '2025-02-05 19:57:34', 1, NULL, 'vip', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (8, 'student', '$2b$10$nru7E2W1IQkM2bjMQmBlhuv19FAsdRYRvaWngRwHj4dGgWHCQz8vm', '13377238689@163.com', NULL, '2025-03-08 18:58:41', 1, NULL, 'normal', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NDUzMDQ5MDksImV4cCI6MTc0NTkwOTcwOSwiYXVkIjoiQUlyZXZpZXctY2xpZW50IiwiaXNzIjoiQUlyZXZpZXcifQ.NYPsBJedQLvTGVX__K7WtLsEh9CXRbzSl0LfGL3ifYw');
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (9, 'teacher', '$2b$10$gAHcMFe0rz/X9T5QA9gzBeoz25b9pD6l5q2ZzEUJ9ZWj9Apykyxe2', '17324042932@163.com', '17324042932', '2025-03-08 19:01:51', 1, NULL, 'teacher', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NDYyNDgxNjAsImV4cCI6MTc0Njg1Mjk2MCwiYXVkIjoiQUlyZXZpZXctY2xpZW50IiwiaXNzIjoiQUlyZXZpZXcifQ.p_uUmFFTCYSpGUnWR-QZSuNkbn91W5D1beXg4B2SzHw');
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (11, 'johndoe', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'johndoe@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'admin', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (12, 'janedoe', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'janedoe@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (13, 'bobsmith', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'bobsmith@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (14, 'alicewang', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'alicewang@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (15, 'mikebrown', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'mikebrown@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (17, 'davidzhou', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'davidzhou@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (18, 'lindachen', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'lindachen@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (19, 'tomwilson', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'tomwilson@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (20, 'emmajones', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'emmajones@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (21, 'ryankim', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'ryankim@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'admin', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (22, 'sophiama', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'sophiama@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'super_vip', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (23, 'alexpark', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'alexpark@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (24, 'hannahli', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'hannahli@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (25, 'jasontan', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'jasontan@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (26, 'oliviazhang', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'oliviazhang@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (27, 'williamgao', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'williamgao@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'teacher', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (28, 'nataliewu', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'nataliewu@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (29, 'kevinliu', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'kevinliu@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'super_vip', NULL, NULL);
INSERT INTO `users` (`id`, `username`, `password`, `email`, `phone`, `created_at`, `status`, `token`, `role`, `role_expire_time`, `refresh_token`) VALUES (30, 'gracezhu', '$2b$10$WuykF1MPbs1MJWHGvoZyL.5krLatNrJN6823dLDPCWzYm96Nh0DUi', 'gracezhu@example.com', NULL, '2025-04-18 09:15:40', 1, NULL, 'normal', NULL, NULL);
COMMIT;

-- ----------------------------
-- View structure for problem_stats
-- ----------------------------
DROP VIEW IF EXISTS `problem_stats`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `problem_stats` AS select `p`.`problem_number` AS `problem_number`,count(distinct `s`.`id`) AS `total_submissions`,count(distinct (case when (`s`.`status` = 'Accepted') then `s`.`id` end)) AS `accepted_submissions`,round(((count(distinct (case when (`s`.`status` = 'Accepted') then `s`.`id` end)) * 100.0) / nullif(count(distinct `s`.`id`),0)),2) AS `acceptance_rate` from (`problems` `p` left join `submissions` `s` on((`p`.`problem_number` = `s`.`problem_id`))) group by `p`.`problem_number`;

-- ----------------------------
-- Procedure structure for cleanup_old_analytics_events
-- ----------------------------
DROP PROCEDURE IF EXISTS `cleanup_old_analytics_events`;
delimiter ;;
CREATE PROCEDURE `cleanup_old_analytics_events`()
BEGIN
    -- 删除3个月前的数据
    DELETE FROM analytics_events 
    WHERE timestamp < (UNIX_TIMESTAMP() - 7776000) * 1000; -- 90天 * 24小时 * 60分钟 * 60秒 * 1000毫秒
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_aggregate_daily_analytics
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_aggregate_daily_analytics`;
delimiter ;;
CREATE PROCEDURE `proc_aggregate_daily_analytics`()
BEGIN
  DECLARE cur_date DATE;
  
  -- 获取昨天的日期
  SET cur_date = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY);
  
  -- 删除已有的聚合数据
  DELETE FROM analytics_daily_summary WHERE date = cur_date;
  
  -- 插入各事件类型的聚合数据
  INSERT INTO analytics_daily_summary (date, event_type, count, unique_users)
  SELECT 
    DATE(FROM_UNIXTIME(timestamp/1000)) as date,
    type as event_type,
    COUNT(*) as count,
    COUNT(DISTINCT user_id) as unique_users
  FROM analytics_events
  WHERE timestamp BETWEEN UNIX_TIMESTAMP(cur_date) * 1000 AND UNIX_TIMESTAMP(DATE_ADD(cur_date, INTERVAL 1 DAY)) * 1000 - 1
    AND type IS NOT NULL
  GROUP BY date, type;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for analytics_cleanup_event
-- ----------------------------
DROP EVENT IF EXISTS `analytics_cleanup_event`;
delimiter ;;
CREATE EVENT `analytics_cleanup_event`
ON SCHEDULE
EVERY '1' MONTH STARTS '2025-05-01 10:01:43'
DO CALL cleanup_old_analytics_events()
;;
delimiter ;

-- ----------------------------
-- Event structure for evt_daily_analytics_summary
-- ----------------------------
DROP EVENT IF EXISTS `evt_daily_analytics_summary`;
delimiter ;;
CREATE EVENT `evt_daily_analytics_summary`
ON SCHEDULE
EVERY '1' DAY STARTS '2025-05-01 09:00:00'
DO CALL proc_aggregate_daily_analytics()
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
