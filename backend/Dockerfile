FROM node:18

# 设置工作目录
WORKDIR /app

# 安装构建工具和Python (bcrypt依赖)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 复制package.json和package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制剩余文件
COPY . .

# 创建必要的目录
RUN mkdir -p logs uploads temp

# 设置入口点脚本权限
RUN chmod +x /app/docker-entrypoint.sh

# 暴露端口
EXPOSE 3000

# 使用bash执行入口点脚本，避免权限问题
ENTRYPOINT ["/bin/bash", "/app/docker-entrypoint.sh"]

# 启动应用
CMD ["node", "src/app.js"] 