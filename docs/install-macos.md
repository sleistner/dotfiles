# Install — macOS

Step-by-step fresh-Mac setup. Run these in order; each step assumes the
previous one completed successfully.

## 1. Xcode Command Line Tools

Installs `git`, `make`, and the compiler toolchain Homebrew depends on.

```sh
xcode-select --install
```

Wait for the dialog-box install to finish (a few minutes).

## 2. Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After it finishes, Homebrew prints two lines to add its `shellenv` to
your profile — you can run them, but the dotfiles' `linked/zprofile`
handles this for you after step 5.

## 3. 1Password (optional)

This config includes hooks for the 1Password SSH agent and SSH-based
git commit signing (see `linked/gitconfig` and `linked/zshrc`). Both
degrade gracefully when 1Password isn't installed:

- `linked/zshrc` only sets `SSH_AUTH_SOCK` when 1Password's agent
  socket actually exists.
- `linked/gitconfig`'s SSH-signing block is inert unless 1Password is
  running — you'll see "error: cannot spawn op-ssh-sign" on commit,
  which is your cue to either install 1Password or remove the
  `[commit] gpgsign = true` / `[gpg "ssh"]` blocks from
  `linked/gitconfig` for your fork.

If you use 1Password, install it **before** cloning so `git clone
git@github.com:...` works via its agent:

```sh
brew install --cask 1password 1password-cli
```

Open 1Password → Settings → Developer → enable "Use the SSH agent". Add
your GitHub SSH key as an Item if it isn't there yet.

If you don't use 1Password, generate a standard key instead:

```sh
ssh-keygen -t ed25519 -C "your@email"
cat ~/.ssh/id_ed25519.pub  # add to github.com/settings/ssh-keys
```

Or skip SSH entirely and clone via HTTPS in the next step.

## 4. Clone the repo

```sh
mkdir -p ~/config
git clone git@github.com:sleistner/dotfiles.git ~/config/dotfiles
cd ~/config/dotfiles
```

## 5. Create the symlinks

```sh
./setup
```

Links `linked/*` into `~/.*` and `xdg/*` into `~/.config/*`. Idempotent
— safe to re-run after adding, renaming, or removing files.

## 6. Install everything from the Brewfile

```sh
brew bundle --file=Brewfile
```

Installs ~115 formulae and ~15 casks: zsh plugins, CLIs, fonts, GUI apps
(OrbStack, Ghostty, Raycast, Zed, etc.). Takes 10–20 minutes on first
run.

## 7. Open a fresh shell

Quit your terminal and reopen it so `~/.zshrc` runs from scratch with
the new symlinks and every brew-installed tool on `PATH`.

## 8. Install oh-my-zsh and the one custom plugin

```sh
# oh-my-zsh — installer will notice ~/.zshrc exists; --keep-zshrc keeps
#             the symlinked rc untouched.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# zsh-autosuggestions (listed in plugins=(git zsh-autosuggestions))
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```

## 9. First-run housekeeping

One-time actions after the core install.

- **OrbStack** — launch once; it sets up the docker socket and the
  `orbstack` docker context. Verify with `docker context show`.
- **Ghostty** — launch and grant accessibility perms. Brewfile fonts
  are already available.
- **Raycast** — launch, run the setup wizard, grant accessibility
  perms. Optionally rebind ⌘-space in its settings.
- **Rust** (only if you work in Rust): `curl --proto '=https'
  --tlsv1.2 -sSf https://sh.rustup.rs | sh` — creates `~/.cargo/env`,
  which `linked/zshenv` already sources.
- **atuin** (shell history sync) — `atuin register -u <name> -e <email>`
  for cross-machine sync, or `atuin login` if already registered. Skip
  for local-only mode.
- **nvim** — launch `nvim` once; lazy.nvim bootstraps plugins from
  `xdg/nvim/lazy-lock.json`.
- **mise** — run `mise install` in any project with a `mise.toml` to
  fetch the pinned toolchains.

Done. `zsh` startup should be ~150ms. Run `tools` for the grouped CLI
reference, or `tools -h` for filter usage.

## Re-run after changes

Add or remove files in `linked/` or `xdg/`, then:

```sh
./setup
```
