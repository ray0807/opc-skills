#!/usr/bin/env bash
# 为一个或多个 AI agent 安装这些 skill。
#
#   ./install.sh                          # 安装到所有 agent（用户级）
#   ./install.sh --agent cursor,codex     # 只装给指定 agent
#   ./install.sh --agent cursor --project ~/code/my-app
#   ./install.sh --agent all --uninstall
#
# 无需克隆，远程直接安装：
#   curl -fsSL https://raw.githubusercontent.com/ray0807/opc-skills/main/install.sh | bash -s -- --agent cursor
set -euo pipefail

REPO="ray0807/opc-skills"
BRANCH="main"
AGENTS="all"
BASE="$HOME"
UNINSTALL=0

while [ $# -gt 0 ]; do
  case "$1" in
    --agent)     AGENTS="$2"; shift 2 ;;
    --project)   BASE="$(cd "$2" && pwd)"; shift 2 ;;
    --uninstall) UNINSTALL=1; shift ;;
    -h|--help)   echo "用法：install.sh [--agent claude,cursor,codex,gemini,agents|all] [--project 目录] [--uninstall]"; exit 0 ;;
    *) echo "未知参数：$1" >&2; exit 1 ;;
  esac
done

TMP_DIR=""
SOURCE_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
fi
if [ -z "$SOURCE_DIR" ] || [ ! -d "$SOURCE_DIR" ]; then
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT
  echo "正在下载 $REPO@$BRANCH ..."
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TMP_DIR"
  SOURCE_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)/skills"
fi

agent_dir() {
  case "$1" in
    claude) echo ".claude/skills" ;;
    cursor) echo ".cursor/skills" ;;
    codex)  echo ".codex/skills" ;;
    gemini) echo ".gemini/skills" ;;
    agents) echo ".agents/skills" ;;
    *) echo "未知的 agent：$1（可选 claude、cursor、codex、gemini、agents、all）" >&2; exit 1 ;;
  esac
}

[ "$AGENTS" = "all" ] && AGENTS="claude,cursor,codex,gemini,agents"

IFS=',' read -ra AGENT_LIST <<< "$AGENTS"
for agent in "${AGENT_LIST[@]}"; do
  target="$BASE/$(agent_dir "$agent")"
  count=0
  for skill in "$SOURCE_DIR"/*/; do
    [ -f "$skill/SKILL.md" ] || continue
    name="$(basename "$skill")"
    rm -rf "${target:?}/$name"
    if [ "$UNINSTALL" -eq 0 ]; then
      mkdir -p "$target"
      cp -R "$skill" "$target/$name"
    fi
    count=$((count + 1))
  done
  verb=$([ "$UNINSTALL" -eq 1 ] && echo 已卸载 || echo 已安装)
  echo "$verb $count 个 skill（$agent）-> $target"
done

[ "$UNINSTALL" -eq 0 ] && echo "完成。请重启 agent 或新开一个对话，让 skill 生效。"
exit 0
