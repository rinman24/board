#!/usr/bin/env bash
# board bootstrap: clone or update both repos, write the config if absent,
# regenerate the advisor agents. Idempotent; safe to run on every container start.
#
# Run it somewhere git can authenticate to the PRIVATE knowledge repo. Under billet
# that is personal_bootstrap_cmd (agent forwarded), NOT the devcontainer
# postCreateCommand: billet runs postCreateCommand via `docker compose exec`,
# which has no agent socket, so an SSH clone there fails. See README.md.
#
# Required:
#   BOARD_KNOWLEDGE_URL   git URL of your private knowledge repo
#                         (SSH form, e.g. git@github.com:<you>/board-knowledge.git)
# Optional:
#   BOARD_URL             git URL of this repo   (default: https://github.com/rinman24/board.git)
#   BOARD_HOME            where both clones live (default: ~/src)
#
# Non-fatal by design: a workspace bootstrap must never brick on the board.
set -uo pipefail

: "${BOARD_KNOWLEDGE_URL:?set BOARD_KNOWLEDGE_URL to your private knowledge repo}"
BOARD_URL="${BOARD_URL:-https://github.com/rinman24/board.git}"
BOARD_HOME="${BOARD_HOME:-$HOME/src}"
board_dir="$BOARD_HOME/board"
knowledge_dir="$BOARD_HOME/board-knowledge"
config="${XDG_CONFIG_HOME:-$HOME/.config}/board/config.toml"

warn() { echo "board: $*" >&2; }

sync_repo() {  # url dir
  if [ -d "$2/.git" ]; then
    git -C "$2" pull --ff-only --quiet || warn "could not fast-forward $2 (left as is)"
  else
    mkdir -p "$(dirname "$2")"
    # BatchMode: fail fast instead of hanging on a host-key or passphrase prompt.
    GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-ssh -o BatchMode=yes}" git clone --quiet "$1" "$2" \
      || { warn "clone of $1 failed — is an SSH agent forwarded, or a credential injected?"; return 1; }
  fi
}

sync_repo "$BOARD_URL" "$board_dir" || exit 0
sync_repo "$BOARD_KNOWLEDGE_URL" "$knowledge_dir" || exit 0

if [ ! -f "$config" ]; then
  mkdir -p "$(dirname "$config")"
  printf '[board]\nknowledge = "%s"\n' "$knowledge_dir" > "$config"
fi

command -v uv >/dev/null 2>&1 || { warn "uv not on PATH; agents not generated"; exit 0; }
uv run --quiet "$board_dir/scripts/generate-agents.py" || warn "agent generation failed"
