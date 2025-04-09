module.exports = {
  presets: [
    '@vue/cli-plugin-babel/preset'
  ],
  plugins: [
    '@babel/plugin-transform-class-static-block',
    '@babel/plugin-transform-modules-commonjs',
    '@babel/plugin-transform-runtime'
  ],
  sourceType: 'unambiguous',
  assumptions: {
    noDocumentAll: true
  }
}
