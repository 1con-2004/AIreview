const { defineConfig } = require('@vue/cli-service')
const path = require('path')

module.exports = defineConfig({
  transpileDependencies: true,
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
        target: 'http://localhost',
        changeOrigin: true,
        secure: false,
        logLevel: 'debug'
      },
      '/uploads': {
        target: 'http://localhost',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
