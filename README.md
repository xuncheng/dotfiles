# dotfiles

Personal macOS (Apple Silicon) configuration, symlinked into place with
[dotbot](https://github.com/anishathalye/dotbot).

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

# 5. Install the packages (reads the ~/.Brewfile symlink created in step 4)
brew bundle --global

# 6. Restart the shell
exec zsh
```

`./install` is idempotent — re-run it any time links are added or changed.

## Layout

| Path                | Contents                                                       |
| ------------------- | -------------------------------------------------------------- |
| `install.conf.yaml` | dotbot manifest: the source-of-truth list of every symlink      |
| `install`           | dotbot entry point (syncs the submodule, then applies the yaml) |
| `dotbot/`           | git submodule                                                   |
| `dotfiles-private/` | private git submodule: machine-local, non-public config         |
| `config/zsh/`       | zsh config, linked to `~/.config/zsh` (`$ZDOTDIR`)              |
| `config/nvim/`      | Neovim config (LazyVim based)                                   |
| `config/tmux/`      | tmux config                                                     |
| `config/kitty/`     | kitty terminal config + themes                                  |
| `config/bat/`       | bat config (`$BAT_CONFIG_PATH`)                                 |
| `config/rg/`        | ripgrep config (`$RIPGREP_CONFIG_PATH`)                         |
| `config/vscode/`    | VS Code custom CSS                                              |
| `git/`              | gitconfig, global gitignore, commit template, log helpers       |
| `claude/`           | Claude Code `settings.json` + `rules/` (into `~/.claude/`)      |
| `bin/`              | personal scripts, linked to `~/.bin` (on `$PATH`)               |
| `macos/`            | `Brewfile` (linked to `~/.Brewfile`) and macOS-only helpers     |
| `vim/`, `vimrc`     | legacy Vim config, superseded by `config/nvim`                  |

## zsh

Startup is split across three files by role:

- **`.zshenv`** — read by every zsh, login or not. Environment variables and
  `$PATH`. Sets `ZDOTDIR=~/.config/zsh`, which is why the rest of the config
  lives under `~/.config` instead of `$HOME`.
- **`.zprofile`** — login shells only. Runs `brew shellenv`, then prepends
  Homebrew's ruby and its gem bin directory to `$PATH` (must come after brew is
  on the path, hence not in `.zshenv`).
- **`.zshrc`** — interactive shells. Sources every `scripts/*.zsh`, then loads
  zsh-syntax-highlighting last.

Add new shell config as a file in `config/zsh/scripts/` — it is picked up
automatically, no `source` line needed. Syntax highlighting must stay last in
`.zshrc`, since it has to wrap widgets defined by everything before it.

> **Note:** `~/.zshrc` in `$HOME` is *not* used. Because `$ZDOTDIR` is set,
> zsh reads `~/.config/zsh/.zshrc` instead.

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
friends are pretty-log aliases implemented in `git/.githelpers`. `git div` and
`git gn` shell out to `bin/git-divergence` and `bin/git-goodness`.

## Claude Code

Two things are managed: `~/.claude/settings.json` and the rule files under
`~/.claude/rules/`. The rest of `~/.claude` is local state — `sessions/`,
`projects/`, `history.jsonl`, `shell-snapshots/` — and is deliberately left
alone, which is why `install.conf.yaml` links individual paths rather than the
directory.

This is the *user* scope, the lowest precedence Claude Code reads. Anything in
a project's `.claude/settings.json` (team-shared) or `.claude/settings.local.json`
(personal, gitignored) overrides it. There is no user-level `settings.local.json`
— per-machine or per-project deviations go in the project's local file.

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

The `private` link is guarded by an `if:` in `install.conf.yaml`, so a machine
without access to the private repo installs everything else and skips it,
instead of failing. `install.conf.yaml` inits submodules *before* the link
step, so a fresh clone is fully set up in a single `./install` run.

## Keeping Brewfile in sync

```sh
brew bundle dump --global --force   # overwrite ~/.Brewfile from what's installed
brew bundle cleanup --global        # list installed packages not in the Brewfile
```

The checked-in `macos/Brewfile` is hand-curated and grouped by purpose, so
prefer editing it by hand over `dump`, which flattens the grouping.
