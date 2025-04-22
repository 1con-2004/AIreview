import axios from 'axios'

// 创建axios实例
const request = axios.create({
  baseURL: process.env.VUE_APP_BASE_API || '', // url = base url + request url
  timeout: 15000 // 请求超时时间
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    // 在发送请求之前做些什么
    // 增强令牌获取逻辑，从多个位置尝试获取令牌
    let accessToken = null
    
    // 先从localStorage直接获取accessToken
    const directToken = localStorage.getItem('accessToken')
    if (directToken) {
      accessToken = directToken
    } 
    // 如果直接获取失败，尝试从userInfo获取
    else {
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        try {
          const userInfo = JSON.parse(userInfoStr)
          if (userInfo.accessToken) {
            accessToken = userInfo.accessToken
            
            // 同步到localStorage中的独立令牌项
            localStorage.setItem('accessToken', userInfo.accessToken)
          }
        } catch (e) {
          console.error('解析localStorage中userInfo出错:', e)
        }
      }
    }
    
    // 如果找到令牌，添加到请求头
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`
    }
    
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    const res = response.data
    return res
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 获取题目的显示样例
export const getProblemExamples = async (problemId) => {
  try {
    // 确保获取和使用正确的token
    const userInfoStr = localStorage.getItem('userInfo')
    const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
    const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')

    const headers = accessToken ? { Authorization: `Bearer ${accessToken}` } : {}

    const response = await request.get(`testcases/examples/${problemId}`, { headers })
    return response.data
  } catch (error) {
    console.error('获取题目样例失败:', error)
    throw error
  }
}

// 获取题目的所有测试用例（管理员接口）
export const getAllTestCases = async (problemId) => {
  try {
    const response = await request.get(`testcases/admin/all/${problemId}`)
    return response.data
  } catch (error) {
    console.error('获取所有测试用例失败:', error)
    throw error
  }
}

// 添加测试用例（管理员接口）
export const addTestCase = async (data) => {
  try {
    const response = await request.post('testcases/admin', data)
    return response.data
  } catch (error) {
    console.error('添加测试用例失败:', error)
    throw error
  }
}

// 更新测试用例（管理员接口）
export const updateTestCase = async (id, data) => {
  try {
    const response = await request.put(`testcases/admin/${id}`, data)
    return response.data
  } catch (error) {
    console.error('更新测试用例失败:', error)
    throw error
  }
}

// 删除测试用例（管理员接口）
export const deleteTestCase = async (id) => {
  try {
    const response = await request.delete(`testcases/admin/${id}`)
    return response.data
  } catch (error) {
    console.error('删除测试用例失败:', error)
    throw error
  }
}

export default request
