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

 Date: 04/04/2025 16:54:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
