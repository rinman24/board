# Adopting the board into a berth

The board has two halves: this public repo (machinery) and your private knowledge
repo (wikis, context, roster). A berth needs both cloned, a config file pointing at
the second, and the agents generated into `~/.claude/`. `bootstrap.sh` does all
three, idempotently.

## The one rule: run it where git can authenticate

The knowledge repo is private. **Run the bootstrap in a context where git
credentials already exist.** Anywhere else, the clone fails at build time and the
board looks broken.

Under billet, that context is `personal_bootstrap_cmd`, not the devcontainer's
`postCreateCommand`. Billet runs `postCreateCommand` through `docker compose exec`,
which has no SSH agent socket. The personal bootstrap hops through the container's
sshd with your agent forwarded, so SSH clones of private repos work there and no
key is ever parked on the host.

## Checklist

**Once per operator:**

- [ ] Your knowledge repo is on GitHub and reachable over SSH with your key.
- [ ] `uv` and `git` are on the berth image's PATH.
- [ ] `personal_bootstrap_cmd` in `~/.config/billet/config.toml` runs the bootstrap:

  ```toml
  personal_bootstrap_cmd = "export PATH=\"$HOME/.local/bin:$PATH\"; BOARD_KNOWLEDGE_URL=git@github.com:<you>/board-knowledge.git bash -c \"$(curl -fsSL https://raw.githubusercontent.com/rinman24/board/main/templates/berth/bootstrap.sh)\""
  ```

  If you manage dotfiles with chezmoi, wire it there instead. Put both repos in
  `.chezmoiexternal.toml` as `git-repo` externals with SSH URLs, template
  `~/.config/board/config.toml`, and have a `run_onchange_` script call
  `scripts/generate-agents.py`. The generator is a plain script, so it does not
  care which of the two drives it.

**Per repo:** nothing. The board lives in `$HOME`, not in any repo's devcontainer.

**Without billet:** run the same script anywhere your SSH agent is available. If
you must bootstrap from `postCreateCommand`, inject a fine-grained, read-only PAT
scoped to the knowledge repo as a devcontainer secret, and use an HTTPS
`BOARD_KNOWLEDGE_URL` that git's credential helper can satisfy.

## Permissions

Advisors read the wiki, context and raw layers, and `/ask-<slug>` writes a
session file into `<knowledge>/sessions/`. From any project other than the
knowledge repo itself, both are outside the working directory. In default
permission mode, Claude Code will prompt for them unless you add the knowledge
root to `permissions.additionalDirectories` in `~/.claude/settings.json`:

```json
{ "permissions": { "additionalDirectories": ["/home/dev/src/board-knowledge"] } }
```

## Verify

```sh
ls ~/.claude/agents/board-*.md ~/.claude/skills/ask-*/SKILL.md
```

Then start a new Claude Code session (agents load at session start) and run
`/ask-<slug>` with a question.
