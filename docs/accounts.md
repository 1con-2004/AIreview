# 系统账户信息

## 初始账户

### 管理员账户
- 用户名: admin
- 密码: 123456
- 权限: admin

### 教师账户
- 用户名: teacher
- 密码: 123456
- 权限: teacher

### 学生账户
- 用户名: student
- 密码: 123456
- 权限: normal

## 邮箱配置

邮箱配置位于 `backend/config/email.js`，需要配置以下信息：
- 邮箱地址
- SMTP密码（注意：这不是邮箱登录密码）

### 获取SMTP密码步骤（以QQ邮箱为例）：
1. 登录QQ邮箱
2. 点击"设置" -> "账户"
3. 找到"POP3/IMAP/SMTP/Exchange/CardDAV/CalDAV服务"
4. 开启"POP3/SMTP服务"
5. 按照提示获取授权码，该授权码即为SMTP密码

## 权限说明

### admin权限
- 系统管理
- 用户管理
- 所有功能访问权限

### teacher权限
- 题目管理
- 学生管理
- 成绩查看

### normal权限（学生）
- 做题
- 查看个人成绩
- 查看学习路径 