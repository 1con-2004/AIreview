FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 安装构建工具和Python (bcrypt依赖)，以及Docker CLI
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    bash \
    docker-cli

# 复制package.json和package-lock.json
COPY package*.json ./

# 安装依赖和nodemon用于开发环境的热重载
RUN yarn install && yarn global add nodemon

# 复制剩余文件
COPY . .

# 创建必要的目录
RUN mkdir -p logs uploads temp

# 暴露端口
EXPOSE 3000

# 使用nodemon启动应用以支持热重载
CMD ["nodemon", "src/app.js"] 