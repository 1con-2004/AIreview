# cpp_language_support_fix

1. [ ✅ ] 发现在提交C++代码进行判题时，系统报错"不支持的编程语言: c++"

2. { 2023.07.15 } 修改了以下文件：
   - `/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/services/judge/sandbox.js`
   - `/Users/apple/Desktop/项目备份/4.9/AIreview/backend/src/services/judge/executor.js`

   主要修改内容是：
   - 在 `createSandbox` 函数中添加了对 'c++' 语言的支持，将其映射到 gcc 镜像
   - 添加了将 'c++' 标准化为 'cpp' 的逻辑，使其在内部处理时统一
   - 在 `execute`、`executeDebug`、`run` 和 `preprocessCode` 方法中都添加了对 'c++' 的处理逻辑

3. [ ✅ ] 解决方案说明：
   - 问题原因：后端判题服务中，只支持 'cpp' 作为C++语言的标识符，而前端提交时使用的是 'C++'，经过转小写后变成 'c++'，导致无法识别
   - 解决方法：添加对 'c++' 标识符的支持，并在内部统一转换为 'cpp' 进行处理
   - 修复后：用户可以正常使用 'C++' 或 'c++' 作为语言选项提交代码进行判题 