# AgentRecord

> Long-term analyses of foundational agent problems, durable mechanisms, and revisions in understanding.

[中文主页](./README.md)

## Long-term objective

> Improve practical experience in using agents based on the cases I describe, without becoming dependent on fashionable tool frameworks that will eventually be replaced.

This section is the authoritative statement of the repository's current long-term direction. Revise it directly when that direction changes; transient Codex task status, execution plans, and progress do not belong in the repository.

A described case is an entry point for locating a problem, counterexample, or evidence gap; the description itself is not automatically a fact or general principle. Only traceable case artifacts and their effect on an existing judgment, boundary, or action enter the analysis that owns the question.

Agent tools, frameworks, and products change quickly. This repository does not track them as durable assets. It keeps only analyses that form an independent judgment and remain useful across particular tools.

## Scope

AgentRecord studies agents themselves: problem representation, premature search convergence, belief revision, commitment under uncertainty, independent verification, memory control, and human overreliance.

It does **not** collect:

- agent tools, popular repositories, or news;
- setup guides, prompts, or skills;
- domain engineering cases, code, experiments, or implementation plans;
- summaries that do not form an independent judgment;
- extra directories, templates, or workflows created only to appear systematic.

External papers, projects, and cases may appear only as evidence pointers inside an analysis. Their original artifacts remain in the repository where the work was performed.

## Companion engineering repository

[AgentWorkbench](https://github.com/sightdev00/AgentWorkbench) is the engineering companion to this project. It stores my own engineering experience, external agent engineering cases, reproductions, experiments, and executable implementations. The repositories form one system without maintaining duplicate authority:

- AgentRecord owns foundational cross-tool problems, mechanisms, evidence strength, and responsibility boundaries;
- AgentWorkbench owns implementation facts, adaptation work, test results, and failure records;
- engineering observations flow back only when they change a judgment, evidence strength, validity boundary, or practical action here;
- AgentRecord cites fixed commits, versions, or experiment artifacts instead of copying engineering process and implementation.

AgentWorkbench is currently a private incubation repository. Until it becomes public, private artifacts cannot be the sole evidence for a public AgentRecord conclusion; this repository records only the responsibility link, evidence role, and sources that can be disclosed without exposing sensitive material.

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

The root README is the only analysis index; directory layers do not receive additional index files.

## Current analyses

- [Problem-solving control for agents: representation, belief, commitment, and verification](./analyses/agent-problem-solving-control.md)
- [Human review of agent outputs: understanding, control, and decisions](./analyses/human-review-of-agent-outputs.md)
- [Responsibility boundaries for agent control: from single sampling to sustained execution](./analyses/agent-runtime-control-boundaries.md)

## How the analyses relate

| Analysis | Owns the question | Does not define |
|---|---|---|
| [Problem-solving control](./analyses/agent-problem-solving-control.md) | How judgment moves from problem representation to belief, commitment, and verification | A concrete runtime topology; the full human-review responsibility boundary |
| [Runtime control boundaries](./analyses/agent-runtime-control-boundaries.md) | How instruction content, current views, model-external responsibility, continued execution, and optional topology combine to enforce control | Whether judgments, evidence, or acceptance content are correct; a complexity or maturity ladder |
| [Human review](./analyses/human-review-of-agent-outputs.md) | How a responsible person understands, controls, and decides within a stated scope | Automated authorization policy; a guarantee that human judgment is correct |

The first analysis asks which distinctions must be maintained across judgment, commitment, and verification; the second asks where and when the system enforces them; the third asks who understands and decides at consequential commitment boundaries. New evidence should revise the analysis that owns its question; update another analysis only when its boundary or interface changes.

## Admission and maintenance

A conversation or task triggers a review, not an obligation to create an asset. No repository change is a valid outcome. A new analysis must:

1. address a foundational agent problem rather than a domain implementation;
2. distinguish verified facts, structural analogies, inferences, hypotheses, and the current judgment;
3. use traceable sources and examine counterevidence or competing explanations;
4. state validity boundaries, unresolved questions, and possible falsifiers;
5. change how agents are judged, used, authorized, or verified without overextending the evidence;
6. treat named tools and implementations as replaceable evidence, so the core problem and judgment survive their removal.

For the same core question, revise its owning analysis instead of creating a parallel article. When several sources support a claim, disclose shared models, data, benchmarks, evaluators, upstream sources, or organizational incentives; citation count alone does not establish independence.

When an analysis is revised, an adjacent question is added, or ownership changes, also check whether the article still owns an independent question, has valid evidence, and changes a real decision. If not, first present an exact list of content merges, link and index repairs, and file removals. After any required confirmation for structural changes, merge the surviving content and remove the superseded article. An independent question with insufficient evidence may remain when that uncertainty still changes action, but its judgment must be narrowed. Git preserves earlier text; the repository does not maintain maturity labels, archive directories, or a separate asset-status system.

Prioritize proactive research only when it can distinguish a current unresolved question and change an action, authorization, verification, or retention decision. Novelty and popularity are not priorities. See the [writing and evidence guide](./_meta/writing-guide.md) for the full rules.
