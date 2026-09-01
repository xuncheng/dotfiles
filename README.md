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
| `dotfiles-private/` | private git submodule: machine-local, non-public config          |
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
  initialises rbenv, then loads zsh-syntax-highlighting last.

Add new shell config as a file in `config/zsh/scripts/` — it is picked up
automatically, no `source` line needed. Syntax highlighting must stay last in
`.zshrc`, since it has to wrap widgets defined by everything before it.

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
friends are pretty-log aliases implemented in `git/.githelpers`. `git div` and
`git gn` shell out to `bin/git-divergence` and `bin/git-goodness`.

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

The `private` link is guarded by an `if:` in `install.conf.yaml`, so a machine
without access to the private repo installs everything else and skips it,
instead of failing. `install.conf.yaml` inits submodules _before_ the link
step, so a fresh clone is fully set up in a single `./install` run.

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

Every line is a deviation from the macOS factory defaults — press-and-hold,
text substitution, tap to click, Finder view and search scope, Spotlight,
Dock. Anything the factory already gets right is deliberately
absent, so the file stays a diff rather than a dump.

Deliberately _not_ wired into `install.conf.yaml`: `./install` is a symlink
sync meant to be re-run any time, while this mutates system state and restarts
Finder and Dock. It asks for `sudo` up front (only
`mdutil` needs it), and the keyboard, text and hotkey settings take effect on
the next login.
