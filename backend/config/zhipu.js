module.exports = {
    // 智谱AI配置 - 请勿在生产环境直接写入API密钥
    API_KEY: '3d15eadb20ff4880990d557b6689b58f.i5SZZQ04oTCWyqMX',  // 格式: {id}.{secret}
    BASE_URL: 'https://open.bigmodel.cn/api/paas/v4/chat/completions',
    MODEL: 'glm-4-flash',  // 使用flash快速版本
    
    // 模型参数配置
    DEFAULT_PARAMS: {
        temperature: 0.7,  // 温度参数，控制输出的随机性
        top_p: 0.7,       // 核采样参数
        max_tokens: 1500,  // flash版本建议使用较小的max_tokens
        request_id: null,  // 由系统自动生成
        do_sample: true,   // 是否抽样
        stream: false      // 是否流式输出
    },
    
    // 超时设置
    TIMEOUT: 30000,  // 30秒，flash版本响应更快
    
    // 重试配置
    MAX_RETRIES: 2,
    RETRY_DELAY: 1000  // 1秒
}; 