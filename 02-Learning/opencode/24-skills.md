# OpenCode 代理技能

创建和使用代理技能来扩展OpenCode的能力。

## 概述

代理技能（Agent Skills）是预定义的专业知识和工作流程，可以让OpenCode更好地完成特定类型的任务。

## 什么是代理技能

代理技能是：
- 专业领域的专业知识
- 预定义的工作流程
- 可重用的提示模板
- 特定任务的最佳实践

## 技能结构

技能通常包含以下部分：

### 基本结构

```markdown
# 技能名称

## 描述

技能的简要描述。

## 指令

技能的核心指令和指导。

## 示例

使用示例。

## 最佳实践

使用这个技能时的最佳实践。
```

## 技能类型

### 代码审查技能

```markdown
# 代码审查技能

## 描述

专业的代码审查技能，提供高质量的代码审查和改进建议。

## 指令

进行代码审查时，请检查以下方面：

1. 代码质量
   - 代码是否清晰易读？
   - 变量和函数命名是否恰当？
   - 是否有重复代码可以提取？

2. 潜在错误
   - 是否有逻辑错误？
   - 边界情况是否处理？
   - 错误处理是否完善？

3. 性能问题
   - 是否有性能瓶颈？
   - 算法是否最优？
   - 内存使用是否合理？

4. 安全问题
   - 是否有安全漏洞？
   - 输入验证是否充分？
   - 敏感数据是否安全处理？

5. 测试覆盖
   - 是否有足够的测试？
   - 测试是否有效？
   - 边缘情况是否覆盖？

## 工作流程

1. 先理解代码的目的和上下文
2. 逐项检查上述方面
3. 提供具体的改进建议
4. 给出代码示例（如适用）
5. 总结最重要的问题

## 示例

审查示例：

```
这是我的代码，请审查：

function processData(data) {
  let result = [];
  for (let i = 0; i < data.length; i++) {
    if (data[i].active) {
      result.push(data[i].value * 2);
    }
  }
  return result;
}
```

审查反馈：

1. 代码质量
- 使用更具描述性的函数名，如 `doubleActiveValues`
- 可以使用数组方法简化代码

2. 建议改进：

```javascript
function doubleActiveValues(data) {
  return data
    .filter(item => item.active)
    .map(item => item.value * 2);
}
```

3. 考虑添加输入验证和类型检查
```

## 测试生成技能

```markdown
# 测试生成技能

## 描述

自动生成全面的测试用例，确保代码质量。

## 指令

生成测试时，请确保覆盖以下方面：

1. 正常情况
   - 典型输入和预期输出
   - 主要功能路径

2. 边界情况
   - 空输入
   - 最大/最小值
   - 临界值

3. 错误情况
   - 无效输入
   - 异常条件
   - 错误处理

4. 集成测试
   - 组件交互
   - API 调用
   - 数据流

## 测试原则

1. 测试应该独立
2. 测试应该可重复
3. 测试应该快速执行
4. 测试应该清晰描述

## 示例

代码：

```python
def calculate_area(width, height):
    if width <= 0 or height <= 0:
        raise ValueError("Width and height must be positive")
    return width * height
```

生成的测试：

```python
import pytest
from mymodule import calculate_area

def test_normal_case():
    """测试正常情况"""
    assert calculate_area(5, 3) == 15
    assert calculate_area(2, 4) == 8
    assert calculate_area(1, 1) == 1

def test_boundary_values():
    """测试边界值"""
    assert calculate_area(0.1, 0.1) == 0.01
    assert calculate_area(1000, 1000) == 1000000

def test_invalid_inputs():
    """测试无效输入"""
    with pytest.raises(ValueError):
        calculate_area(0, 5)
    with pytest.raises(ValueError):
        calculate_area(5, 0)
    with pytest.raises(ValueError):
        calculate_area(-1, 5)
```

## 重构技能

```markdown
# 重构技能

## 描述

安全地重构代码，提高质量、可读性和可维护性，同时保持功能不变。

## 重构原则

1. 保持功能不变
2. 小步前进，频繁验证
3. 每次重构后运行测试
4. 有清晰的重构目标

## 常见重构模式

1. 提取函数
   - 将长函数拆分为小函数
   - 每个函数只做一件事
   - 给函数起描述性的名字

2. 重命名
   - 变量名要清晰表达意图
   - 避免缩写（除非是广泛理解的）
   - 保持命名风格一致

3. 消除重复
   - 识别重复代码
   - 提取公共逻辑
   - 使用合适的抽象

4. 简化条件
   - 分解复杂条件
   - 使用早期返回
   - 考虑多态替代条件

## 重构工作流程

1. 理解现有代码
2. 添加测试（如缺失）
3. 选择重构策略
4. 小步执行重构
5. 运行测试验证
6. 提交更改

## 示例

重构前：

```javascript
function processOrder(order) {
  let total = 0;
  for (let i = 0; i < order.items.length; i++) {
    total += order.items[i].price * order.items[i].quantity;
  }
  if (order.country === 'US') {
    total += total * 0.08;
  } else if (order.country === 'EU') {
    total += total * 0.15;
  }
  if (order.customer === 'VIP') {
    total *= 0.9;
  }
  return total;
}
```

重构后：

```javascript
const TAX_RATES = {
  'US': 0.08,
  'EU': 0.15
};

const VIP_DISCOUNT = 0.9;

function calculateItemTotal(item) {
  return item.price * item.quantity;
}

function calculateSubtotal(items) {
  return items.reduce((sum, item) => sum + calculateItemTotal(item), 0);
}

function calculateTax(subtotal, country) {
  const rate = TAX_RATES[country] || 0;
  return subtotal * rate;
}

function applyDiscount(total, customerType) {
  return customerType === 'VIP' ? total * VIP_DISCOUNT : total;
}

function processOrder(order) {
  const subtotal = calculateSubtotal(order.items);
  const tax = calculateTax(subtotal, order.country);
  const totalWithTax = subtotal + tax;
  return applyDiscount(totalWithTax, order.customer);
}
```

## 文档生成技能

```markdown
# 文档生成技能

## 描述

为代码生成清晰、有用的文档。

## 文档类型

1. API 文档
2. 代码内联注释
3. README 文件
4. 架构文档
5. 使用指南

## API 文档指南

### 函数文档

包括：

- 功能描述
- 参数说明
- 返回值说明
- 使用示例
- 注意事项
- 相关函数

### 示例

```javascript
/**
 * 计算两个日期之间的工作日数
 * 
 * @param {Date} startDate - 开始日期
 * @param {Date} endDate - 结束日期
 * @returns {number} 工作日数量（不包括周末）
 * @throws {Error} 如果开始日期晚于结束日期
 * 
 * @example
 * const start = new Date('2024-01-01');
 * const end = new Date('2024-01-10');
 * console.log(countBusinessDays(start, end)); // 输出：8
 * 
 * @see {@link isWeekend}
 * @see {@link addBusinessDays}
 */
function countBusinessDays(startDate, endDate) {
  // 实现...
}
```

## 技能文件位置

技能文件可以保存在：

- 项目级：`.opencode/skills/
- 全局：`~/.config/opencode/skills/`

## 使用技能

在 TUI 中使用技能：

```
/skill 代码审查
```

或者使用技能选择器。

## 创建自定义技能

在技能目录中创建 `.md` 文件来添加自定义技能。

## 更多信息

有关代理技能的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/skills/
