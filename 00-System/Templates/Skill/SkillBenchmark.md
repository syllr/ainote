<%*
// Templater template for skill-creator Benchmark mode

const skill_name = await tp.system.prompt(
  "要基准测试 Skill 名称：",
  "",
  true,
  {},
  false
);
const runs = await tp.system.prompt(
  "运行次数（推荐：10）：",
  "10",
  true,
  {},
  false
);
const goals = await tp.system.prompt(
  "基准测试目标，要对比/测量什么：",
  "",
  true,
  {},
  true // 多行
);

tR += `
# 基准测试 Skill: ${skill_name}

---

## Skill 名称

${skill_name}

## 运行次数

${runs}（推荐 10 次以获得统计显著结果）

## 基准测试目标

要对比什么，测量什么:

${goals}

## skill-creator 会做什么

- 带 Skill 运行 N 次所有测试
- 不带 Skill 运行 N 次测试
- 对比：通过率、token 消耗、耗时
- 输出汇总表格，量化证明 Skill 是否真的带来改进
`;
%>
