# AgentRecord

> 关于 Agent 基础问题、稳定机制与认识修订的长期思考记录。

[English summary](./README.en.md)

Agent 工具、框架和产品变化很快。这个仓库不追踪它们的数量，也不把 Prompt、Skill、教程或项目案例当作长期资产；它只保留能够跨工具继续成立、并且已经形成独立判断的分析。

## 唯一职责

AgentRecord 研究 Agent 本身，例如：

- Agent 如何表征问题，以及错误表征怎样限制后续搜索；
- 搜索为什么会过早收敛；
- 假设如何形成、竞争、被证伪或被修订；
- 证据不足的判断为什么会过早升级为行动；
- 执行、验收和记忆写入为什么需要相互制约；
- 用户如何受到自动化偏见、过度依赖和认知卸载影响。

## 不收录

- Agent 工具、框架、热门仓库和新闻清单；
- 安装配置、使用教程、Prompt 或 Skill 收藏；
- 视觉算法等领域工程案例及其代码、实验和实施计划；
- 尚未形成独立判断的论文、帖子或聊天摘要；
- 为显得系统而扩建的目录、模板和流程。

外部论文、项目和工程案例只能作为分析中的证据指针。原始过程和制品保留在其所属仓库，不复制到这里。

## 目录

```text
AgentRecord/
├── README.md
├── README.en.md
├── AGENTS.md
├── LICENSE
├── analyses/              # 已形成独立判断的 Agent 基础分析
└── _meta/
    ├── writing-guide.md   # 最小写作与证据规范
    └── analysis-template.md
```

根 README 直接维护全部分析索引，不再为目录层级额外维护索引文件。

## 当前分析

- [Agent 问题求解的基础控制：问题表征、信念更新、承诺与验收](./analyses/agent-problem-solving-control.md)

## 准入标准

一篇新分析至少应：

1. 讨论 Agent 本身的基础问题，而非某个领域的具体实现；
2. 区分事实、结构类比、推断、假设和当前结论；
3. 使用可定位的来源，并主动处理反证或竞争解释；
4. 说明适用边界、仍未知之处和可能推翻结论的证据；
5. 对日常使用 Agent 产生明确但不过度扩张的含义。

新证据出现时直接修订正文，并在文末记录实质变化。Git 历史负责保存旧版本，不再建立额外的资产状态系统。

## License

This project is licensed under the terms of the [LICENSE](./LICENSE).
