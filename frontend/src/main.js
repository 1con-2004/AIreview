import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

// 基础样式
import './assets/styles/common.css'
import './assets/styles/login.css'

// Element Plus
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import 'element-plus/dist/index.css'
import { ElMessage } from 'element-plus'
import axios from 'axios'

// PrimeVue 相关
import PrimeVue from 'primevue/config'
import ToastService from 'primevue/toastservice'
import Toast from 'primevue/toast'
import Dialog from 'primevue/dialog'
import InputText from 'primevue/inputtext'
import Dropdown from 'primevue/dropdown'
import Textarea from 'primevue/textarea'
import InputNumber from 'primevue/inputnumber'
import Editor from 'primevue/editor'
import Chips from 'primevue/chips'
import Button from 'primevue/button'

// PrimeVue 样式
import 'primevue/resources/themes/saga-blue/theme.css'
import 'primevue/resources/primevue.css'
import 'primeicons/primeicons.css'
import 'primeflex/primeflex.css'

// Font Awesome
import '@fortawesome/fontawesome-free/css/all.min.css'

const app = createApp(App)

app.use(router)
app.use(store)
app.use(ElementPlus, {
  locale: zhCn,
})

// 配置 PrimeVue
app.use(PrimeVue, {
  ripple: true,
  inputStyle: 'filled'
})
app.use(ToastService)

// 注册 PrimeVue 组件
app.component('Toast', Toast)
app.component('Dialog', Dialog)
app.component('InputText', InputText)
app.component('Dropdown', Dropdown)
app.component('Textarea', Textarea)
app.component('InputNumber', InputNumber)
app.component('Editor', Editor)
app.component('Chips', Chips)
app.component('Button', Button)

// 全局挂载 $message
app.config.globalProperties.$message = ElMessage

// 配置axios默认值
axios.defaults.baseURL = 'http://localhost:3000'
axios.defaults.withCredentials = true
axios.defaults.headers.common['Content-Type'] = 'application/json'

// 添加请求拦截器
axios.interceptors.request.use(
  config => {
    const requestId = `req-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 发送请求: ${config.method.toUpperCase()} ${config.url}`);
    
    // 增强token获取逻辑
    let accessToken = null;
    
    // 首先尝试从localStorage的userInfo中获取token
    try {
      const userInfoStr = localStorage.getItem('userInfo');
      if (userInfoStr) {
        const userInfo = JSON.parse(userInfoStr);
        if (userInfo && userInfo.accessToken) {
          accessToken = userInfo.accessToken;
          console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 从userInfo获取到token: ${accessToken.substring(0, 15)}...`);
        }
      }
    } catch (e) {
      console.error(`[前端日志] [${new Date().toISOString()}] [${requestId}] 解析userInfo出错:`, e);
    }
    
    // 如果userInfo中没有token，尝试直接从localStorage获取
    if (!accessToken) {
      accessToken = localStorage.getItem('accessToken');
      if (accessToken) {
        console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 从localStorage直接获取到token: ${accessToken.substring(0, 15)}...`);
      }
    }
    
    // 如果有token，添加到请求头
    if (accessToken) {
      config.headers['Authorization'] = `Bearer ${accessToken}`;
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 添加认证令牌到请求头`);
    } else {
      console.log(`[前端日志] [${new Date().toISOString()}] [${requestId}] 未找到认证令牌`);
    }
    
    return config;
  },
  error => {
    console.error(`[前端日志] [${new Date().toISOString()}] 请求错误:`, error);
    return Promise.reject(error);
  }
);

// 添加响应拦截器，处理响应数据的编码问题
axios.interceptors.response.use(
  response => {
    console.log('收到响应:', response.status, response.config?.url);
    
    // 处理可能的中文编码问题
    if (response.data && typeof response.data === 'object') {
      // 递归处理对象中的字符串值
      const processStringValues = (obj) => {
        if (!obj || typeof obj !== 'object') return obj;
        
        // 处理数组
        if (Array.isArray(obj)) {
          return obj.map(item => processStringValues(item));
        }
        
        // 复制对象，避免直接修改原对象
        const result = {...obj};
        
        Object.keys(result).forEach(key => {
          if (typeof result[key] === 'string') {
            try {
              // 判断是否包含ISO-8859-1编码的中文乱码特征
              if (/æ|ø|å|ð|ñ|ò|ó|ô|õ|ö|È|É|Ê|Ë|è|é|ê|ë|Ì|Í|Î|Ï|ì|í|î|ï/.test(result[key])) {
                console.log('检测到可能的乱码:', key, result[key]);
                
                // 尝试修复乱码
                try {
                  // 针对特定的乱码模式进行替换
                  if(key === 'tags' && typeof result[key] === 'string') {
                    // 常见标签的乱码映射
                    const tagMappings = {
                      'æ•°ç»„': '数组',
                      'å"ˆå¸Œè¡¨': '哈希表',
                      'é"¾è¡¨': '链表',
                      'å­—ç¬¦ä¸²': '字符串',
                      'åŠ¨æ€è§„åˆ': '动态规划',
                      'è´ªå¿ƒç®—æ³•': '贪心算法',
                      'æ·±åº¦ä¼˜å…ˆæœç´¢': '深度优先搜索',
                      'å¹¿åº¦ä¼˜å…ˆæœç´¢': '广度优先搜索',
                      'äºŒå‰æ ': '二叉树'
                    };
                    
                    // 按逗号分割标签
                    const tags = result[key].split(',');
                    const fixedTags = tags.map(tag => {
                      const trimmedTag = tag.trim();
                      return tagMappings[trimmedTag] || trimmedTag;
                    });
                    
                    result[key] = fixedTags.join(',');
                    console.log('修复后的标签:', result[key]);
                  } 
                  // 针对题目描述和标题等其他字段的修复
                  else if(['title', 'description', 'difficulty'].includes(key)) {
                    // 尝试将ISO-8859-1编码的字符串转回UTF-8
                    const isoString = result[key];
                    // 创建一个字节数组
                    const bytes = [];
                    for (let i = 0; i < isoString.length; i++) {
                      bytes.push(isoString.charCodeAt(i));
                    }
                    // 将字节数组转为UTF-8字符串
                    const decoder = new TextDecoder('utf-8');
                    const uint8Array = new Uint8Array(bytes);
                    const decoded = decoder.decode(uint8Array);
                    
                    // 如果解码后的字符串包含大量问号或无法识别的字符，则放弃修复
                    if (decoded.indexOf('') === -1) {
                      result[key] = decoded;
                      console.log('修复后的内容:', key, result[key]);
                    }
                  }
                } catch (fixError) {
                  console.error('修复乱码失败:', fixError);
                }
              }
            } catch (e) {
              console.error('处理编码时出错:', e);
            }
          } else if (result[key] && typeof result[key] === 'object') {
            // 递归处理嵌套对象
            result[key] = processStringValues(result[key]);
          }
        });
        
        return result;
      };
      
      // 处理并替换response.data
      response.data = processStringValues(response.data);
    }
    
    return response;
  },
  error => {
    console.error('响应错误:', error.response?.status, error.response?.data);
    return Promise.reject(error);
  }
);

// 定义全局用户信息修复函数
window.$fixUserInfo = function() {
  // 从localStorage获取用户信息
  const userInfoStr = localStorage.getItem('userInfo')
  if (!userInfoStr) return false
  
  try {
    const userInfo = JSON.parse(userInfoStr)
    if (userInfo && userInfo.username) {
      // 只将用户名存入sessionStorage，但不触发任何可能导致用户切换的操作
      sessionStorage.setItem('current_user', userInfo.username)
      console.log('已同步用户信息到sessionStorage:', userInfo.username)
      return true
    }
  } catch (e) {
    console.error('用户信息修复失败:', e)
  }
  return false
}

// 调用一次修复函数以便初始化
window.$fixUserInfo()

app.mount('#app')
