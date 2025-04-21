module.exports = {
  root: true,
  env: {
    node: true
  },
  extends: [
    'plugin:vue/vue3-essential',
    'eslint:recommended',
    '@vue/standard'
  ],
  parserOptions: {
    parser: '@babel/eslint-parser',
    requireConfigFile: false
  },
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'vue/multi-word-component-names': 'off',
    'import/no-unresolved': 'off',
    'no-unused-vars': 'warn',
    'vue/no-unused-vars': 'warn',
    'vue/no-unused-components': 'warn',
    'import/no-duplicates': 'warn',
    'node/no-callback-literal': 'off',
    'brace-style': 'warn',
    'vue/no-use-v-if-with-v-for': 'warn',
    'no-dupe-keys': 'warn',
    'vue/no-dupe-keys': 'warn',
    'no-undef': 'warn',
    'no-useless-escape': 'warn',
    'vue/no-side-effects-in-computed-properties': 'warn',
    'no-implied-eval': 'warn',
    'no-case-declarations': 'warn'
  }
}
