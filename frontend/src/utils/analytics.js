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
  // 是否已初始化
  initialized: false,
  // 页面加载时间
  pageLoadTime: Date.now(),
  // 存储当前用户会话信息
  userSession: {
    userId: null,
    username: null
  },
  // 存储等待上报的事件
  pendingEvents: [],
  // 上报间隔(毫秒)
  reportInterval: 10000, // 10秒
  // 批量上报的最大事件数
  maxBatchSize: 20,
  // 上报计时器
  reportTimer: null,
  // 初始化函数
  init () {
    if (this.initialized) return
    console.log('埋点系统初始化完成')
    this.initialized = true
    this.pageLoadTime = Date.now()
    // 尝试获取并缓存用户信息
    this._getUserInfo()
    // 初始化事件
    this.trackEvent('system', 'init', {
      timestamp: Date.now(),
      userAgent: navigator.userAgent
    })
    // 启动定时上报
    this._startReportTimer()
    // 添加页面离开事件
    window.addEventListener('beforeunload', () => {
      // 页面离开时立即上报所有待发送事件
      this.trackEvent('system', 'page_exit', {
        stayDuration: Date.now() - this.pageLoadTime
      })
      this._reportPendingEvents(true)
    })
  },

  // 启动定时上报
  _startReportTimer () {
    // 清除已有的计时器
    if (this.reportTimer) {
      clearInterval(this.reportTimer)
    }
    // 设置新的计时器
    this.reportTimer = setInterval(() => {
      this._reportPendingEvents()
    }, this.reportInterval)
  },

  // 跟踪页面访问
  trackPageView (pageName, pageParams = {}) {
    if (!this.enabled) return
    const eventData = {
      type: EVENT_TYPES.PAGE_VIEW,
      pageName,
      pageParams,
      timestamp: Date.now(),
      path: window.location.pathname,
      title: document.title
    }
    this._addToPendingEvents(eventData)
  },
  // 跟踪点击事件
  trackClick (elementName, elementId = '', extraData = {}) {
    if (!this.enabled) return
    const eventData = {
      type: EVENT_TYPES.CLICK,
      elementName,
      elementId,
      ...extraData,
      timestamp: Date.now(),
      path: window.location.pathname
    }
    this._addToPendingEvents(eventData)
  },
  // 跟踪筛选事件
  trackFilter (filterName, filterValue, extraData = {}) {
    if (!this.enabled) return
    const eventData = {
      type: EVENT_TYPES.FILTER,
      filterName,
      filterValue,
      ...extraData,
      timestamp: Date.now(),
      path: window.location.pathname
    }
    this._addToPendingEvents(eventData)
  },
  // 跟踪分页事件
  trackPagination (pageType, pageNumber, extraData = {}) {
    if (!this.enabled) return
    const eventData = {
      type: EVENT_TYPES.PAGINATION,
      pageType,
      pageNumber,
      ...extraData,
      timestamp: Date.now(),
      path: window.location.pathname
    }
    this._addToPendingEvents(eventData)
  },
  // 通用事件跟踪
  trackEvent (category, action, data = {}) {
    if (!this.enabled) return
    const eventData = {
      type: 'custom',
      category,
      action,
      ...data,
      timestamp: Date.now(),
      path: window.location.pathname
    }
    this._addToPendingEvents(eventData)
  },
  // 添加到待上报事件队列
  _addToPendingEvents (data) {
    // 确保用户信息是最新的
    if (!this.userSession.userId) {
      this._getUserInfo()
    }
    // 添加用户标识
    data.userId = this.userSession.userId
    data.username = this.userSession.username
    // 添加到待上报队列
    this.pendingEvents.push(data)
    // 在调试模式下，打印埋点数据
    if (this.debugMode) {
      console.log('%c埋点数据(待上报)', 'color: #4ecdc4; font-weight: bold', data)
    }
    // 如果待上报事件达到最大批量大小，立即上报
    if (this.pendingEvents.length >= this.maxBatchSize) {
      this._reportPendingEvents()
    }
    // 同时保存到本地存储用于调试
    this._saveToLocalStorage(data)
  },
  // 上报待发送的事件
  _reportPendingEvents (isPageExit = false) {
    // 如果没有待上报事件，直接返回
    if (this.pendingEvents.length === 0) return
    // 复制需要上报的事件数据，并清空待上报队列
    const eventsToReport = [...this.pendingEvents]
    this.pendingEvents = []
    if (this.debugMode) {
      console.log('%c批量上报埋点数据', 'color: #4ecdc4; font-weight: bold', eventsToReport)
    }
    // 如果是页面退出，使用同步请求
    if (isPageExit && navigator.sendBeacon) {
      navigator.sendBeacon('/api/analytics/batch-events', JSON.stringify({
        events: eventsToReport,
        isExit: true
      }))
    } else {
      // 正常情况下使用异步请求
      fetch('/api/analytics/batch-events', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ events: eventsToReport }),
        keepalive: true
      }).catch(err => {
        console.error('埋点数据发送失败', err)
        // 发送失败时，将事件重新加入队列
        this.pendingEvents = [...eventsToReport, ...this.pendingEvents]
      })
    }
  },
  // 获取用户信息
  _getUserInfo () {
    try {
      // 尝试从localStorage中获取用户信息
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        const userInfo = JSON.parse(userInfoStr)
        // 检查userInfo中有效的ID字段
        if (userInfo && userInfo.id) {
          this.userSession.userId = userInfo.id
          this.userSession.username = userInfo.username || 'anonymous'
          console.log('从userInfo.id获取到用户信息:', this.userSession)
          return
        }
        // 有些情况下用户信息可能保存在其他字段
        if (userInfo && userInfo.userId) {
          this.userSession.userId = userInfo.userId
          this.userSession.username = userInfo.username || 'anonymous'
          console.log('从userInfo.userId获取到用户信息:', this.userSession)
          return
        }
        // 如果有username但没有id，使用username作为userId
        if (userInfo && userInfo.username) {
          this.userSession.userId = userInfo.username
          this.userSession.username = userInfo.username
          console.log('使用username作为userId:', this.userSession)
          return
        }
      }
      // 如果localStorage中没有，尝试从token中解析
      const storedToken = localStorage.getItem('accessToken')
      if (storedToken) {
        try {
          // 如果有token，尝试解析token获取用户ID
          const tokenParts = storedToken.split('.')
          if (tokenParts.length === 3) {
            const tokenData = JSON.parse(atob(tokenParts[1]))
            if (tokenData.id) {
              this.userSession.userId = tokenData.id
              this.userSession.username = tokenData.username || 'anonymous'
              console.log('从token获取到用户信息:', this.userSession)
              return
            }
            // 如果token中没有id但有sub字段，使用sub作为userId
            if (tokenData.sub) {
              this.userSession.userId = tokenData.sub
              this.userSession.username = tokenData.username || tokenData.sub || 'anonymous'
              console.log('从token.sub获取到用户信息:', this.userSession)
              return
            }
          }
        } catch (e) {
          console.error('解析token失败', e)
        }
      }
      // 尝试从sessionStorage获取
      const sessionUserInfo = sessionStorage.getItem('session_user_info')
      if (sessionUserInfo) {
        try {
          const userInfo = JSON.parse(sessionUserInfo)
          if (userInfo && (userInfo.id || userInfo.userId || userInfo.username)) {
            this.userSession.userId = userInfo.id || userInfo.userId || userInfo.username
            this.userSession.username = userInfo.username || 'anonymous'
            console.log('从sessionStorage获取到用户信息:', this.userSession)
            return
          }
        } catch (e) {
          console.error('解析sessionStorage中的用户信息失败', e)
        }
      }
      // 如果都没有，设为匿名用户，但保存一个唯一标识在localStorage中
      let anonymousId = localStorage.getItem('anonymous_user_id')
      if (!anonymousId) {
        anonymousId = 'anonymous_' + Math.random().toString(36).substring(2, 15)
        localStorage.setItem('anonymous_user_id', anonymousId)
      }
      this.userSession.userId = anonymousId
      this.userSession.username = 'anonymous'
      console.log('使用匿名用户ID:', this.userSession)
    } catch (error) {
      console.error('获取用户信息失败', error)
      this.userSession.userId = 'anonymous'
      this.userSession.username = 'anonymous'
    }
  },
  // 将数据保存到本地存储，用于调试
  _saveToLocalStorage (data) {
    try {
      const storageKey = 'analytics_events'
      const storedEvents = JSON.parse(localStorage.getItem(storageKey) || '[]')
      storedEvents.push(data)
      // 只保留最近的100条记录，避免占用过多存储空间
      if (storedEvents.length > 100) {
        storedEvents.splice(0, storedEvents.length - 100)
      }
      localStorage.setItem(storageKey, JSON.stringify(storedEvents))
    } catch (error) {
      console.error('本地埋点数据存储失败', error)
    }
  }
}

export default analytics
