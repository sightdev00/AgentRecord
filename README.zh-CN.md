[English](./README.md)

# AgentRecord

> 一个持续记录 Prompt、Agent 工作流、编程实验、Harness 思路与高价值拆解的公开实践仓库。

AgentRecord是一个长期更新的个人Agent实践档案。

它的目标是把分散的 Agent 相关信息沉淀为：

- 可复用的 **playbooks**
- 可验证的 **builds**
- 有判断力的 **reviews**
- 可持续追踪的 **journal**

它既是我的 Agent 学习记录，也是我的公开实验室。

---

## 这里有什么

### `playbooks/`
可直接复用的资产。

包括：

- prompts
- workflows
- skills
- templates

适合快速借鉴、复制、修改和落地。

---

### `builds/`
真实做过的实验与项目。

包括：

- agents
- automations
- benchmarks
- harness

这里关注的不只是“想法”，而是可运行、可验证、可复盘的实现。

---

### `reviews/`
对外部高价值内容的结构化拆解。

包括：

- repos
- blogs
- posts
- papers

目标不是收藏链接，而是提炼：

- 它是什么
- 为什么重要
- 能借鉴什么
- 边界在哪里

---

### `journal/`
持续更新记录。

包括：

- weekly
- monthly
- changelog

用于记录近期探索、实验进展、认知变化与阶段性成果。

---

## 仓库结构

```text
AgentRecord/
├── builds/
│   ├── agents/
│   ├── automations/
│   ├── benchmarks/
│   └── harness/
├── journal/
│   ├── CHANGELOG.md
│   ├── monthly/
│   └── weekly/
├── _meta/
│   ├── contribution.md
│   ├── scripts/
│   ├── taxonomy.md
│   └── templates/
├── playbooks/
│   ├── prompts/
│   ├── skills/
│   ├── templates/
│   └── workflows/
├── reviews/
│   ├── blogs/
│   ├── papers/
│   ├── posts/
│   └── repos/
└── README.md