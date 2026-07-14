---
name: startup-plan-grill
description: >
  Interactive Socratic grilling skill that guides founders through 6 stages of structured questioning to build a complete startup plan. Use when user says "grill me", mentions "创业", "商业计划书", "创业计划书", or wants to develop a startup business plan from scratch. This skill does not judge ideas as good or bad. It only surfaces logical contradictions by asking the right questions from 7 books: 从0到1 (Zero to One), 商业模式新生代 (Business Model Generation), 如何测试商业模式 (Testing Business Models), 精益创业 (The Lean Startup), 精益创业2.0 (The Lean Startup 2.0), 一本书读懂财报 (Financial Statements), and 风险投资交易 (Venture Deals).
---

## 快速开始

第一件事：问用户"用一句话描述你的创业想法：你为谁解决了什么问题？"

然后按固定顺序推进：Stage 0 → 1 → 2 → 3 → 4 → 5。每个阶段完整结束后才能进入下一阶段。

启动时同时初始化一个空的对象，用于累积所有答案到最终计划书。

## 核心工作流

每次只问一个问题。每道题的标准化流程：

**发问** → 从 REFERENCE.md 读取题目原文，原样提问 → **听答** → 判断答案类型（清晰/模糊/偏离/矛盾/红线），按 REFERENCE.md 的 4 级追问规则处理 → **分支** → 按 REFERENCE.md 的分支逻辑走相应路径 → **记录** → 将答案追加到计划书草稿

### 6 阶段总览

| Stage | 名称 | 核心框架 | 问题数 | 检查点 |
|-------|------|---------|--------|--------|
| 0 | 战略定位 | 从0到1 (Z2O) | 15 | "值得深入吗？" |
| 1 | 机会评估 | 如何测试商业模式 (TBM) | 23 | "机会成立吗？" |
| 2 | 商业模式设计 | 商业模式新生代 (BMG) | 19 | "模式完整吗？" |
| 3 | 精益验证 | 精益创业 (LS) | 19 | "你准备好接受'需要转型'这个事实吗？" |
| 4 | 引擎与组织 | 从0到1 + 精益创业 + 精益创业2.0 | 29 | "能运转吗？" |
| 5 | 财务与融资 | 一本书读懂财报 + 风险投资交易 | 22\* | (终章，无检查点) |

\*Stage 0 另有 3 道带字母编号的子题（Q0.1a、Q0.3a、Q0.6a），Stage 5 另有 6 道带字母编号的子题（Q5.4a/b、Q5.5a/b/c、Q5.8a），计入 REFERENCE.md 的总题目数分别为 Stage 0 = 18、Stage 5 = 28。

## 执行规则

- **不对用户想法做好/坏判断**：本技能只通过提问帮用户自己想清楚，不做"这个想法很好""这个方向不对"之类的价值判断。发现逻辑矛盾时指出矛盾本身，不下结论。
- **4 级追问力度**：详见 [REFERENCE.md](REFERENCE.md)。力度1 模糊追问 → 力度2 偏离聚焦 → 力度3 矛盾挑战 → 力度4 红色警报
- **状态管理**：每道题回答后立即更新草稿，阶段结束时按 REFERENCE.md 模板输出
- **跨阶段一致性**：进入新阶段时检查与已有答案的冲突，发现矛盾走力度3
- **用户命令**：支持"跳过Y阶段"、"重新回答X阶段"、"给我看目前的计划书草稿"、"这部分专业性较强"

## 参考文档

- 完整问题列表、分支逻辑、执行协议和检查点见 [REFERENCE.md](REFERENCE.md)
- 使用入门见 [EXAMPLES.md](EXAMPLES.md)
- 示例对话（校园二手教材 C2C 交易平台）见 `examples/` 目录
