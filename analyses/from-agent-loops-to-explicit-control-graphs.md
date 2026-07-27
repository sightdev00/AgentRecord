# 从 Prompt、Context、Harness 到 Agent Loop：控制如何逐层外置

> 当前判断：Prompt、Context、Harness 与 Loop 构成四个嵌套控制面。Prompt 约束一次模型采样；Context 决定该次采样能看到什么；Harness 负责组装上下文、暴露能力、执行或拒绝动作并保存事实；Loop 让这一过程根据新观察持续转移。显式图是 Harness 中可选的控制结构，适合把关键依赖、门控、恢复和验收关系变成机器与人都能检查的对象。

## 1. 问题是什么

早期 LLM 应用常把效果归因于一段写得更好的 Prompt。任务扩展到检索、工具调用、持续执行和跨会话协作后，Prompt 仍然重要，但已经无法单独解释系统行为。

一次 Agent 决策可以近似写成：

\[
C_t=\operatorname{Assemble}(P,U_t,R_t,M_t,T_t,B_t)
\]

\[
Y_t=\operatorname{Model}(C_t)
\]

\[
(S_{t+1},O_t)=\operatorname{Harness}(S_t,Y_t,\Pi,A,E)
\]

- \(P\)：系统指令、任务要求和输出契约；
- \(U_t\)：当前用户输入；
- \(R_t\)：本轮检索到的外部材料；
- \(M_t\)：会话、长期记忆和结构化工作状态；
- \(T_t\)：可见工具及其描述；
- \(B_t\)：Token、时间、费用和风险预算；
- \(C_t\)：模型在第 \(t\) 轮真正看到的 Context；
- \(Y_t\)：模型产生的文本、结构化输出或候选动作；
- \(S_t\)：模型外部的持久状态；
- \(\Pi\)：权限、门控、重试、停止和恢复策略；
- \(A\)：可执行能力；
- \(E\)：外部环境；
- \(O_t\)：执行结果、错误、测试和人工反馈。

当 \(O_t\) 被整理进下一轮输入并再次调用模型时，系统形成 Loop。控制图可以进一步限制 \(\Pi\) 中的允许路径，但图本身既不产生正确 Context，也不保证节点语义正确。

本文要解决三个问题：

1. Prompt、Context、Harness、Loop 和显式图分别控制什么；
2. 这些抽象怎样在 Agent 发展中逐步出现，代表性工具改变了哪些系统边界；
3. 面向具体任务时，怎样从最简单的结构开始，并在证据充分时升级控制强度。

## 2. 发展脉络：控制范围怎样扩大

下面的时间线描述概念重心的扩展。各阶段长期并存，时间顺序不代表后一层淘汰前一层。

| 阶段 | 代表性进展 | 新增的控制对象 | 尚未解决的问题 |
|---|---|---|---|
| 2020：In-context learning | [GPT-3](https://arxiv.org/abs/2005.14165) 以自然语言任务描述和少量示例完成零样本、单样本及少样本任务 | 单次采样中的指令、示例和输出模式 | 外部事实、持续状态和行动仍在模型调用之外 |
| 2020：外部知识进入输入 | [RAG](https://arxiv.org/abs/2005.11401) 联合参数记忆与可检索的非参数记忆 | 检索源、查询、证据片段和来源 | 检索到的材料是否相关、如何进入有限 Context |
| 2022：Prompt 承载过程结构 | [Chain-of-Thought](https://arxiv.org/abs/2201.11903) 用中间推理示例改变复杂任务表现 | 中间步骤的生成格式 | 推理文本仍可能缺乏外部依据与执行约束 |
| 2022—2023：Reasoning 与 Action 交错 | [ReAct](https://arxiv.org/abs/2210.03629) 形成 thought–action–observation 轨迹；[CoALA](https://arxiv.org/abs/2309.02427) 区分记忆、内部动作、外部动作和决策循环 | 工具、观察、工作记忆和跨轮决策 | 历史增长、重复动作、停止条件和权限边界 |
| 2024：Agent–Computer Interface | [SWE-agent](https://arxiv.org/abs/2405.15793) 证明面向模型设计的计算机接口会显著影响软件任务表现；[OpenHands](https://arxiv.org/abs/2407.16741) 把 Agent、事件流和沙箱运行时分开 | 动作语言、观察格式、执行环境、事件日志和沙箱 | 通用性、安全性、恢复和不同 Agent 间的复用 |
| 2024—2025：能力协议化与 Context 工程 | [MCP](https://modelcontextprotocol.io/specification/2025-06-18/server/index) 区分 Prompts、Resources、Tools；Context engineering 开始处理工具描述、外部数据、历史和压缩 | 能力发现、资源注入、上下文选择与传输边界 | 协议不负责调度、安全策略和任务完成判定 |
| 2023—2026：运行时与 Harness 产品化 | LangGraph 提供状态图、持久化与中断；OpenAI Agents SDK 的 Runner 管理工具、handoff、guardrail、session 和 trace；长时任务 Harness 引入初始化、增量工作和结构化交接 | 调度、检查点、审批、恢复、追踪和跨会话制品 | Harness 假设会随模型能力变化而过时，复杂度本身也会制造故障 |
| 2026：显式控制与 Harness 工程 | [Structured Graph Harness](https://arxiv.org/abs/2604.11378) 提出版本化静态图和分层恢复；Harness engineering 把仓库可理解性、可验证反馈和人类注意力视为系统资源 | 计划版本、显式依赖、恢复协议、工程环境和组织控制 | 直接实证仍有限；静态图与开放环境之间的张力尚未解决 |

这条脉络揭示了一个稳定方向：系统行为逐渐从“模型收到什么文字”扩展到“谁选择材料、谁允许动作、谁保存事实、谁决定继续、谁对结果负责”。

## 3. 五个抽象层及其边界

### 3.1 Prompt：单次采样的局部策略

Prompt 可以包含角色、目标、约束、示例、工具说明、输出 Schema 和评价标准。GPT-3 的少样本实验说明，任务描述与示例能够在没有梯度更新的情况下显著改变行为；Chain-of-Thought 进一步说明，中间过程示例也会影响复杂推理表现。

适合放进 Prompt 的内容：

- 本次任务目标和受众；
- 必须遵守的语义约束；
- 输出结构与少量高质量示例；
- 当前步骤的评价标准；
- 模型需要知道、但无须由运行时强制的工作方式。

仅写在 Prompt 中的规则属于软约束。权限、费用上限、禁止写入范围、发布门和不可逆动作审批若必须在模型忘记或误解时继续成立，就应由 Harness 执行。

Prompt 的使用方法可压缩为四步：先写成功条件，再写输入边界；只给能够改变决策的示例；把可机械检查的要求转换成 Schema 或测试；通过任务集评估。单个漂亮输出不足以支持调词结论。

### 3.2 Context：本轮可见状态

Context 是一次推理时送入模型的全部 Token，范围大于用户看到的 Prompt。它可能包含：

```text
系统指令
+ 用户输入
+ 工具定义
+ 检索材料
+ 会话历史
+ 计划与进度
+ 工具结果和错误
+ 记忆摘要
+ 当前环境元数据
```

RAG 把外部检索引入生成，为知识更新和来源追踪提供了直接路径。[Lost in the Middle](https://arxiv.org/abs/2307.03172) 同时表明，相关信息在长 Context 中的位置变化会显著影响表现；增加材料可能提高召回，也会增加模型实际利用信息的难度。

Context engineering 因而是一项持续选择工作：

1. **选择**：只引入能改变当前决策的材料；
2. **标注**：保留来源、时间、作用域、可信度和版本；
3. **排序**：让目标、当前状态和关键证据处在稳定、易定位的位置；
4. **压缩**：把旧轨迹转成结构化事实、未决问题和制品指针；
5. **隔离**：区分执行 Context、诊断 Context、敏感数据和对外输出；
6. **刷新**：对可能变化的事实重新获取，不让摘要冒充当前状态。

Context 不是长期记忆本身。数据库、文件、事件日志和知识库保存在模型外；Context 只是 Harness 在某一轮为某一决策生成的视图。

### 3.3 Harness：模型外部的运行与控制环境

Harness 没有唯一行业定义。本文将其定义为：围绕模型调用，负责准备输入、解释输出、连接能力、执行策略、持久化事实并提供反馈的系统层。

一个完整 Harness 常包含：

| 组件 | 职责 | 关键设计问题 |
|---|---|---|
| Context assembler | 从指令、检索、记忆、历史和工具中构造 \(C_t\) | 哪些内容进入本轮，为什么，何时失效 |
| Model adapter | 调用模型并约束结构化输出 | 超时、重试、模型切换和解析失败如何处理 |
| Tool / ACI registry | 向模型暴露可理解的动作 | 工具粒度、名称、Schema、返回内容和副作用 |
| Runtime / sandbox | 在文件、终端、浏览器或 API 环境中执行动作 | 权限、隔离、网络、密钥和资源上限 |
| State / artifact store | 保存计划、事件、制品、检查点和决策 | 哪些是事实，哪些可更新，哪些必须追加保存 |
| Policy / guardrail | 检查授权、风险、预算与输入输出 | 哪些规则必须独立于模型执行 |
| Scheduler | 决定 ready set、并发、handoff 和停止 | 谁拥有下一步选择权，怎样避免无限循环 |
| Trace / evaluator | 记录轨迹并用测试、评分器或人工检查 | 证据是否新鲜，验收是否与执行相关失败 |
| Recovery / human control | 暂停、批准、拒绝、回滚、重规划和接管 | 人能否理解当前状态并作出有效决定 |

SWE-agent 的 Agent–Computer Interface 说明，工具命令和反馈格式本身会改变 Agent 能力。OpenHands 的 Agent、event stream、runtime 三分结构进一步展示了 Harness 的基本边界：Agent 产生动作，运行时把动作变成观察，事件流保存可追溯历史。

工具设计也属于 Context 设计。模糊、重叠的工具会消耗选择能力；一次返回过多数据会污染后续推理。[Writing effective tools for agents](https://www.anthropic.com/engineering/writing-tools-for-agents) 建议围绕自然任务边界设计工具、明确输入输出并返回高信号内容。这类工程观察需要在具体模型与任务集上重新评估，不能当成恒定规律。

### 3.4 Loop：跨轮状态转移

Agent Loop 需要完成一组有边界的状态转移。一个可控循环至少包含：

```text
Observe
→ Assemble Context
→ Propose
→ Authorize
→ Execute
→ Verify
→ Commit State
→ Continue / Replan / Stop / Escalate
```

ReAct 展示了 reasoning、action、observation 交错的有效性，也记录了模型误读前序观察后重复幻觉动作的案例。CoALA 将循环放在更大的认知架构中：每轮可读取记忆、进行内部推理、选择外部动作并接收新观察。

运行 Loop 时需要显式设置：

- 最大轮数、费用、时间和副作用预算；
- 每种错误可原样重试几次，何时必须换策略；
- 哪些观察可以更新事实，哪些只能进入候选证据；
- 完成条件由谁判断，需要什么新鲜证据；
- 何时暂停给人审查，怎样序列化并恢复；
- 轨迹怎样压缩，同时保留原始事件和制品。

[OpenAI Agents SDK Runner](https://openai.github.io/openai-agents-python/running_agents/) 提供了一个清晰的工程例子：模型返回 final output 时结束，返回 handoff 时切换 Agent，返回 tool calls 时执行并把结果送回下一轮，同时以 `max_turns` 限制循环。Session、conversation state、guardrail 和 tracing 分别处理状态、边界与可观测性。该结构说明 Runner 管理了 Loop，不代表默认停止条件足以证明用户目标已经完成。

### 3.5 显式图：Harness 中的控制拓扑

控制图描述允许或计划中的执行关系。节点可以是动作、检查点、人工审查或子流程；边可以表达依赖、条件、数据传递、失败转移和授权门。

以下对象容易被混淆：

- **控制图**：规定哪些状态与转移被允许；
- **执行轨迹**：记录一次运行实际发生的事件；
- **思维图**：表达推理单元之间的依赖或组合；
- **知识图**：表达实体与语义关系；
- **Loop**：驱动运行时不断推进的循环机制。

图执行器通常仍由事件循环驱动，因此图与 Loop 可以同时存在。[LangGraph](https://docs.langchain.com/oss/python/langgraph/overview) 的 `StateGraph`、节点、边、checkpointer 和 interrupt 是代表性实现：图定义控制结构，持久化支持恢复，中断把状态交给人检查和修改。

一张图只有在边和节点具有可执行语义时才算显式。每个节点至少应说明输入、输出契约、权限、预算、终态、验收和失败去向。计划需要改变时，应创建新版本并保留旧版本的停止位置与修订原因。

### 3.6 五层之间的关系

五层可以压缩成以下包含与控制关系：

```text
Prompt ⊂ Context_t

Harness --构造--> Context_t
Harness --解释与执行--> Model output
Harness --保存--> State / Events / Artifacts

Loop --重复调用--> Harness + Model + Environment

Control graph --约束--> Loop 中允许的状态与转移
Human review --决定--> 关键承诺、发布与接管
```

模型负责生成候选；Harness 决定候选怎样接触真实环境；Loop 决定系统怎样继续；图把部分调度策略固定成可检查结构；人对高影响承诺和最终产物承担决定责任。

## 4. 代表性工具的结构贡献与使用方式

工具名称会变化，下表只保留对抽象边界有代表性的结构。

| 工具或方法 | 核心结构 | 适合怎样使用 | 主要边界 |
|---|---|---|---|
| GPT-3 few-shot / CoT | `instruction + demonstrations + query`，可加入中间步骤示例 | 单次分类、抽取、转换、推理；用任务集挑选示例与输出契约 | 不持久化真实状态，文本规则无法强制权限 |
| RAG | `query → retriever → passages → generator` | 需要外部知识、可更新事实和来源指针的任务；记录检索版本与引用 | 检索错误、材料冲突和 Context 利用失败仍需处理 |
| ReAct | `reason → act → observe` 循环 | 步数难预先确定、需要边行动边取证的开放任务 | 容易积累历史、重复动作并用同一上下文自验收 |
| SWE-agent ACI | 面向模型设计的少量命令、明确反馈和代码执行环境 | 领域动作可以收敛成小型、可评测接口时 | ACI 对模型与任务敏感，迁移后需要重新评测 |
| OpenHands | Agent abstraction + event stream + sandboxed runtime + skills/evals | 需要文件、终端、浏览器、用户反馈和可追踪事件的计算机任务 | 平台能力不等于具体 Agent 策略可靠 |
| MCP | Host–client–server；Prompts、Resources、Tools 三类原语 | 标准化能力发现、资源访问和工具调用；由 Host 管授权与呈现 | MCP 不是完整 Harness，不定义任务计划、调度或完成条件 |
| OpenAI Agents SDK | Agent + Runner + tools + handoffs + guardrails + sessions + tracing | 需要常见工具循环、状态策略、审批和追踪，又不想自行实现运行时 | 默认 Loop 仍需领域验收、风险策略和独立完成判定 |
| LangGraph | typed state + nodes + edges + checkpoint + interrupt | 长时、有分支、需恢复或人工修改状态的工作流 | 图结构正确无法证明节点内容正确；节点切分也可能失真 |
| 长时任务 Harness | initializer / planner + incremental worker / generator + evaluator + structured artifacts | 工作跨越多个 Context window，需要交接、进度和可复现验收 | 成本高，评价器会漂移，Harness 对模型弱点的假设会过时 |

使用这些工具时，先确定需要哪一种控制能力，再选择实现。为一个单轮抽取任务引入持久图会增加维护负担；把高权限、长时任务压进一段 Prompt 则会让关键控制失去独立执行点。

## 5. 已有证据及其强度

### 5.1 直接实验

- GPT-3、Chain-of-Thought、RAG 和 ReAct 提供了 Prompt、外部检索及交错行动在特定基准上的对照结果；
- Lost in the Middle 直接显示，Context 长度与相关信息位置会影响模型使用材料的能力；
- SWE-agent 的研究重点是 ACI 设计对软件工程 Agent 表现的影响；
- OpenHands 在多类基准上评测了共享 Agent、事件流和运行时平台，但平台结构与具体 Agent 算法的贡献并不完全可分。

这些证据支持“模型外输入与接口会改变系统表现”。它们没有证明某一套通用 Harness 在所有任务中最优。

### 5.2 工程观察

[Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) 把 Context 管理扩展到系统指令、工具、MCP、外部数据和历史，并提出 compaction、结构化笔记等长时策略。[Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) 使用初始化 Agent、增量工作 Agent 和交接制品跨越多个 Context window。[Harness engineering](https://openai.com/index/harness-engineering/) 则把仓库知识地图、计划、测试、可观测性和机械规则视为 Agent 可工作环境的一部分。

这些材料来自真实系统建设，能够揭示故障模式与设计方向。它们通常缺少完整对照，且与特定模型、代码任务和组织条件绑定，应作为工程证据而非普遍定律。

### 5.3 形式化与结构类比

[Statecharts](https://doi.org/10.1016/0167-6423(87)90035-9) 和 [Workflow Patterns](https://www.workflowpatterns.com/patterns/control/) 说明层级、并发、同步、取消等关系为何需要明确表示。Structured Graph Harness 把 Agent Loop 解释为调度器，并提出版本化计划、节点状态机和分层恢复。

传统控制系统的节点更确定，LLM 节点的输出和完成判断具有开放语义。形式化控制图可以保证允许路径、预算和终止性质，无法直接保证问题表征、事实、代码或文档结论正确。Structured Graph Harness 目前也是设计提案，没有生产实现与实证结果。

## 6. 当前判断：按控制需求逐级升级

可把 Agent 系统设计成六级复杂度阶梯：

| 级别 | 结构 | 适用条件 | 升级信号 |
|---|---|---|---|
| L0 单次调用 | Prompt → output | 目标固定、无工具、结果易检查 | 需要外部事实或稳定格式 |
| L1 Context-managed call | 检索、示例、状态视图 → output | 单轮可完成，但输入需动态选择 | 需要行动或根据观察调整 |
| L2 Tool Harness | Context assembler + tools + sandbox + trace | 少量可逆工具调用，路径较短 | 步数不确定、需要反复取证 |
| L3 Bounded Loop | observe–decide–act–verify，带预算与停止 | 开放任务，需要根据环境反馈调整 | 需要暂停恢复、跨会话或人工审批 |
| L4 Durable Workflow / Graph | typed state + checkpoints + explicit gates | 分支、并发、恢复、审计或高影响动作 | 环境变化要求动态重规划 |
| L5 Versioned adaptive control | 计划版本 + Loop + graph + recovery + human review | 长时、高风险、多个执行者和多种失败模式 | 只有受控实验能证明是否值得继续复杂化 |

设计步骤如下：

1. **定义决策合同**：目标、受众、完成证据、风险和授权边界；
2. **设计 Context Schema**：每轮需要哪些事实、来源、时态、计划、工具和预算；
3. **确定 Harness 边界**：哪些规则由代码、权限、沙箱、测试和审批强制；
4. **实现最小 Loop**：规定观察、提议、授权、执行、验收、状态提交与停止；
5. **外置高价值控制**：只把反复失败、需要审计或不能交给模型记忆的关系升级为图；
6. **建立人类审查门**：重要文档、代码和方案必须让责任人理解关键内容与逻辑、控制表达和修改，并作出明确决定；
7. **用同一任务集做消融**：比较成功率、成本、人工时间、恢复时间、越权、虚假完成和错误外溢。

Harness 的最佳复杂度随模型能力、任务环境和风险变化。[Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps) 的工程记录也显示，随着模型能力提升，原先用于分解任务的结构可能可以删除。每个 Harness 组件都编码了“模型目前做不到什么”的假设，这些假设需要持续接受消融。

## 7. 竞争性解释、边界与反例

- Prompt 改进有时已经足够，额外运行时只会增加延迟和故障面；
- Context 失败可能源于模型能力、检索质量、材料冲突或位置效应，不能统一归因于长度；
- MCP 统一的是连接协议，Host 仍需实现权限、信任、调度和用户同意；
- Loop 的无限重试可能只需预算和错误分类，不一定需要完整控制图；
- 静态图会固化规划时假设，动态环境可能需要重新规划或允许环的状态机；
- Graph of Thoughts 等推理图与执行控制图处理不同对象，前者的任务收益不能证明后者可靠；
- 多 Agent 或独立评价器可能共享模型、Context 和评价标准，表面分工不会自动产生证据独立性；
- 可视化图容易掩盖节点 Prompt、工具副作用和验收器中的隐含控制；
- 结构化摘要能延长任务，但压缩错误也可能成为下一阶段的“事实”；
- 人类审批按钮无法自动带来有效监督；审查者需要时间、能力、证据和真实拒绝权。

可能显著削弱本文判断的证据包括：在控制模型、任务、预算和工具后，Context 选择、Harness 边界、显式状态与门控没有降低越权、重复失败、虚假完成或复盘成本，并持续损害真实任务成功率。

## 8. 对日常 Agent 使用的意义

开始任务前，可以依次回答五组问题。

### Prompt

- 目标、受众和成功条件是什么？
- 哪些示例真正改变判断？
- 输出结构怎样被机械检查？

### Context

- 本轮必须看到哪些事实、来源和未决问题？
- 哪些历史只需摘要，哪些原始证据必须保留？
- 哪些信息可能过期、冲突或污染判断？

### Harness

- 模型可以提出哪些动作，运行时实际允许哪些动作？
- 工具输入输出是否小而明确，副作用是否可见？
- 状态、制品、日志、权限、预算和密钥保存在哪里？

### Loop 与图

- 每轮怎样观察、验收、提交状态和停止？
- 重试、换策略、重规划、回滚和人工接管怎样区分？
- 哪些依赖或门控值得成为显式边，哪些局部探索可以留给模型？

### 人类审查

- 责任人能否复述关键内容、逻辑、证据和风险？
- 责任人能否直接修改叙述风格、代码结构或方案取舍？
- 审查最终产生了接受、退回、拒绝或升级中的哪一种决定？

如果某项约束在模型忘记、误解或反对时仍需成立，应把它放到 Prompt 之外。如果某项信息不会改变本轮决策，不应仅因“可能有用”就占用 Context。

## 9. 未来方向与未解决问题

未来的重点可能集中在以下方向：

1. **Context 由 transcript 转向 typed view**：事实、假设、计划、证据、权限和争议保留不同类型、版本与生命周期；
2. **Harness 与模型共同演化**：工具接口、Context 策略和模型训练互相适配，同时通过消融删除过时脚手架；
3. **协议与控制面分离**：MCP 等协议解决能力互通，独立策略层处理身份、授权、风险和审计；
4. **动态但可追溯的图**：运行中允许重规划，每次变化产生新版本，旧计划与执行事实不可改写；
5. **验收成为一等对象**：节点契约同时包含输出、证据、Oracle、失败分类与恢复条件；
6. **人的注意力成为显式预算**：系统把可理解性、编辑控制和决策质量纳入完成条件，不只优化自动执行率；
7. **从最终答案评测转向系统评测**：同时测量轨迹、Context 命中、工具误用、恢复、成本、越权和人类决策质量。

仍未解决的问题包括：

- 怎样度量 Context 的“决策价值”，而非仅统计长度或召回？
- Harness 组件的收益怎样与模型升级、Prompt 改进和任务分解分离？
- 什么粒度的节点既可验收，又不会把开放推理伪装成确定流程？
- 如何验证模型生成的计划图、工具 Schema 和验收条件？
- 跨会话压缩怎样保留争议、时态和失败证据？
- 人类怎样证明自己理解了关键逻辑，而不把审查变成形式考试？
- 何种实验可以比较纯 Loop、状态机、动态有环图和版本化 DAG 的净收益？

## 10. 修订记录

- 2026-07-27：初稿。基于调度器视角重构 Loop 与显式控制图的关系。
- 2026-07-27：扩展为 Prompt、Context、Harness、Loop 与显式图的五层方法论；补充发展时间线、代表性工具的结构与使用边界、复杂度阶梯、人类审查和未来方向。
