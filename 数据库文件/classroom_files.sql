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

 Date: 10/03/2025 08:52:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
