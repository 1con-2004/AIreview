const { defineConfig } = require('@vue/cli-service')
const path = require('path')

module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  configureWebpack: {
    resolve: {
      alias: {
        '@': path.resolve(__dirname, 'src'),
        primevue: path.resolve(__dirname, 'node_modules/primevue')
      }
    },
    module: {
      rules: [
        {
          test: /\.mjs$/,
          resolve: {
            fullySpecified: false
          },
          include: /node_modules/,
          type: 'javascript/auto'
        }
      ]
    }
  },
  css: {
    loaderOptions: {
      css: {
        modules: false
      },
      postcss: {
        postcssOptions: {
          plugins: [
            require('postcss-preset-env')
          ]
        }
      }
    }
  },
  devServer: {
    hot: true,
    watchFiles: {
      paths: ['src/**/*'],
      options: {
        ignored: /node_modules/,
        poll: true
      }
    },
    proxy: {
      '/api': {
        target: process.env.VUE_APP_DOCKER_ENV ? 'http://backend:3000' : 'http://localhost',
        changeOrigin: true,
        secure: false,
        logLevel: 'debug',
        onProxyReq: (proxyReq, req, res) => {
          proxyReq.setHeader('X-Real-IP', req.socket.remoteAddress)
          proxyReq.setHeader('X-Forwarded-For', req.socket.remoteAddress)
        }
      },
      '/uploads': {
        target: process.env.VUE_APP_DOCKER_ENV ? 'http://backend:3000' : 'http://localhost',
        changeOrigin: true,
        secure: false,
        onProxyReq: (proxyReq, req, res) => {
          proxyReq.setHeader('X-Real-IP', req.socket.remoteAddress)
          proxyReq.setHeader('X-Forwarded-For', req.socket.remoteAddress)
        }
      }
    },
    static: {
      directory: path.join(__dirname, '../uploads'),
      publicPath: '/uploads',
      watch: true
    }
  }
})
