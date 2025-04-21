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
// 导入API服务
import apiService, { getApiUrl, getResourceUrl } from './utils/api'

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
  locale: zhCn
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

// 注册为全局属性
app.config.globalProperties.$axios = apiService
app.config.globalProperties.$getApiUrl = getApiUrl
app.config.globalProperties.$getResourceUrl = getResourceUrl

// 全局挂载API工具
app.provide('apiService', apiService)
app.provide('getApiUrl', getApiUrl)
app.provide('getResourceUrl', getResourceUrl)

// 定义全局用户信息修复函数
window.$fixUserInfo = function () {
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
