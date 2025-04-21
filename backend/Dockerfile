FROM node:16-alpine

# 设置工作目录
WORKDIR /app

# 安装依赖
COPY package*.json ./
RUN npm install

# 安装 Docker CLI 以支持判题功能
RUN apk add --no-cache docker-cli

# 复制项目文件
COPY . .

# 创建必要的目录
RUN mkdir -p logs uploads temp

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["node", "src/app.js"] 