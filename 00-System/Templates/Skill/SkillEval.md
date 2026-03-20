<%*
// Templater template for skill-creator Eval mode

const level = await tp.system.prompt(
  "Skill 级别：输入 user 表示用户级全局 Skill，输入 project 表示项目级 Skill：",
  "user",
  true,
  {},
  false
);
const skill_name = await tp.system.prompt(
  "要运行测试的 Skill 名称：",
  "",
  true,
  {},
  false
);
const notes = await tp.system.prompt(
  "附加说明/指令（可选，没有留空即可）：",
  "",
  true,
  {},
  true // 多行
);

tR += `
# 运行 Skill 测试: ${skill_name}

---

## Skill 信息

- **Skill 名称**: \`${skill_name}\`
- **Skill 级别**: \`${level}\`（user = 用户级全局 Skill，project = 项目级 Skill）

## 附加说明（可选）

运行测试有什么特殊说明:

${notes}

## 测试用例最佳实践提醒

确保你的 \`evals.json\` 遵循这些最佳实践:

- ✅ 预期结果必须**具体可验证**（例如："输出包含问题陈述章节" ✓，"输出高质量" ✗）
- ✅ 包含**边缘情况**（不只是正常输入测试）
- ✅ 每行一个预期，可独立检查
`;
%>
