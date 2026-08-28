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

# 6. Install the casks that have to stay on an old version
./macos/pinned-casks.sh

# 7. Apply the macOS system preferences (asks for sudo once, up front)
./macos/defaults.sh

# 8. Restart the shell
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
| `npm/`              | `npmrc` (linked to `~/.npmrc`)                                  |
| `dropbox/`          | `rules.dropboxignore`, **copied** into `~/Dropbox` by `install`  |
| `macos/`            | `Brewfile` (linked to `~/.Brewfile`) and the macOS setup scripts |
| `vim/`              | legacy Vim config, read as `~/.vim/vimrc` (Vim 8+)              |

## zsh

Startup is split across three files by role:

- **`.zshenv`** — read by every zsh, login or not. Environment variables and
  `$PATH`. Sets `ZDOTDIR=~/.config/zsh`, which is why the rest of the config
  lives under `~/.config` instead of `$HOME`.
- **`.zprofile`** — login shells only. Runs `brew shellenv` and caches
  `$BREW_PREFIX` (must come after brew is on the path, hence not in `.zshenv`).
- **`.zshrc`** — interactive shells. Sources every `scripts/*.zsh`, then
  initialises rbenv, then loads zsh-syntax-highlighting last.

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

## macOS system defaults

```sh
./macos/defaults.sh
```

Every line is a deviation from the macOS factory defaults — key repeat and
press-and-hold, text substitution, tap to click, Finder view and search scope,
Spotlight, Dock. Anything the factory already gets right is deliberately
absent, so the file stays a diff rather than a dump.

Deliberately *not* wired into `install.conf.yaml`: `./install` is a symlink
sync meant to be re-run any time, while this mutates system state and restarts
Finder and Dock. Run it once per machine. It asks for `sudo` up front (only
`mdutil` needs it), and the keyboard, text and hotkey settings take effect on
the next login.

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

## Keeping Brewfile in sync

```sh
brew bundle dump --file=-      # print the installed state; writes nothing
brew bundle cleanup --global   # prompts, then UNINSTALLS anything not listed
```

`macos/Brewfile` is edited by hand. It is grouped by purpose, and it leaves out
the four casks `pinned-casks.sh` holds at an old version — neither survives a
`brew bundle dump --force`, which flattens the grouping and writes those four
back unpinned. Diff against `--file=-` instead. (`--global` and `--file` can't
be combined; `--file=-` alone reads the installed state and prints it.)

`cleanup` uninstalls, it doesn't list, and it counts those same four casks as
unlisted. Read its prompt before answering it.
