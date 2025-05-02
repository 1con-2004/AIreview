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
    
    // 首先获取用户现有的弱点分析数据
    const [existingWeaknessTags] = await connection.query(
      'SELECT tag FROM learning_path_weakness_analysis WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );
    
    // 获取标签数据，优先使用已存在的弱点分析标签
    let selectedTags = [];
    
    if (existingWeaknessTags.length > 0) {
      console.log(`[${requestId}] 使用已存在的弱点分析标签，数量: ${existingWeaknessTags.length}`);
      // 使用已有的标签，最多取3个
      selectedTags = existingWeaknessTags.slice(0, 3);
    } else {
      // 如果没有弱点分析数据，再从问题表获取标签
      console.log(`[${requestId}] 未找到弱点分析标签，从问题表获取常用标签`);
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
        selectedTags = [{ tag: '数组' }, { tag: '排序' }, { tag: '字符串' }];
      } else {
        selectedTags = tags;
      }
      
      // 重要修改：只在非强制刷新模式下自动创建弱点分析记录
      if (!forceRefresh) {
        console.log(`[${requestId}] 非强制刷新模式，为没有弱点分析的标签创建记录`);
        // 为这些标签创建弱点分析记录
        for (const tagObj of selectedTags) {
          // 检查标签是否在弱点分析表中存在
          const [existingTag] = await connection.query(
            'SELECT tag FROM learning_path_weakness_analysis WHERE tag = ? AND user_id = ? LIMIT 1',
            [tagObj.tag, userId]
          );
          
          if (existingTag.length === 0) {
            console.log(`[${requestId}] 标签 ${tagObj.tag} 在弱点分析表中不存在，添加一条记录`);
            
            // 添加一条默认的弱点分析记录
            const defaultIdea = `学习 "${tagObj.tag}" 相关的概念和技巧 👨‍💻\n\n掌握这个知识点可以帮助你提高解题能力和代码质量 🚀\n\n核心要点：\n- 理解基本原理和实现方式 📝\n- 掌握常见应用场景 🔍\n- 学习典型解题策略 💡\n\n多做相关练习，理解其核心思想！💪`;
            
            await connection.query(
              'INSERT INTO learning_path_weakness_analysis (user_id, tag, idea) VALUES (?, ?, ?)',
              [userId, tagObj.tag, defaultIdea]
            );
          }
        }
      } else {
        console.log(`[${requestId}] 强制刷新模式，不自动创建弱点分析记录，依赖/weakness接口的结果`);
      }
    }
    
    console.log(`[${requestId}] 找到${selectedTags.length}个标签用于生成学习方向`);
    
    // 为每个标签生成学习资源，使用固定的URL模板
    const allDirections = [];
    
    for (const tagObj of selectedTags) {
      const tag = tagObj.tag;
      console.log(`[${requestId}] 为标签 ${tag} 生成学习资源`);
      
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
    
    // 如果不是强制刷新, 首先检查是否有已存在的推荐题目(强制限制显示6道题目)
    if (!forceRefresh) {
      const [existingRecommendations] = await connection.query(`
        SELECT r.*, 
               IFNULL(r.title, p.title) as title,
               p.difficulty
        FROM learning_path_recommend r
        LEFT JOIN problems p ON r.problem_number = p.problem_number
        WHERE r.user_id = ? 
        ORDER BY r.created_at DESC 
        LIMIT 6
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
    
    // ===== 修改开始：使用新算法确定最薄弱的标签 =====
    
    // 1. 获取用户弱点分析标签和对应数据
    const [weaknessTags] = await connection.query(
      'SELECT tag, idea FROM learning_path_weakness_analysis WHERE user_id = ?',
      [userId]
    );
    
    // 2. 如果用户没有弱点标签，回退到原来的随机选择逻辑
    if (weaknessTags.length === 0) {
      console.log(`[${requestId}] 未找到用户弱点标签，使用热门标签作为替代`);
      
      // 获取热门标签
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
      
      // 为这些标签创建弱点分析记录
      for (const tagObj of popularTags) {
        console.log(`[${requestId}] 为标签 ${tagObj.tag} 添加默认的弱点分析记录`);
        
        const defaultIdea = `学习 "${tagObj.tag}" 相关的概念和技巧 👨‍💻\n\n掌握这个知识点可以帮助你提高解题能力和代码质量 🚀\n\n核心要点：\n- 理解基本原理和实现方式 📝\n- 掌握常见应用场景 🔍\n- 学习典型解题策略 💡\n\n多做相关练习，理解其核心思想！💪`;
        
        try {
          await connection.query(
            'INSERT INTO learning_path_weakness_analysis (user_id, tag, idea) VALUES (?, ?, ?)',
            [userId, tagObj.tag, defaultIdea]
          );
        } catch (error) {
          console.error(`[${requestId}] 插入弱点分析记录失败:`, error);
        }
      }
      
      // 使用这些热门标签
      const [updatedWeaknessTags] = await connection.query(
        'SELECT tag, idea FROM learning_path_weakness_analysis WHERE user_id = ?',
        [userId]
      );
      
      if (updatedWeaknessTags.length > 0) {
        console.log(`[${requestId}] 成功创建${updatedWeaknessTags.length}个默认弱点分析记录`);
        // 使用新创建的弱点标签继续
        weaknessTags.push(...updatedWeaknessTags);
      } else {
        // 极端情况：无法添加默认标签记录，返回空结果
        console.log(`[${requestId}] 无法添加默认弱点分析记录，返回空推荐`);
        await connection.commit();
        connection.release();
        return res.json({
          success: true,
          data: []
        });
      }
    }
    
    console.log(`[${requestId}] 找到${weaknessTags.length}个弱点标签`);
    
    // 3. 获取用户提交记录以分析这些标签的实际通过率
    const tagRates = {};
    
    for (const tagObj of weaknessTags) {
      const tag = tagObj.tag;
      
      // 查询该标签下的提交情况
      const [submissions] = await connection.query(`
        SELECT COUNT(CASE WHEN s.status = 'Accepted' THEN 1 END) as accepted_count,
               COUNT(*) as total_submissions
        FROM submissions s
        JOIN problems p ON s.problem_id = p.id
        WHERE s.user_id = ? AND p.tags LIKE ?
      `, [userId, `%${tag}%`]);
      
      // 计算通过率（默认为50%）
      let passRate = 0.5;
      if (submissions[0].total_submissions > 0) {
        passRate = submissions[0].accepted_count / submissions[0].total_submissions;
      }
      
      // 为每个标签创建一个综合得分（通过率越低，需要练习的优先级越高）
      tagRates[tag] = {
        tag,
        passRate,
        totalSubmissions: submissions[0].total_submissions,
        // 算法：如果总提交数为0，给予中等优先级；否则根据通过率反向计算优先级
        priority: submissions[0].total_submissions === 0 ? 0.5 : (1 - passRate)
      };
      
      console.log(`[${requestId}] 标签 ${tag} 的通过率: ${passRate}, 总提交数: ${submissions[0].total_submissions}, 优先级: ${tagRates[tag].priority}`);
    }
    
    // 4. 使用智谱AI分析哪些标签是用户最需要提高的
    // 准备分析所需数据
    const weaknessData = Object.values(tagRates).map(data => ({
      tag: data.tag,
      passRate: data.passRate,
      totalSubmissions: data.totalSubmissions,
      priority: data.priority
    }));
    
    // 构建智谱AI提示
    const prompt = `分析以下编程标签数据，确定用户最需要加强的三个标签，按优先级排序。每个标签包含：
    - 标签名称 (tag)
    - 通过率 (passRate): 用户在该类题目中的通过率
    - 总提交数 (totalSubmissions): 用户提交该类题目的总次数
    - 优先级 (priority): 初步计算的优先级指数，越高表示越需要加强
    
    标签数据: ${JSON.stringify(weaknessData)}
    
    分析标准:
    1. 通过率低的标签需要更多练习
    2. 总提交数量较多但通过率低的标签表明持续的困难
    3. 没有提交记录的标签可能是盲点，需要初步了解
    
    请分析后直接返回JSON格式的三个最需要加强的标签名称数组，按重要性降序排列，不需要任何解释。格式为:
    ["标签1", "标签2", "标签3"]
    `;
    
    let priorityTags = [];
    
    try {
      console.log(`[${requestId}] 使用智谱AI分析用户最薄弱的标签`);
      
      // 调用智谱AI分析
      const aiResponse = await zhipuAI.chat([
        { role: "user", content: prompt }
      ]);
      
      // 尝试解析AI响应
      try {
        const parsedResponse = JSON.parse(aiResponse.replace(/```json|```/g, '').trim());
        if (Array.isArray(parsedResponse) && parsedResponse.length > 0) {
          priorityTags = parsedResponse.slice(0, 3); // 确保只取最多3个标签
          console.log(`[${requestId}] 智谱AI分析结果: ${JSON.stringify(priorityTags)}`);
        }
      } catch (parseError) {
        console.error(`[${requestId}] 解析AI响应失败:`, parseError);
        console.log(`[${requestId}] 原始AI响应:`, aiResponse);
        
        // 解析失败，降级使用算法排序
        priorityTags = Object.values(tagRates)
          .sort((a, b) => b.priority - a.priority)
          .slice(0, 3)
          .map(item => item.tag);
      }
    } catch (aiError) {
      console.error(`[${requestId}] 调用智谱AI失败:`, aiError);
      
      // AI调用失败，降级使用算法排序
      priorityTags = Object.values(tagRates)
        .sort((a, b) => b.priority - a.priority)
        .slice(0, 3)
        .map(item => item.tag);
    }
    
    // 如果没有获取到优先标签，使用所有标签
    if (priorityTags.length === 0) {
      priorityTags = weaknessTags.map(t => t.tag).slice(0, 3);
    }
    
    console.log(`[${requestId}] 最终确定的优先标签: ${JSON.stringify(priorityTags)}`);
    
    // 5. 使用AI生成个性化的题目推荐
    const allRecommendations = [];
    
    for (const tag of priorityTags) {
      console.log(`[${requestId}] 为标签 ${tag} 获取相关题目`);
      
      // 获取含有该标签的题目
      const [problems] = await connection.query(`
        SELECT problem_number, title, difficulty, description
        FROM problems
        WHERE tags LIKE ? AND description IS NOT NULL
        LIMIT 5
      `, [`%${tag}%`]);
      
      if (problems.length === 0) {
        console.log(`[${requestId}] 未找到标签 ${tag} 相关的题目`);
        continue;
      }
      
      // 构建AI提示
      const problemsData = problems.map(p => ({
        problem_number: p.problem_number,
        title: p.title,
        difficulty: p.difficulty,
        description: p.description ? p.description.substring(0, 200) + '...' : '无描述'
      }));
      
      const aiPrompt = `根据用户在"${tag}"标签上的学习需求，从以下题目中选择最适合的2个问题（不需要全部使用）。
      用户特点: 对"${tag}"相关概念掌握不牢固，需要针对性练习。
      
      可选题目:
      ${JSON.stringify(problemsData)}
      
      请为选出的题目提供简短的推荐理由（不超过50字），解释为什么这道题目对提高用户在"${tag}"标签上的能力有帮助。
      
      请直接返回JSON格式结果，包含选择的题目编号、标题和推荐理由，格式如下:
      [
        {"problem_number": "题号", "title": "标题", "reason": "推荐理由"},
        {"problem_number": "题号", "title": "标题", "reason": "推荐理由"}
      ]
      
      不要包含任何其他解释或前缀。
      `;
      
      try {
        console.log(`[${requestId}] 使用智谱AI为标签 ${tag} 生成题目推荐`);
        
        // 调用智谱AI生成推荐
        const aiRecommendResponse = await zhipuAI.chat([
          { role: "user", content: aiPrompt }
        ]);
        
        // 尝试解析AI响应
        try {
          const parsedRecommend = JSON.parse(aiRecommendResponse.replace(/```json|```/g, '').trim());
          
          if (Array.isArray(parsedRecommend) && parsedRecommend.length > 0) {
            console.log(`[${requestId}] 智谱AI为标签 ${tag} 推荐了 ${parsedRecommend.length} 道题目`);
            
            // 保存每道推荐题目
            for (const recommend of parsedRecommend) {
              if (!recommend.problem_number || !recommend.title) continue;
              
              // 查询题目难度
              const [problemInfo] = await connection.query(
                'SELECT difficulty FROM problems WHERE problem_number = ?',
                [recommend.problem_number]
              );
              
              const difficulty = problemInfo.length > 0 ? problemInfo[0].difficulty : null;
              
              // 存入数据库
              const [result] = await connection.query(
                'INSERT INTO learning_path_recommend (user_id, tag, problem_number, title) VALUES (?, ?, ?, ?)',
                [userId, tag, recommend.problem_number, recommend.title]
              );
              
              // 添加到返回结果
              allRecommendations.push({
                id: result.insertId,
                user_id: userId,
                tag: tag,
                problem_number: recommend.problem_number,
                title: recommend.title,
                difficulty: difficulty,
                reason: recommend.reason || null,
                created_at: new Date()
              });
            }
          }
        } catch (parseError) {
          console.error(`[${requestId}] 解析AI推荐响应失败:`, parseError);
          // 解析失败时降级使用常规推荐逻辑
          await fallbackRecommendation(connection, userId, tag, problems, allRecommendations, requestId);
        }
      } catch (aiError) {
        console.error(`[${requestId}] 调用智谱AI推荐题目失败:`, aiError);
        // AI调用失败时降级使用常规推荐逻辑
        await fallbackRecommendation(connection, userId, tag, problems, allRecommendations, requestId);
      }
    }
    
    console.log(`[${requestId}] 最终生成了 ${allRecommendations.length} 道推荐题目`);
    
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

// 降级推荐算法
async function fallbackRecommendation(connection, userId, tag, problems, allRecommendations, requestId) {
  console.log(`[${requestId}] 使用降级推荐算法为标签 ${tag} 推荐题目`);
  
  // 按通过率排序（从低到高），取前2个题目
  const sortedProblems = problems.sort((a, b) => 
    (a.acceptance_rate || 0) - (b.acceptance_rate || 0)
  ).slice(0, 2);
  
  for (const problem of sortedProblems) {
    try {
      // 存入数据库
      const [result] = await connection.query(
        'INSERT INTO learning_path_recommend (user_id, tag, problem_number, title) VALUES (?, ?, ?, ?)',
        [userId, tag, problem.problem_number, problem.title]
      );
      
      // 添加到返回结果
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
      console.error(`[${requestId}] 保存降级推荐题目到数据库失败:`, saveError);
    }
  }
}

module.exports = router; 