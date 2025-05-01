# Nginx配置

本目录包含AIreview系统的Nginx配置文件，用于提供前端静态资源服务、API反向代理和请求转发等功能。

## 目录结构

```
nginx/
├── default.conf      # 主配置文件
└── mime.types       # MIME类型配置文件(可选)
```

## 主要功能

### 1. 静态资源服务
- 提供前端打包后的静态资源访问
- 配置静态资源缓存策略
- 处理静态资源压缩

### 2. API反向代理
- 将`/api`请求转发到后端服务
- 配置跨域请求支持
- 处理WebSocket连接

### 3. 上传文件处理
- 提供`/uploads`目录访问
- 配置上传文件缓存策略
- 设置文件访问权限

### 4. 路由处理
- 处理前端单页应用路由
- 配置默认首页
- 设置错误页面处理

### 5. 性能优化
- 启用gzip压缩
- 配置静态资源缓存
- 优化连接处理

### 6. 安全配置
- 设置安全响应头
- 配置跨域策略
- 限制访问权限

## 配置说明

### default.conf

`default.conf`是主要的配置文件，包含以下配置块:

```nginx
# 服务器基本配置
server {
    listen 80;
    server_name localhost;
    
    # gzip配置
    gzip on;
    gzip_min_length 1k;
    gzip_comp_level 5;
    gzip_types text/plain text/css application/javascript application/json;
    
    # 静态资源配置
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
        expires 30d;
    }
    
    # API代理配置
    location /api {
        proxy_pass http://backend:3000/api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_read_timeout 300s;
    }
    
    # 上传文件访问配置
    location /uploads {
        alias /usr/share/nginx/html/uploads;
        expires 7d;
        add_header Cache-Control public;
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    }
    
    # 健康检查接口
    location /health {
        access_log off;
        return 200 "ok";
    }
}
```

## 修改配置

在开发过程中，如需修改Nginx配置:

1. 编辑`default.conf`文件
2. 重启Nginx容器:
   ```bash
   docker restart aireview-nginx
   ```

## 性能调优

根据项目需求，可考虑以下性能调优:

1. **静态资源缓存**:
   - 调整`expires`指令设置缓存时间
   - 使用`Cache-Control`响应头精细控制缓存

2. **压缩配置**:
   - 调整`gzip_comp_level`压缩级别
   - 添加更多`gzip_types`支持更多文件类型压缩

3. **连接优化**:
   - 调整`worker_processes`和`worker_connections`
   - 设置`keepalive_timeout`优化长连接

4. **SSL优化** (如启用HTTPS):
   - 配置SSL会话缓存
   - 启用HTTP/2支持

## 安全最佳实践

1. **响应头安全**:
   ```nginx
   add_header X-Content-Type-Options nosniff;
   add_header X-XSS-Protection "1; mode=block";
   add_header X-Frame-Options SAMEORIGIN;
   ```

2. **限制请求大小**:
   ```nginx
   client_max_body_size 10M;
   ```

3. **控制访问权限**:
   ```nginx
   location /admin {
       allow 192.168.1.0/24;
       deny all;
   }
   ```

## 日志配置

根据需要，可配置访问日志和错误日志:

```nginx
access_log /var/log/nginx/access.log main;
error_log /var/log/nginx/error.log warn;
```

## 容器配置

在`docker-compose.yml`中，Nginx容器配置如下:

```yaml
services:
  nginx:
    image: nginx:alpine
    container_name: aireview-nginx
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
      - ./frontend/dist:/usr/share/nginx/html
      - ./frontend/public/icons:/usr/share/nginx/html/icons
      - ./uploads:/usr/share/nginx/html/uploads
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - aireview_network
```

更多高级配置和优化选项，请参考[Nginx官方文档](https://nginx.org/en/docs/)。 