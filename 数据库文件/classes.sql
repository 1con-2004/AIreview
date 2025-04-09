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

 Date: 05/03/2025 10:41:26
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

SET FOREIGN_KEY_CHECKS = 1;
