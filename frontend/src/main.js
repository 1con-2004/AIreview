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
    console.log('发送请求:', config.method.toUpperCase(), config.url, config.data);
    
    // 从localStorage获取token并添加到请求头
    const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}');
    if (userInfo.token) {
      config.headers['Authorization'] = `Bearer ${userInfo.token}`;
      console.log('添加认证令牌:', `Bearer ${userInfo.token}`);
    } else {
      console.log('未找到认证令牌');
    }
    
    return config;
  },
  error => {
    console.error('请求错误:', error);
    return Promise.reject(error);
  }
);

// 添加响应拦截器
axios.interceptors.response.use(
  response => {
    console.log('收到响应:', response.status, response.data);
    return response;
  },
  error => {
    console.error('响应错误:', error.response?.status, error.response?.data);
    return Promise.reject(error);
  }
);

app.mount('#app')
