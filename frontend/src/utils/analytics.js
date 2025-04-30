// 简单的前端埋点工具

// 埋点事件类型
const EVENT_TYPES = {
  PAGE_VIEW: 'page_view',
  CLICK: 'click',
  FILTER: 'filter',
  PAGINATION: 'pagination'
}

// 简单的埋点工具
const analytics = {
  // 是否开启埋点
  enabled: true,
  // 是否开启控制台日志
  debugMode: true,
  // 初始化函数
  init () {
    console.log('埋点系统初始化完成');
    this.trackEvent('system', 'init', {
      timestamp: new Date().getTime(),
      userAgent: navigator.userAgent
    });
  },
  
  // 跟踪页面访问
  trackPageView(pageName, pageParams = {}) {
    if (!this.enabled) return;
    
    const eventData = {
      type: EVENT_TYPES.PAGE_VIEW,
      pageName,
      pageParams,
      timestamp: new Date().getTime()
    };
    
    this._sendToServer(eventData);
  },
  
  // 跟踪点击事件
  trackClick(elementName, elementId = '', extraData = {}) {
    if (!this.enabled) return;
    
    const eventData = {
      type: EVENT_TYPES.CLICK,
      elementName,
      elementId,
      ...extraData,
      timestamp: new Date().getTime()
    };
    
    this._sendToServer(eventData);
  },
  
  // 跟踪筛选事件
  trackFilter(filterName, filterValue, extraData = {}) {
    if (!this.enabled) return;
    
    const eventData = {
      type: EVENT_TYPES.FILTER,
      filterName,
      filterValue,
      ...extraData,
      timestamp: new Date().getTime()
    };
    
    this._sendToServer(eventData);
  },
  
  // 跟踪分页事件
  trackPagination(pageType, pageNumber, extraData = {}) {
    if (!this.enabled) return;
    
    const eventData = {
      type: EVENT_TYPES.PAGINATION,
      pageType,
      pageNumber,
      ...extraData,
      timestamp: new Date().getTime()
    };
    
    this._sendToServer(eventData);
  },
  
  // 通用事件跟踪
  trackEvent(category, action, data = {}) {
    if (!this.enabled) return;
    
    const eventData = {
      category,
      action,
      ...data,
      timestamp: new Date().getTime()
    }
    this._sendToServer(eventData)
  },
  
  // 发送数据到服务器
  _sendToServer(data) {
    // 在调试模式下，打印埋点数据
    if (this.debugMode) {
      console.log('%c埋点数据', 'color: #4ecdc4; font-weight: bold', data);
    }
    
    // 这里可以使用 navigator.sendBeacon 或 fetch 发送数据
    // 简单起见，这里使用 localStorage 暂存埋点数据
    try {
      const storageKey = 'analytics_events';
      const storedEvents = JSON.parse(localStorage.getItem(storageKey) || '[]');
      storedEvents.push(data);
      localStorage.setItem(storageKey, JSON.stringify(storedEvents));
      
      // 也可以替换为实际的API调用
      // fetch('/api/analytics/event', {
      //   method: 'POST',
      //   headers: { 'Content-Type': 'application/json' },
      //   body: JSON.stringify(data),
      //   keepalive: true // 确保页面关闭时也能发送
      // });
    } catch (error) {
      console.error('埋点数据发送失败', error)
    }
  }
}

export default analytics
