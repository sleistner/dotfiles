# dotfiles

![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)
![zsh](https://img.shields.io/badge/shell-zsh-1A5E2A)
![oh-my-zsh](https://img.shields.io/badge/oh--my--zsh-C25B5B?logo=ohdear)
![Starship](https://img.shields.io/badge/prompt-Starship-DD0B78?logo=starship&logoColor=white)
![Neovim](https://img.shields.io/badge/editor-Neovim-57A143?logo=neovim&logoColor=white)
![Ghostty](https://img.shields.io/badge/terminal-Ghostty-222222)
![startup ~130ms](https://img.shields.io/badge/zsh_startup-~130ms-brightgreen)

Personal macOS config — zsh + oh-my-zsh + starship, neovim, git, tig,
ghostty, ripgrep, mise, tmux, zed.

See **[TOOLS.md](./TOOLS.md)** for a grouped reference of the important
Homebrew-installed tools and what they do.

## Install

```sh
./setup
```

Idempotent. Creates symlinks from this repo into `$HOME` and `~/.config`.
Safe to re-run after adding or removing files.

## Layout

```
linked/   -> ~/.<name>          Dotfiles that tools read straight from $HOME
xdg/      -> ~/.config/<name>   XDG-aware tools that look in $XDG_CONFIG_HOME
shell/    sourced by zshrc      Shared shell env (PATH, EDITOR, locale, etc.)
```

### linked/

Every file or directory here becomes `~/.<name>`:

| Entry                  | Symlinked to          |
| ---------------------- | --------------------- |
| `linked/zshrc`         | `~/.zshrc`            |
| `linked/zshenv`        | `~/.zshenv`           |
| `linked/zprofile`      | `~/.zprofile`         |
| `linked/gitconfig`     | `~/.gitconfig`        |
| `linked/gitignore_global` | `~/.gitignore_global` |
| `linked/tigrc`         | `~/.tigrc`            |
| `linked/tmux.conf`     | `~/.tmux.conf`        |
| `linked/pryrc`         | `~/.pryrc`            |
| `linked/bin/`          | `~/.bin/` (on PATH via `shell/env`) |

### xdg/

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

| Entry                        | Mode       | Mirrored to                         |
| ---------------------------- | ---------- | ----------------------------------- |
| `xdg/starship.toml`          | file       | `~/.config/starship.toml`           |
| `xdg/nvim/`                  | whole-dir  | `~/.config/nvim/`                   |
| `xdg/ripgrep/ripgreprc`      | file-walk  | `~/.config/ripgrep/ripgreprc`       |
| `xdg/ghostty/config`         | file-walk  | `~/.config/ghostty/config`          |
| `xdg/mise/config.toml`       | file-walk  | `~/.config/mise/config.toml`        |
| `xdg/zed/settings.json`      | file-walk  | `~/.config/zed/settings.json`       |

### shell/

- `shell/env` — sourced from `linked/zshrc`. Holds `PATH`, `EDITOR`,
  locale, `GOPATH`, `RIPGREP_CONFIG_PATH`, ulimit, keybindings, and
  `typeset -U path` for auto-dedupe.

## Adding a new config

1. Find out where the tool reads its config: `~/.toolrc`, `~/.toolrc.d/`,
   or `~/.config/tool/`.
2. Drop the file or directory into `linked/` (for `~/.*`) or `xdg/` (for
   `~/.config/*`). If the tool owns its config dir (writes state into
   it), keep the file shallow so the file-walk mode applies. If the repo
   owns the entire tree, `touch xdg/<tool>/.link-as-dir`.
3. Run `./setup`.

No per-tool edits to the setup script.

## Not versioned (by design)

- Anything with secrets — `~/.npmrc`, `~/.terraformrc`,
  `~/.config/gh/hosts.yml`, `~/.contentfulrc.json`, etc. Use 1Password or
  a secret manager; keep templates only.
- Tool state and history — shell history, `~/.zcompdump`, `~/.viminfo`,
  `~/.lesshst`, REPL histories, etc.
- App caches — `~/.cache`, `~/Library`.

## Startup perf

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
