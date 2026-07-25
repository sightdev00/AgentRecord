---
type: decision
status: tested
created: 2026-07-25
updated: 2026-07-25
scope: AgentRecord repository structure and contribution flow
owners:
  - sightdev00
based_on:
  - ../foundations/agent_problem_solving_harness_analysis.md
review_on: 2026-10-25
supersedes: legacy-v0 content-type taxonomy
superseded_by:
---

# Decision 0001：按知识形成过程组织仓库

## 决策

AgentRecord 的主目录按 `Foundation → Case → Pattern → Decision → Experiment → Revision` 组织，不再按 Prompt、Skill、工具、论文、博客或仓库等载体组织。

## 背景与约束

- Agent 工具和框架迭代快，以工具为中心的内容折旧快；
- 旧结构方便收藏，却无法稳定保存问题表征、竞争假设、证据和修订过程；
- 仓库需要服务日常开发，而不是只形成公开展示；
- 当前内容量不大，可以保留历史并建立新的主线；
- 不引入数据库、知识图谱或复杂生成脚本。

## 依据

- 基础分析指出，Agent 经验的长期价值在于问题空间、信念状态、承诺和验收如何被控制；
- Case-Based Reasoning 的价值来自 Retrieve–Reuse–Revise–Retain，而不是保存问题—答案对；
- 当前 `playbooks / builds / reviews / journal` 结构按内容形态分类，不能表达一条结论由哪些案例、实验和反例支持；
- 用户明确要求以 `agent_problem_solving_harness_analysis.md` 这类思考沉淀为主，避免堆砌工具。

## 考虑过的方案

| 方案 | 收益 | 风险 | 结论 |
|---|---|---|---|
| 保留旧结构，只增加写作规范 | 改动小 | 内容仍会自然流向工具和收藏 | 放弃 |
| 按 Agent 能力模块分类 | 容易浏览 | 模块随技术变化，仍缺少证据关系 | 放弃 |
| 建立数据库或知识图谱 | 关系表达强 | 维护成本先于真实需求，容易工具化 | 暂不采用 |
| 按知识形成过程分类 | 能保留判断与修订链 | 初期写作门槛更高 | 采用 |

## 未解决问题

- 当 Case 数量明显增长后，手工索引是否足够；
- Pattern 至少需要多少独立案例才可以升级；
- 如何为不同 Agent 提供轻量入口而不复制一组平台专用 Prompt；
- 如何对“思考质量”建立不依赖 LLM 自评的回归集。

## 验收与责任

- 验收标准：主目录、模板、准入规则和检查脚本能表达完整知识链；旧内容保留且退出主入口；
- 验收者：仓库维护者；
- 复议日期：2026-10-25，或累计 10 个正式 Case 后，以先到者为准。

## 撤销或修订触发器

- 真实内容连续三次无法归入五种正式资产；
- 同一材料必须重复维护才能表达必要关系；
- 使用者能证明旧结构在检索和复用上稳定优于新结构；
- 新目录造成的维护成本超过它减少的错误和重复劳动。
