module.exports = {
  root: true,
  env: {
    node: true
  },
  extends: [
    'plugin:vue/essential',
    '@vue/standard'
  ],
  parserOptions: {
    parser: '@babel/eslint-parser',
    requireConfigFile: false
  },
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'space-before-function-paren': 'off',
    'comma-dangle': 'off',
    'vue/no-deprecated-slot-attribute': 'off',
    'vue/no-v-model-argument': 'off',
    'vue/no-mutating-props': 'off',
    'vue/valid-v-slot': 'off',
    'vue/experimental-script-setup-vars': 'off',
    'vue/valid-template-root': 'off',
    'vue/no-parsing-error': ['error', {
      'x-invalid-end-tag': false,
      'invalid-first-character-of-tag-name': false
    }]
  }
} 
