# Tools

Brief reference for the important tools installed via Homebrew (`Brewfile`).
Only user-facing tools are listed — transitive deps (icu, harfbuzz, etc.)
are omitted.

## Shell & prompt

| Tool | What it does |
| --- | --- |
| **zsh** | Shell (configured via oh-my-zsh). |
| **oh-my-zsh** | Plugin framework for zsh. Minimal plugin set: `git`, `zsh-autosuggestions`. |
| **starship** | Cross-shell prompt. Config: `xdg/starship.toml`. |
| **zsh-autosuggestions** | Greys out history-based completion as you type; `→` to accept. |
| **zsh-syntax-highlighting** | Live colorizes command line (green = valid, red = not found). |
| **atuin** | Sqlite-backed shell history with search UI. Owns `ctrl-R`. Optional cross-machine sync. |
| **direnv** | Auto-loads per-directory `.envrc` files (env vars, PATH additions). |
| **mise** | Version manager for node/terraform/etc — `asdf`/`nvm`/`rbenv` replacement. Config: `xdg/mise/config.toml`. |

## Search & filesystem navigation

| Tool | What it does |
| --- | --- |
| **ripgrep** (`rg`) | Fast recursive grep. Config: `xdg/ripgrep/ripgreprc`. |
| **fd** | Fast `find` alternative with saner defaults. |
| **fzf** | Fuzzy finder. Keybindings: `ctrl-T` (files), `alt-C` (cd), `**<tab>` (fuzzy). |
| **zoxide** (`z`) | Smart `cd` that learns frequent dirs. `z foo` jumps to the best match. |
| **yazi** (`y`) | Rust `ranger`-style TUI file manager. `y` wrapper cd's the shell to yazi's last directory. |
| **lsd** | `ls` with icons and colors. |
| **bat** | `cat` with syntax highlighting and git integration. |
| **tree** | Directory tree view. |

## Git

| Tool | What it does |
| --- | --- |
| **git** | Core. Config: `linked/gitconfig` (includes delta as pager, zdiff3 conflicts, autosquash). |
| **gh** | GitHub CLI (PRs, issues, releases, actions). |
| **git-delta** | Syntax-highlighted diff pager. |
| **git-absorb** | Auto-creates `fixup!` commits for staged hunks. Pairs with `rebase.autosquash = true`. |
| **lazygit** | Full-featured TUI — stage, commit, rebase, cherry-pick interactively. |
| **tig** | TUI log/diff viewer. Config: `linked/tigrc`. |
| **gitleaks** | Scan repos for accidentally committed secrets. |

## Editors

| Tool | What it does |
| --- | --- |
| **neovim** | Primary editor. Config: `xdg/nvim/` (NvChad + lazy.nvim). |
| **tree-sitter-cli** (`tree-sitter`) | CLI used by nvim-treesitter's main branch to compile parsers from grammars. Not used interactively. |
| **zed** (cask) | GUI editor. Config: `xdg/zed/settings.json`. |

## HTTP & network

| Tool | What it does |
| --- | --- |
| **curl** | The default. |
| **xh** | User-friendly HTTP client (JSON bodies, colorized output); Rust httpie replacement. |
| **wget** | File download. |
| **mkcert** | Generate locally-trusted TLS certs for dev. |
| **testssl** | Audit TLS config of a server. |
| **speedtest-cli** | CLI speedtest.net. |
| **wrk** | HTTP benchmarking tool — high-load request generator. |
| **hurl** | HTTP tests as plain-text files — versionable, scriptable, CI-friendly. |
| **dnsmasq** | Local DNS resolver (e.g. `*.local` → `127.0.0.1` for dev). |

## Data / JSON / YAML / SQL

| Tool | What it does |
| --- | --- |
| **jaq** (`jaq`) | Rust jq clone — jq-compatible syntax, faster. Aliased to `jq` in zshrc. |
| **yq** | YAML processor (jq-like syntax). |
| **dasel** | Query/modify JSON/YAML/TOML/XML with a single tool. |
| **mysql-client** | MySQL CLI. |
| **postgresql@14** | Postgres server + `psql`. |
| **sequel-ace** (cask) | MySQL GUI. |

## Containers & orchestration

Primary runtime: **Colima** (Containers on Lima). The `docker` CLI is the
standalone Homebrew client (`brew "docker"`), and the engine runs in a Lima
VM started with `colima start`. The `zprofile` points `DOCKER_HOST` at
`~/.colima/default/docker.sock` once Colima has run at least once. Confirm
anytime with `colima status`, `docker context show`, or `docker info | grep Name`.

| Tool | What it does |
| --- | --- |
| **colima** | Primary runtime. Docker-compatible engine in a Lima VM for macOS. Start/stop with `colima start` / `colima stop`; inspect with `colima status`. Autostarts at login via `brew services` (`restart_service: :changed` in the Brewfile); toggle with `colima-autostart` / `colima-autostart off`. |
| **docker** | The docker CLI client. Talks to Colima's engine over `DOCKER_HOST`. |
| **docker-buildx** | BuildKit-backed `docker buildx` builds (multi-platform, cache). |
| **docker-credential-helper** | Provides `docker-credential-osxkeychain` so `docker login` stores registry creds in the macOS Keychain (OrbStack/Docker Desktop used to supply this). |
| **docker-compose** | Multi-container orchestration (`docker compose up`). Talks to whichever runtime owns the active context. |
| **dive** | Interactively explore the layers of a Docker image. |
| **lazydocker** | TUI for docker/compose (containers, logs, stats). |
| **podman**, **podman-compose**, **podman-tui**, **podman-desktop** | Installed but idle — alternative OSS runtime + tooling. Candidates for removal unless you use rootless/OSS containers specifically. |

## Cloud & devops

| Tool | What it does |
| --- | --- |
| **azure-cli** (`az`) | Azure management. |
| **azcopy** | High-perf file transfer to/from Azure Storage. |
| **azure-functions-core-tools@4** | Local Azure Functions dev. |
| **azd** | Azure Developer CLI (deploy templates). |
| **cargo-lambda** | Build + deploy AWS Lambda functions in Rust. |
| **contentful-cli** | Contentful (headless CMS) CLI — manage spaces, migrations, content. |

## Languages & package managers

| Tool | What it does |
| --- | --- |
| **node** | JavaScript runtime (primarily via mise). |
| **pnpm** | Fast disk-efficient npm alternative. |
| **uv** | Modern Python package + env + version manager (replaces pip/pipenv/pyenv). |
| **python@3.13** | Needed as a dep of other brews (azure-cli, podman-compose, speedtest-cli). |

## Security & secrets

| Tool | What it does |
| --- | --- |
| **gnupg** (`gpg`) | Encryption/signing (used by some tools even though git signs via SSH/1Password). |
| **gopass** | GPG-encrypted password manager (drop-in successor to `pass`). |
| **1password-cli** (`op`) | 1Password CLI. |
| **gitleaks** | See Git section. |
| **trivy** | Vulnerability scanner — container images, filesystems, IaC (Terraform/k8s), SBOMs. |

## Code quality / formatters / linters

| Tool | What it does |
| --- | --- |
| **shellcheck** | Shell script linter. |
| **shfmt** | Shell script formatter. |
| **stylua** | Lua formatter (used by nvim config). |
| **yamllint** | YAML linter. |

## System monitoring & utilities

| Tool | What it does |
| --- | --- |
| **bottom** (`btm`) | Rust `top`/`htop` replacement — TUI system monitor with CPU/mem/net/disk/process graphs. |
| **dust** | Rust `du` replacement — tree view with visual size bars. |
| **coreutils** | GNU versions of core Unix tools (prefix with `g`: `gls`, `gdate`, …). |
| **tmux** | Terminal multiplexer. |
| **hyperfine** | Statistical CLI benchmarking — `time` with warmup runs and variance. |
| **tealdeer** (`tldr`) | Rust tldr client — fast cached man-page examples. |
| **pv** | Pipe viewer — progress bar on pipes. |
| **mdcat** | Rust markdown renderer — inline images in kitty/wezterm/ghostty. Used by `dotctl tools`. |
| **procs** | Rust `ps` replacement — colorized, tree view, saner defaults. |
| **sd** | Rust `sed` replacement — intuitive find/replace syntax. |
| **just** | Rust command runner — cleaner `make` replacement for project scripts. |
| **difftastic** (`difft`) | Syntax-aware structural diff. Wire up as `GIT_EXTERNAL_DIFF`. |
| **bacon** | Rust background code checker — `cargo-watch` successor. |

## Image & media

Used by Sparkle project and general image optimization.

| Tool | What it does |
| --- | --- |
| **imagemagick** | Image conversion/manipulation (`convert`, `magick`). |
| **ffmpeg** | Audio/video transcoding. |
| **ghostscript** | PostScript + PDF processing. |
| **poppler** | PDF rendering and CLI utils (`pdfinfo`, `pdftotext`). |
| **pngcrush**, **pngquant**, **optipng** | PNG optimization. |
| **oxipng** | Rust PNG optimizer — replaces optipng/pngcrush with one tool. |
| **jpegoptim**, **jhead** | JPEG optimization / EXIF. |
| **gifsicle** | GIF optimization. |
| **advancecomp** | Deflate-based recompression. |
| **tesseract** | OCR engine. |
| **imageoptim** (cask) | GUI that fronts most of the above. |

## Fonts

| Cask | Notes |
| --- | --- |
| **font-iosevka** | Primary coding font. |
| **font-inconsolata-nerd-font** | With glyph icons for status lines. |
| **font-0xproto-nerd-font** | Alternative coding font with icon glyphs. |

## Productivity apps (casks)

| Tool | What it does |
| --- | --- |
| **raycast** | Spotlight replacement with plugins (window management, clipboard, snippets, AI). |
| **alt-tab** | Windows-style alt-tab (shows windows, not apps). |
| **rectangle** | Keyboard-driven window snapping. |
| **ghostty** | Terminal emulator. Config: `xdg/ghostty/config`. |
| **copilot-cli** | GitHub Copilot in the terminal. |
| **codex** | OpenAI's CLI coding agent. |
| **mas** | Mac App Store CLI (so Brewfile can include App Store apps). |

## Fetch-based utilities

| Tool | What it does |
| --- | --- |
| **blueutil** | Bluetooth control from CLI. |
| **xclip** | Clipboard helper (not strictly needed on macOS; `pbcopy`/`pbpaste` is built in). |
