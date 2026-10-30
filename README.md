# dotfiles

Personal macOS (Apple Silicon) configuration, symlinked into place with
[dotbot](https://github.com/anishathalye/dotbot).

> [!WARNING]
> These are one person's dotfiles. Fork the repo, read what it does, and strip
> out what you do not want before running anything. What bites:
>
> - **`./install`** — force-links over `~/.bin`, `~/.gitconfig`,
>   `~/.config/nvim`, `~/.config/kitty` and `~/.config/vscode`, replacing real
>   files already sitting at those paths, and copies a file into `~/Dropbox`.
> - **`git/.gitconfig`** — carries my name, email, GitHub user and signing key
>   path, and sets `commit.gpgsign`, so a machine without that key cannot
>   commit at all.
> - **`macos/defaults.sh`** — rewrites 24 system preferences, then restarts
>   Finder and Dock.
> - **`macos/pinned-casks.sh`** — installs four apps at deliberately old
>   versions.

## Bootstrap on a new machine

```sh
# 1. Xcode command line tools (provides git)
xcode-select --install

# 2. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Clone — the path matters, $DOTFILES is hardcoded to ~/.dotfiles
# (`dotfiles-private` is a private submodule; without access to it the clone
# still works and `./install` just skips the rules it carries)
git clone --recurse-submodules https://github.com/xuncheng/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 4. Create all the symlinks
./install

# 5. Restart the shell — a login shell, so .zprofile puts brew on the path
exec zsh -l
```

`./install` is idempotent — re-run it any time links are added or changed.

It only creates symlinks. Four more steps are run once per machine:

- [Install the packages](#brewfile)
- [Pin the version-locked casks](#version-pinned-casks)
- [Apply the macOS defaults](#macos-system-defaults)
- [Set up commit signing](#commit-signing)

## Layout

| Path                | Contents                                                         |
| ------------------- | ---------------------------------------------------------------- |
| `install.conf.yaml` | dotbot manifest: the source-of-truth list of every symlink       |
| `install`           | dotbot entry point (syncs the submodule, then applies the yaml)  |
| `dotbot/`           | git submodule                                                    |
| `dotfiles-private/` | private git submodule: work-only config, kept out of this repo   |
| `config/zsh/`       | zsh config, linked to `~/.config/zsh` (`$ZDOTDIR`)               |
| `config/nvim/`      | Neovim config (LazyVim based)                                    |
| `config/tmux/`      | tmux config                                                      |
| `config/kitty/`     | kitty terminal config + themes                                   |
| `config/bat/`       | bat config (`$BAT_CONFIG_PATH`)                                  |
| `config/rg/`        | ripgrep config (`$RIPGREP_CONFIG_PATH`)                          |
| `config/vscode/`    | VS Code custom CSS                                               |
| `git/`              | gitconfig, global gitignore, commit template, log helpers        |
| `claude/`           | Claude Code `settings.json` + `rules/` (into `~/.claude/`)       |
| `bin/`              | personal scripts, linked to `~/.bin` (on `$PATH`)                |
| `npm/`              | `npmrc` (linked to `~/.npmrc`)                                   |
| `dropbox/`          | `rules.dropboxignore`, **copied** into `~/Dropbox` by `install`  |
| `macos/`            | `Brewfile` (linked to `~/.Brewfile`) and the macOS setup scripts |
| `vim/`              | legacy Vim config, read as `~/.vim/vimrc` (Vim 8+)               |

## zsh

Startup is split across three files by role:

- **`.zshenv`** — read by every zsh, login or not. Environment variables and
  `$PATH`. Sets `ZDOTDIR=~/.config/zsh`, which is why the rest of the config
  lives under `~/.config` instead of `$HOME`.
- **`.zprofile`** — login shells only. Runs `brew shellenv` and caches
  `$BREW_PREFIX` (must come after brew is on the path, hence not in `.zshenv`).
- **`.zshrc`** — interactive shells. Sources every `scripts/*.zsh`, then
  `~/.config/zsh-local/`, then initialises rbenv, then loads
  zsh-syntax-highlighting last.

Add new shell config as a file in `config/zsh/scripts/` — it is picked up
automatically, no `source` line needed. Syntax highlighting must stay last in
`.zshrc`, since it has to wrap widgets defined by everything before it.

Anything this repo does not carry goes in `~/.config/zsh-local/`, where every
`*.zsh` is sourced. It is the one extension point, and it does not care what put
a file there — hand-written on a single machine, or symlinked in by another repo,
both work and neither needs an edit here.

It sits outside `$ZDOTDIR` on purpose: that path is a symlink into this repo, so
a file dropped under it at runtime would land in this repo's work tree. Its slot
in `.zshrc` is also deliberate — after `completion.zsh` has run `compinit`, so
those files can call `compdef`, and before rbenv and syntax highlighting.

> [!NOTE]
> `~/.zshrc` in `$HOME` is _not_ used. Because `$ZDOTDIR` is set, zsh reads
> `~/.config/zsh/.zshrc` instead.

## Neovim

A [LazyVim](https://www.lazyvim.org/) install; this repo only carries the
overrides in `lua/config/` and `lua/plugins/`. Enabled language extras are
tracked in `lazyvim.json`, plugin versions in `lazy-lock.json`.

## tmux

Prefix is `C-s`. `C-h/j/k/l` move between panes and transparently cross into
Neovim splits, paired with the `nvim-tmux-navigation` plugin on the editor
side. `prefix + r` reloads the config.

## Git

`git/.gitconfig` is linked to `~/.gitconfig`. `git l`, `git r`, `git hp` and
friends are pretty-log aliases implemented in `git/.githelpers`.

`user.email` is the GitHub `users.noreply.github.com` address rather than a
real mailbox: commit metadata is public and permanent, and an address tied to
an employer stops linking those commits to the account once it is removed from
it.

### Commit signing

`commit.gpgsign` is on unconditionally, so **a machine cannot commit until it
has a signing key** — a missing key fails the commit loudly, rather than
quietly writing unsigned history.

The key is per machine and never copied between them, so a lost laptop costs
one revocation on GitHub instead of a new identity. It is also separate from
any authentication key, so the two can be revoked independently.

```sh
# 1. A passphrase, asked for twice in step 2 and once in step 3. Copy it from
#    the output — the clipboard is not safe here, pasting the commands clobbers it
openssl rand -base64 24

# 2. Generate — the comment is what names the key in GitHub's list
ssh-keygen -t ed25519 -C "git signing $(hostname -s)" \
  -f ~/.ssh/id_ed25519_signing

# 3. Store the passphrase in the login keychain and load the key into ssh-agent
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_signing

# 4. Copy the public key
pbcopy < ~/.ssh/id_ed25519_signing.pub
```

Add the copied key at [github.com/settings/keys](https://github.com/settings/keys)
as a **Signing Key** — _Authentication Key_ is a separate list and produces no
Verified badge. Then commit and confirm GitHub shows **Verified**.

> [!NOTE]
> The filename is fixed at `id_ed25519_signing`, since `user.signingkey` in
> `git/.gitconfig` points at that path. Step 3 is needed once per key: it is
> what puts the passphrase in the keychain. ssh-agent starts empty after a
> reboot, and `ssh-keygen -Y sign` consults neither `ssh_config` nor the
> keychain, so `config/zsh/scripts/ssh-agent.zsh` reloads the keychain's keys
> into the agent on the first shell of each boot.

> [!TIP]
> `git log --show-signature` wants a `gpg.ssh.allowedSignersFile` that is not
> set up here; a `gpgsig` header in `git cat-file commit HEAD` proves a commit
> was signed without it.

## Claude Code

Two things are managed: `~/.claude/settings.json` and the rule files under
`~/.claude/rules/`. The rest of `~/.claude` is local state — `sessions/`,
`projects/`, `history.jsonl`, `shell-snapshots/` — and is deliberately left
alone, which is why `install.conf.yaml` links individual paths rather than the
directory.

This is the _user_ scope, the lowest precedence Claude Code reads. Anything in
a project's `.claude/settings.json` (team-shared) or `.claude/settings.local.json`
(personal, gitignored) overrides it. There is no user-level `settings.local.json`
— per-machine or per-project deviations go in the project's local file.

> [!WARNING]
> Keep secrets out of `settings.json` — it is committed. Anything sensitive
> (API keys, an `env` block with tokens) goes in `settings.local.json`.

### Rules

Claude Code reads every `.md` under `~/.claude/rules/` as global instructions,
so the directory is assembled from two sources:

| Link                      | Source                           | Repo              |
| ------------------------- | -------------------------------- | ----------------- |
| `~/.claude/rules/common`  | `claude/rules/`                  | this repo, public |
| `~/.claude/rules/private` | `dotfiles-private/claude/rules/` | private submodule |

Anything that should not be public — client and project names, environment IDs,
internal conventions — goes in the private submodule; the public `claude/rules/`
holds only general engineering habits. Real credentials belong in neither: the
private repo is still hosted on GitHub.

`./install` runs the private manifest only when the submodule's manifest is
present. A machine without access to the private repo installs the public
configuration and skips the private links. The public manifest attempts to
initialize submodules before the link step.

## Codex

`codex/AGENTS.md` is linked to `~/.codex/AGENTS.md` as global guidance.
It carries cross-project engineering preferences and the default workflow:
Codex investigates, implements, tests, fixes failures and reviews the final diff.
Routine reversible decisions do not require confirmation. Material requirement
ambiguities and actions requiring authorization still do.

Project-root `AGENTS.md` files should describe architecture, setup and validation
commands, and business constraints. Nested files add directory-specific guidance.
Existing project conventions take precedence over personal code-style defaults.
Use personal preferences when the project has no established convention; leave
unrelated code alone.
A non-empty `AGENTS.override.md` replaces `AGENTS.md` at the same discovery level;
it does not discard instructions inherited from other levels.

Claude and Codex retain separate instruction files because their execution and
permission mechanisms differ. Keep shared engineering preferences consistent
when applicable; tool-specific workflow changes need not be mirrored verbatim.

The optional private manifest links its `codex/cloudbase.md` to
`~/.codex/cloudbase.md`. This is Codex-specific guidance based on the existing
Claude stack rules; Claude keeps its original file. The global AGENTS.md asks
Codex to read the file when working on that stack; this is an explicit read instruction, not
automatic recursive discovery of a rules folder.
Without the private submodule, general guidance still works.

`codex/config.toml` is linked to `~/.codex/config.toml`: workspace-write sandbox,
network access requiring escalation, automatic review of eligible approvals, concise output,
fullscreen TUI and notifications while unfocused. Run `codex` directly; no profile
or wrapper is required. These TUI options apply to the CLI, not the desktop app's appearance.

The development default is `gpt-6.1-sol` with `medium` reasoning and Standard
speed. Explicit Plan mode uses `high` reasoning. For a difficult debugging or
design task, use `codex -c 'model_reasoning_effort="high"'`; model access depends
on the signed-in account or workspace. Keep automatic context compaction at the
client defaults rather than hardcoding model context windows or token thresholds.

Simple tasks use one agent. Global guidance requests delegation only when a
complex task has independent work, or a critical change needs independent review.
At most two spawned agents may be open concurrently, excluding the primary agent.
Prefer parallel read-only work; parallel implementation needs separate worktrees
or non-overlapping file ownership. The primary agent integrates and validates the result.
Subagents inherit model and reasoning settings unless explicitly overridden;
they consume additional usage, so there is no mandatory multi-agent pipeline.

Validation follows the project's existing commands and the affected behavior.
Behavior fixes should have regression coverage; small documentation or config
changes use appropriate static checks. Ordinary changes receive a final diff
self-review. Authorization, concurrency, data migration and public API compatibility
changes also receive independent review. A separate manual review is available
with `codex review --uncommitted`; review does not replace tests.

No custom skills or agent definitions are installed by this repo. Built-in and
plugin-provided capabilities remain client-managed. Add a skill only for a focused,
repeatable workflow: personal skills belong under `~/.agents/skills/<name>/SKILL.md`,
and project skills under `.agents/skills/<name>/SKILL.md`. Codex can choose a skill
from its description or the user can invoke it with `$skill-name`; global engineering
rules belong in AGENTS.md rather than being duplicated into skills.

`codex/rules/common.rules` is linked as an individual file under
`~/.codex/rules/`, alongside any locally managed command rules.
It blocks sudo and rebase and prompts for push and PR creation outside the
sandbox. Tests keep normal sandbox permissions; no blanket host-access grants
are installed. Native `.rules` files are command policies, unlike the private
Markdown instructions above. They do not provide file-read exclusions or the
same wildcard matching as Claude permissions.
With automatic review enabled, a `prompt` rule routes through approval review;
it does not guarantee a human confirmation. The explicit push and PR authorization
requirement also remains in AGENTS.md.

The private manifest also links a native CloudBase command policy. The Codex
Markdown file contains its stack conventions and environment checks.
Credential-file avoidance lives in AGENTS.md as an instruction,
not an enforced filesystem deny list. CloudBase command rules conservatively
prompt outside the sandbox; environment checks live in the private instructions.

Run `./install` to install the links, then start a new Codex session. Existing
regular files at these destinations are not forcibly overwritten. If
`~/.codex/config.toml` already exists, merge the desired settings manually or
back it up and replace it with the link; review account and provider settings
before replacing it. Credentials, skills and session state remain local.
These paths assume the default Codex home; a custom `CODEX_HOME` needs matching
links. A non-empty `~/.codex/AGENTS.override.md` takes precedence over AGENTS.md.

The CLI is installed separately from these links. Use `command -v codex` and
`codex --version` to inspect the installation. After configuration changes, validate
with `codex --strict-config app-server --print-startup-config` and check command rules
with `codex execpolicy check --rules codex/rules/common.rules git push origin main`.
The latter evaluates the policy without executing the command. CI checks TOML syntax
and the installed public Codex links; CLI validation uses the installed binary.

Because the config is a symlink, client changes can write project trust entries,
absolute paths and UI state back into the worktree. Inspect `git diff -- codex/config.toml`
before staging; do not commit machine-specific entries or credentials. The symlink
keeps shared defaults easy to maintain, but does not isolate client-written state.
Do not use assume-unchanged or skip-worktree to hide these changes.

References: [configuration](https://learn.chatgpt.com/docs/config-file/config-reference)
and [command rules](https://learn.chatgpt.com/docs/agent-configuration/rules),
[AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md),
[subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents),
and [skills](https://learn.chatgpt.com/docs/build-skills).

## Brewfile

```sh
brew bundle --global   # install everything, read from the ~/.Brewfile link
```

`macos/Brewfile` is edited by hand: grouped by purpose, and deliberately
missing the four casks `pinned-casks.sh` holds at an old version.

```sh
brew bundle dump --file=-   # print the installed state, to diff by eye
```

Never `dump --force`, which rewrites the file from whatever happens to be
installed — the grouping goes flat and those four casks come back unpinned.
Nor `brew bundle cleanup`, which uninstalls rather than lists, and counts the
same four as unlisted.

## Version-pinned casks

```sh
./macos/pinned-casks.sh
```

Four apps have to stay on an old release — CleanShot X, Keyboard Maestro,
RunJS and the WeChat DevTools. A Brewfile has no way to say which version of a
cask it wants, so those four are left out of `macos/Brewfile` and installed
here instead, each from the homebrew-cask definition at the commit that
shipped its version.

All four ship their own updater, so after installing, turn auto-update off
inside each app; otherwise it walks straight back to the latest release and the
pin is meaningless. `brew upgrade` leaves them alone (they are `auto_updates`
casks), but `brew upgrade --greedy` would not.

## macOS system defaults

```sh
./macos/defaults.sh
```

Every line is a deviation from the macOS factory defaults; anything the
factory already gets right is deliberately absent, so the file stays a diff
rather than a dump. It is grouped by area and commented line by line — read it
for what it sets and why.

Deliberately _not_ wired into `install.conf.yaml`: `./install` is a symlink
sync meant to be re-run any time, while this mutates system state and restarts
Finder and Dock. It asks for `sudo` up front, and some of what it writes only
takes effect on the next login.

## License

MIT, see `LICENSE`. The `dotbot/` submodule and the files under `vim/colors/`
and `vim/autoload/` carry their own upstream licenses.
