const express = require('express');
const router = express.Router();
const zhipuAI = require('../../utils/zhipuAI');
const db = require('../../db');
const { authenticateToken } = require('../../middleware/auth');

// 获取当前学习路径
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户学习路径, userId:', userId); // 添加日志

    // 获取最新的活跃学习路径
    const [paths] = await db.query(
      `SELECT * FROM learning_paths 
       WHERE user_id = ? AND status = 'active'
       ORDER BY created_at DESC 
       LIMIT 1`,
      [userId]
    );

    if (!paths || paths.length === 0) {
      console.log('未找到活跃的学习路径'); // 添加日志
      return res.json({
        success: true,
        data: null
      });
    }

    const path = paths[0];
    console.log('找到学习路径:', path.id); // 添加日志

    // 获取该路径的所有阶段
    const [stages] = await db.query(
      `SELECT * FROM learning_path_stages 
       WHERE path_id = ? 
       ORDER BY stage_order`,
      [path.id]
    );

    // 获取用户已完成的题目
    const [completedProblems] = await db.query(
      `SELECT DISTINCT problem_id 
       FROM submissions 
       WHERE user_id = ? AND status = 'Accepted'`,
      [userId]
    );

    const completedProblemIds = new Set(
      completedProblems.map(p => p.problem_id)
    );

    // 处理每个阶段的完成状态
    const processedStages = stages.map(stage => {
      const requiredProblems = JSON.parse(stage.required_problems);
      const completedCount = requiredProblems.filter(
        id => completedProblemIds.has(id)
      ).length;
      
      return {
        ...stage,
        required_problems: requiredProblems,
        progress: Math.round((completedCount / requiredProblems.length) * 100)
      };
    });

    res.json({
      success: true,
      data: {
        ...path,
        stages: processedStages
      }
    });
  } catch (error) {
    console.error('获取学习路径失败:', error);
    res.status(500).json({
      success: false,
      message: '获取学习路径失败'
    });
  }
});

// 获取已完成的题目
router.get('/completed-problems', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户已完成题目, userId:', userId);

    const [problems] = await db.query(
      `SELECT p.*, MAX(s.created_at) as completed_at
       FROM problems p
       JOIN submissions s ON p.id = s.problem_id
       WHERE s.user_id = ? AND s.status = 'Accepted'
       GROUP BY p.id
       ORDER BY completed_at DESC`,
      [userId]
    );

    res.json({
      success: true,
      data: problems
    });
  } catch (error) {
    console.error('获取已完成题目失败:', error);
    res.status(500).json({
      success: false,
      message: '获取已完成题目失败'
    });
  }
});

// 获取学习进度
router.get('/progress', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    console.log('获取用户学习进度, userId:', userId); // 添加日志

    // 获取最新的活跃学习路径
    const [paths] = await db.query(
      `SELECT * FROM learning_paths 
       WHERE user_id = ? AND status = 'active'
       ORDER BY created_at DESC 
       LIMIT 1`,
      [userId]
    );

    if (!paths || paths.length === 0) {
      console.log('未找到活跃的学习路径'); // 添加日志
      return res.json({
        success: true,
        data: {
          totalProblems: 0,
          completedProblems: 0,
          progress: 0
        }
      });
    }

    const pathId = paths[0].id;
    console.log('找到学习路径:', pathId); // 添加日志

    // 获取路径中的所有题目
    const [stages] = await db.query(
      `SELECT required_problems 
       FROM learning_path_stages 
       WHERE path_id = ?`,
      [pathId]
    );

    // 统计总题目数
    const allProblems = new Set();
    stages.forEach(stage => {
      const problems = JSON.parse(stage.required_problems);
      problems.forEach(id => allProblems.add(id));
    });

    // 获取已完成的题目
    const [completedProblems] = await db.query(
      `SELECT DISTINCT problem_id 
       FROM submissions 
       WHERE user_id = ? 
       AND status = 'Accepted' 
       AND problem_id IN (?)`,
      [userId, [...allProblems]]
    );

    const progress = Math.round(
      (completedProblems.length / allProblems.size) * 100
    );

    res.json({
      success: true,
      data: {
        totalProblems: allProblems.size,
        completedProblems: completedProblems.length,
        progress
      }
    });
  } catch (error) {
    console.error('获取学习进度失败:', error);
    res.status(500).json({
      success: false,
      message: '获取学习进度失败'
    });
  }
});

// 生成新的学习路径
router.post('/generate', authenticateToken, async (req, res) => {
    try {
        const userId = req.user.id;
        console.log('开始生成学习路径，用户ID:', userId);
        
        // 先检查用户是否有未完成的学习路径
        const [existingPath] = await db.query(`
            SELECT lp.*, 
                   JSON_ARRAYAGG(
                       JSON_OBJECT(
                           'stage_number', lps.stage_number,
                           'stage_name', lps.stage_name,
                           'description', lps.description,
                           'required_problems', lps.required_problems,
                           'completion_criteria', lps.completion_criteria,
                           'estimated_days', lps.estimated_days
                       )
                   ) as stages
            FROM learning_paths lp
            LEFT JOIN learning_path_stages lps ON lp.id = lps.path_id
            WHERE lp.user_id = ? AND lp.is_completed = 0
            GROUP BY lp.id
            ORDER BY lp.created_at DESC
            LIMIT 1
        `, [userId]);

        if (existingPath && existingPath.length > 0) {
            console.log('找到未完成的学习路径，返回现有路径');
            return res.json({
                success: true,
                message: '返回现有学习路径',
                data: existingPath[0]
            });
        }

        // 获取用户资料
        const [userProfile] = await db.query(
            'SELECT * FROM user_profile WHERE user_id = ?',
            [userId]
        );
        console.log('获取到的用户资料:', userProfile);

        if (!userProfile) {
            console.log('未找到用户资料');
            return res.status(404).json({
                success: false,
                message: '未找到用户资料'
            });
        }
        
        // 获取用户的刷题历史
        const [userHistory] = await db.query(`
            SELECT ups.*, p.title, p.difficulty, p.tags 
            FROM submissions ups
            JOIN problems p ON ups.problem_id = p.id
            WHERE ups.user_id = ?
        `, [userId]);
        console.log('获取到的用户刷题历史数量:', userHistory.length);

        // 计算用户特征
        const userLevel = calculateUserLevel(userHistory);
        const problemCount = userHistory.length;
        const userTags = extractUserTags(userHistory);

        // 查找匹配的模板
        const [templates] = await db.query(`
            SELECT t.*, m.id as mapping_id, m.problem_count as template_problem_count,
                   ABS(m.problem_count - ?) as problem_count_diff,
                   m.created_at as template_created_at
            FROM learning_path_templates t
            JOIN user_path_template_mapping m ON t.id = m.template_id
            WHERE m.user_level = ?
            AND m.user_id = ?  -- 只匹配当前用户的模板
            AND ABS(m.problem_count - ?) <= 2  -- 题目数量差距缩小到2题以内
            AND JSON_OVERLAPS(m.tags, ?)
            AND m.created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)  -- 只使用最近1天内的模板
            ORDER BY 
                problem_count_diff ASC,  -- 优先选择题目数量差距最小的
                template_created_at DESC  -- 其次选择最新的
            LIMIT 1
        `, [problemCount, userLevel, userId, problemCount, userTags]);

        let learningPath;
        let templateId;

        if (templates.length > 0) {
            // 检查模板是否仍然适用
            const templateProblemCount = templates[0].template_problem_count;
            const problemCountDiff = Math.abs(templateProblemCount - problemCount);
            
            if (problemCountDiff > 2) {
                // 如果题目数量差距过大，生成新的学习路径
                console.log('用户进度发生较大变化，生成新的学习路径...');
                learningPath = await zhipuAI.generateLearningPath(userProfile, userHistory);
            } else {
                // 使用现有模板
                console.log('找到匹配的模板，使用现有模板');
                try {
                    const stagesData = typeof templates[0].stages_data === 'string' 
                        ? JSON.parse(templates[0].stages_data)
                        : templates[0].stages_data;

                    learningPath = {
                        path_name: templates[0].path_name,
                        description: templates[0].description,
                        total_stages: templates[0].total_stages,
                        stages: stagesData
                    };
                    templateId = templates[0].id;
                    console.log('成功解析模板数据:', learningPath);
                } catch (error) {
                    console.error('解析模板数据失败:', error);
                    // 如果解析失败，生成新的学习路径
                    console.log('模板解析失败，改为生成新的学习路径...');
                    learningPath = await zhipuAI.generateLearningPath(userProfile, userHistory);
                }
            }
        } else {
            // 生成新的学习路径
            console.log('未找到匹配的模板，调用AI生成新的学习路径...');
            learningPath = await zhipuAI.generateLearningPath(userProfile, userHistory);
            console.log('AI生成的学习路径:', learningPath);

            // 保存新模板
            const [templateResult] = await db.query(`
                INSERT INTO learning_path_templates 
                (path_name, description, total_stages, stages_data)
                VALUES (?, ?, ?, ?)
            `, [
                learningPath.path_name,
                learningPath.description,
                learningPath.total_stages,
                JSON.stringify(learningPath.stages)
            ]);
            templateId = templateResult.insertId;

            // 保存用户-模板映射
            await db.query(`
                INSERT INTO user_path_template_mapping
                (user_id, template_id, user_level, problem_count, tags)
                VALUES (?, ?, ?, ?, ?)
            `, [userId, templateId, userLevel, problemCount, userTags]);
        }

        // 开启事务
        console.log('开始数据库事务...');
        await db.query('START TRANSACTION');

        try {
            // 先插入学习路径主表
            const [pathResult] = await db.query(`
                INSERT INTO learning_paths 
                (user_id, path_name, description, total_stages, current_stage, created_at)
                VALUES (?, ?, ?, ?, 1, NOW())
            `, [userId, learningPath.path_name, learningPath.description, learningPath.total_stages]);

            const pathId = pathResult.insertId;
            console.log('插入的学习路径ID:', pathId);

            // 插入所有阶段
            console.log('开始插入学习阶段...');
            for (const stage of learningPath.stages) {
                await db.query(`
                    INSERT INTO learning_path_stages 
                    (path_id, stage_number, stage_name, description, required_problems, completion_criteria, estimated_days)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                `, [
                    pathId,
                    stage.stage_number,
                    stage.stage_name,
                    stage.description,
                    JSON.stringify(stage.required_problems),
                    JSON.stringify(stage.completion_criteria),
                    stage.estimated_days
                ]);
                console.log('已插入阶段:', stage.stage_number);
            }

            // 提交事务
            console.log('提交事务...');
            await db.query('COMMIT');

            // 返回完整的学习路径信息
            console.log('查询完整的学习路径信息...');
            const [newPath] = await db.query(`
                SELECT lp.*, 
                       JSON_ARRAYAGG(
                           JSON_OBJECT(
                               'stage_number', lps.stage_number,
                               'stage_name', lps.stage_name,
                               'description', lps.description,
                               'required_problems', lps.required_problems,
                               'completion_criteria', lps.completion_criteria,
                               'estimated_days', lps.estimated_days
                           )
                       ) as stages
                FROM learning_paths lp
                LEFT JOIN learning_path_stages lps ON lp.id = lps.path_id
                WHERE lp.id = ?
                GROUP BY lp.id
            `, [pathId]);

            console.log('返回生成的学习路径数据');
            res.json({
                success: true,
                message: '学习路径生成成功',
                data: newPath[0]
            });

        } catch (error) {
            // 如果出错，回滚事务
            console.error('生成学习路径过程中出错，执行回滚:', error);
            await db.query('ROLLBACK');
            throw error;
        }

    } catch (error) {
        console.error('生成学习路径失败:', error);
        res.status(500).json({
            success: false,
            message: '生成学习路径失败: ' + error.message
        });
    }
});

// 辅助函数：计算用户水平
function calculateUserLevel(userHistory) {
    if (!userHistory.length) return 'beginner';
    
    const solvedCount = userHistory.length;
    const difficultyScores = userHistory.reduce((acc, prob) => {
        if (prob.difficulty === 'easy') acc.easy++;
        else if (prob.difficulty === 'medium') acc.medium++;
        else if (prob.difficulty === 'hard') acc.hard++;
        return acc;
    }, { easy: 0, medium: 0, hard: 0 });

    if (solvedCount < 10) return 'beginner';
    if (difficultyScores.hard >= 5) return 'advanced';
    if (difficultyScores.medium >= 10) return 'intermediate';
    return 'beginner';
}

// 辅助函数：提取用户常用标签
function extractUserTags(userHistory) {
    const tagCount = {};
    userHistory.forEach(prob => {
        let tags;
        try {
            // 处理不同的标签格式
            if (typeof prob.tags === 'string') {
                // 如果是逗号分隔的字符串
                if (prob.tags.includes(',')) {
                    tags = prob.tags.split(',').map(tag => tag.trim());
                } else {
                    // 尝试解析JSON
                    try {
                        tags = JSON.parse(prob.tags);
                    } catch {
                        tags = [prob.tags];
                    }
                }
            } else if (Array.isArray(prob.tags)) {
                tags = prob.tags;
            } else {
                tags = [];
            }

            // 统计标签
            if (Array.isArray(tags)) {
                tags.forEach(tag => {
                    if (tag) {
                        tagCount[tag] = (tagCount[tag] || 0) + 1;
                    }
                });
            }
        } catch (error) {
            console.error('处理标签时出错:', error);
        }
    });

    // 返回出现次数最多的前5个标签
    const sortedTags = Object.entries(tagCount)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5)
        .map(([tag]) => tag);

    // 确保返回的是JSON数组格式
    return JSON.stringify(sortedTags);
}

// 修改进入下一阶段的逻辑
router.post('/advance-stage', authenticateToken, async (req, res) => {
    try {
        const userId = req.user.id;
        console.log('尝试进入下一阶段，用户ID:', userId);

        // 获取用户当前的学习路径
        const [learningPath] = await db.query(`
            SELECT * FROM learning_paths
            WHERE user_id = ? AND is_completed = 0
            ORDER BY created_at DESC
            LIMIT 1
        `, [userId]);

        if (!learningPath) {
            return res.status(404).json({
                success: false,
                message: '未找到学习路径'
            });
        }

        // 获取所有阶段信息
        const [stages] = await db.query(`
            SELECT * FROM learning_path_stages
            WHERE path_id = ?
            ORDER BY stage_number
        `, [learningPath.id]);

        // 检查是否是最后一个阶段
        if (learningPath.current_stage >= stages.length) {
            // 如果是最后一个阶段，标记路径为已完成
            await db.query(`
                UPDATE learning_paths
                SET is_completed = 1,
                    updated_at = NOW()
                WHERE id = ?
            `, [learningPath.id]);

            return res.status(400).json({
                success: false,
                message: '已完成所有阶段'
            });
        }

        // 获取用户的题目进度
        const [userProgress] = await db.query(`
            SELECT * FROM submissions
            WHERE user_id = ?
        `, [userId]);

        // 检查当前阶段是否完成
        const currentStage = stages.find(s => s.stage_number === learningPath.current_stage);
        const progress = await calculateStageProgress(userId, currentStage, userProgress);

        if (!progress.can_advance) {
            return res.status(400).json({
                success: false,
                message: '当前阶段尚未完成，无法进入下一阶段'
            });
        }

        // 更新到下一阶段
        await db.query(`
            UPDATE learning_paths
            SET current_stage = current_stage + 1,
                updated_at = NOW()
            WHERE id = ?
        `, [learningPath.id]);

        res.json({
            success: true,
            message: '成功进入下一阶段',
            data: {
                new_stage: learningPath.current_stage + 1
            }
        });

    } catch (error) {
        console.error('进入下一阶段失败:', error);
        res.status(500).json({
            success: false,
            message: '进入下一阶段失败: ' + error.message
        });
    }
});

module.exports = router; 