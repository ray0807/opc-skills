#!/usr/bin/env bash
# Install these skills for one or more AI coding agents.
#
#   ./install.sh                          # all agents, user-level
#   ./install.sh --agent cursor,codex     # selected agents
#   ./install.sh --agent cursor --project ~/code/my-app
#   ./install.sh --agent all --uninstall
#
# Remote, without cloning:
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
    -h|--help)   echo "Usage: install.sh [--agent claude,cursor,codex,gemini,agents|all] [--project DIR] [--uninstall]"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
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
  echo "Downloading $REPO@$BRANCH ..."
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
    *) echo "Unknown agent: $1 (use claude, cursor, codex, gemini, agents, all)" >&2; exit 1 ;;
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
  verb=$([ "$UNINSTALL" -eq 1 ] && echo Removed || echo Installed)
  printf '%s %d skills for %-6s -> %s\n' "$verb" "$count" "$agent" "$target"
done
