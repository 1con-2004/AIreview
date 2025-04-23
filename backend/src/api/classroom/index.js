const express = require('express');
const router = express.Router();
const classroomController = require('./classroom.controller');
const { upload } = require('../../utils/fileUpload');

// 获取所有课堂
router.get('/', classroomController.getAllClassrooms);

// 获取单个课堂信息
router.get('/:code', classroomController.getClassroomByCode);

// 创建新课堂
router.post('/', classroomController.createClassroom);

// 更新课堂信息
router.put('/:id', classroomController.updateClassroom);

// 删除课堂
router.delete('/:id', classroomController.deleteClassroom);

// 添加课堂留言
router.post('/:id/messages', classroomController.addClassroomMessage);

// 获取课堂留言
router.get('/:id/messages', classroomController.getClassroomMessages);

// 删除课堂留言
router.delete('/messages/:messageId', classroomController.deleteClassroomMessage);

// 上传课堂文件
router.post('/:id/files', upload.single('file'), classroomController.uploadClassroomFile);

// 获取课堂文件列表
router.get('/:id/files', classroomController.getClassroomFiles);

// 下载课堂文件
router.get('/files/:fileId/download', classroomController.downloadClassroomFile);

// 删除课堂文件
router.delete('/files/:fileId', classroomController.deleteClassroomFile);

// 添加讨论消息
router.post('/:id/discussions', classroomController.addDiscussionMessage);

// 获取讨论消息
router.get('/:id/discussions', classroomController.getDiscussionMessages);

// 验证课堂码
router.post('/verify', classroomController.verifyClassroomCode);

module.exports = router; 