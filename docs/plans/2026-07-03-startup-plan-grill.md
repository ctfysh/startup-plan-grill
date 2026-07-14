# startup-plan-grill Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an installable opencode skill that runs a 6-stage Socratic grilling session, guiding a user from vague startup idea to structured business plan.

**Architecture:** Single skill package under `startup-plan-grill/`. SKILL.md as agent entry point with concise workflow + trigger conditions. REFERENCE.md as unified reference with all 136 questions, branching logic, execution protocol, checkpoint conditions, and output templates. examples/ (under skill package) as example conversation outputs.

**Tech Stack:** Pure agent-interactive pattern — no CLI scripts, no dependencies, no external tools. Single agent loads skill and executes Q&A flow.

## Global Constraints

- SKILL.md must stay under 100 lines (write-a-skill guideline)
- DESCRIPTION field must be <1024 chars, include trigger keywords: "startup", "创业", "商业计划书", "grill me", "创业计划书"
- All questions are from the 7 books, not invented by the agent — if not in REFERENCE.md, don't ask it
- Chinese as primary interaction language; agent may use English for book-specific terminology
- No "好/坏" judgment of user's ideas — only point out logical contradictions and blind spots
- 6 stages must run sequentially (Stage 0 → 1 → 2 → 3 → 4 → 5)
- Each stage has a checkpoint before advancing to next
- Final output: consolidated 10-chapter startup plan `.md` file

---

### Task 1: Write SKILL.md — agent entry point

**Files:**
- Create: `SKILL.md`
- Reference: `docs/specs/2026-07-03-startup-plan-grill-design.md`

**Interfaces:**
- Consumes: `docs/specs/2026-07-03-startup-plan-grill-design.md` (design document)
- Produces: SKILL.md — the file an agent loads to understand the skill's purpose, trigger conditions, and workflow at a glance. Task 2's REFERENCE.md is linked from here.

**Requirements:**

The SKILL.md must contain exactly 4 sections:

1. **Frontmatter** — YAML `name` and `description` fields
   - `name: startup-plan-grill`
   - `description`: <1024 chars, must include trigger keywords "startup", "创业", "商业计划书", "grill me", "创业计划书". First sentence describes what it does. Second sentence says "Use when [triggers]."

2. **Quick Start** — minimal start sequence (5-8 lines)
   - "Ask the user: '用一句话描述你的创业想法：你为谁解决了什么问题？'"
   - "Then follow the 6-stage workflow in REFERENCE.md"
   - "Stage order is fixed: 0 → 1 → 2 → 3 → 4 → 5"
   - "Each stage ends with a checkpoint before advancing"

3. **Workflow Overview** — table of 6 stages (keep compact)
   - Each row: Stage # / Name / Core Framework / # Questions / Gate
   - Stage 0: 战略定位 / Z2O / 15 questions → "值得深入吗？"
   - Stage 1: 机会评估 / TBM / 23 questions → "机会成立吗？"
   - Stage 2: 商业模式设计 / BMG / 19 questions → "模式完整吗？"
   - Stage 3: 精益验证 / LS / 19 questions → "准备好转型了吗？"
   - Stage 4: 引擎与组织 / Z2O+LS+LS2 / 29 questions → "能运转吗？"
   - Stage 5: 财务与融资 / 财报+VD / 22 questions → (no gate, final output)

4. **References** — links to deeper docs
   - See [REFERENCE.md](../../REFERENCE.md) for all questions, branching logic, checkpoints, and output templates
   - See `examples/` for example conversations (example product: 校园二手教材 C2C 交易平台)

**MUST DO:**
- Keep under 100 lines total (target: ~75-85 lines)
- Description must be self-contained (agent sees this when deciding to load)
- Chinese for all instructional text
- No inline questions — all detailed Q&A goes in REFERENCE.md

**MUST NOT DO:**
- Don't include question details, branching logic, or output templates in SKILL.md
- Don't include emojis

---

### Task 2: Write REFERENCE.md — full question inventory and workflow

**Files:**
- Create: `REFERENCE.md`
- Reference: `docs/specs/2026-07-03-startup-plan-grill-design.md`

**Interfaces:**
- Consumes: `docs/specs/2026-07-03-startup-plan-grill-design.md` (all 136 questions across 6 stages)
- Produces: REFERENCE.md — the detailed reference that the agent reads alongside SKILL.md during execution

**Requirements:**

REFERENCE.md must cover all content that the agent needs at runtime. Organize by stage.

**Stage per-section structure:**

```markdown
### Stage N: Name
**Goal:** [one line]
**Duration estimate:** [from DESIGN]
**Books:** [from DESIGN]

#### Questions
| # | Question | Branching Logic |
|---|----------|-----------------|

#### Stage Output
[structured text template]

#### Checkpoint
[checkpoint question and logic]
```

**Content checklist:**

- [ ] **Stage 0 — 战略定位 (15 questions: Q0.1-Q0.15)**
  - Q0.1-Q0.1a: 热身/一句话想法 + 0→1 vs 1→n
  - Q0.2-Q0.3a: 秘密与反主流观点（含竞争观分支）
  - Q0.4-Q0.6a: 垄断与护城河（含市场大小分支）
  - Q0.7-Q0.8: 幂次法则与聚焦
  - Q0.9-Q0.15: 特斯拉7问全景扫描
  - Stage 0 输出模板 + 检查点

- [ ] **Stage 1 — 机会评估 (23 questions: Q1.1-Q1.23)**
  - 1A 市场宏观 (Q1.1-Q1.3)
  - 1B 市场微观+移情图 (Q1.4-Q1.7)
  - 1C 行业宏观·五力分析 (Q1.8-Q1.12)
  - 1D 行业微观·竞争优势 (Q1.13-Q1.15)
  - 1E 使命与个人 (Q1.16-Q1.18)
  - 1F 执行能力 (Q1.19-Q1.21)
  - 1G 关系网络 (Q1.22-Q1.23)
  - Stage 1 输出模板 + 检查点

- [ ] **Stage 2 — 商业模式设计 (19 questions: Q2.1-Q2.19)**
  - 2A 画布9模块 (Q2.1-Q2.9)
  - 2B 模式类型匹配 (Q2.10-Q2.11)
  - 2C SWOT评估 (Q2.12-Q2.14)
  - 2D 蓝海战略ERRC (Q2.15-Q2.19)
  - Stage 2 输出模板 + 检查点

- [ ] **Stage 3 — 精益验证 (19 questions: Q3.1-Q3.19)**
  - 3A 飞跃假设 (Q3.1-Q3.4)
  - 3B MVP设计 (Q3.5-Q3.8)
  - 3C 创新核算3步 (Q3.9-Q3.12)
  - 3D BML循环速度 (Q3.13-Q3.14)
  - 3E 转型选项与跑道 (Q3.15-Q3.17)
  - 3F 验证到财务桥接 (Q3.18-Q3.19)
  - Stage 3 输出模板 + 检查点

- [ ] **Stage 4 — 引擎与组织 (29 questions: Q4.1-Q4.29)**
  - 4A 销售路径 (Q4.1-Q4.3)
  - 4B 增长引擎 (Q4.4-Q4.6)
  - 4C 小批量与自适应 (Q4.7-Q4.8)
  - 4D 团队基石 (Q4.9-Q4.14)
  - 4E LS2五原则与治理 (Q4.15-Q4.25)
  - 4F 三阶段转型路线图 (Q4.26-Q4.29)
  - Stage 4 输出模板 + 检查点

- [ ] **Stage 5 — 财务与融资 (22 questions: Q5.1-Q5.22)**
  - 5A 三张报表基础 (Q5.1-Q5.4b)
  - 5B 关键财务指标 (Q5.5-Q5.8a)
  - 5C 财务预测 (Q5.9-Q5.11)
  - 5D 公司架构与知识产权 (Q5.12-Q5.15)
  - 5E 融资判断 (Q5.16-Q5.19)
  - 5F 估值与条款基础 (Q5.20-Q5.22, 可跳过)
  - Stage 5 输出模板

- [ ] **Final output — 创业计划书模板 (design spec §6)**
  - 10-chapter structure with mapping back to each stage's output

- [ ] **Cross-book tension notes** (from design spec §3)
  - Z2O vs LS: 确定论 vs 试错论 → 先假设后验证
  - TBM vs BMG: 外部机会 vs 内部模式 → 先评估后设计
  - LS vs LS2: 创新核算3步 vs 3层次 → Stage 3 vs Stage 4

- [ ] **Error handling / edge cases** (from design spec §7-9)
  - User says "跳过Y阶段" → skip
  - User says "重新回答X阶段" → loop back
  - User says "给我看目前的计划书草稿" → consolidate existing output
  - User says "这部分专业性较强" → recommend professional consultation (Stage 5E)
  - User's answer contradicts earlier answers → point out inconsistency

**MUST DO:**
- Each question has its branching logic verbatim from the design spec
- Output templates are structured text (not markdown table — plain text for agent to write)
- Checkpoint questions and decision logic are explicit
- All 6 stages covered completely

**MUST NOT DO:**
- Don't add questions not in the design spec
- Don't lose branching logic detail
- Don't use emojis
- Don't include examples/ content (they're separate examples)

---

### Task 3: Final verification

**Files:**
- Read: `SKILL.md`
- Read: `REFERENCE.md`

**Verification checklist:**
- [ ] SKILL.md ≤ 100 lines
- [ ] DESCRIPTION < 1024 chars, includes "startup", "创业", "商业计划书", "grill me", "创业计划书"
- [ ] REFERENCE.md covers all 136 questions from the design spec across 6 stages
- [ ] All branching logic preserved verbatim from the design spec
- [ ] All 5 checkpoint conditions documented
- [ ] Cross-book tensions (Z2O/LS, TBM/BMG, LS/LS2) documented
- [ ] All 5 error handling cases documented
- [ ] Final output template matches design spec §6 (10 chapters)
- [ ] No emojis in either file
- [ ] All references consistent (no broken links to non-existent files)

**MUST DO:**
- Count SKILL.md lines with `wc -l`
- Count DESCRIPTION chars
- Spot-check 5 random questions from REFERENCE.md against the design source for accuracy
