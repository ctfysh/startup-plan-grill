#!/bin/bash
# validate-skill.sh — 结构自检 startup-plan-grill 的9维合规性
# 用法: bash validate-skill.sh

cd "$(dirname "$0")"

PASS=0
FAIL=0
WARN=0
SKILL="SKILL.md"

check() {
  local dim="$1" label="$2" result="$3"
  if [ "$result" = "pass" ]; then
    echo "  ✅ Dim$dim $label"
    PASS=$((PASS + 1))
  elif [ "$result" = "warn" ]; then
    echo "  ⚠️  Dim$dim $label"
    WARN=$((WARN + 1))
  else
    echo "  ❌ Dim$dim $label"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== startup-plan-grill 结构自检 ==="
echo ""

# Dim 1: frontmatter
echo "--- Dim 1: 前置元数据 ---"
if grep -qE "^name:" "$SKILL"; then check 1 "name字段" "pass"; else check 1 "name字段" "fail"; fi
if grep -qE "^description:" "$SKILL"; then check 1 "description字段" "pass"; else check 1 "description字段" "fail"; fi
DESC_LEN=$(sed -n '/^description:/,/^---/p' "$SKILL" | wc -c | tr -d ' ')
if [ "$DESC_LEN" -le 1024 ]; then check 1 "description≤1024字节($DESC_LEN)" "pass"; else check 1 "description≤1024字节($DESC_LEN)" "fail"; fi
if ! grep -qE "(在 Claude Code|Cursor only|Codex 中|~/\.claude/skills/[a-z])" "$SKILL"; then check 1 "无平台硬编码" "pass"; else check 1 "无平台硬编码" "fail"; fi

# Dim 2: workflow clarity
echo ""
echo "--- Dim 2: 工作流清晰度 ---"
if grep -qE "Stage [0-5]" "$SKILL"; then check 2 "阶段编号" "pass"; else check 2 "阶段编号" "fail"; fi
if grep -qE "🔴|STOP|检查点" "$SKILL"; then check 2 "检查点标记" "pass"; else check 2 "检查点标记" "fail"; fi
if grep -qE "plan\.(answers|hints)" "$SKILL"; then check 2 "plan对象追踪" "pass"; else check 2 "plan对象追踪" "fail"; fi

# Dim 3: failure modes
echo ""
echo "--- Dim 3: 失败模式编码 ---"
FAIL_ROWS=$(grep -cE "^\|.*\|.*\|.*\|$" "$SKILL" 2>/dev/null || echo "0")
if [ "$FAIL_ROWS" -ge 6 ]; then check 3 "失败模式≥6行(实际$FAIL_ROWS)" "pass"; else check 3 "失败模式≥6行(实际$FAIL_ROWS)" "fail"; fi

# Dim 4: checkpoints
echo ""
echo "--- Dim 4: 检查点设计 ---"
if grep -qE "每个阶段结束|每阶段结束|阶段末尾" "$SKILL"; then check 4 "阶段末检查点" "pass"; else check 4 "阶段末检查点" "fail"; fi
if grep -qE "摘要|确认|准备好进入下一阶段" "$SKILL"; then check 4 "摘要+确认" "pass"; else check 4 "摘要+确认" "fail"; fi

# Dim 5: actionability
echo ""
echo "--- Dim 5: 可执行具体性 ---"
if grep -qE "可以做：|不能做：" "$SKILL"; then check 5 "提示内容边界规则" "pass"; else check 5 "提示内容边界规则" "fail"; fi
if grep -qE "hints_given|contradictions|red_flags" "$SKILL"; then check 5 "plan对象字段完整" "pass"; else check 5 "plan对象字段完整" "fail"; fi
if grep -qE "自我验证" "$SKILL"; then check 5 "自我验证协议" "pass"; else check 5 "自我验证协议" "fail"; fi

# Dim 6: resource integration
echo ""
echo "--- Dim 6: 资源整合度 ---"
if grep -qE "REFERENCE\.md" "$SKILL"; then check 6 "REFERENCE.md引用" "pass"; else check 6 "REFERENCE.md引用" "fail"; fi
if grep -qE "EXAMPLES\.md" "$SKILL"; then check 6 "EXAMPLES.md引用" "pass"; else check 6 "EXAMPLES.md引用" "fail"; fi
if [ -f "REFERENCE.md" ]; then check 6 "REFERENCE.md存在" "pass"; else check 6 "REFERENCE.md存在" "fail"; fi

# Dim 7: architecture
echo ""
echo "--- Dim 7: 整体架构 ---"
SECTIONS=$(grep -c "^## " "$SKILL")
if [ "$SECTIONS" -ge 5 ]; then check 7 "章节结构≥5(实际$SECTIONS)" "pass"; else check 7 "章节结构≥5(实际$SECTIONS)" "fail"; fi
if ! grep -qE "TODO|FIXME|HACK|XXX" "$SKILL"; then check 7 "无遗留标记" "pass"; else check 7 "无遗留标记" "fail"; fi

# Dim 8: test prompts
echo ""
echo "--- Dim 8: 实测表现 ---"
if [ -f "test-prompts.json" ]; then
  TP_COUNT=$(python3 -c "import json; print(len(json.load(open('test-prompts.json'))))" 2>/dev/null || echo "0")
  if [ "$TP_COUNT" -ge 8 ]; then check 8 "测试用例≥8条(实际$TP_COUNT)" "pass"; elif [ "$TP_COUNT" -ge 5 ]; then check 8 "测试用例≥5条(实际$TP_COUNT)" "warn"; else check 8 "测试用例≥5条(实际$TP_COUNT)" "fail"; fi
else
  check 8 "test-prompts.json存在" "fail"
fi

# Dim 9: anti-patterns
echo ""
echo "--- Dim 9: 反例与黑名单 ---"
ANTI=$(grep -c "不做价值判断\|不发明问题\|不一次问多个\|不跳过检查点\|不替用户做决定\|不偏离框架\|提示不是暗示" "$SKILL" || echo "0")
if [ "$ANTI" -ge 6 ]; then check 9 "反模式≥6条(实际$ANTI)" "pass"; else check 9 "反模式≥6条(实际$ANTI)" "fail"; fi

# Summary
echo ""
echo "=========================="
echo "PASS: $PASS | FAIL: $FAIL | WARN: $WARN"
TOTAL=$((PASS + FAIL + WARN))
if [ "$FAIL" -eq 0 ]; then
  echo "✅ 全部通过"
  exit 0
else
  echo "❌ 有 $FAIL 项未通过"
  exit 1
fi
