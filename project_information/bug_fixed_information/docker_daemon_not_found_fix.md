# docker_daemon_not_found_fix

1. [ ✅ ] 发现Docker服务无法在后端容器中使用的问题

2. { 2025-04-21 } 修改了后端Dockerfile，添加了docker-cli的安装：
- 文件路径: `backend/Dockerfile`
- 修改内容: 在`apk add`命令中添加了`docker-cli`包
- 原因: 后端容器中没有安装Docker命令行工具，导致无法执行Docker相关操作

3. [ ✅ ] 在docker-compose.yml中添加特权模式，确保容器可以访问主机Docker:
- 文件路径: `docker-compose.yml`
- 修改内容: 
  - 添加`privileged: true`以运行特权模式
  - 注释掉`user`设置，使容器使用root用户运行
  - 这样确保了容器有足够的权限访问主机的Docker socket
- 问题原因：容器内部无法访问主机Docker daemon

# 解决方案详细说明

## 问题现象
后端服务启动时报错：
```
Docker daemon不可用: Command failed: docker info
/bin/sh: docker: not found

Docker环境初始化失败: Docker不可用，请确保Docker服务正在运行
Docker环境初始化失败: Docker不可用，请确保Docker服务正在运行
判题系统可能无法正常工作，请检查Docker配置
```

## 原因分析
1. 后端容器中没有安装Docker CLI，导致无法执行Docker命令
2. 容器用户权限不足，无法访问挂载的Docker socket
3. Docker socket挂载正确，但需要容器有适当的权限访问

## 解决步骤
1. 修改`backend/Dockerfile`，安装Docker CLI:
```dockerfile
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    bash \
    docker-cli
```

2. 修改`docker-compose.yml`，设置容器权限:
```yaml
# 后端服务
backend:
  # ...其他配置
  privileged: true  # 添加特权模式
  # user: "${UID:-1000}:${DOCKER_GROUP_ID:-999}"  # 注释掉用户设置
```

3. 重新构建并启动容器:
```bash
docker-compose down && docker-compose up -d --build
```

## 结果验证
修复后，Docker服务可以正常在容器中使用，日志显示：
```
Docker daemon正常运行
镜像 gcc:latest 已存在
镜像 python:3.9-slim 已存在
镜像 openjdk:11 已存在
Docker网络 aireview_network 已存在
Docker环境初始化成功
Docker环境初始化成功，判题系统已就绪
```

## 注意事项
1. 使用特权模式运行容器存在潜在安全风险，仅适用于开发和测试环境
2. 在生产环境中，应该使用更安全的方式来让容器访问Docker，如使用Docker-in-Docker (DinD)或限制特定命令的执行权限 