# board

A personal board of advisors for Claude Code. Six advisors, each built from a
structured wiki distilled from that person's own published work, answering from
their own method and staying inside their own lane.

**Status: v1 in progress.** This repo currently holds only the ingestion spec.
The skill, the advisor template, the generator and `templates/berth/` land next.

## What is here

| Path | What it is |
|---|---|
| `docs/ingestion-session-prompt.md` | The pipeline spec: manifest format, raw-file naming, and the nine-section wiki structure every advisor is built to. |

## What is coming

`SKILL.md`, `templates/advisor.md.tmpl`, `scripts/generate-agents.py`,
`config.example.toml`, and `templates/berth/`.

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
