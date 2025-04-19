const express = require('express');
const router = express.Router();
const pool = require('../../db');
const { authenticateToken } = require('../../middleware/auth');
const ZhipuAI = require('../../utils/zhipuAI');

// 初始化智谱AI实例
const zhipuAI = new ZhipuAI();

/**
 * @api {get} /api/learning-path/weakness 获取用户弱点分析
 * @apiName GetWeaknessAnalysis
 * @apiGroup LearningPath
 * @apiDescription 获取用户在各标签上的弱点分析
 */
router.get('/weakness', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const requestId = `weakness-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  console.log(`[${requestId}] 获取用户弱点分析，用户ID: ${userId}`);
  
  try {
    // 首先检查用户是否有已存在的弱点分析数据
    const [existingAnalysis] = await pool.query(
      'SELECT * FROM learning_path_weakness_analysis WHERE user_id = ? ORDER BY created_at DESC LIMIT 3',
      [userId]
    );
    
    if (existingAnalysis.length > 0) {
      console.log(`[${requestId}] 找到${existingAnalysis.length}条已存在的弱点分析数据`);
      return res.json({
        success: true,
        data: existingAnalysis
      });
    }
    
    // 如果没有已存在的数据，则计算用户不熟悉的标签
    console.log(`[${requestId}] 未找到现有弱点分析数据，开始计算用户不熟悉的标签`);
    
    // 1. 获取用户提交记录并计算各标签的通过率
    const [submissions] = await pool.query(`
      SELECT p.problem_number, p.tags, 
             COUNT(CASE WHEN s.status = 'Accepted' THEN 1 END) as accepted_count,
             COUNT(*) as total_submissions
      FROM submissions s
      JOIN problems p ON s.problem_id = p.id
      WHERE s.user_id = ?
      GROUP BY p.problem_number, p.tags
      HAVING total_submissions > 0
    `, [userId]);
    
    console.log(`[${requestId}] 查询到用户提交数据 ${submissions.length} 条`);
    
    // 2. 解析标签并计算各标签的通过率
    const tagStats = {};
    
    submissions.forEach(sub => {
      if (!sub.tags) return;
      
      // 分割标签并处理每个标签
      const tags = sub.tags.split(',').map(tag => tag.trim());
      
      tags.forEach(tag => {
        if (!tagStats[tag]) {
          tagStats[tag] = { accepted: 0, total: 0 };
        }
        
        tagStats[tag].accepted += sub.accepted_count;
        tagStats[tag].total += sub.total_submissions;
      });
    });
    
    // 3. 过滤出通过率低于50%且至少有2次提交的标签
    const weakTags = Object.entries(tagStats)
      .filter(([_, stats]) => (stats.accepted / stats.total) < 0.5 && stats.total >= 2)
      .map(([tag, stats]) => ({
        tag,
        passRate: stats.accepted / stats.total
      }))
      .sort((a, b) => a.passRate - b.passRate) // 按通过率升序排序
      .slice(0, 3); // 取前3个弱点标签
    
    console.log(`[${requestId}] 计算出弱点标签 ${weakTags.length} 个: ${JSON.stringify(weakTags)}`);
    
    // 4. 如果没有弱点标签，直接返回空数组
    if (weakTags.length === 0) {
      console.log(`[${requestId}] 未发现弱点标签，返回空数组`);
      return res.json({
        success: true,
        data: []
      });
    }
    
    // 5. 为每个弱点标签生成解释和学习思路
    const analysisPromises = weakTags.map(async weakTag => {
      console.log(`[${requestId}] 为标签 ${weakTag.tag} 生成学习思路`);
      
      // 使用智谱AI生成思路
      const prompt = `我是一名编程学习助手。用户在"${weakTag.tag}"这个标签的题目上通过率较低（${Math.round(weakTag.passRate * 100)}%）。
      请以教学导师的语气，针对"${weakTag.tag}"这个算法或编程概念，用200字左右简要概括核心思路、关键点、常见解题技巧等。
      内容需要：简洁明了、易于理解、重点突出，不要使用冗长的理论解释。`;
      
      try {
        const aiResponse = await zhipuAI.chat([
          { role: "user", content: prompt }
        ]);
        
        console.log(`[${requestId}] 智谱AI返回标签 ${weakTag.tag} 的思路`);
        
        // 将数据保存到数据库
        const [result] = await pool.query(
          'INSERT INTO learning_path_weakness_analysis (user_id, tag, idea) VALUES (?, ?, ?)',
          [userId, weakTag.tag, aiResponse]
        );
        
        return {
          id: result.insertId,
          user_id: userId,
          tag: weakTag.tag,
          idea: aiResponse,
          created_at: new Date()
        };
      } catch (error) {
        console.error(`[${requestId}] 为标签 ${weakTag.tag} 生成思路失败:`, error);
        // 出错时返回一个默认解释
        const defaultIdea = `"${weakTag.tag}"是编程中的重要概念，掌握它可以帮助你提高解题能力。建议多做与此相关的练习题，理解其核心思想和应用场景。`;
        
        const [result] = await pool.query(
          'INSERT INTO learning_path_weakness_analysis (user_id, tag, idea) VALUES (?, ?, ?)',
          [userId, weakTag.tag, defaultIdea]
        );
        
        return {
          id: result.insertId,
          user_id: userId,
          tag: weakTag.tag,
          idea: defaultIdea,
          created_at: new Date()
        };
      }
    });
    
    // 等待所有标签分析完成
    const analysisResults = await Promise.all(analysisPromises);
    console.log(`[${requestId}] 所有标签分析完成，共 ${analysisResults.length} 个`);
    
    res.json({
      success: true,
      data: analysisResults
    });
  } catch (error) {
    console.error(`[${requestId}] 获取弱点分析失败:`, error);
    res.status(500).json({
      success: false,
      message: '获取弱点分析失败',
      error: error.message
    });
  }
});

/**
 * @api {get} /api/learning-path/directions 获取学习方向建议
 * @apiName GetLearningDirections
 * @apiGroup LearningPath
 * @apiDescription 获取用户学习方向建议和相关资源链接
 */
router.get('/directions', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const requestId = `directions-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  console.log(`[${requestId}] 获取用户学习方向建议，用户ID: ${userId}`);
  
  try {
    // 首先检查是否有已存在的学习方向数据
    const [existingDirections] = await pool.query(
      'SELECT * FROM learning_path_directions WHERE user_id = ? ORDER BY created_at DESC LIMIT 9',
      [userId]
    );
    
    if (existingDirections.length > 0) {
      console.log(`[${requestId}] 找到${existingDirections.length}条已存在的学习方向数据`);
      return res.json({
        success: true,
        data: existingDirections
      });
    }
    
    // 如果没有已存在数据，先获取用户的弱点标签
    console.log(`[${requestId}] 未找到现有学习方向数据，开始生成新的学习方向`);
    
    const [weaknessTags] = await pool.query(
      'SELECT tag FROM learning_path_weakness_analysis WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );
    
    if (weaknessTags.length === 0) {
      console.log(`[${requestId}] 未找到用户弱点标签，无法生成学习方向`);
      return res.json({
        success: true,
        data: []
      });
    }
    
    console.log(`[${requestId}] 找到${weaknessTags.length}个弱点标签用于生成学习方向`);
    
    // 为每个弱点标签生成学习资源
    const directionsPromises = weaknessTags.map(async weaknessTag => {
      const tag = weaknessTag.tag;
      console.log(`[${requestId}] 为标签 ${tag} 生成学习资源`);
      
      // 使用智谱AI生成学习资源链接
      const prompt = `我是一名编程学习助手。用户需要学习"${tag}"相关的知识。
      请推荐3个学习该主题的网络资源，必须从以下三个来源各选一个：CSDN、LeetCode、知乎。
      
      对于每个资源，请提供：
      1. 资源标题（简洁明了，30字以内）
      2. 资源URL（必须是真实存在的链接，格式为完整URL，包含https://）
      3. 资源来源（CSDN、LeetCode或知乎）
      
      请以JSON格式返回，格式如下：
      [
        {"title": "资源1标题", "url": "https://资源1链接", "source": "来源网站"},
        {"title": "资源2标题", "url": "https://资源2链接", "source": "来源网站"},
        {"title": "资源3标题", "url": "https://资源3链接", "source": "来源网站"}
      ]`;
      
      try {
        const aiResponse = await zhipuAI.chat([
          { role: "user", content: prompt }
        ]);
        
        console.log(`[${requestId}] 智谱AI返回标签 ${tag} 的学习资源`);
        
        // 尝试解析JSON响应
        let resources;
        try {
          resources = JSON.parse(aiResponse);
          
          if (!Array.isArray(resources)) {
            throw new Error('返回的资源不是数组格式');
          }
        } catch (parseError) {
          console.error(`[${requestId}] 解析AI返回的资源失败:`, parseError);
          console.log(`[${requestId}] 原始响应:`, aiResponse);
          
          // 使用默认资源
          resources = [
            {
              title: `${tag}编程基础知识详解`,
              url: `https://blog.csdn.net/topics/search?keyword=${encodeURIComponent(tag)}`,
              source: "CSDN"
            },
            {
              title: `${tag}相关题目解析`,
              url: `https://leetcode.cn/tag/${encodeURIComponent(tag)}/`,
              source: "LeetCode"
            },
            {
              title: `${tag}学习路径指南`,
              url: `https://www.zhihu.com/search?q=${encodeURIComponent(tag)}`,
              source: "知乎"
            }
          ];
        }
        
        // 将资源保存到数据库并返回
        const savePromises = resources.map(async resource => {
          try {
            const [result] = await pool.query(
              'INSERT INTO learning_path_directions (user_id, tag, url, title, source) VALUES (?, ?, ?, ?, ?)',
              [userId, tag, resource.url, resource.title, resource.source]
            );
            
            return {
              id: result.insertId,
              user_id: userId,
              tag: tag,
              url: resource.url,
              title: resource.title,
              source: resource.source,
              created_at: new Date()
            };
          } catch (saveError) {
            console.error(`[${requestId}] 保存资源到数据库失败:`, saveError);
            return null;
          }
        });
        
        return await Promise.all(savePromises);
      } catch (error) {
        console.error(`[${requestId}] 为标签 ${tag} 生成学习资源失败:`, error);
        return [];
      }
    });
    
    // 等待所有学习方向生成完成并合并结果
    const allDirections = await Promise.all(directionsPromises);
    const flattenedDirections = allDirections.flat().filter(item => item !== null);
    
    console.log(`[${requestId}] 所有学习方向生成完成，共 ${flattenedDirections.length} 个`);
    
    res.json({
      success: true,
      data: flattenedDirections
    });
  } catch (error) {
    console.error(`[${requestId}] 获取学习方向失败:`, error);
    res.status(500).json({
      success: false,
      message: '获取学习方向失败',
      error: error.message
    });
  }
});

/**
 * @api {get} /api/learning-path/recommend 获取题目推荐
 * @apiName GetProblemRecommendations
 * @apiGroup LearningPath
 * @apiDescription 根据用户弱点标签推荐相关题目
 */
router.get('/recommend', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const requestId = `recommend-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  
  console.log(`[${requestId}] 获取用户题目推荐，用户ID: ${userId}`);
  
  try {
    // 首先检查是否有已存在的推荐题目
    const [existingRecommendations] = await pool.query(
      'SELECT * FROM learning_path_recommend WHERE user_id = ? ORDER BY created_at DESC LIMIT 5',
      [userId]
    );
    
    if (existingRecommendations.length > 0) {
      console.log(`[${requestId}] 找到${existingRecommendations.length}条已存在的推荐题目`);
      return res.json({
        success: true,
        data: existingRecommendations
      });
    }
    
    // 如果没有已存在数据，先获取用户的弱点标签
    console.log(`[${requestId}] 未找到现有推荐题目，开始生成新的推荐`);
    
    const [weaknessTags] = await pool.query(
      'SELECT tag FROM learning_path_weakness_analysis WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );
    
    if (weaknessTags.length === 0) {
      console.log(`[${requestId}] 未找到用户弱点标签，无法生成题目推荐`);
      return res.json({
        success: true,
        data: []
      });
    }
    
    console.log(`[${requestId}] 找到${weaknessTags.length}个弱点标签用于生成题目推荐`);
    
    // 获取用户已经做过的题目
    const [solvedProblems] = await pool.query(
      `SELECT DISTINCT problem_number 
       FROM submissions 
       WHERE user_id = ? AND status = 'Accepted'`,
      [userId]
    );
    
    const solvedSet = new Set(solvedProblems.map(p => p.problem_number));
    console.log(`[${requestId}] 用户已解决${solvedSet.size}道题目`);
    
    // 为每个弱点标签查找相关题目
    const recommendProblems = [];
    const recommendedSet = new Set(); // 用于去重
    
    for (const weaknessTag of weaknessTags) {
      const tag = weaknessTag.tag;
      console.log(`[${requestId}] 为标签 ${tag} 查找相关题目`);
      
      // 查找包含该标签且用户未解决的题目
      const [problems] = await pool.query(
        `SELECT id, problem_number, title, difficulty, tags
         FROM problems
         WHERE tags LIKE ? AND difficulty != '困难'
         ORDER BY RAND()
         LIMIT 10`,
        [`%${tag}%`]
      );
      
      console.log(`[${requestId}] 找到${problems.length}道与标签 ${tag} 相关的题目`);
      
      // 过滤出用户未解决的题目并限制数量
      let count = 0;
      for (const problem of problems) {
        if (!solvedSet.has(problem.problem_number) && !recommendedSet.has(problem.problem_number) && count < 2) {
          try {
            const [result] = await pool.query(
              'INSERT INTO learning_path_recommend (user_id, tag, problem_number) VALUES (?, ?, ?)',
              [userId, tag, problem.problem_number]
            );
            
            recommendProblems.push({
              id: result.insertId,
              user_id: userId,
              tag: tag,
              problem_number: problem.problem_number,
              created_at: new Date()
            });
            
            recommendedSet.add(problem.problem_number);
            count++;
          } catch (insertError) {
            console.error(`[${requestId}] 保存推荐题目失败:`, insertError);
          }
        }
        
        if (count >= 2) break; // 每个标签最多推荐2道题
      }
    }
    
    console.log(`[${requestId}] 生成了${recommendProblems.length}道推荐题目`);
    
    res.json({
      success: true,
      data: recommendProblems
    });
  } catch (error) {
    console.error(`[${requestId}] 获取题目推荐失败:`, error);
    res.status(500).json({
      success: false,
      message: '获取题目推荐失败',
      error: error.message
    });
  }
});

module.exports = router; 