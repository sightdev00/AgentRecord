# OpenClaw Provider Kit

面向你的实际启动方式：

```bash
openclaw gateway
```

这套脚本把 **OpenClaw 网关** 和 **三家原生 CLI** 分开管理：

- `openclaw gateway`：统一走 **API Key**
- `codex / claude / gemini` 原生 CLI：支持 **订阅 / OAuth 登录** 或 **API Key**

## 为什么这样分层

第三方网关通常最稳定的接入方式是显式 API Key。
原生 CLI 则可以稳定使用各家的订阅 / OAuth 登录。

因此这套脚本的原则是：

1. **OpenClaw 网关只吃 API Key**
2. **原生 CLI 负责订阅模式**
3. **切换时主动清理会相互覆盖的环境变量**

## 目录

- `profiles/`：配置模板
- `scripts/`：切换、启动、健康检查脚本
- `runtime/`：当前激活配置
- `logs/`：日志目录
- `docs/`：说明文档

## 最小使用流程

### 1. 填写 API 配置

复制模板：

```bash
cd profiles
cp openai.api.env.example openai.api.env
cp anthropic.api.env.example anthropic.api.env
cp gemini.api.env.example gemini.api.env
```

填入你的 key。

### 2. 切换 OpenClaw 网关当前 provider

```bash
./scripts/use-gateway-profile.sh openai.api.env
```

或：

```bash
./scripts/use-gateway-profile.sh anthropic.api.env
./scripts/use-gateway-profile.sh gemini.api.env
```

### 3. 启动 OpenClaw 网关

```bash
./scripts/openclaw-gateway.sh
```

本脚本内部就是：

```bash
openclaw gateway
```

只是在启动前做了：
- 代理注入
- API Key 注入
- provider/model 注入
- 日志落盘

## 原生 CLI：订阅 / OAuth 模式

### Codex CLI（订阅 / ChatGPT 登录）

首次登录：

```bash
codex --login
```

之后运行：

```bash
./scripts/run-codex-subscription.sh
```

### Claude Code（订阅 / Claude.ai 登录）

首次登录：

```bash
claude
# 进入后执行 /login
```

之后运行：

```bash
./scripts/run-claude-subscription.sh
```

### Gemini CLI（Google 登录 / Gemini Code Assist / 个人 Google 账号）

首次登录：

```bash
gemini
```

按提示选择 Google 登录。

之后运行：

```bash
./scripts/run-gemini-subscription.sh
```

## 原生 CLI：API 模式

```bash
./scripts/run-codex-api.sh
./scripts/run-claude-api.sh
./scripts/run-gemini-api.sh
```

这些脚本会读取 `profiles/*.api.env`。

## 核心注意事项

1. `openclaw gateway` 这套脚本默认 **不尝试复用原生 CLI 的 OAuth 凭证**。
   这样做更稳，也更容易排错。

2. Claude Code 在检测到 `ANTHROPIC_API_KEY` 时，会优先用 API key，
   从而覆盖 Claude.ai 订阅登录。订阅模式脚本会主动 `unset ANTHROPIC_API_KEY`。

3. Gemini Advanced / Google One 订阅 **不等于** Gemini API 计费额度。
   用 Gemini API 时仍需要独立的 Gemini API key / Google Cloud billing。

4. Codex CLI 支持 `codex --login` 的 ChatGPT 登录流，也支持 `OPENAI_API_KEY`。
   这两种模式都在脚本里分开处理。

## 推荐使用习惯

- 飞书机器人 / 自动化 / OpenClaw：优先 API Key
- 手工编码 / 本地调试：优先原生 CLI 的订阅模式
- API 限额不够时：再切原生 CLI，或者换 provider

## 快速检查

```bash
./scripts/show-current.sh
./scripts/healthcheck.sh
```
