# 登录数据库问题修复记录

## 问题描述

1. [ ✅ ] 登录时服务器返回500错误，控制台显示"Failed to load resource: the server responded with a status of 500 (Internal Server Error)"

## 问题分析

后端日志显示错误信息：
```
[ERROR] 登录错误: Error: Table 'AIreview.users' doesn't exist
    at PromisePool.execute (/app/node_modules/mysql2/lib/promise/pool.js:54:22)
    at /app/src/api/login/index.js:45:31
```

问题原因：
- 数据库中不存在users表
- Docker部署时缺少数据库初始化脚本
- 项目首次启动时未初始化数据库结构

## 解决方案

1. { 2025.04.21 } 创建数据库初始化脚本：
   - 在项目根目录创建了`db/init/01_schema.sql`文件
   - 添加了创建users表和user_profile表的SQL语句
   - 添加了默认管理员、教师和学生账号，密码为"123456"

2. { 2025.04.21 } 重新部署Docker容器：
   - 停止并删除所有容器：`docker-compose down`
   - 删除数据库卷：`docker volume rm aireview_db_data`
   - 重启容器：`docker-compose up -d`

3. { 2025.04.21 } 记录操作：
   - 在项目文档中记录了数据库结构
   - 记录了表字段说明和测试账号信息

## 验证结果

问题已成功解决，使用以下任一测试账号可以成功登录系统：
- 管理员账号：admin / 123456
- 教师账号：teacher / 123456 
- 学生账号：student / 123456

验证方法：
```bash
curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"123456"}' http://localhost/api/login
```

返回成功结果，包含JWT token和用户信息。

## 经验总结

1. Docker项目部署时，需要确保数据库初始化脚本存在且正确
2. 在容器首次启动前，应当检查初始化脚本是否完备
3. 项目应当提供清晰的数据库结构文档和初始账号信息
4. 避免在初始化脚本中引用尚未创建的表，以防止初始化失败 