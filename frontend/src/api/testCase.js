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
    const userInfoStr = localStorage.getItem('userInfo')
    const userInfo = userInfoStr ? JSON.parse(userInfoStr) : null
    const accessToken = userInfo?.accessToken || localStorage.getItem('accessToken')

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

    const response = await axios.get(`/api/testcases/examples/${problemId}`, { headers })
    return response.data
  } catch (error) {
    console.error('获取题目样例失败:', error)
    throw error
  }
}

// 获取题目的所有测试用例（管理员接口）
export const getAllTestCases = async (problemId) => {
  try {
    const response = await axios.get(`/api/testcases/admin/all/${problemId}`)
    return response.data
  } catch (error) {
    console.error('获取所有测试用例失败:', error)
    throw error
  }
}

// 添加测试用例（管理员接口）
export const addTestCase = async (data) => {
  try {
    const response = await axios.post('/api/testcases/admin', data)
    return response.data
  } catch (error) {
    console.error('添加测试用例失败:', error)
    throw error
  }
}

// 更新测试用例（管理员接口）
export const updateTestCase = async (id, data) => {
  try {
    const response = await axios.put(`/api/testcases/admin/${id}`, data)
    return response.data
  } catch (error) {
    console.error('更新测试用例失败:', error)
    throw error
  }
}

// 删除测试用例（管理员接口）
export const deleteTestCase = async (id) => {
  try {
    const response = await axios.delete(`/api/testcases/admin/${id}`)
    return response.data
  } catch (error) {
    console.error('删除测试用例失败:', error)
    throw error
  }
}
