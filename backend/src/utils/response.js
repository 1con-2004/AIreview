/**
 * 生成统一的成功响应
 * @param {*} data 响应数据
 * @param {string} message 成功信息
 * @returns {Object} 成功响应对象
 */
function successResponse(data, message = '操作成功') {
  return {
    code: 200,
    message,
    data,
    timestamp: Date.now()
  };
}

/**
 * 生成统一的错误响应
 * @param {number} code 错误码
 * @param {string} message 错误信息
 * @returns {Object} 错误响应对象
 */
function errorResponse(code, message) {
  return {
    code,
    message,
    data: null,
    timestamp: Date.now()
  };
}

module.exports = {
  successResponse,
  errorResponse
}; 