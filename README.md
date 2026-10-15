# 极简创业者 — Agent Skills

基于 Sahil Lavingia 的著作[《极简创业者》（The Minimalist Entrepreneur）](https://www.minimalistentrepreneur.com/)整理的一组 AI agent 技能（skill）。

每个 skill 都是一个普通的 `skills/<名称>/SKILL.md` 文件，采用开放的 [Agent Skills](https://agentskills.io) 格式（YAML 头部包含 `name` 和 `description`，正文是 Markdown 指令），因此适用于所有支持 skill 的 agent：Claude Code、Cursor、OpenAI Codex、Gemini CLI、GitHub Copilot 等。

## 安装

### 一句话让 agent 帮你装

把下面这句话发给 Cursor、Codex、Claude Code 或任何能执行命令的 agent：

> 访问 https://github.com/ray0807/opc-skills ，按照 README 里"给 AI agent 的安装步骤"，帮我一键安装这些 skill

### 一行命令安装

Windows（PowerShell）：

```powershell
irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1 | iex
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/ray0807/opc-skills/main/install.sh | bash
```

以上命令会为所有支持的 agent 安装。只想装给指定的 agent：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1))) -Agent cursor,codex
```

```bash
curl -fsSL https://raw.githubusercontent.com/ray0807/opc-skills/main/install.sh | bash -s -- --agent cursor,codex
```

### 给 AI agent 的安装步骤

如果用户让你安装这些 skill，请严格按以下步骤执行，不要做其他操作：

1. 判断你自己是哪个 agent，对照下方表格选出对应的 `--agent` 取值（`cursor`、`codex`、`claude`、`gemini`）。无法确定时使用 `all`。
2. 根据用户的操作系统运行一行命令：
   - Windows：`& ([scriptblock]::Create((irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1))) -Agent <agent>`
   - macOS / Linux：`curl -fsSL https://raw.githubusercontent.com/ray0807/opc-skills/main/install.sh | bash -s -- --agent <agent>`
3. 确认输出中出现 `已安装 10 个 skill`，然后提醒用户重启 agent（或新开一个对话），skill 才会生效。

### 从本地克隆安装

先克隆仓库，再运行对应平台的脚本。默认会安装到所有支持的 agent 的用户级 skill 目录；用 `-Agent` / `--agent` 可以指定 agent。

Windows（PowerShell）：

```powershell
git clone https://github.com/ray0807/opc-skills.git
cd opc-skills
.\install.ps1                          # 安装到所有 agent
.\install.ps1 -Agent cursor,codex      # 只装给 Cursor 和 Codex
.\install.ps1 -Agent cursor -Project D:\code\my-app   # 安装到指定项目
.\install.ps1 -Uninstall               # 卸载
```

macOS / Linux：

```bash
git clone https://github.com/ray0807/opc-skills.git
cd opc-skills
./install.sh                           # 安装到所有 agent
./install.sh --agent cursor,codex      # 只装给 Cursor 和 Codex
./install.sh --agent cursor --project ~/code/my-app   # 安装到指定项目
./install.sh --uninstall               # 卸载
```

| `--agent` 取值 | Agent | 安装位置 |
|-----------|-------|-------------|
| `claude` | Claude Code | `~/.claude/skills/` |
| `cursor` | Cursor | `~/.cursor/skills/` |
| `codex` | OpenAI Codex | `~/.codex/skills/` |
| `gemini` | Gemini CLI | `~/.gemini/skills/` |
| `agents` | 多个 agent 共用的目录 | `~/.agents/skills/` |

使用 `--project <目录>` 时，会在该项目目录下创建同样的相对路径，而不是装到用户主目录。安装完成后需重启 agent 才能加载新的 skill。

### 使用 `npx skills`

如果装了 Node.js，可以用 [`skills` 命令行工具](https://github.com/vercel-labs/skills)，它会自动检测已安装的 agent 并完成安装：

```bash
npx skills add ray0807/opc-skills
```

### Claude Code 插件

```
/plugin marketplace add ray0807/opc-skills
/plugin install minimalist-entrepreneur
```

### 手动复制

把 `skills/` 下任意文件夹复制到你的 agent 的 skill 目录即可，每个文件夹都是独立的。

## Skill 列表

当你的请求与某个 skill 的描述相符时，agent 会自动加载它。也可以手动调用，例如在 Claude Code 或 Cursor 中输入 `/validate-idea`，在 Codex 中输入 `$validate-idea`，或直接说"使用 validate-idea 这个 skill"。

| Skill | 名称 | 适用场景 |
|-------|------|-------------|
| **寻找社群** | `find-community` | 正在寻找创业方向，想找到自己的社群 |
| **验证想法** | `validate-idea` | 判断一个商业想法是否值得投入 |
| **最小可行产品** | `mvp` | 准备做第一个产品，不知道范围怎么定 |
| **流程化** | `processize` | 有了产品想法，想在写代码前先手动交付价值 |
| **首批客户** | `first-customers` | 已有产品，需要找到前 100 个客户 |
| **定价** | `pricing` | 制定价格或考虑调价 |
| **营销计划** | `marketing-plan` | 已达到产品市场契合，准备用内容扩大规模 |
| **可持续增长** | `grow-sustainably` | 在花钱、招人或扩张方面做决策 |
| **公司价值观** | `company-values` | 确立企业文化，准备招聘 |
| **极简审视** | `minimalist-review` | 对任何商业决策做一次直觉检验 |

## 极简创业者之路

这些 skill 按照书中的顺序排列：

1. **社群** — 先找到属于你的人群
2. **验证** — 确认这个问题值得解决
3. **构建** — 先交付手动流程，再做成产品
4. **流程化** — 把产品想法变成今天就能交付的手动流程
5. **销售** — 一个一个地拿下前 100 个客户
6. **定价** — 从第一天起就收费
7. **营销** — 通过内容积累受众
8. **增长** — 保持盈利，可持续地增长
9. **文化** — 打造你自己愿意长住的"房子"
10. **审视** — 用极简原则检验每一个决策
