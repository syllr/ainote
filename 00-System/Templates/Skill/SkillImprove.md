<%*
// Templater template for skill-creator Improve mode

const level = await tp.system.prompt(
  "Skill 级别：输入 user 表示用户级全局 Skill，输入 project 表示项目级 Skill：",
  "user",
  true,
  {},
  false
);
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

## Skill 信息

- **Skill 名称**: \`${skill_name}\`
- **Skill 级别**: \`${level}\`（user = 用户级全局 Skill，project = 项目级 Skill）

## 当前状态

描述哪些测试失败了，问题出在哪里:

${status}

## 优化具体目标

${goals}
`;
%>
