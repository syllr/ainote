<%*
// Templater template for skill-creator Create mode
// This will prompt you for all variables one by one
// Fifth parameter = true enables multi-line input

const skill_name = await tp.system.prompt(
  "1/5 Skill 名称（小写加连字符，例如：sql-uppercase）：",
  "",
  true,
  {},
  false // 名称用单行足够
);
const description = await tp.system.prompt(
  "2/5 功能描述（做什么，什么时候触发，例如：转换 SQL 关键字为大写，当用户需要格式化 SQL 时使用）：",
  "",
  true,
  {},
  true // 描述需要多行
);
const inputs = await tp.system.prompt(
  "3/5 需要什么输入：",
  "",
  true,
  {},
  true // 多行
);
const output = await tp.system.prompt(
  "4/5 期望输出是什么：",
  "",
  true,
  {},
  true // 多行
);
const rules = await tp.system.prompt(
  "5/9 Claude 必须遵守的规则（每条规则一行）：",
  "",
  true,
  {},
  true // 多行
);
const prohibited = await tp.system.prompt(
  "6/9 Claude 绝对不能做的事（每条一行）：",
  "",
  true,
  {},
  true // 多行
);
const notes = await tp.system.prompt(
  "附加说明/上下文（可选，没有留空即可）：",
  "",
  true,
  {},
  true // 多行
);

// Build the output
tR += `
# 创建新 Skill: ${skill_name}

---

## Skill 基本信息

- **Skill 名称**: \`${skill_name}\`
- **功能描述**（做什么，什么时候触发）:

${description}

## 输入要求

这个 Skill 需要什么输入:

${inputs}

## 期望输出

期望输出是什么:

${output}

## 需要遵守的规则

列出 Claude 必须遵守的具体规则:

${rules}

## Claude 绝对不能做的事

列出 Claude 绝对不能做的事:

${prohibited}

## 附加上下文（可选）

创建这个 Skill 时，skill-creator 还需要知道什么其他信息:

${notes}
`;
%>
