# Install — Linux

Debian/Ubuntu is the primary target; Fedora and Arch notes are inline
where commands differ.

The macOS-only parts of this repo (OrbStack, Ghostty, Raycast, Rectangle,
Alt-tab, Sequel Ace) don't apply on Linux — use native alternatives. Shell
config, nvim config, git config, and the modern CLIs all work identically.

## Quick start

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sleistner/dotfiles/HEAD/install.sh)"
```

The dispatcher detects Linux and runs `install/install-linux.sh`, which
automates the parts with clean cross-distro behavior: system
prerequisites (§1), optional `chsh` to zsh, clone (§3), `./setup` (§4),
and oh-my-zsh + `zsh-autosuggestions` (§5). Idempotent.

What's **not** automated, because it's opinionated per-distro / per-desktop:

- SSH access for GitHub — [§2](#2-ssh-access-for-github-clone)
- Modern CLI toolchain (mise, starship, cargo installs, `gh`) — [§6](#6-install-the-cli-toolchain)
- Docker engine — [§7](#7-docker)
- Terminal emulator + nerd font — [§8](#8-terminal-emulator--fonts)
- First-run housekeeping (atuin, nvim, mise) — [§9](#9-first-run-housekeeping)

Finish those manually after the one-liner returns.

---

<a id="1-system-prerequisites"></a>
## 1. System prerequisites

```sh
# Debian / Ubuntu
sudo apt update
sudo apt install -y git curl zsh build-essential

# Fedora
sudo dnf install -y git curl zsh @development-tools

# Arch
sudo pacman -S --needed git curl zsh base-devel
```

Make zsh the default shell:

```sh
chsh -s "$(command -v zsh)"
```

Sign out and back in (or reboot) for the shell change to take effect.

<a id="2-ssh-access-for-github-clone"></a>
## 2. SSH access for GitHub clone

Either:

- **Use 1Password's SSH agent** — install the Linux desktop app from
  [1password.com/downloads/linux](https://1password.com/downloads/linux/),
  enable Developer → SSH agent, add your GitHub key as an Item.
- **Or generate a local key**:
  ```sh
  ssh-keygen -t ed25519 -C "$(git config --global user.email)"
  cat ~/.ssh/id_ed25519.pub  # add this to github.com/settings/ssh-keys
  ```

Skip if you plan to clone via HTTPS.

## 3. Clone the repo

```sh
mkdir -p ~/config
git clone git@github.com:sleistner/dotfiles.git ~/config/dotfiles
cd ~/config/dotfiles
```

## 4. Create the symlinks

```sh
./setup
```

Links `linked/*` into `~/.*` and `xdg/*` into `~/.config/*`. Idempotent.

## 5. Install oh-my-zsh and the one custom plugin

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" "" --unattended --keep-zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```

<a id="6-install-the-cli-toolchain"></a>
## 6. Install the CLI toolchain

The `Brewfile` in this repo is macOS-focused (GUI casks, macOS-only
formulae). On Linux, install the core tools via your distro package
manager and modern ones via their upstream binaries or `cargo`.

### 6a. Core tools from the distro repo

```sh
# Debian / Ubuntu
sudo apt install -y \
  neovim tmux tig curl wget \
  ripgrep fd-find bat fzf \
  shellcheck shfmt direnv \
  build-essential pkg-config libssl-dev

# Fedora
sudo dnf install -y \
  neovim tmux tig curl wget \
  ripgrep fd-find bat fzf \
  ShellCheck shfmt direnv \
  make pkgconf-pkg-config openssl-devel

# Arch
sudo pacman -S --needed \
  neovim tmux tig curl wget \
  ripgrep fd bat fzf \
  shellcheck shfmt direnv \
  base-devel pkgconf openssl
```

> On Debian/Ubuntu, `fd` is installed as `fdfind`. Either alias it
> (`alias fd=fdfind` in `shell/env`) or symlink:
> `mkdir -p ~/.local/bin && ln -s "$(command -v fdfind)" ~/.local/bin/fd`.

> `jq`, `htop`, and `tldr` are intentionally absent from the distro list —
> the macOS Brewfile uses the Rust replacements `jaq`, `bottom`, and
> `tealdeer` (installed via cargo below). If you want `/usr/bin/jq` as a
> fallback for scripts, add `jq` back to the apt/dnf/pacman line.

### 6b. Modern CLIs (install via upstream release or cargo)

The short path is to install `mise` and let it manage runtimes, then use
`cargo install` for Rust CLIs, or grab static binaries from release pages.

```sh
# mise — version manager for node/python/terraform/etc.
curl https://mise.run | sh
# add ~/.local/bin/mise to PATH; linked/shell/env already prepends ~/.local/bin

# starship — prompt (config at xdg/starship.toml is already symlinked)
curl -sS https://starship.rs/install.sh | sh

# Rust (enables the cargo installs below)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Rust-based CLIs referenced by this config:
cargo install --locked \
  atuin zoxide git-delta xh yazi-fm gitleaks \
  hyperfine git-absorb stylua eza \
  bottom du-dust tealdeer jaq \
  sd just difftastic procs bacon oxipng mdcat hurl

# Node-based CLIs (install via your mise-managed node):
mise install node@latest
npm install -g pnpm

# trivy — vulnerability scanner (official installer, distro-agnostic)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
  | sudo sh -s -- -b /usr/local/bin
```

> Pick either `lsd` (apt) or `eza` (cargo). Your `linked/zshrc` uses
> neither directly; aliases/functions live in `shell/env`.

### 6c. GitHub CLI

```sh
# Debian / Ubuntu
(type -p wget >/dev/null || sudo apt install -y wget) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update && sudo apt install -y gh

# Fedora
sudo dnf install -y gh

# Arch
sudo pacman -S --needed github-cli
```

<a id="7-docker"></a>
## 7. Docker

Native Linux Docker engine (no VM, no Docker Desktop needed):

```sh
# Debian / Ubuntu — follow https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"  # log out + back in to take effect

# Fedora
sudo dnf -y install docker-ce docker-ce-cli containerd.io

# Arch
sudo pacman -S --needed docker docker-compose
sudo systemctl enable --now docker
```

The sparkle `dev:https` script handles Linux: it requires the daemon to
be running (`sudo systemctl start docker`) but never tries to auto-launch
a GUI app. No code changes needed on your end.

<a id="8-terminal-emulator--fonts"></a>
## 8. Terminal emulator + fonts

macOS uses Ghostty via a `.app` cask — on Linux, download the
[Ghostty AppImage](https://github.com/ghostty-org/ghostty/releases)
or install via your distro (Ghostty has native packages on Arch,
`ghostty-git` on AUR). The config at `xdg/ghostty/config` applies.

Install a nerd font so the starship prompt glyphs render:

```sh
# Debian / Ubuntu
sudo apt install -y fonts-firacode
# or download an Iosevka nerd font release from:
# https://github.com/ryanoasis/nerd-fonts/releases
```

Set your terminal to use the nerd font in its preferences.

<a id="9-first-run-housekeeping"></a>
## 9. First-run housekeeping

- **atuin** — `atuin register -u <name> -e <email>` (or `atuin login`).
- **nvim** — launch once; lazy.nvim bootstraps and installs plugins
  from `xdg/nvim/lazy-lock.json`.
- **mise** — in any project with a `mise.toml`, run `mise install`.
- **Raycast replacement** — consider [Ulauncher](https://ulauncher.io/)
  or [Albert](https://albertlauncher.github.io/). Neither is covered
  by this repo's config.
- **Window management replacement** — `pop-shell` (GNOME),
  `kwin-bismuth` (KDE), or a tiling WM like `i3`/`sway` if you're
  going full keyboard-driven.

## What's missing vs. macOS

- OrbStack → native Docker engine (above)
- Ghostty .app → Ghostty AppImage or distro build
- Raycast → Ulauncher / Albert
- Rectangle / alt-tab → distro's native window manager
- Sequel Ace → [Beekeeper Studio](https://www.beekeeperstudio.io/) or
  [DBeaver](https://dbeaver.io/)
- 1Password GUI → available natively on Linux

Shell config, nvim config, git config, Starship prompt, and every CLI
tool you install above will work identically to the Mac setup.
