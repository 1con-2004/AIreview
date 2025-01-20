import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/styles/login.css'
import './assets/styles/common.css'

const app = createApp(App)
app.use(router)
app.mount('#app')
