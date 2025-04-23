// backend/config/email.js
const nodemailer = require('nodemailer')

const transporter = nodemailer.createTransport({
  host: 'smtp.qq.com', // 以QQ邮箱为例，可以换成其他邮箱服务器
  port: 465,
  secure: true,
  auth: {
    user: '2456947952@qq.com', // 你的邮箱
    pass: 'rnmnxamisdaqdicg' // 你的SMTP密码
  }
})

module.exports = transporter