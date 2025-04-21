FROM node:16-alpine

# 设置工作目录
WORKDIR /app

# 安装依赖
COPY package*.json ./
RUN npm install

# 复制项目文件
COPY . .

# 构建应用
RUN npm run build

# 安装全局的serve包来提供静态文件服务
RUN npm install -g serve

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["serve", "-s", "dist", "-l", "8080"] 