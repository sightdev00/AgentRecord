# AgentRecord

> 记录 Agent 如何理解问题、形成判断、采取行动，以及哪里判断错了。

[English summary](./README.en.md)

Agent 迭代很快，工具名、框架和 Prompt 很容易过时。真正值得长期保留的是：

- 当时如何表征问题；
- 看到了哪些异常和约束；
- 保留过哪些竞争解释；
- 哪个实验真正改变了判断；
- 为什么允许进入实施；
- 结果由什么证据验收；
- 这条经验在什么条件下失效。

因此，这里不再把 Prompt、Skill、Agent 框架或热门仓库本身当作核心资产。它们可以是证据、实验材料或实现手段，但不能代替思考过程。

## 仓库如何形成知识

```text
具体问题
  → Case：保存事实、表征、假设、区分实验和结果
  → Pattern：从多个案例中抽取稳定机制
  → Decision：说明在什么边界内采用该模式
  → Experiment：持续证伪和回归
  → Revision：新证据到来后修订或废止
```

理论资料从 `foundations/` 进入这条链路，但理论权威不等于工程结论。外部文章、论文和仓库只通过引用进入 Case、Pattern 或 Experiment，不再按载体单独收藏。

## 目录

```text
AgentRecord/
├── foundations/       # 基础理论、概念边界、可争论命题
├── cases/             # 真实问题的完整求解记录
├── patterns/          # 跨案例复现的机制与失败模式
├── decisions/         # 有范围、有依据、可撤销的实践决策
├── experiments/       # 对照、证伪、评测和回归
├── inbox/             # 尚未形成判断的临时线索
├── _meta/
│   ├── knowledge-model.md
│   ├── writing-standard.md
│   └── templates/
└── archive/legacy-v0/ # 旧版按工具和内容类型组织的材料
```

## 从这里开始

1. 先读 [Agent 问题求解的基础分析](./foundations/agent_problem_solving_harness_analysis.md)。
2. 再读 [知识模型](./_meta/knowledge-model.md)，理解不同资产之间如何转化。
3. 日常遇到真实问题时，从 [Case 模板](./_meta/templates/case.md) 开始，不从总结或工具清单开始。
4. 只有跨案例复现的机制，才能进入 `patterns/`；只有经过验收且说明边界的做法，才能进入 `decisions/`。

## 准入规则

以下内容不能直接进入主目录：

- “最近有哪些 Agent 工具”的列表；
- 没有原始证据的二手结论；
- 只有最终答案、没有判断过程的复盘；
- 由同一个 Agent 自述“已经验证”的成功案例；
- 没有适用边界、反例或失效条件的通用原则；
- 为了显得系统而拼接的术语和清单。

一份正式资产至少要回答：

1. 它解决的是哪个问题族？
2. 事实、推断、假设和决策是否分开？
3. 什么证据能推翻当前判断？
4. 哪一步真正改变了判断？
5. 结果由什么独立证据验收？
6. 哪些条件变化后不能再复用？

## 状态而不是“完成”

每份资产使用以下状态之一：

| 状态 | 含义 |
|---|---|
| `draft` | 已成文，但关键证据或反例仍缺失 |
| `tested` | 已有一次真实测试或案例支持 |
| `replicated` | 在不同案例或环境中再次成立 |
| `bounded` | 适用范围与主要失效条件已经明确 |
| `superseded` | 被新证据或新结论替代，原文保留 |

状态表示证据成熟度，不表示文字是否写得漂亮。

## 当前主线

- Agent 为什么会搜索过早收敛；
- 问题表征如何限制后续搜索和行动；
- 如何维持竞争假设并选择区分性实验；
- 如何阻止证据不足的过早承诺；
- 如何把真实问题转化为可迁移、可修订的经验；
- 如何让执行权、验收权和记忆写入相互制约。

## 当前资产

| 类型 | 内容 | 状态 |
|---|---|---|
| Foundation | [Agent 的基础问题：从语言生成器到受控问题求解系统](./foundations/agent_problem_solving_harness_analysis.md) | `draft` |
| Decision | [0001：按知识形成过程组织仓库](./decisions/0001-organize-by-knowledge-formation.md) | `tested` |

目前没有把旧材料强行包装成 Case 或 Pattern。后续应从真实开发问题中逐个补齐证据链；空目录比虚构的“完整知识体系”更诚实。

## 历史内容

旧版内容保存在 [`archive/legacy-v0/`](./archive/legacy-v0/README.md)。保留它们是为了避免“重构等于删除历史”，但这些材料只有经过重新取证和改写后，才能进入新的知识主线。

## License

This project is licensed under the terms of the [LICENSE](./LICENSE).
