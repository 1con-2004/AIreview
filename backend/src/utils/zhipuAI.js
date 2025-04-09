const crypto = require('crypto');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const config = require('../../config/zhipu');

class ZhipuAI {
    constructor() {
        console.log('初始化ZhipuAI实例...');
        
        if (!config.API_KEY) {
            throw new Error('未配置智谱AI API密钥，请检查配置文件');
        }
        
        // API密钥格式：id.secret
        const [id, secret] = config.API_KEY.split('.');
        if (!id || !secret) {
            throw new Error('智谱AI API密钥格式错误，应为 "id.secret" 格式');
        }
        
        this.apiId = id;
        this.apiSecret = secret;
        this.baseUrl = config.BASE_URL || 'https://open.bigmodel.cn/api/paas/v4/chat/completions';
        this.model = config.MODEL || 'glm-4-flash';  // 智谱清言AI使用glm-4-flash模型
        
        console.log('ZhipuAI初始化完成，使用模型:', this.model);
        console.log('API基础URL:', this.baseUrl);
    }

    // 生成JWT token
    generateToken() {
        try {
            console.log('开始生成JWT token...');
            const timestamp = Math.floor(Date.now() / 1000);
            const payload = {
                api_key: this.apiId,
                exp: timestamp + 3600,  // token有效期1小时
                timestamp: timestamp
            };
            console.log('JWT payload:', payload);

            const token = jwt.sign(payload, this.apiSecret, { 
                algorithm: 'HS256',
                header: {
                    alg: 'HS256',
                    sign_type: 'SIGN'
                }
            });

            console.log('JWT token生成成功');
            return token;
        } catch (error) {
            console.error('生成Token失败:', error);
            throw new Error(`生成Token失败: ${error.message}`);
        }
    }

    // 调用智谱AI接口
    async chat(messages) {
        try {
            console.log('=== 智谱AI调用开始 ===');
            console.log('发送给AI的消息:', JSON.stringify(messages, null, 2));
            
            const token = this.generateToken();
            console.log('使用模型:', this.model);
            
            // 生成唯一的请求ID
            const requestId = crypto.randomUUID();
            console.log('请求ID:', requestId);
            
            const response = await axios.post(
                this.baseUrl,
                {
                    model: this.model,
                    messages,
                    max_tokens: 1500,
                    temperature: 0.7,
                    stream: false
                },
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`,
                        'Accept': 'application/json',
                        'X-Request-Id': requestId
                    },
                    timeout: config.TIMEOUT
                }
            );

            console.log('AI响应状态:', response.status);
            console.log('AI返回的完整响应:', JSON.stringify(response.data, null, 2));
            
            if (response.data && response.data.choices && response.data.choices[0] && response.data.choices[0].message) {
                let result = response.data.choices[0].message.content;
                
                // 清理可能的markdown代码块标记
                result = result.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
                console.log('清理后的AI响应:', result);
                
                return result;
            }
            
            throw new Error('AI响应格式不正确');
        } catch (error) {
            console.error('智谱AI调用失败:', error.message);
            if (error.response) {
                console.error('错误响应数据:', JSON.stringify(error.response.data, null, 2));
            }
            throw new Error(`智谱AI调用失败: ${error.message}`);
        } finally {
            console.log('=== 智谱AI调用结束 ===');
        }
    }

    // 分析用户刷题历史并生成推荐
    async analyzeAndRecommend(userData) {
        console.log('=== 开始分析用户数据生成推荐 ===');
        console.log('输入的用户数据:', JSON.stringify(userData, null, 2));
        
        try {
            const prompt = this.generateAnalysisPrompt(userData);
            console.log('生成的提示词:', prompt);
            
            const messages = [{
                role: "user",
                content: prompt
            }];
            
            const result = await this.chat(messages);
            console.log('AI分析结果:', result);
            
            return this.parseAIResponse(result);
        } catch (error) {
            console.error('生成推荐失败:', error);
            throw error;
        } finally {
            console.log('=== 结束分析用户数据生成推荐 ===');
        }
    }

    generateAnalysisPrompt(userData) {
        return `请分析以下用户的学习数据并给出建议：
历史提交记录：${JSON.stringify(userData.history)}
能力分析：${JSON.stringify(userData.analytics)}

请从以下几个方面进行分析并给出建议：
1. 学习进度评估
2. 已掌握的知识点
3. 需要改进的地方
4. 下一步建议

请用JSON格式返回，格式如下：
{
    "progress_evaluation": "学习进度评估",
    "mastered_points": ["已掌握的知识点1", "已掌握的知识点2"],
    "improvement_areas": ["需要改进的地方1", "需要改进的地方2"],
    "next_steps": ["下一步建议1", "下一步建议2"]
}`
    }

    // 评估题目实际难度
    async analyzeProblemDifficulty(problemStats) {
        const prompt = [
            {
                role: "system",
                content: "你是一个专业的题目难度评估专家，负责分析题目的实际难度。"
            },
            {
                role: "user",
                content: `请分析以下题目的统计数据并评估其实际难度：${JSON.stringify(problemStats)}`
            }
        ];

        try {
            const response = await this.chat(prompt);
            return response.choices[0].message.content;
        } catch (error) {
            console.error('难度评估失败:', error);
            throw error;
        }
    }

    // 生成学习路径
    async generateLearningPath(userProfile, userHistory) {
        // 清理用户历史数据，移除不必要的字段
        const cleanHistory = userHistory.map(item => ({
            problem_id: item.problem_id,
            title: item.title,
            difficulty: item.difficulty,
            tags: item.tags,
            status: item.status,
            submission_count: item.submission_count || 0
        }));

        // 获取已完成的题目ID列表
        const completedProblems = cleanHistory
            .filter(item => item.status === 'accepted')
            .map(item => item.problem_id);

        const prompt = [
            {
                role: "system",
                content: "你是一个专业的编程学习规划师，负责为用户制定个性化的算法学习路径。请基于用户的编程水平、学习历史和目标，设计一个循序渐进的学习计划。请直接返回JSON格式的数据，不要包含任何markdown标记、注释或占位符。对于题目ID列表，请直接使用数字数组，例如[1,2,3,4,5]。"
            },
            {
                role: "user",
                content: `请为以下用户制定算法学习路径：
                用户信息：${JSON.stringify(userProfile)}
                学习历史：${JSON.stringify(cleanHistory)}
                已完成的题目：${JSON.stringify(completedProblems)}
                
                请提供一个包含以下字段的JSON对象：
                {
                    "path_name": "路径名称",
                    "description": "路径描述",
                    "total_stages": 总阶段数(建议3-5个阶段),
                    "stages": [
                        {
                            "stage_number": 阶段序号,
                            "stage_name": "阶段名称",
                            "description": "阶段描述",
                            "required_problems": [题目ID数组，每个阶段4-6个题目，且不包含用户已完成的题目],
                            "completion_criteria": {
                                "min_problems": 最少需要完成的题目数(建议为required_problems长度的80%),
                                "min_acceptance_rate": 最低通过率(0-100的数字),
                                "required_tags": [必须掌握的知识点标签]
                            },
                            "estimated_days": 预计完成天数(7-30之间的数字)
                        }
                    ]
                }
                
                注意：
                1. 每个阶段的题目数量应该在4-6个之间
                2. 不要包含用户已完成的题目
                3. 难度要循序渐进
                4. 每个字段都必须提供实际的值，不要使用注释或占位符
                5. required_problems必须是实际的题目ID数组，例如[1,2,3,4,5]`
            }
        ];

        try {
            const response = await this.chat(prompt);
            const content = response.choices[0].message.content;
            
            // 尝试清理并解析JSON
            let jsonStr = content;
            
            // 移除可能的markdown代码块标记
            jsonStr = jsonStr.replace(/```json\n?/g, '').replace(/```\n?/g, '');
            
            // 移除开头和结尾的空白字符
            jsonStr = jsonStr.trim();
            
            console.log('准备解析的JSON字符串:', jsonStr);
            
            try {
                return JSON.parse(jsonStr);
            } catch (parseError) {
                console.error('JSON解析失败，尝试进行修复:', parseError);
                // 尝试修复常见的JSON格式问题
                jsonStr = jsonStr
                    .replace(/\n/g, ' ')  // 移除换行符
                    .replace(/,\s*}/g, '}')  // 移除对象末尾多余的逗号
                    .replace(/,\s*]/g, ']')  // 移除数组末尾多余的逗号
                    .replace(/(['"])?([a-zA-Z0-9_]+)(['"])?\s*:/g, '"$2":')  // 确保键名使用双引号
                    .replace(/:\s*'([^']*)'/g, ':"$1"')  // 将单引号替换为双引号
                    .replace(/\/\*[^*]*\*\//g, '');  // 移除注释
                
                console.log('修复后的JSON字符串:', jsonStr);
                return JSON.parse(jsonStr);
            }
        } catch (error) {
            console.error('生成学习路径失败:', error);
            throw new Error('生成学习路径失败: ' + error.message);
        }
    }

    // 评估学习阶段完成情况
    async evaluateStageProgress(stageData, userProgress) {
        const prompt = [
            {
                role: "system",
                content: "你是一个编程学习评估专家，负责评估用户在当前学习阶段的完成情况。请直接返回JSON格式的数据，不要包含任何markdown标记。"
            },
            {
                role: "user",
                content: `请评估用户在当前学习阶段的完成情况：
                阶段要求：${JSON.stringify(stageData)}
                用户进度：${JSON.stringify(userProgress)}
                
                请提供一个包含以下字段的JSON对象：
                {
                    "completion_percentage": 完成度百分比,
                    "can_advance": 是否可以晋级(true/false),
                    "issues": ["存在的问题"],
                    "suggestions": ["改进建议"],
                    "next_steps": ["下一步建议"]
                }`
            }
        ];

        try {
            const response = await this.chat(prompt);
            const content = response.choices[0].message.content;
            
            // 清理并解析JSON
            let jsonStr = content.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
            
            try {
                return JSON.parse(jsonStr);
            } catch (parseError) {
                console.error('JSON解析失败，尝试进行修复:', parseError);
                jsonStr = jsonStr
                    .replace(/\n/g, ' ')
                    .replace(/,\s*}/g, '}')
                    .replace(/,\s*]/g, ']')
                    .replace(/(['"])?([a-zA-Z0-9_]+)(['"])?\s*:/g, '"$2":')
                    .replace(/:\s*'([^']*)'/g, ':"$1"');
                
                return JSON.parse(jsonStr);
            }
        } catch (error) {
            console.error('评估学习进度失败:', error);
            throw new Error('评估学习进度失败: ' + error.message);
        }
    }

    // 调整学习路径
    async adjustLearningPath(currentPath, userPerformance) {
        const prompt = [
            {
                role: "system",
                content: "你是一个学习路径优化专家，负责根据用户的实际表现调整学习计划。"
            },
            {
                role: "user",
                content: `请根据用户表现调整学习路径：
                当前路径：${JSON.stringify(currentPath)}
                用户表现：${JSON.stringify(userPerformance)}
                
                请提供：
                1. 调整后的学习路径
                2. 调整原因说明
                3. 新的完成标准
                
                返回格式要求：JSON格式，包含调整后的完整路径信息`
            }
        ];

        try {
            const response = await this.chat(prompt);
            return JSON.parse(response.choices[0].message.content);
        } catch (error) {
            console.error('调整学习路径失败:', error);
            throw error;
        }
    }
}

// 修改导出方式
module.exports = ZhipuAI;

// 汇总用户学习数据
async function summarizeUserLearningData(userId, db) {
    console.log('开始汇总用户学习数据, userId:', userId);
    try {
        // 1. 获取最近一个月的做题记录
        console.log('获取最近一个月做题记录...');
        const [recentSubmissions] = await db.query(`
            SELECT 
                p.id,
                p.title,
                p.difficulty,
                p.tags,
                ups.status,
                ups.submission_count,
                ups.last_submission_time
            FROM user_problem_status ups
            JOIN problems p ON ups.problem_id = p.id
            WHERE ups.user_id = ?
            AND ups.last_submission_time >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
            ORDER BY ups.last_submission_time DESC
        `, [userId]);
        console.log('获取到的做题记录数:', recentSubmissions.length);

        // 2. 获取知识点掌握情况
        console.log('获取知识点掌握情况...');
        const [knowledgeMastery] = await db.query(`
            SELECT 
                kp.name as knowledge_point,
                kp.category,
                kmd.mastery_level
            FROM knowledge_mastery_details kmd
            JOIN knowledge_points kp ON kmd.knowledge_point_id = kp.id
            WHERE kmd.user_id = ?
            ORDER BY kmd.mastery_level DESC
            LIMIT 10
        `, [userId]);
        console.log('获取到的知识点掌握记录数:', knowledgeMastery.length);

        // 3. 获取用户能力评估
        const [abilityAssessment] = await db.query(`
            SELECT *
            FROM ability_assessments
            WHERE user_id = ?
            ORDER BY assessment_date DESC
            LIMIT 1
        `, [userId]);

        // 4. 统计各难度题目的完成情况
        const difficultyStats = {
            easy: { total: 0, solved: 0 },
            medium: { total: 0, solved: 0 },
            hard: { total: 0, solved: 0 }
        };

        recentSubmissions.forEach(sub => {
            const difficulty = sub.difficulty.toLowerCase();
            if (difficultyStats[difficulty]) {
                difficultyStats[difficulty].total++;
                if (sub.status === 'Accepted') {
                    difficultyStats[difficulty].solved++;
                }
            }
        });

        // 5. 统计最常用的标签
        const tagStats = {};
        recentSubmissions.forEach(sub => {
            const tags = JSON.parse(sub.tags || '[]');
            tags.forEach(tag => {
                tagStats[tag] = (tagStats[tag] || 0) + 1;
            });
        });

        const topTags = Object.entries(tagStats)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 5)
            .map(([tag]) => tag);

        // 返回汇总数据
        const result = {
            recentActivity: {
                totalProblems: recentSubmissions.length,
                acceptedProblems: recentSubmissions.filter(s => s.status === 'Accepted').length,
                difficultyStats,
                topTags
            },
            knowledgeMastery: knowledgeMastery.map(k => ({
                point: k.knowledge_point,
                category: k.category,
                level: k.mastery_level
            })),
            abilityAssessment: abilityAssessment[0] || null
        };

        console.log('用户学习数据汇总完成:', JSON.stringify(result, null, 2));
        return result;
    } catch (error) {
        console.error('汇总用户学习数据失败:', error);
        console.error('错误堆栈:', error.stack);
        throw error;
    }
}

// 生成智能学习路径
async function generateLearningPath(userProfile, learningData) {
    console.log('开始生成智能学习路径...');
    console.log('用户资料:', JSON.stringify(userProfile, null, 2));
    console.log('学习数据:', JSON.stringify(learningData, null, 2));
    
    try {
        // 构建提示信息
        const prompt = `作为一个编程学习助手，请根据以下用户信息生成一个包含10道题目的学习路径：

用户近期学习数据：
- 已解决题目数：${learningData.recentActivity.acceptedProblems}
- 总尝试题目数：${learningData.recentActivity.totalProblems}
- 难度分布：${JSON.stringify(learningData.recentActivity.difficultyStats)}
- 擅长领域：${learningData.recentActivity.topTags.join(', ')}

知识点掌握情况：
${learningData.knowledgeMastery.map(k => `- ${k.point}(${k.category}): ${k.level}分`).join('\\n')}

能力评估：
- 学习效率：${learningData.abilityAssessment?.learning_efficiency || 'N/A'}
- 知识应用：${learningData.abilityAssessment?.knowledge_application || 'N/A'}
- 综合评分：${learningData.abilityAssessment?.overall_score || 'N/A'}

请生成一个学习路径，包含以下内容：
1. 路径名称
2. 路径描述
3. 10道推荐题目的ID列表（题目ID范围：1-100）
4. 每道题目的推荐原因

注意：
- 题目难度要循序渐进
- 要覆盖用户较弱的知识点
- 要包含一些挑战性题目
- 题目数量固定为10道
- 只返回JSON格式数据`;

        console.log('生成的提示信息:', prompt);

        // 调用智谱AI
        console.log('调用智谱AI生成学习路径...');
        const response = await zhipuAI.chat([{ role: "user", content: prompt }]);

        console.log('AI响应:', JSON.stringify(response, null, 2));

        // 解析AI响应
        const aiResponse = JSON.parse(response.choices[0].message.content);
        console.log('解析后的AI响应:', JSON.stringify(aiResponse, null, 2));

        // 验证推荐的题目是否存在
        const recommendedProblemIds = aiResponse.problems.map(p => p.id);
        console.log('推荐的题目ID:', recommendedProblemIds);

        const [existingProblems] = await db.query(
            'SELECT id FROM problems WHERE id IN (?)',
            [recommendedProblemIds]
        );
        console.log('数据库中存在的题目:', existingProblems);

        const validProblemIds = existingProblems.map(p => p.id);
        console.log('有效的题目ID:', validProblemIds);

        // 构建学习路径数据
        const result = {
            path_name: aiResponse.path_name,
            description: aiResponse.description,
            total_stages: 1,
            stages: [{
                stage_number: 1,
                stage_name: "智能推荐阶段",
                description: aiResponse.description,
                required_problems: validProblemIds,
                completion_criteria: {
                    min_problems: Math.ceil(validProblemIds.length * 0.8),
                    required_tags: learningData.recentActivity.topTags,
                    min_acceptance_rate: 80
                },
                estimated_days: 7
            }]
        };

        console.log('生成的学习路径:', JSON.stringify(result, null, 2));
        return result;
    } catch (error) {
        console.error('生成学习路径失败:', error);
        console.error('错误堆栈:', error.stack);
        throw error;
    }
} 