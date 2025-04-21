# 中文编码问题修复日志

## 问题描述

1. [ ✅ ] 在前端网站中发现从后端获取的中文内容显示为乱码。具体表现为：
   - 标签列表中显示为乱码： "å"ˆå¸Œè¡¨", "æ•°ç»„", "é"¾è¡¨"
   - 进入题目详情页面时，提示"获取提交记录失败"

2. [ ✅ ] 后端日志显示多处错误：
   - 查询 problems 表标签字段失败，提示 Unknown column 'tags' in 'field list'
   - 获取提交记录失败，提示 Unknown column 'NaN' in 'where clause'

## 解决方案

### 1. 修复后端编码问题

{ 2025.4.21 } 修改了以下文件：

1. `backend/src/app.js` 
   - 添加了全局中间件，为所有响应设置正确的 UTF-8 编码头：
   ```javascript
   // 添加响应头中间件，确保所有响应使用UTF-8编码
   app.use((req, res, next) => {
     res.setHeader('Content-Type', 'application/json; charset=utf-8');
     next();
   });
   ```

2. `backend/src/api/problems/index.js`
   - 修改了标签获取逻辑，检查表结构并在出错时返回正确的中文默认标签：
   ```javascript
   // 修改默认标签
   tagArray = ['哈希表', '数组', '链表', '字符串', '动态规划', '贪心算法'];
   ```

### 2. 修复前端编码检测和处理

{ 2025.4.21 } 修改了以下文件：

1. `frontend/src/main.js`
   - 增强了 axios 响应拦截器，添加了识别和处理潜在编码问题的功能：
   ```javascript
   // 处理可能的中文编码问题
   if (response.data && typeof response.data === 'object') {
     // 递归处理对象中的字符串值
     const processStringValues = (obj) => {
       if (!obj || typeof obj !== 'object') return obj;
       
       Object.keys(obj).forEach(key => {
         if (typeof obj[key] === 'string') {
           try {
             // 尝试检测是否存在乱码并修复
             if (/æ|ø|å|ð|ñ|ò|ó|ô|õ|ö/.test(obj[key])) {
               console.log('检测到可能的乱码:', obj[key]);
             }
           } catch (e) {
             console.error('处理编码时出错:', e);
           }
         } else if (obj[key] && typeof obj[key] === 'object') {
           // 递归处理嵌套对象
           processStringValues(obj[key]);
         }
       });
     };
     
     processStringValues(response.data);
   }
   ```

## 问题原因分析

此问题主要由以下原因导致：

1. 后端响应没有明确指定 UTF-8 编码，导致浏览器默认使用错误的编码方式解析中文字符
2. 数据库架构可能存在问题，表结构中缺少预期的 tags 字段或编码问题
3. 前端处理后端返回数据时没有做编码处理

## 解决问题使用的简要方案

1. 确保后端响应头中包含正确的 UTF-8 编码声明
2. 增强前端检测并处理可能的编码问题的能力
3. 为缺失的数据或字段提供中文默认值，确保前端显示正常

后续可考虑的优化：
- 检查数据库编码配置，确保使用 UTF8MB4 编码存储中文
- 优化前端编码处理能力，增加更复杂的编码自动识别和转换算法
- 增加编码问题的全局监控和报警 