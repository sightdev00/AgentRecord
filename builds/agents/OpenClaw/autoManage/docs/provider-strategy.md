# Provider Strategy

## 一、分层原则

### 1. OpenClaw 网关层
- 统一走 API Key
- 目标：稳定、可预期、易排障

### 2. 原生 CLI 层
- OpenAI / Codex：订阅登录 或 API Key
- Claude Code：Claude.ai 订阅登录 或 API Key
- Gemini CLI：Google 登录 / Gemini Code Assist 配额 或 API Key

## 二、为什么不让 OpenClaw 直接复用订阅登录

原因不是“绝对做不到”，而是工程上不稳：

1. 第三方网关通常并不知道各家 CLI 的本地 token 存储格式
2. 各家 CLI 的认证优先级不同，容易被环境变量覆盖
3. API Key 更适合守护进程、systemd、pm2、飞书机器人这类长期后台进程

## 三、适用策略

### OpenAI / Codex
- 网关：API Key
- 手工：`codex --login` 或 API Key

### Claude
- 网关：API Key
- 手工：Claude.ai 订阅登录
- 注意：存在 `ANTHROPIC_API_KEY` 时会优先走 API Key

### Gemini
- 网关：API Key
- 手工：Gemini CLI 的 Google 登录 / Gemini Code Assist 配额
- 注意：Gemini Advanced 订阅不等于 Gemini API 额度

## 四、推荐切换习惯

- 写代码：先试 Codex / Claude 原生 CLI
- 自动化：OpenClaw API 模式
- 长上下文/资料整理：Gemini API 或 Gemini CLI
