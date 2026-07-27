# AgentRecord

> Long-term analyses of foundational agent problems, durable mechanisms, and revisions in understanding.

[中文主页](./README.md)

Agent tools, frameworks, and products change quickly. This repository does not track them as durable assets. It keeps only analyses that form an independent judgment and remain useful across particular tools.

## Scope

AgentRecord studies agents themselves: problem representation, premature search convergence, belief revision, commitment under uncertainty, independent verification, memory control, and human overreliance.

It does **not** collect:

- agent tools, popular repositories, or news;
- setup guides, prompts, or skills;
- domain engineering cases, code, experiments, or implementation plans;
- summaries that do not form an independent judgment.

External papers, projects, and cases may appear only as evidence pointers inside an analysis. Their original artifacts remain in the repository where the work was performed.

## Structure

```text
AgentRecord/
├── README.md
├── README.en.md
├── AGENTS.md
├── LICENSE
├── analyses/
└── _meta/
    ├── writing-guide.md
    └── analysis-template.md
```

## Current analysis

- [Problem-solving control for agents: representation, belief, commitment, and verification](./analyses/agent-problem-solving-control.md)
- [From agent loops to explicit control graphs: when execution structure should be externalized](./analyses/from-agent-loops-to-explicit-control-graphs.md)

Every new analysis must distinguish evidence from inference, examine competing explanations, state its validity boundary, identify unresolved questions, and produce a concrete implication for everyday agent use.
