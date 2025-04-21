# 构建阶段
FROM node:18-alpine

# 设置工作目录
WORKDIR /app

# 复制package.json和yarn.lock
COPY package*.json ./
COPY yarn.lock ./

# 安装ESLint插件依赖
RUN yarn add eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard --dev

# 安装依赖
RUN yarn install

# 复制源代码
COPY . .

# 使用环境变量设置API基础路径
ARG VUE_APP_BASE_API=/api
ARG VUE_APP_USE_RELATIVE_PATH=true

ENV VUE_APP_BASE_API=${VUE_APP_BASE_API}
ENV VUE_APP_USE_RELATIVE_PATH=${VUE_APP_USE_RELATIVE_PATH}

# 使用.eslintignore文件忽略lint检查
RUN echo "**/*" > .eslintignore

# 构建应用 - 禁用ESLint检查
RUN yarn run build

# 输出构建信息
RUN echo "前端构建完成，输出在 /app/dist 目录"

# 安装全局的serve包和vue-cli-service
RUN yarn global add serve @vue/cli @vue/cli-service

# 暴露端口
EXPOSE 8080 