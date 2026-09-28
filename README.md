# board

A personal board of advisors for Claude Code. Six advisors, each built from a
structured wiki distilled from that person's own published work, answering from
their own method and staying inside their own lane.

**Status: v1.** One advisor at a time, via `/ask-<slug>`. No fan-out, synthesiser
or memory yet.

## What is here

| Path | What it is |
|---|---|
| `scripts/generate-agents.py` | Reads `roster.yaml` from the knowledge repo and writes `~/.claude/agents/board-<slug>.md` and `~/.claude/skills/ask-<slug>/SKILL.md` per advisor. Standalone; run with `uv run`. |
| `templates/advisor.md.tmpl` | The advisor agent: mode inference, the mandatory mode and scope lines, the lane rule, citation-following, blocking questions. The wiki's sections 1–5, 8 and 9 are embedded; 6–7 (voice) are read at runtime in counsel mode only. |
| `templates/ask.md.tmpl` | The `/ask-<slug>` skill: passes the question to the agent blind, relays the answer verbatim, writes a session file into the knowledge repo. |
| `templates/berth/` | Bootstrap for a devcontainer berth, and the checklist for adopting it. |
| `config.example.toml` | The one config key: where the knowledge repo is. |
| `docs/ingestion-session-prompt.md` | The pipeline spec: manifest format, raw-file naming, and the nine-section wiki structure every advisor is built to. |

## Use

```sh
uv run scripts/generate-agents.py --knowledge ~/src/board-knowledge
```

Then, in a new Claude Code session: `/ask-juval [--mode counsel|method] <question>`.
Re-run the generator after editing a wiki or the roster.

## The split

This repo is generic machinery and knows nothing about any particular user.
The advisor wikis, the standing context and the roster live in a separate
private repo, and the two are joined at runtime by a path:

1. `--knowledge` flag
2. `BOARD_KNOWLEDGE` environment variable
3. `~/.config/board/config.toml`
4. `./knowledge` relative to the working directory

Agents are **build artifacts**, generated into `~/.claude/agents/` from the
template here plus the roster there. They are never hand-authored and never
committed.
