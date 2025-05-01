// 在backend/src/api/analytics/index.js中
const express = require('express');
const router = express.Router();
const analyticsService = require('../../services/analytics/analyticsService');
const { authenticateToken } = require('../../middleware/auth');

// 获取真实客户端IP的函数
const getClientIP = (req) => {
  // 调试日志
  console.log('请求头信息:', {
    'x-real-ip': req.headers['x-real-ip'],
    'x-forwarded-for': req.headers['x-forwarded-for'],
    'x-original-forwarded-for': req.headers['x-original-forwarded-for'],
    'x-client-ip': req.headers['x-client-ip'],
    'remote-address': req.socket.remoteAddress,
    'req.ip': req.ip
  });

  // 获取真实IP的优先级：
  // 1. X-Forwarded-For的第一个IP（代理链）
  // 2. X-Real-IP（Nginx设置的真实IP）
  // 3. req.ip（Express的IP）
  // 4. socket的远程地址

  // 1. 检查X-Forwarded-For
  const forwardedFor = req.headers['x-forwarded-for'];
  if (forwardedFor) {
    const ips = forwardedFor.split(',');
    const clientIP = ips[0].trim();
    if (!clientIP.includes('172.18.0')) {
      return clientIP;
    }
  }

  // 2. 检查X-Real-IP
  const realIP = req.headers['x-real-ip'];
  if (realIP && !realIP.includes('172.18.0')) {
    return realIP;
  }

  // 3. 使用req.ip
  if (req.ip && !req.ip.includes('172.18.0')) {
    return req.ip;
  }

  // 4. 使用socket的远程地址
  return req.socket.remoteAddress;
};

// 接收埋点事件数据（单个事件）
router.post('/event', async (req, res) => {
  try {
    const eventData = req.body;
    
    // 添加真实IP和时间戳
    eventData.ip = getClientIP(req);
    eventData.receivedAt = new Date();
    
    // 尝试从请求头获取用户信息（如果前端没有提供userId）
    if (!eventData.userId || eventData.userId === 'anonymous') {
      // 检查是否有用户会话
      if (req.session && req.session.user && req.session.user.id) {
        eventData.userId = req.session.user.id;
      } else if (req.headers.authorization) {
        // 从授权头中提取用户ID
        try {
          const token = req.headers.authorization.split(' ')[1];
          // 这里简单处理，实际应该验证token
          const tokenParts = token.split('.');
          if (tokenParts.length === 3) {
            const payload = JSON.parse(Buffer.from(tokenParts[1], 'base64').toString());
            if (payload && payload.id) {
              eventData.userId = payload.id;
            }
          }
        } catch (error) {
          console.error('从令牌中提取用户ID失败', error);
        }
      }
    }
    
    console.log('收到埋点事件:', {
      type: eventData.type,
      userId: eventData.userId,
      pageName: eventData.pageName,
      elementName: eventData.elementName,
      path: eventData.path
    });
    
    // 存储事件数据
    await analyticsService.storeEvent(eventData);
    
    // 无需等待响应，直接返回成功
    res.status(200).send({ success: true });
  } catch (error) {
    console.error('存储埋点数据失败', error);
    res.status(500).send({ success: false, error: error.message });
  }
});

// 接收批量埋点事件数据
router.post('/batch-events', async (req, res) => {
  try {
    const { events = [], isExit = false } = req.body;
    
    if (!Array.isArray(events) || events.length === 0) {
      return res.status(400).send({ success: false, message: '无效的事件数据' });
    }
    
    console.log(`收到批量埋点事件: ${events.length}条` + (isExit ? ' (页面退出)' : ''));
    console.log('批量埋点事件样例:', JSON.stringify(events[0]));
    
    // 检查事件数据中是否包含关键字段
    const hasTypeField = events.some(event => !!event.type);
    const hasUserIdField = events.some(event => !!event.userId && event.userId !== 'anonymous');
    console.log('埋点事件字段检查: 类型字段存在=', hasTypeField, '用户ID字段存在=', hasUserIdField);
    
    // 为每个事件添加IP和接收时间
    const enhancedEvents = events.map(eventData => {
      // 添加IP和时间戳
      eventData.ip = getClientIP(req);
      eventData.receivedAt = new Date();
      
      // 尝试从请求头获取用户信息（如果事件中没有有效的userId）
      if (!eventData.userId || eventData.userId === 'anonymous') {
        // 检查是否有用户会话
        if (req.session && req.session.user && req.session.user.id) {
          console.log('从会话中获取用户ID:', req.session.user.id);
          eventData.userId = req.session.user.id;
        } else if (req.headers.authorization) {
          // 从授权头中提取用户ID
          try {
            const token = req.headers.authorization.split(' ')[1];
            // 这里简单处理，实际应该验证token
            const tokenParts = token.split('.');
            if (tokenParts.length === 3) {
              const payload = JSON.parse(Buffer.from(tokenParts[1], 'base64').toString());
              if (payload && payload.id) {
                console.log('从token中获取用户ID:', payload.id);
                eventData.userId = payload.id;
              }
            }
          } catch (error) {
            console.error('从令牌中提取用户ID失败', error);
          }
        }
      }
      
      return eventData;
    });
    
    // 批量存储事件数据
    const result = await analyticsService.storeBatchEvents(enhancedEvents);
    
    // 返回成功响应
    console.log('批量埋点事件处理完成, 结果:', result ? '成功' : '失败');
    res.status(200).send({ success: true, processed: events.length });
  } catch (error) {
    console.error('批量存储埋点数据失败', error);
    res.status(500).send({ success: false, error: error.message });
  }
});

// 获取埋点数据API（需要管理员权限）
router.get('/events', authenticateToken, async (req, res) => {
  try {
    // 验证是否是管理员
    if (req.user.role !== 'admin') {
      return res.status(403).send({ success: false, message: '权限不足' });
    }
    
    const { startDate, endDate, eventType, page, limit } = req.query;
    const events = await analyticsService.getEvents({
      startDate, 
      endDate, 
      eventType,
      page: parseInt(page) || 1,
      limit: parseInt(limit) || 10
    });
    
    res.send({ success: true, data: events });
  } catch (error) {
    console.error('获取埋点数据失败', error);
    res.status(500).send({ success: false, error: error.message });
  }
});

// 获取统计数据API
router.get('/stats', authenticateToken, async (req, res) => {
  try {
    // 验证是否是管理员
    if (req.user.role !== 'admin') {
      return res.status(403).send({ success: false, message: '权限不足' });
    }
    
    const { startDate, endDate, eventType } = req.query;
    const stats = await analyticsService.getStats({
      startDate,
      endDate,
      eventType
    });
    
    res.send({ success: true, data: stats });
  } catch (error) {
    console.error('获取统计数据失败', error);
    res.status(500).send({ success: false, error: error.message });
  }
});

// 获取图表数据API
router.get('/chart-data', authenticateToken, async (req, res) => {
  try {
    console.log('收到图表数据请求，参数:', req.query);
    
    // 验证是否是管理员
    if (req.user.role !== 'admin') {
      return res.status(403).send({ success: false, message: '权限不足' });
    }
    
    const { startDate, endDate, eventType } = req.query;
    console.log('处理后的参数:', { startDate, endDate, eventType });
    
    const chartData = await analyticsService.getChartData({
      startDate,
      endDate,
      eventType
    });
    
    console.log('成功获取图表数据，返回数据结构:', Object.keys(chartData));
    res.send({ success: true, data: chartData });
  } catch (error) {
    console.error('获取图表数据失败, 详细错误:', error);
    res.status(500).send({ success: false, error: error.message });
  }
});

// 导出埋点数据API
router.get('/export', authenticateToken, async (req, res) => {
  try {
    // 验证是否是管理员
    if (req.user.role !== 'admin') {
      return res.status(403).send({ success: false, message: '权限不足' });
    }
    
    const { startDate, endDate, eventType } = req.query;
    const csvData = await analyticsService.exportEvents({
      startDate,
      endDate,
      eventType
    });
    
    // 设置响应头为CSV文件
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', `attachment; filename=analytics_export_${new Date().toISOString().split('T')[0]}.csv`);
    
    // 发送CSV数据
    res.send(csvData);
  } catch (error) {
    console.error('导出埋点数据失败', error);
    res.status(500).send({ success: false, error: error.message });
  }
});

module.exports = router;