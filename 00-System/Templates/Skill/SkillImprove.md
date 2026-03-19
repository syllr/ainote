<%*
// Templater template for skill-creator Improve mode

const skill_name = await tp.system.prompt(
  "要优化的 Skill 名称：",
  "",
  true,
  {},
  false
);
const status = await tp.system.prompt(
  "描述哪些测试失败了，问题是什么：",
  "",
  true,
  {},
  true // 多行
);
const goals = await tp.system.prompt(
  "优化的具体目标：",
  "",
  true,
  {},
  true // 多行
);

tR += `
# 优化 Skill: ${skill_name} 基于测试失败

---

## Skill 名称

${skill_name}

## 当前状态

描述哪些测试失败了，问题出在哪里:

${status}

## 优化具体目标

${goals}
`;
%>
