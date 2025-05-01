// 在backend/src/services/analytics/analyticsService.js中
const pool = require('../../db'); // 修改为使用数据库连接池

// 处理单个事件数据的通用方法
const processEventData = (eventData) => {
  console.log('处理埋点事件数据:', JSON.stringify(eventData));
  
  // 从eventData或其metadata字段中提取用户ID
  let userId = eventData.userId || 'anonymous';
  // 如果前端使用vuex存储，可能会在user对象中传递
  if (eventData.user && eventData.user.id) {
    userId = eventData.user.id;
  }
  
  // 根据事件类型提取页面名称和元素信息
  let pageName = '';
  let elementName = '';
  let elementId = '';
  let eventType = '';
  
  // 确保事件类型正确
  if (typeof eventData.type === 'string') {
    eventType = eventData.type;
  }
  
  // 处理不同类型的事件
  switch(eventType) {
    case 'page_view':
      pageName = eventData.pageName || '';
      break;
    case 'click':
      elementName = eventData.elementName || '';
      elementId = eventData.elementId || '';
      break;
    case 'filter':
      elementName = eventData.filterName || '';
      elementId = eventData.filterValue || '';
      break;
    case 'pagination':
      elementName = eventData.pageType || '';
      elementId = eventData.pageNumber?.toString() || '';
      break;
    case 'custom':
      // 对于自定义事件，尝试从category和action中提取信息
      if (eventData.category && eventData.action) {
        elementName = eventData.category;
        elementId = eventData.action;
      }
      break;
    default:
      // 尝试从metadata中提取更多信息
      console.log('未知事件类型:', eventType, '尝试从其他字段提取信息');
      
      // 检查是否有可能是系统事件
      if (eventData.category === 'system') {
        eventType = 'system';
        elementName = eventData.action || '';
      } 
      // 检查是否为自定义事件的格式
      else if (eventData.category && eventData.action) {
        eventType = 'custom';
        elementName = eventData.category;
        elementId = eventData.action;
      }
  }
  
  // 确保timestamp是数字类型
  let timestamp = Date.now();
  if (eventData.timestamp && !isNaN(eventData.timestamp)) {
    timestamp = eventData.timestamp;
  }
  
  const result = {
    eventType, 
    userId,
    pageName,
    elementName,
    elementId,
    timestamp,
    metadata: JSON.stringify(eventData),
    ip: eventData.ip || ''
  };
  
  console.log('处理后的埋点数据:', result);
  return result;
};

const analyticsService = {
  // 存储埋点事件
  async storeEvent(eventData) {
    try {
      console.log('接收到的埋点数据:', JSON.stringify(eventData));
      
      const processedData = processEventData(eventData);
      
      // 将事件数据插入到analytics_events表
      const sql = `
        INSERT INTO analytics_events 
        (event_type, user_id, page_name, element_name, element_id, timestamp, metadata, ip)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `;
      
      const params = [
        processedData.eventType,
        processedData.userId,
        processedData.pageName,
        processedData.elementName,
        processedData.elementId,
        processedData.timestamp,
        processedData.metadata,
        processedData.ip
      ];
      
      const [result] = await pool.query(sql, params);
      console.log('埋点事件存储成功，ID:', result.insertId);
      return true;
    } catch (error) {
      console.error('存储埋点事件失败:', error);
      throw error;
    }
  },
  
  // 批量存储埋点事件
  async storeBatchEvents(eventsData) {
    try {
      if (!Array.isArray(eventsData) || eventsData.length === 0) {
        console.warn('批量存储埋点事件: 没有有效的事件数据');
        return false;
      }
      
      console.log(`准备批量存储 ${eventsData.length} 条埋点事件`);
      
      // 处理所有事件数据
      const processedEvents = eventsData.map(processEventData);
      
      // 使用事务保证数据一致性
      const connection = await pool.getConnection();
      await connection.beginTransaction();
      
      try {
        const sql = `
          INSERT INTO analytics_events 
          (event_type, user_id, page_name, element_name, element_id, timestamp, metadata, ip)
          VALUES ?
        `;
        
        // 准备批量插入的参数
        const values = processedEvents.map(event => [
          event.eventType,
          event.userId,
          event.pageName,
          event.elementName,
          event.elementId,
          event.timestamp,
          event.metadata,
          event.ip
        ]);
        
        // 执行批量插入
        const [result] = await connection.query(sql, [values]);
        
        // 提交事务
        await connection.commit();
        
        console.log(`成功批量存储 ${result.affectedRows} 条埋点事件`);
        return true;
      } catch (error) {
        // 发生错误时回滚事务
        await connection.rollback();
        throw error;
      } finally {
        // 释放连接
        connection.release();
      }
    } catch (error) {
      console.error('批量存储埋点事件失败:', error);
      
      // 如果批量失败，尝试逐个存储
      console.log('尝试逐个存储事件...');
      try {
        for (const eventData of eventsData) {
          await this.storeEvent(eventData).catch(err => {
            console.error('单个事件存储失败:', err, eventData);
          });
        }
        return true;
      } catch (fallbackError) {
        console.error('逐个存储事件也失败:', fallbackError);
        throw error; // 抛出原始错误
      }
    }
  },
  
  // 获取埋点数据
  async getEvents({ startDate, endDate, eventType, page = 1, limit = 10 }) {
    try {
      let sql = `SELECT * FROM analytics_events WHERE 1=1`;
      const params = [];
      
      if (startDate) {
        sql += ` AND timestamp >= ?`;
        params.push(startDate);
      }
      
      if (endDate) {
        sql += ` AND timestamp <= ?`;
        params.push(endDate);
      }
      
      if (eventType) {
        sql += ` AND event_type = ?`;
        params.push(eventType);
      }
      
      // 获取总数
      const countSql = sql.replace('SELECT *', 'SELECT COUNT(*) as total');
      const [countResult] = await pool.query(countSql, params);
      const total = countResult[0].total;
      
      // 添加分页
      const offset = (page - 1) * limit;
      sql += ` ORDER BY timestamp DESC LIMIT ? OFFSET ?`;
      params.push(parseInt(limit), parseInt(offset));
      
      const [rows] = await pool.query(sql, params);
      
      return {
        events: rows,
        total
      };
    } catch (error) {
      console.error('获取埋点数据失败:', error);
      throw error;
    }
  },
  
  // 获取统计数据
  async getStats({ startDate, endDate, eventType }) {
    try {
      const params = [];
      let whereClause = '1=1';
      
      if (startDate) {
        whereClause += ' AND timestamp >= ?';
        params.push(startDate);
      }
      
      if (endDate) {
        whereClause += ' AND timestamp <= ?';
        params.push(endDate);
      }
      
      // 获取总事件数
      let sql = `SELECT COUNT(*) as total FROM analytics_events WHERE ${whereClause}`;
      const [totalResult] = await pool.query(sql, params);
      
      // 获取页面访问量
      const pageViewParams = [...params];
      if (eventType) {
        whereClause += ' AND event_type = ?';
        pageViewParams.push('page_view');
      } else {
        whereClause += ' AND event_type = ?';
        pageViewParams.push('page_view');
      }
      sql = `SELECT COUNT(*) as total FROM analytics_events WHERE ${whereClause}`;
      const [pageViewsResult] = await pool.query(sql, pageViewParams);
      
      // 获取点击事件数
      const clickParams = [...params];
      whereClause = whereClause.replace(' AND event_type = ?', '');
      whereClause += ' AND event_type = ?';
      clickParams.push('click');
      sql = `SELECT COUNT(*) as total FROM analytics_events WHERE ${whereClause}`;
      const [clickEventsResult] = await pool.query(sql, clickParams);
      
      // 获取活跃用户数
      sql = `SELECT COUNT(DISTINCT user_id) as total FROM analytics_events WHERE ${whereClause.replace(' AND event_type = ?', '')}`;
      const [activeUsersResult] = await pool.query(sql, params);
      
      return {
        totalEvents: totalResult[0].total,
        pageViews: pageViewsResult[0].total,
        clickEvents: clickEventsResult[0].total,
        activeUsers: activeUsersResult[0].total
      };
    } catch (error) {
      console.error('获取统计数据失败:', error);
      throw error;
    }
  },
  
  // 获取图表数据
  async getChartData({ startDate, endDate, eventType }) {
    try {
      const result = {
        eventTrend: { dates: [], values: [] },
        eventTypeDistribution: [],
        popularClickElements: { elements: [], counts: [] },
        pageViewDistribution: [],
        userBehaviorPath: { nodes: [], links: [] }
      };
      
      const params = [];
      let whereClause = '1=1';
      
      if (startDate) {
        whereClause += ' AND timestamp >= ?';
        params.push(startDate);
      }
      
      if (endDate) {
        whereClause += ' AND timestamp <= ?';
        params.push(endDate);
      }
      
      if (eventType && eventType !== '') {
        whereClause += ' AND event_type = ?';
        params.push(eventType);
      }
      
      // 获取事件趋势数据（安全处理日期）
      const trendSql = `
        SELECT 
          DATE(FROM_UNIXTIME(timestamp/1000)) as date,
          COUNT(*) as count
        FROM analytics_events
        WHERE ${whereClause}
        GROUP BY date
        ORDER BY date
      `;
      
      console.log('趋势SQL:', trendSql, '参数:', params);
      
      try {
        const [trendResults] = await pool.query(trendSql, params);
        result.eventTrend.dates = trendResults.map(row => row.date);
        result.eventTrend.values = trendResults.map(row => row.count);
      } catch (error) {
        console.error('获取事件趋势数据失败:', error);
        result.eventTrend = { dates: [], values: [], error: error.message };
      }
      
      // 获取事件类型分布（不包含事件类型筛选条件）
      let typeParams = [...params];
      let typeWhereClause = whereClause;
      
      if (eventType && eventType !== '') {
        // 移除事件类型筛选
        typeWhereClause = typeWhereClause.replace(' AND event_type = ?', '');
        typeParams = typeParams.filter(p => p !== eventType);
      }
      
      const typeSql = `
        SELECT event_type, COUNT(*) as count
        FROM analytics_events
        WHERE ${typeWhereClause}
        GROUP BY event_type
        ORDER BY count DESC
      `;
      
      try {
        const [typeResults] = await pool.query(typeSql, typeParams);
        result.eventTypeDistribution = typeResults.map(row => ({
          name: row.event_type || '未知类型',
          value: row.count
        }));
      } catch (error) {
        console.error('获取事件类型分布失败:', error);
        result.eventTypeDistribution = [];
      }
      
      // 获取热门点击元素
      let elementParams = [...params];
      let elementWhereClause = whereClause;
      
      if (eventType && eventType !== '') {
        // 移除事件类型筛选，替换为click类型
        elementWhereClause = elementWhereClause.replace(' AND event_type = ?', '');
        elementParams = elementParams.filter(p => p !== eventType);
      }
      
      elementWhereClause += ' AND event_type = "click"';
      
      const elementSql = `
        SELECT element_name, COUNT(*) as count
        FROM analytics_events
        WHERE ${elementWhereClause}
        GROUP BY element_name
        ORDER BY count DESC
        LIMIT 10
      `;
      
      try {
        const [elementResults] = await pool.query(elementSql, elementParams);
        result.popularClickElements.elements = elementResults.map(row => row.element_name || '未知元素');
        result.popularClickElements.counts = elementResults.map(row => row.count);
      } catch (error) {
        console.error('获取热门点击元素失败:', error);
        result.popularClickElements = { elements: [], counts: [] };
      }
      
      // 获取页面访问分布
      let pageParams = [...params];
      let pageWhereClause = whereClause;
      
      if (eventType && eventType !== '') {
        // 移除事件类型筛选，替换为page_view类型
        pageWhereClause = pageWhereClause.replace(' AND event_type = ?', '');
        pageParams = pageParams.filter(p => p !== eventType);
      }
      
      pageWhereClause += ' AND event_type = "page_view"';
      
      const pageSql = `
        SELECT page_name, COUNT(*) as count
        FROM analytics_events
        WHERE ${pageWhereClause}
        GROUP BY page_name
        ORDER BY count DESC
        LIMIT 10
      `;
      
      try {
        const [pageResults] = await pool.query(pageSql, pageParams);
        result.pageViewDistribution = pageResults.map(row => ({
          name: row.page_name || '未知页面',
          value: row.count
        }));
      } catch (error) {
        console.error('获取页面访问分布失败:', error);
        result.pageViewDistribution = [];
      }
      
      return result;
    } catch (error) {
      console.error('获取图表数据失败, 详细错误:', error);
      throw error;
    }
  },
  
  // 导出埋点数据为CSV
  async exportEvents({ startDate, endDate, eventType }) {
    try {
      let sql = `SELECT * FROM analytics_events WHERE 1=1`;
      const params = [];
      
      if (startDate) {
        sql += ` AND timestamp >= ?`;
        params.push(startDate);
      }
      
      if (endDate) {
        sql += ` AND timestamp <= ?`;
        params.push(endDate);
      }
      
      if (eventType) {
        sql += ` AND event_type = ?`;
        params.push(eventType);
      }
      
      sql += ` ORDER BY timestamp DESC LIMIT 10000`; // 限制导出数量
      
      const [rows] = await pool.query(sql, params);
      
      // 生成CSV标题行
      const headers = ['时间', '事件类型', '用户ID', '页面名称', '元素名称', '元素ID', 'IP', '详细数据'];
      
      // 生成CSV行数据
      const csvData = rows.map(row => {
        return [
          new Date(row.timestamp).toISOString(),
          row.event_type,
          row.user_id,
          row.page_name,
          row.element_name,
          row.element_id,
          row.ip,
          row.metadata
        ].map(val => `"${(val || '').toString().replace(/"/g, '""')}"`).join(',');
      });
      
      // 组合CSV内容
      return [headers.join(','), ...csvData].join('\n');
    } catch (error) {
      console.error('导出埋点数据失败:', error);
      throw error;
    }
  }
};

module.exports = analyticsService;