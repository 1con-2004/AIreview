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

    console.log('Docker环境初始化成功');
  } catch (error) {
    console.error('Docker环境初始化失败:', error.message);
    throw error;
  }
}

module.exports = {
  checkDockerAvailability,
  ensureRequiredImages,
  initializeDockerEnvironment
}; 