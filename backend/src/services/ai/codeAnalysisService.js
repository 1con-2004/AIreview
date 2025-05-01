// 代码分析服务
const ZhipuAI = require('../../utils/zhipuAI');

// 智谱AI提示词模板
const PROMPT_TEMPLATES = {
  naming: function(code, language) {
    return `用中文回答以下问题：
1. 分析以下代码的变量名词规范性。请从以下4个维度进行评估：
1. 变量命名规则遵循度(检查变量命名是否遵循常见的命名规则，如驼峰命名法（camelCase）、蛇形命名法（snake_case）等。)
2. 变量命名表意性(评估变量名是否能清晰表达其用途和含义。)
3. 函数命名规范性(检查函数命名是否符合规范，且能准确描述函数的功能。)
4. 命名一致性(查看代码中命名是否一致，包括变量名、函数名的大小写、缩写等。)

每个维度满分25分，总分100分。请按以下JSON格式返回分析结果：

{
  "analysis": "详细分析文本，使用Markdown格式",
  "score": 分数(0-100的整数),
  "suggestion": "改进建议，使用Markdown格式"
}

代码(${language})：
\`\`\`
${code}
\`\`\``;
  },

  logic: function(code, language) {
    return `分析以下代码的逻辑连通性。请从以下4个维度进行评估：
1. 条件判断逻辑(检查代码中的条件判断语句是否合理，是否能正确处理各种边界情况。)
2. 循环逻辑(评估循环语句的使用是否合理，循环条件和循环体的逻辑是否正确。)
3. 函数调用逻辑(查看函数之间的调用关系是否合理，参数传递是否正确。)
4. 代码整体逻辑连贯性(评估代码从整体上看是否能清晰地实现题目的要求，各个部分之间的逻辑是否连贯。)

每个维度满分25分，总分100分。请按以下JSON格式返回分析结果，只返回JSON，不要包含其他任何内容：

{
  "analysis": "详细分析文本，使用Markdown格式",
  "score": 分数(0-100的整数),
  "suggestion": "改进建议，使用Markdown格式"
}

代码(${language})：
\`\`\`
${code}
\`\`\``;
  },

  complexity: function(code, language) {
    return `分析以下代码的复杂度。请从以下4个维度进行评估：
1. 时间复杂度(分析代码中主要算法的时间复杂度，如 O(1)、O(n)、O(n^2) 等。)
2. 空间复杂度(评估代码在运行过程中占用的额外空间，如数组、栈等。)
3. 算法选择(评估代码中选择的算法是否适合问题，是否高效。)
4. 代码结构复杂度(检查代码中函数、循环、条件语句等的嵌套层数和整体结构复杂性。)

每个维度满分25分，总分100分。请按以下JSON格式返回分析结果，只返回JSON，不要包含其他任何内容：

{
  "analysis": "详细分析文本，使用Markdown格式",
  "score": 分数(0-100的整数),
  "suggestion": "改进建议，使用Markdown格式"
}

代码(${language})：
\`\`\`
${code}
\`\`\``;
  },

  readability: function(code, language) {
    return `分析以下代码的可读性。请从以下4个维度进行评估：
1. 注释完整性(检查代码中是否有必要的注释，解释关键逻辑和函数功能。)
2. 代码布局(查看代码的缩进、换行等布局是否规范，是否易于阅读。)
3. 函数和类设计(评估函数和类的命名是否清晰，功能是否单一、明确。)
4. 代码简洁性(评估代码是否简洁明了，没有不必要的复杂性。)

每个维度满分25分，总分100分。请按以下JSON格式返回分析结果，只返回JSON，不要包含其他任何内容：

{
  "analysis": "详细分析文本，使用Markdown格式",
  "score": 分数(0-100的整数),
  "suggestion": "改进建议，使用Markdown格式"
}

代码(${language})：
\`\`\`
${code}
\`\`\``;
  },
};

/**
 * 从AI响应中提取JSON数据 - 增强版
 * @param {string} text - AI响应文本
 * @returns {Object} - 解析后的JSON对象
 */
function extractJsonFromText(text) {
  // 记录处理过程的日志ID
  const logId = `json-extract-${Date.now()}`;
  console.log(`[${logId}] 开始从AI响应中提取JSON`);
  
  // 步骤1: 尝试直接解析完整响应（如果响应本身就是一个JSON）
  try {
    const parsed = JSON.parse(text);
    console.log(`[${logId}] 直接解析成功！响应本身就是一个有效的JSON`);
    return parsed;
  } catch (e) {
    console.log(`[${logId}] 直接解析失败: ${e.message}，尝试在文本中查找JSON...`);
  }
  
  // 步骤2: 尝试使用不同的正则表达式查找JSON
  // 2.1 首先使用原始的简单正则表达式
  const simpleJsonRegex = /\{[\s\S]*?\}(?!\s*[\[\{\w])/g;
  let matches = text.match(simpleJsonRegex);
  
  if (matches && matches.length > 0) {
    console.log(`[${logId}] 使用简单正则找到 ${matches.length} 个匹配项`);
    
    // 尝试解析第一个匹配项
    try {
      const parsed = JSON.parse(matches[0]);
      if (parsed.analysis && parsed.score && parsed.suggestion) {
        console.log(`[${logId}] 成功解析第一个匹配项`);
        return parsed;
      }
    } catch (e) {
      console.log(`[${logId}] 简单正则第一个匹配项解析失败: ${e.message}`);
      
      // 尝试清理后再解析
      try {
        const jsonStr = matches[0].replace(/\\n/g, '\\n')
                               .replace(/\\'/g, "\\'")
                               .replace(/\\"/g, '\\"')
                               .replace(/\\&/g, '\\&')
                               .replace(/\\r/g, '\\r')
                               .replace(/\\t/g, '\\t')
                               .replace(/\\b/g, '\\b')
                               .replace(/\\f/g, '\\f');
        
        const parsed = JSON.parse(jsonStr);
        if (parsed.analysis && parsed.score && parsed.suggestion) {
          console.log(`[${logId}] 清理后成功解析第一个匹配项`);
          return parsed;
        }
      } catch (e2) {
        console.log(`[${logId}] 清理后解析仍失败: ${e2.message}`);
      }
    }
  }
  
  // 2.2 使用更复杂的正则表达式，可以处理嵌套JSON
  console.log(`[${logId}] 尝试使用递归正则表达式查找更复杂的JSON结构`);
  const complexJsonRegex = /\{(?:[^{}]|(?:\{(?:[^{}]|(?:\{(?:[^{}]|(?:\{[^{}]*\}))*\}))*\}))*\}/g;
  matches = text.match(complexJsonRegex);
  
  if (matches && matches.length > 0) {
    console.log(`[${logId}] 使用复杂正则找到 ${matches.length} 个匹配项`);
    
    // 尝试每个匹配项，直到找到可以解析的
    for (let i = 0; i < matches.length; i++) {
      const match = matches[i];
      
      try {
        const parsed = JSON.parse(match);
        
        // 验证解析结果是否包含期望的字段
        if (parsed.analysis && parsed.score && parsed.suggestion) {
          console.log(`[${logId}] 成功解析第${i+1}个复杂匹配项`);
          return parsed;
        } else {
          console.log(`[${logId}] 第${i+1}个复杂匹配项缺少必要字段`);
        }
      } catch (e) {
        console.log(`[${logId}] 第${i+1}个复杂匹配项解析失败: ${e.message}`);
      }
    }
  }
  
  // 步骤3: 尝试更宽松的提取方法，直接从文本中提取字段
  console.log(`[${logId}] 尝试使用字段提取法`);
  try {
    // 查找"analysis"、"score"和"suggestion"字段
    const analysisMatch = text.match(/"analysis"\s*:\s*"([^"]*(?:"[^"]*"[^"]*)*)"/) || 
                         text.match(/analysis['"]\s*:\s*['"]([^'"]*(?:['"][^'"]*['"][^'"]*)*)['"]/);
    const scoreMatch = text.match(/"score"\s*:\s*(\d+)/) || 
                      text.match(/score['"]\s*:\s*(\d+)/);
    const suggestionMatch = text.match(/"suggestion"\s*:\s*"([^"]*(?:"[^"]*"[^"]*)*)"/) || 
                           text.match(/suggestion['"]\s*:\s*['"]([^'"]*(?:['"][^'"]*['"][^'"]*)*)['"]/);
    
    if (analysisMatch || scoreMatch || suggestionMatch) {
      console.log(`[${logId}] 字段提取法找到部分字段`);
      console.log(`[${logId}] 分析字段: ${!!analysisMatch}, 分数字段: ${!!scoreMatch}, 建议字段: ${!!suggestionMatch}`);
      
      return {
        analysis: analysisMatch ? analysisMatch[1] : "无法提取详细分析文本",
        score: scoreMatch ? parseInt(scoreMatch[1]) : 60,
        suggestion: suggestionMatch ? suggestionMatch[1] : "无法提取详细建议"
      };
    } else {
      console.log(`[${logId}] 字段提取法未找到任何字段`);
    }
  } catch (e) {
    console.log(`[${logId}] 字段提取法失败: ${e.message}`);
  }
  
  // 步骤4: 如果所有尝试都失败，返回用户友好的默认结果
  console.log(`[${logId}] 所有提取方法都失败，返回默认结果`);
  return {
    analysis: "AI分析结果格式化失败，但您仍可查看原始响应内容。\n\n" + text.substring(0, 1000),
    score: 60,
    suggestion: "由于技术原因，无法提供格式化的分析结果。您可以在上方查看AI的完整响应，或尝试其他分析类型。"
  };
}

// 分析代码函数
async function analyzeCode(code, language, analysisType) {
  try {
    if (!Object.keys(PROMPT_TEMPLATES).includes(analysisType)) {
      throw new Error(`不支持的分析类型: ${analysisType}`);
    }

    // 替换提示词模板中的变量
    const prompt = PROMPT_TEMPLATES[analysisType](code, language);

    // 调用智谱AI
    const zhipuAI = new ZhipuAI();
    const aiResponse = await zhipuAI.chat([
      { role: "system", content: "你是一个代码分析专家，请按照要求分析用户提供的代码。请只返回JSON格式的结果，不要包含其他内容。" },
      { role: "user", content: prompt }
    ]);

    console.log("AI响应原始内容: ", aiResponse.substring(0, 200) + "...");

    // 提取并解析AI返回的JSON
    try {
      return extractJsonFromText(aiResponse);
    } catch (parseError) {
      console.log(`解析AI响应时出错: ${parseError.message}`);
      throw new Error("解析AI响应失败");
    }
  } catch (error) {
    console.log(`调用智谱AI分析代码时出错: ${error.message}`);
    throw error;
  }
}

module.exports = {
  analyzeCode
}; 