/**
 * Docker辅助脚本 - 用于在容器中支持Docker命令
 * 通过将宿主机的Docker socket挂载到容器中，实现容器内部控制宿主机Docker的功能
 */

const { execSync, spawn } = require('child_process');
const path = require('path');
const fs = require('fs').promises;
const util = require('util');
const exec = util.promisify(require('child_process').exec);

/**
 * 检查Docker可用性
 * @returns {Promise<boolean>} Docker是否可用
 */
async function checkDockerAvailability() {
  try {
    await exec('docker info');
    console.log('Docker daemon正常运行');
    return true;
  } catch (error) {
    console.error('Docker daemon不可用:', error.message);
    return false;
  }
}

/**
 * 获取Docker详细信息
 * @returns {Promise<Object>} Docker详细信息
 */
async function getDockerInfo() {
  try {
    const { stdout } = await exec('docker info --format "{{json .}}"');
    try {
      const info = JSON.parse(stdout);
      return {
        success: true,
        info,
        error: null
      };
    } catch (parseError) {
      console.error('Docker信息解析失败:', parseError.message);
      return {
        success: false,
        info: null,
        error: `Docker信息解析失败: ${parseError.message}`,
        rawOutput: stdout
      };
    }
  } catch (error) {
    console.error('获取Docker信息失败:', error.message);
    return {
      success: false,
      info: null,
      error: `获取Docker信息失败: ${error.message}`,
      command: 'docker info',
      errorDetails: error
    };
  }
}

/**
 * 检查Docker权限问题并尝试修复
 * @returns {Promise<Object>} 检查结果和修复建议
 */
async function diagnoseDockerPermissions() {
  try {
    const results = {
      dockerSocket: false,
      socketPermissions: null,
      userInDockerGroup: false,
      canRunContainer: false,
      diagnostics: [],
      fixSuggestions: []
    };
    
    // 检查Docker Socket是否存在
    try {
      const socketStats = await fs.stat('/var/run/docker.sock');
      results.dockerSocket = true;
      results.socketPermissions = {
        mode: socketStats.mode.toString(8),
        uid: socketStats.uid,
        gid: socketStats.gid
      };
      results.diagnostics.push('Docker socket存在');
    } catch (error) {
      results.diagnostics.push('Docker socket不存在或无法访问');
      results.fixSuggestions.push('确保Docker服务正在运行，并且/var/run/docker.sock文件存在');
    }
    
    // 检查当前用户是否在Docker组中
    try {
      const { stdout: groups } = await exec('id -Gn');
      if (groups.includes('docker')) {
        results.userInDockerGroup = true;
        results.diagnostics.push('当前用户在docker组中');
      } else {
        results.diagnostics.push('当前用户不在docker组中');
        results.fixSuggestions.push('将当前用户添加到docker组: sudo usermod -aG docker $USER');
      }
    } catch (error) {
      results.diagnostics.push('无法检查用户组信息');
    }
    
    // 尝试运行简单的Docker容器
    try {
      await exec('docker run --rm hello-world');
      results.canRunContainer = true;
      results.diagnostics.push('成功运行测试容器');
    } catch (error) {
      results.diagnostics.push(`运行测试容器失败: ${error.message}`);
      results.fixSuggestions.push('检查Docker服务状态: systemctl status docker');
    }
    
    return results;
  } catch (error) {
    return {
      success: false,
      error: `诊断Docker权限失败: ${error.message}`,
      errorDetails: error
    };
  }
}

/**
 * 检查必要的镜像是否存在，如果不存在则拉取
 * @returns {Promise<void>}
 */
async function ensureRequiredImages() {
  const requiredImages = [
    'gcc:latest',
    'python:3.9-slim',
    'openjdk:11'
  ];

  for (const image of requiredImages) {
    try {
      const { stdout } = await exec(`docker images -q ${image}`);
      if (!stdout.trim()) {
        console.log(`拉取镜像: ${image}`);
        await exec(`docker pull ${image}`);
        console.log(`镜像 ${image} 拉取成功`);
      } else {
        console.log(`镜像 ${image} 已存在`);
      }
    } catch (error) {
      console.error(`拉取镜像 ${image} 失败:`, error.message);
      throw new Error(`拉取镜像 ${image} 失败: ${error.message}`);
    }
  }
}

/**
 * 获取Docker网络
 * @returns {Promise<string>} Docker网络名称
 */
async function getDockerNetwork() {
  // 首先尝试从环境变量获取网络
  const networkName = process.env.JUDGE_NETWORK || 'aireview_network';
  
  // 检查网络是否存在
  try {
    const { stdout } = await exec(`docker network ls --filter name=${networkName} --format "{{.Name}}"`);
    if (!stdout.trim()) {
      console.log(`创建Docker网络: ${networkName}`);
      await exec(`docker network create ${networkName}`);
      console.log(`Docker网络 ${networkName} 创建成功`);
    } else {
      console.log(`Docker网络 ${networkName} 已存在`);
    }
    return networkName;
  } catch (error) {
    console.error(`检查或创建Docker网络失败:`, error.message);
    throw new Error(`Docker网络操作失败: ${error.message}`);
  }
}

/**
 * 初始化Docker环境
 * @returns {Promise<void>}
 */
async function initializeDockerEnvironment() {
  try {
    // 检查Docker可用性
    const isDockerAvailable = await checkDockerAvailability();
    if (!isDockerAvailable) {
      throw new Error('Docker不可用，请确保Docker服务正在运行');
    }

    // 确保必要的镜像存在
    await ensureRequiredImages();
    
    // 确保Docker网络存在
    await getDockerNetwork();

    console.log('Docker环境初始化成功');
  } catch (error) {
    console.error('Docker环境初始化失败:', error.message);
    throw error;
  }
}

/**
 * 获取判题容器启动命令
 * @param {string} containerName 容器名称
 * @param {string} image 镜像名称
 * @returns {Promise<string>} Docker run命令
 */
async function getJudgeContainerCommand(containerName, image) {
  const networkName = await getDockerNetwork();
  
  // 在Docker网络中创建容器
  return `docker run -d --network=${networkName} --cpus=1 --memory=512m --name=${containerName} -w /app ${image} tail -f /dev/null`;
}

module.exports = {
  checkDockerAvailability,
  ensureRequiredImages,
  initializeDockerEnvironment,
  getDockerNetwork,
  getJudgeContainerCommand,
  getDockerInfo,
  diagnoseDockerPermissions
}; 