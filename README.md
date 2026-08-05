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
- **No GUI auto-config.** Raycast/Ghostty need their one-time
  accessibility perms and first-launch wizards, and Colima needs a one-time
  `colima start` — the install doc calls these out explicitly.
- **Not a framework.** There's no plugin system or per-tool install
  script — `./setup` is a single ~50-line shell loop. Add a file under
  `linked/` or `xdg/`, re-run `./setup`, done.

## Re-run after changes

Add or remove files in `linked/` or `xdg/`, then:

```sh
./setup
```

Idempotent — `ln -sfn` overwrites existing symlinks to the same target.

## Manage with `dotctl`

`dotctl` is the management CLI for this repo — a git-style dispatcher that
runs `dotctl-<cmd>` from `linked/bin/`. Single namespaced entry point, so
generic names like `doctor` don't collide with tools on PATH (notably
Graphviz's `dot`).

```sh
dotctl              # list commands
dotctl update       # pull + brew bundle + setup (add -u to brew upgrade too)
dotctl doctor       # health-check Brewfile ↔ installed ↔ docs
dotctl tools        # render the grouped TOOLS.md reference
```

### `dotctl update`

Brings a machine back in line with the repo. Runs, in order:

1. `git pull --ff-only` in the repo (skipped safely if there are
   uncommitted changes or no upstream — nothing gets clobbered).
2. `brew bundle install` — installs anything missing from the Brewfile.
3. `./setup` — re-links new entries in `linked/` or `xdg/`.
4. `brew upgrade` — **opt-in only**, with `-u` / `--upgrade`.

Any failing step aborts with a non-zero exit; the default (no `-u`) is
deliberately conservative so routine updates don't silently pull in
major-version bumps of every Homebrew formula.

```sh
dotctl update        # pull + bundle + setup
dotctl update -u     # also `brew upgrade`
```

### `dotctl doctor`

Catches drift between the Brewfile, what's installed, and the docs:

1. **`brew bundle check`** — splits drift into:
   - **missing** (FAIL) — formula/cask/tap not installed.
   - **outdated** (warn, non-fatal) — installed but `brew upgrade` would
     bump it. Routine world drift, not repo drift.
2. **Brewfile ↔ TOOLS.md** — every user-facing formula is documented
   (build/transitive deps are allow-listed in the script).
3. **Brewfile ↔ `install-linux.md`** — every Rust CLI in the Brewfile
   has a matching entry in the `cargo install` block of the Linux guide.

Failing checks collect **runnable fix commands** at the end. On a tty,
you can select one by number, `a` for all, or Enter to skip. In CI the
prompt is suppressed. Exit code is 0 when only warnings fire, non-zero
on any FAIL — CI stays green on outdated packages, red on genuine drift.

### `dotctl tools`

An fzf picker over every tool in [TOOLS.md](./TOOLS.md), with the entry
(and its `tldr` page, once `tldr --update` has populated the cache) in a
preview pane:

```sh
dotctl tools                   # picker
dotctl tools htop              # picker, pre-seeded with a query
dotctl tools --all             # the full reference
dotctl tools --info bottom     # one tool's entry
dotctl tools --json            # every tool as JSON
dotctl tools -h                # help + section list
```

**Enter puts the command on your next prompt, unrun**, so you can add
arguments before running it. Searching `top` and pressing Enter leaves
you at `❯ btm`. That needs zsh's `print -z`, which only the parent shell
can do, so `linked/zshrc` wraps `dotctl` the same way it wraps `yazi`
as `y`. Without the wrapper the picker just prints the command.

You get the command, not the formula name: `ripgrep` hands back `rg`,
`tealdeer` hands back `tldr`.

### How the search picks matches

You can find a tool by what it replaces — `htop` finds `bottom`, `nvm`
finds `mise`, `make` finds `just`. TOOLS.md already names predecessors
in backticks, and those are indexed as the tool's aliases.

Matching is on **word starts**, not fuzzy. fzf's own matcher accepts any
scattered subsequence, so `top` matched `Auto-creates fixup!` and
returned 48 of 110 tools; it now returns 1. Word starts also keep
`desktop` and `Start/stop` out of that result while still letting a
half-typed `monit` find `bottom`. Every word in a multi-word query has
to match.

Results come back in bands, best first:

| Band | Matches                            | `top` hits          |
| ---- | ---------------------------------- | ------------------- |
| 0    | the name, whole word               | —                   |
| 1    | an alias or a backticked tool       | `bottom` (``` `top`/`htop` ```) |
| 2    | a word in either, starting with it  | —                   |
| 3    | a description word starting with it | —                   |

Sections are deliberately not matched. One string is shared by every
tool in a group, so including it ranked `tmux` and `pv` above `bottom`
for a search of `monitor`.

Without a tty the picker is skipped and you get raw markdown, so
`dotctl tools | grep` and `dotctl tools --json` stay scriptable.

### Adding a subcommand

Drop an executable `dotctl-<name>` into `linked/bin/`. The dispatcher
picks it up automatically — no edits to `dotctl` itself.

## Run `dotctl` from Raycast

[`raycast/`](./raycast) has two halves, because Raycast offers two very
different extension points and `dotctl` needs both.

### `raycast/scripts/` — the action commands

[Script commands](https://github.com/raycast/script-commands): plain
bash, no build step. One-time setup — Raycast keeps script directories
in its own database, so `./setup` can't symlink this in:

**Raycast → Settings → Extensions → Script Commands → Add Directories** →
pick `~/config/dotfiles/raycast/scripts`.

| Command                      | Runs                  | Where               |
| ---------------------------- | --------------------- | ------------------- |
| 🩺 Dotfiles Doctor           | `dotctl doctor`       | Raycast output view |
| ✈️ Dotfiles Preflight        | `dotctl preflight -n` | Raycast output view |
| 🧹 Dotfiles Preflight Fix    | `dotctl preflight`    | new Ghostty window  |
| ⬆️ Dotfiles Update           | `dotctl update`       | new Ghostty window  |
| ⏫ Dotfiles Update + Upgrade | `dotctl update -u`    | new Ghostty window  |

The read-only commands render inside Raycast. The three that prompt per
item, run long, or hit a sudo password for cask installs open a Ghostty
window instead and hold it until you press a key — answering a prompt
inside Raycast's output view isn't possible.

Two details the scripts handle, both because Raycast launches them from
launchd rather than a shell:

- `raycast/scripts/.lib.sh` rebuilds `PATH` (`~/.bin`, Homebrew, cargo)
  and holds the Ghostty launcher. Hidden, so Raycast's scan skips it.
- Doctor exits non-zero on drift; its wrapper swallows that so Raycast
  renders the report instead of an error. The CLI exit code is unchanged.

### `raycast/extension/` — the tools browser

Script commands can only emit text, so browsing tools is a real
extension: a searchable list, grouped by section, with the entry in a
detail pane.

```sh
cd raycast/extension && npm install && npm run dev
```

That registers **Browse Dotfiles Tools** under Raycast's *Development*
section. Leave `npm run dev` running only while editing it.

It shells out to `dotctl tools --json`, so TOOLS.md stays the single
source of truth and the markdown parser is not reimplemented in
TypeScript. Point the command's `Dotfiles Repo` preference elsewhere if
the checkout isn't at `~/config/dotfiles`.

Raycast's built-in list filtering is fuzzy in the same way fzf's is, so
it's turned off (`filtering={false}`) and `src/search.ts` applies the
band ranking above. Enter pastes the command into whatever app you came
from — the Raycast equivalent of landing it on your prompt.

`search.ts` and the awk in `dotctl-tools` are two implementations of one
ranking, so they can drift. To check them:

```sh
cd raycast/extension
npx esbuild src/search.ts --bundle --platform=node --format=cjs --outfile=/tmp/search.cjs
# then diff search(q, tools) against `dotctl tools --search q` per query
```

`npm run lint` reports `Invalid author` — that check resolves the
`author` field against the Raycast store's user API, which a local
extension has no entry in. `npm run build` and `npm run dev` are
unaffected.

---

## Under the hood

### Layout

```
linked/   -> ~/.<name>          Dotfiles that tools read straight from $HOME
xdg/      -> ~/.config/<name>   XDG-aware tools that look in $XDG_CONFIG_HOME
shell/    sourced by zshrc      Shared shell env (PATH, EDITOR, locale, etc.)
install/  platform bootstrap    install-macos.sh, install-linux.sh, common.sh
raycast/  added in Raycast UI   Script commands + tools-browser extension (macOS)
```

#### linked/

Every file or directory here becomes `~/.<name>`:

| Entry                     | Symlinked to                        |
| ------------------------- | ----------------------------------- |
| `linked/zshrc`            | `~/.zshrc`                          |
| `linked/zshenv`           | `~/.zshenv`                         |
| `linked/zprofile`         | `~/.zprofile`                       |
| `linked/gitconfig`        | `~/.gitconfig` (includes `~/.gitconfig.local` for identity) |
| `linked/gitignore_global` | `~/.gitignore_global`               |
| `linked/tigrc`            | `~/.tigrc`                          |
| `linked/tmux.conf`        | `~/.tmux.conf`                      |
| `linked/pryrc`            | `~/.pryrc`                          |
| `linked/bin/`             | `~/.bin/` (on PATH via `shell/env`, hosts `dotctl` + subcommands) |

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

### Per-machine git identity

`linked/gitconfig` is shared across machines and intentionally **does not**
contain `[user]`, `[github]`, or the 1Password SSH-signing program path.
Those live in `~/.gitconfig.local`, layered in via:

```gitconfig
[include]
    path = ~/.gitconfig.local
```

On first run, `./setup` copies
[`install/gitconfig.local.example`](./install/gitconfig.local.example)
to `~/.gitconfig.local` if it doesn't already exist. Edit it to set
name, email, signing key, and (on macOS/Linux respectively) the
`gpg.ssh.program` path. Existing files are never overwritten. Git
silently ignores the include if the file is absent.

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
