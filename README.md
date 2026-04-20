# dotfiles

**A one-command setup for a zsh + neovim + modern-CLI workstation on macOS or Linux.**

[![ci](https://github.com/sleistner/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sleistner/dotfiles/actions/workflows/ci.yml)
![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)
![zsh](https://img.shields.io/badge/shell-zsh-1A5E2A)
![oh-my-zsh](https://img.shields.io/badge/oh--my--zsh-C25B5B?logo=ohdear)
![Starship](https://img.shields.io/badge/prompt-Starship-DD0B78?logo=starship&logoColor=white)
![Neovim](https://img.shields.io/badge/editor-Neovim-57A143?logo=neovim&logoColor=white)
![Ghostty](https://img.shields.io/badge/terminal-Ghostty-222222)
![startup ~130ms](https://img.shields.io/badge/zsh_startup-~130ms-brightgreen)

## Install

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install.sh)"
```

Paste that in a macOS Terminal or Linux shell prompt.

The script detects your OS, explains each step as it runs, and prompts before
anything with side effects (installing 1Password, changing your default shell).
It's idempotent — safe to re-run on a machine that's already set up.

Read about what it does, and what it leaves for you to do, in
**[docs/install-macos.md](./docs/install-macos.md)** or
**[docs/install-linux.md](./docs/install-linux.md)**.

## What this repo does

- Installs **Xcode CLT + Homebrew** (macOS) or distro packages (Linux) and runs
  `brew bundle` against a curated [Brewfile](./Brewfile) of ~115 formulae and
  ~15 casks. See **[TOOLS.md](./TOOLS.md)** for what's in it and why.
- Clones itself to `~/config/dotfiles` and symlinks every entry under
  [`linked/`](./linked) into `~/.<name>` and every entry under [`xdg/`](./xdg)
  into `~/.config/<name>`.
- Installs **oh-my-zsh** with `--keep-zshrc` (leaves the symlinked `.zshrc`
  untouched) and the `zsh-autosuggestions` plugin.
- Optionally installs **1Password + 1Password CLI** so SSH agent and git
  commit signing Just Work.
- Opts you into a ~130ms zsh startup with Starship prompt, sensible
  `compinit` handling, and deduped `PATH`.

## What this repo does not do

- **Not a package manager.** It delegates to Homebrew/apt/dnf/pacman and
  pins nothing beyond what's in the Brewfile.
- **No secrets, ever.** Anything that stores tokens or credentials
  (`~/.npmrc`, `~/.terraformrc`, `~/.config/gh/hosts.yml`, `.contentfulrc.json`)
  is deliberately not versioned — use 1Password or a secret manager.
- **No migration of state.** Shell history, `~/.zcompdump`, REPL histories,
  `~/Library`, and `~/.cache` stay put; this repo manages config only.
- **No GUI auto-config.** Raycast/Ghostty/OrbStack need their one-time
  accessibility perms and first-launch wizards — the install doc calls
  these out explicitly.
- **Not a framework.** There's no plugin system or per-tool install
  script — `./setup` is a single ~50-line shell loop. Add a file under
  `linked/` or `xdg/`, re-run `./setup`, done.

## Re-run after changes

Add or remove files in `linked/` or `xdg/`, then:

```sh
./setup
```

Idempotent — `ln -sfn` overwrites existing symlinks to the same target.

---

## Under the hood

### Layout

```
linked/   -> ~/.<name>          Dotfiles that tools read straight from $HOME
xdg/      -> ~/.config/<name>   XDG-aware tools that look in $XDG_CONFIG_HOME
shell/    sourced by zshrc      Shared shell env (PATH, EDITOR, locale, etc.)
install/  platform bootstrap    install-macos.sh, install-linux.sh, common.sh
```

#### linked/

Every file or directory here becomes `~/.<name>`:

| Entry                     | Symlinked to                        |
| ------------------------- | ----------------------------------- |
| `linked/zshrc`            | `~/.zshrc`                          |
| `linked/zshenv`           | `~/.zshenv`                         |
| `linked/zprofile`         | `~/.zprofile`                       |
| `linked/gitconfig`        | `~/.gitconfig`                      |
| `linked/gitignore_global` | `~/.gitignore_global`               |
| `linked/tigrc`            | `~/.tigrc`                          |
| `linked/tmux.conf`        | `~/.tmux.conf`                      |
| `linked/pryrc`            | `~/.pryrc`                          |
| `linked/bin/`             | `~/.bin/` (on PATH via `shell/env`) |

#### xdg/

By default each top-level entry is mirrored into `~/.config/<name>`, but
the behavior differs based on type:

- **Top-level file** — symlinked as a file.
  `xdg/starship.toml` → `~/.config/starship.toml`
- **Directory without `.link-as-dir` marker** — setup walks the tree and
  symlinks each file individually, so tools that write state into their
  own config dir keep ownership. Used when the repo contributes only
  some files to `~/.config/<tool>/`.
  `xdg/zed/settings.json` → `~/.config/zed/settings.json`
  (while `~/.config/zed/conversations/`, `themes/`, ... stay intact)
- **Directory with `.link-as-dir` marker** — the whole directory is
  symlinked. Used when the repo owns the entire config tree.
  `xdg/nvim/` → `~/.config/nvim/` (marker file: `xdg/nvim/.link-as-dir`)

Current contents:

| Entry                   | Mode      | Mirrored to                   |
| ----------------------- | --------- | ----------------------------- |
| `xdg/starship.toml`     | file      | `~/.config/starship.toml`     |
| `xdg/nvim/`             | whole-dir | `~/.config/nvim/`             |
| `xdg/ripgrep/ripgreprc` | file-walk | `~/.config/ripgrep/ripgreprc` |
| `xdg/ghostty/config`    | file-walk | `~/.config/ghostty/config`    |
| `xdg/mise/config.toml`  | file-walk | `~/.config/mise/config.toml`  |
| `xdg/zed/settings.json` | file-walk | `~/.config/zed/settings.json` |

#### shell/

- `shell/env` — sourced from `linked/zshrc`. Holds `PATH`, `EDITOR`,
  locale, `GOPATH`, `RIPGREP_CONFIG_PATH`, ulimit, keybindings, and
  `typeset -U path` for auto-dedupe.

### Adding a new config

1. Find out where the tool reads its config: `~/.toolrc`, `~/.toolrc.d/`,
   or `~/.config/tool/`.
2. Drop the file or directory into `linked/` (for `~/.*`) or `xdg/` (for
   `~/.config/*`). If the tool owns its config dir (writes state into
   it), keep the file shallow so the file-walk mode applies. If the repo
   owns the entire tree, `touch xdg/<tool>/.link-as-dir`.
3. Run `./setup`.

No per-tool edits to the setup script.

### Startup perf

Interactive zsh startup is ~130ms. Key tricks in `linked/zshrc` and
`shell/env`:

- Single `compinit` call (oh-my-zsh handles it; no other source should).
- `ZSH_DISABLE_COMPFIX=true` skips the compaudit security check.
- `ZSH_THEME=""` — starship renders the prompt, so oh-my-zsh doesn't
  need to load a theme only to have it overwritten.
- Plugins kept minimal: `git`, `zsh-autosuggestions`.
- `typeset -U path` auto-dedupes PATH entries across nested sourcings.
- Homebrew paths hard-coded (`/opt/homebrew/opt/<pkg>/bin`) — no
  `brew --prefix` subshells on startup.
