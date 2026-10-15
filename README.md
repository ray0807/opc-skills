# The Minimalist Entrepreneur — Agent Skills

Agent skills based on [The Minimalist Entrepreneur](https://www.minimalistentrepreneur.com/) by Sahil Lavingia.

Every skill is a plain `skills/<name>/SKILL.md` file in the open [Agent Skills](https://agentskills.io) format (YAML frontmatter with `name` + `description`, followed by Markdown instructions), so it works with any agent that supports skills: Claude Code, Cursor, OpenAI Codex, Gemini CLI, GitHub Copilot, and others.

## Installation

### Ask your agent (one sentence)

Paste this into Cursor, Codex, Claude Code, or any agent that can run shell commands:

> 访问 https://github.com/ray0807/opc-skills ，按照 README 里 "For AI agents" 的步骤，帮我一键安装这些 skill
>
> Install the skills from https://github.com/ray0807/opc-skills following the "For AI agents" section of its README.

### One-line command

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1 | iex
```

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/ray0807/opc-skills/main/install.sh | bash
```

This installs for all supported agents. To pick specific ones:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1))) -Agent cursor,codex
```

```bash
curl -fsSL https://raw.githubusercontent.com/ray0807/opc-skills/main/install.sh | bash -s -- --agent cursor,codex
```

### For AI agents

If a user asks you to install these skills, do the following and nothing else:

1. Identify which agent you are and map it to an `--agent` value from the table below (`cursor`, `codex`, `claude`, `gemini`). If unsure, use `all`.
2. Run the one-line command for the user's OS:
   - Windows: `& ([scriptblock]::Create((irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1))) -Agent <agent>`
   - macOS / Linux: `curl -fsSL https://raw.githubusercontent.com/ray0807/opc-skills/main/install.sh | bash -s -- --agent <agent>`
3. Confirm the output lists `Installed 10 skills`, then tell the user to restart the agent (or start a new chat) so the skills load.

### From a local clone

Clone the repo, then run the script for your platform. By default it installs into every supported agent's user-level skills folder; pass `-Agent` / `--agent` to pick specific ones.

Windows (PowerShell):

```powershell
git clone https://github.com/ray0807/opc-skills.git
cd opc-skills
.\install.ps1                          # all agents
.\install.ps1 -Agent cursor,codex      # only Cursor and Codex
.\install.ps1 -Agent cursor -Project D:\code\my-app   # project-level install
.\install.ps1 -Uninstall               # remove
```

macOS / Linux:

```bash
git clone https://github.com/ray0807/opc-skills.git
cd opc-skills
./install.sh                           # all agents
./install.sh --agent cursor,codex      # only Cursor and Codex
./install.sh --agent cursor --project ~/code/my-app   # project-level install
./install.sh --uninstall               # remove
```

| `--agent` | Agent | Installs to |
|-----------|-------|-------------|
| `claude` | Claude Code | `~/.claude/skills/` |
| `cursor` | Cursor | `~/.cursor/skills/` |
| `codex` | OpenAI Codex | `~/.codex/skills/` |
| `gemini` | Gemini CLI | `~/.gemini/skills/` |
| `agents` | Shared location read by several agents | `~/.agents/skills/` |

With `--project <dir>`, the same relative folders are created inside that project instead of your home directory. Restart the agent afterwards so it picks up the new skills.

### `npx skills`

If you have Node.js, the [`skills` CLI](https://github.com/vercel-labs/skills) detects installed agents and installs for them:

```bash
npx skills add ray0807/opc-skills
```

### Claude Code plugin

```
/plugin marketplace add ray0807/opc-skills
/plugin install minimalist-entrepreneur
```

### Manual copy

Copy any folder under `skills/` into your agent's skills directory. Each folder is self-contained.

## Skills

Agents load a skill automatically when your request matches its description. You can also invoke one explicitly — e.g. `/validate-idea` in Claude Code or Cursor, `$validate-idea` in Codex, or simply "use the validate-idea skill".

| Skill | Name | When to use |
|-------|------|-------------|
| **Find Community** | `find-community` | Looking for a business idea, trying to find your community |
| **Validate Idea** | `validate-idea` | Testing if a business idea is worth pursuing |
| **MVP** | `mvp` | Ready to build your first product, struggling with scope |
| **Processize** | `processize` | Have a product idea, want to deliver value by hand before writing code |
| **First Customers** | `first-customers` | Have a product, need to find your first 100 customers |
| **Pricing** | `pricing` | Setting prices, considering price changes |
| **Marketing Plan** | `marketing-plan` | Have product-market fit, ready to scale with content |
| **Grow Sustainably** | `grow-sustainably` | Making decisions about spending, hiring, or scaling |
| **Company Values** | `company-values` | Defining culture, preparing to hire |
| **Minimalist Review** | `minimalist-review` | Gut-checking any business decision |

## The Minimalist Entrepreneur Journey

The skills follow the book's progression:

1. **Community** — Start by finding your people
2. **Validate** — Make sure the problem is worth solving
3. **Build** — Ship a manual process, then productize it
4. **Processize** — Turn your product idea into a manual process you can deliver today
5. **Sell** — Get to 100 customers one by one
6. **Price** — Charge something from day one
7. **Market** — Build an audience through content
8. **Grow** — Stay profitable, grow sustainably
9. **Culture** — Build the house you want to live in
10. **Review** — Apply minimalist principles to every decision
