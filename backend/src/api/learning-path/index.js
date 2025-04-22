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
  const forceRefresh = req.query.refresh === 'true';
  
  console.log(`[${requestId}] 获取用户弱点分析，用户ID: ${userId}, 强制刷新: ${forceRefresh}`);
  
  // 开始事务，避免死锁
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();
    
    // 如果不是强制刷新, 首先检查用户是否有已存在的弱点分析数据
    if (!forceRefresh) {
      const [existingAnalysis] = await connection.query(
        'SELECT * FROM learning_path_weakness_analysis WHERE user_id = ? ORDER BY created_at DESC LIMIT 3',
        [userId]
      );
      
      if (existingAnalysis.length > 0) {
        console.log(`[${requestId}] 找到${existingAnalysis.length}条已存在的弱点分析数据`);
        await connection.commit();
        connection.release();
        return res.json({
          success: true,
          data: existingAnalysis
        });
      }
    } else {
      // 强制刷新时, 删除旧的弱点分析数据
      console.log(`[${requestId}] 强制刷新模式, 删除旧的弱点分析数据`);
      await connection.query('DELETE FROM learning_path_weakness_analysis WHERE user_id = ?', [userId]);
    }
    
    // 如果没有已存在的数据或需要强制刷新，则计算用户不熟悉的标签
    console.log(`[${requestId}] 未找到现有弱点分析数据或需要刷新, 开始计算用户不熟悉的标签`);
    
    // 1. 获取用户提交记录并计算各标签的通过率
    const [submissions] = await connection.query(`
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
      await connection.commit();
      connection.release();
      return res.json({
        success: true,
        data: []
      });
    }
    
    // 5. 为每个弱点标签生成解释和学习思路
    const analysisPromises = weakTags.map(async weakTag => {
      console.log(`[${requestId}] 为标签 ${weakTag.tag} 生成学习思路`);
      
      // 使用智谱AI生成思路，避免使用emoji
      const prompt = `我是一名编程学习助手。用户在"${weakTag.tag}"这个标签的题目上通过率较低（${Math.round(weakTag.passRate * 100)}%）。
      请以教学导师的语气，针对"${weakTag.tag}"这个算法或编程概念，用200-300字左右简要概括核心思路、关键点、常见解题技巧等。
      
      内容要求：
      1. 简洁明了、易于理解、重点突出，不要使用冗长的理论解释
      2. 请使用emoji表情符号增加生动性和吸引力
      3. 适当使用换行符号来分隔不同的思想点和段落，确保格式美观
      4. 可以用短的要点列表来概括关键点，让信息更容易吸收
      5. 确保内容对编程初学者也能理解
      
      请直接返回格式优美的内容，不需要任何解释或前言。`;
      
      try {
        const aiResponse = await zhipuAI.chat([
          { role: "user", content: prompt }
        ]);
        
        console.log(`[${requestId}] 智谱AI返回标签 ${weakTag.tag} 的思路`);
        
        // 将数据保存到数据库
        const [result] = await connection.query(
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
        // 出错时返回一个默认解释，不使用emoji和复杂格式
        const defaultIdea = `"${weakTag.tag}"是编程中的重要概念\n\n掌握它可以帮助你提高解题能力和代码质量。\n\n核心要点：\n- 理解基本原理和实现方式\n- 掌握常见应用场景\n- 学习典型解题策略\n\n常见误区：\n- 不理解基础概念\n- 缺乏系统练习\n\n建议多做与此相关的练习题，理解其核心思想和应用场景！`;
        
        const [result] = await connection.query(
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
    
    // 提交事务
    await connection.commit();
    
    res.json({
      success: true,
      data: analysisResults
    });
  } catch (error) {
    console.error(`[${requestId}] 获取弱点分析失败:`, error);
    
    // 如果连接存在，则回滚事务
    if (connection) {
      try {
        await connection.rollback();
      } catch (rollbackError) {
        console.error(`[${requestId}] 事务回滚失败:`, rollbackError);
      }
    }
    
    res.status(500).json({
      success: false,
      message: '获取弱点分析失败',
      error: error.message
    });
  } finally {
    // 释放连接
    if (connection) {
      connection.release();
    }
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
  const forceRefresh = req.query.refresh === 'true';
  
  console.log(`[${requestId}] 获取用户学习方向建议，用户ID: ${userId}, 强制刷新: ${forceRefresh}`);
  
  // 开始事务，避免死锁
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();
    
    // 如果不是强制刷新, 首先检查是否有已存在的学习方向数据
    if (!forceRefresh) {
      const [existingDirections] = await connection.query(
        'SELECT * FROM learning_path_directions WHERE user_id = ? ORDER BY created_at DESC LIMIT 9',
        [userId]
      );
      
      if (existingDirections.length > 0) {
        console.log(`[${requestId}] 找到${existingDirections.length}条已存在的学习方向数据`);
        await connection.commit();
        connection.release();
        return res.json({
          success: true,
          data: existingDirections
        });
      }
    } else {
      // 强制刷新时, 删除旧的学习方向数据
      console.log(`[${requestId}] 强制刷新模式, 删除旧的学习方向数据`);
      await connection.query('DELETE FROM learning_path_directions WHERE user_id = ?', [userId]);
    }
    
    // 获取标签数据，从问题表直接获取常用标签
    const [tags] = await connection.query(`
      SELECT tag 
      FROM (
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(tags, ',', n.n), ',', -1)) as tag
        FROM problems
        JOIN (
          SELECT 1 as n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
          SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
        ) n
        WHERE n.n <= 1 + LENGTH(tags) - LENGTH(REPLACE(tags, ',', ''))
        GROUP BY tag
      ) t
      WHERE tag != ''
      ORDER BY RAND()
      LIMIT 3
    `);
    
    if (tags.length === 0) {
      console.log(`[${requestId}] 未找到可用标签，使用默认标签`);
      tags.push({ tag: '数组' }, { tag: '排序' }, { tag: '字符串' });
    }
    
    console.log(`[${requestId}] 找到${tags.length}个标签用于生成学习方向`);
    
    // 为每个标签生成学习资源，使用固定的URL模板
    const allDirections = [];
    
    for (const tagObj of tags) {
      const tag = tagObj.tag;
      console.log(`[${requestId}] 为标签 ${tag} 生成学习资源`);
      
      // 检查标签是否在弱点分析表中存在，若不存在则先创建
      const [existingTag] = await connection.query(
        'SELECT tag FROM learning_path_weakness_analysis WHERE tag = ? AND user_id = ? LIMIT 1',
        [tag, userId]
      );
      
      if (existingTag.length === 0) {
        console.log(`[${requestId}] 标签 ${tag} 在弱点分析表中不存在，添加一条记录`);
        
        // 添加一条默认的弱点分析记录
        const defaultIdea = `学习 "${tag}" 相关的概念和技巧 👨‍💻\n\n掌握这个知识点可以帮助你提高解题能力和代码质量 🚀\n\n核心要点：\n- 理解基本原理和实现方式 📝\n- 掌握常见应用场景 🔍\n- 学习典型解题策略 💡\n\n多做相关练习，理解其核心思想！💪`;
        
        await connection.query(
          'INSERT INTO learning_path_weakness_analysis (user_id, tag, idea) VALUES (?, ?, ?)',
          [userId, tag, defaultIdea]
        );
      }
      
      // 使用固定URL格式生成三个平台的URL
      const resources = [
        {
          title: `${tag}编程教学视频集锦`,
          url: `https://search.bilibili.com/all?keyword=编程${encodeURIComponent(tag)}`,
          source: "哔哩哔哩"
        },
        {
          title: `${tag}相关短视频教程`,
          url: `https://www.douyin.com/search/编程${encodeURIComponent(tag)}`,
          source: "抖音"
        },
        {
          title: `${tag}学习资料大全`,
          url: `https://so.csdn.net/so/search?q=编程${encodeURIComponent(tag)}`,
          source: "CSDN"
        }
      ];
      
      // 将资源保存到数据库并返回
      for (const resource of resources) {
        try {
          const [result] = await connection.query(
            'INSERT INTO learning_path_directions (user_id, tag, url, title, source) VALUES (?, ?, ?, ?, ?)',
            [userId, tag, resource.url, resource.title, resource.source]
          );
          
          allDirections.push({
            id: result.insertId,
            user_id: userId,
            tag: tag,
            url: resource.url,
            title: resource.title,
            source: resource.source,
            created_at: new Date()
          });
        } catch (saveError) {
          console.error(`[${requestId}] 保存资源到数据库失败:`, saveError);
          // 继续处理其他资源
        }
      }
    }
    
    console.log(`[${requestId}] 所有学习方向生成完成，共 ${allDirections.length} 个`);
    
    // 提交事务
    await connection.commit();
    connection.release();
    
    res.json({
      success: true,
      data: allDirections
    });
  } catch (error) {
    console.error(`[${requestId}] 获取学习方向失败:`, error);
    
    // 回滚事务
    if (connection) {
      try {
        await connection.rollback();
        connection.release();
      } catch (rollbackError) {
        console.error(`[${requestId}] 事务回滚失败:`, rollbackError);
      }
    }
    
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
  const forceRefresh = req.query.refresh === 'true';
  
  console.log(`[${requestId}] 获取用户题目推荐，用户ID: ${userId}, 强制刷新: ${forceRefresh}`);
  
  // 开始事务，避免死锁
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();
    
    // 如果不是强制刷新, 首先检查是否有已存在的推荐题目
    if (!forceRefresh) {
      const [existingRecommendations] = await connection.query(`
        SELECT r.*, 
               IFNULL(r.title, p.title) as title,
               p.difficulty
        FROM learning_path_recommend r
        LEFT JOIN problems p ON r.problem_number = p.problem_number
        WHERE r.user_id = ? 
        ORDER BY r.created_at DESC 
        LIMIT 5
      `, [userId]);
      
      if (existingRecommendations.length > 0) {
        console.log(`[${requestId}] 找到${existingRecommendations.length}条已存在的推荐题目`);
        await connection.commit();
        connection.release();
        return res.json({
          success: true,
          data: existingRecommendations
        });
      }
    } else {
      // 强制刷新时, 删除旧的推荐题目数据
      console.log(`[${requestId}] 强制刷新模式, 删除旧的推荐题目数据`);
      await connection.query('DELETE FROM learning_path_recommend WHERE user_id = ?', [userId]);
    }
    
    // 获取弱点标签相关的题目
    const allRecommendations = [];
    
    // 从用户弱点分析或随机选择标签
    let tags = [];
    
    // 先尝试获取用户的弱点分析标签
    const [weaknessTags] = await connection.query(
      'SELECT tag FROM learning_path_weakness_analysis WHERE user_id = ? LIMIT 3',
      [userId]
    );
    
    if (weaknessTags.length > 0) {
      tags = weaknessTags;
      console.log(`[${requestId}] 找到${tags.length}个用户弱点标签用于推荐题目`);
    } else {
      // 如果没有弱点分析，使用热门标签
      const [popularTags] = await connection.query(`
        SELECT tag 
        FROM (
          SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(tags, ',', n.n), ',', -1)) as tag
          FROM problems
          JOIN (
            SELECT 1 as n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
            SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
          ) n
          WHERE n.n <= 1 + LENGTH(tags) - LENGTH(REPLACE(tags, ',', ''))
          GROUP BY tag
        ) t
        WHERE tag != ''
        ORDER BY RAND()
        LIMIT 3
      `);
      
      tags = popularTags;
      console.log(`[${requestId}] 未找到用户弱点标签，使用${tags.length}个随机标签`);
      
      // 为这些标签创建弱点分析记录
      for (const tagObj of tags) {
        console.log(`[${requestId}] 标签 ${tagObj.tag} 在弱点分析表中不存在，添加一条记录`);
        
        // 添加一条默认的弱点分析记录
        const defaultIdea = `学习 "${tagObj.tag}" 相关的概念和技巧 👨‍💻\n\n掌握这个知识点可以帮助你提高解题能力和代码质量 🚀\n\n核心要点：\n- 理解基本原理和实现方式 📝\n- 掌握常见应用场景 🔍\n- 学习典型解题策略 💡\n\n多做相关练习，理解其核心思想！💪`;
        
        await connection.query(
          'INSERT INTO learning_path_weakness_analysis (user_id, tag, idea) VALUES (?, ?, ?)',
          [userId, tagObj.tag, defaultIdea]
        );
      }
    }
    
    // 为每个标签获取相关题目
    for (const tagObj of tags) {
      const tag = tagObj.tag;
      console.log(`[${requestId}] 为标签 ${tag} 获取推荐题目`);
      
      // 获取含有该标签的题目，并根据通过率排序（从低到高）
      const [problems] = await connection.query(`
        SELECT p.problem_number, p.title, p.difficulty, p.tags
        FROM problems p 
        WHERE p.tags LIKE ?
        ORDER BY p.acceptance_rate
        LIMIT 3
      `, [`%${tag}%`]);
      
      if (problems.length === 0) {
        console.log(`[${requestId}] 未找到标签 ${tag} 相关的题目`);
        continue;
      }
      
      console.log(`[${requestId}] 找到${problems.length}个标签 ${tag} 相关的题目`);
      
      // 将题目保存到数据库并返回
      for (const problem of problems) {
        try {
          const [result] = await connection.query(
            'INSERT INTO learning_path_recommend (user_id, tag, problem_number, title) VALUES (?, ?, ?, ?)',
            [userId, tag, problem.problem_number, problem.title]
          );
          
          allRecommendations.push({
            id: result.insertId,
            user_id: userId,
            tag: tag,
            problem_number: problem.problem_number,
            title: problem.title,
            difficulty: problem.difficulty,
            created_at: new Date()
          });
        } catch (saveError) {
          console.error(`[${requestId}] 保存推荐题目到数据库失败:`, saveError);
          // 继续处理其他题目
        }
      }
    }
    
    console.log(`[${requestId}] 生成了${allRecommendations.length}道推荐题目`);
    
    // 提交事务
    await connection.commit();
    connection.release();
    
    res.json({
      success: true,
      data: allRecommendations
    });
  } catch (error) {
    console.error(`[${requestId}] 获取题目推荐失败:`, error);
    
    // 回滚事务
    if (connection) {
      try {
        await connection.rollback();
        connection.release();
      } catch (rollbackError) {
        console.error(`[${requestId}] 事务回滚失败:`, rollbackError);
      }
    }
    
    res.status(500).json({
      success: false,
      message: '获取题目推荐失败',
      error: error.message
    });
  }
});

module.exports = router; 