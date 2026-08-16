# .dotfiles

Personal dotfiles for an Arch Linux / X11 desktop managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Stack:** bspwm · sxhkd · polybar · picom · alacritty · rofi · dunst · zsh · neovim

---

## Installation

```bash
git clone --recurse-submodules https://github.com/d093w1z/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` runs `stow` on every top-level directory, symlinking configs into `$HOME`.

### Manual / per-package

```bash
stow zsh          # apply a single package
stow -D zsh       # remove symlinks for a package
stow -n zsh       # dry-run preview
```

---

## Structure

Each top-level directory is a Stow package that mirrors the home directory layout.

| Package | Target | Description |
|---|---|---|
| `apps/` | `~/.config/alacritty/`, `~/.config/mpv/` | Alacritty (TOML) and mpv |
| `bash/` | `~/.bashrc` | Bash shell |
| `bspwm/` | `~/.config/bspwm/bspwmrc` | WM startup: monitors, rules, autostart |
| `dunst/` | `~/.config/dunst/` | Notification daemon |
| `git/` | `~/.gitconfig` | Git configuration |
| `nvim/` | `~/.config/nvim/` | Neovim with lazy.nvim (kickstart.nvim base) |
| `picom/` | `~/.config/picom/picom.conf` | Compositor (GLX backend) |
| `polybar/` | `~/.config/polybar/config.ini` | Status bar (bottom, dark theme) |
| `redshift/` | `~/.config/redshift/` | Blue light filter |
| `rofi/` | `~/.config/rofi/` | Launcher, window switcher, power menu |
| `scripts/` | `~/bin/` | Shell utility scripts (git submodule) |
| `sxhkd/` | `~/.config/sxhkd/sxhkdrc` | Keyboard shortcuts |
| `x11/` | `~/.xinitrc` | X11 session init |
| `zsh/` | `~/.zshrc` | Zsh with git prompt and plugins |

> **Note:** `scripts/` must be stowed for the WM to work — `bspwmrc`, `sxhkdrc`, and polybar all reference scripts in `~/bin/`.

---

## Submodules

| Path | Repository |
|---|---|
| `scripts/bin` | [d093w1z/linux-setup-bin-scripts](https://github.com/d093w1z/linux-setup-bin-scripts) |
| `nvim/.config/nvim/kickstart.nvim` | [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) |

```bash
# Initialize after a plain clone
git submodule update --init --recursive

# Update submodules to latest upstream
git submodule update --remote
```

---

## Key Bindings (sxhkd)

| Binding | Action |
|---|---|
| `Super + Return` | Open Alacritty |
| `Super + Space` | Rofi app launcher |
| `Super + Tab` | Rofi window switcher |
| `Super + Escape` | Reload sxhkd config |
| `Super + {h,j,k,l}` | Focus window (vim directions) |
| `Super + Shift + {h,j,k,l}` | Swap window |
| `Super + {1–9}` | Focus desktop |
| `Super + Shift + {1–9}` | Send window to desktop |
| `Super + {t,s,f}` | Set window state: tiled / floating / fullscreen |
| `Super + m` | Toggle monocle layout |
| `Super + Alt + r` | Restart bspwm |
| `Super + Alt + q` | Quit bspwm |
| `Super + x` | Lock screen |
| `Super + Shift + x` | Power menu |
| `Alt + Space` | Obsidian scratchpad |
| `Alt + f` | File manager (Thunar) scratchpad |
| `Print` | Screenshot to clipboard |
| `Shift + Print` | Rofi screenshot applet |

---

## Monitor Setup

The `bspwmrc` startup script auto-detects monitors:

- **Dual monitor** (`HDMI-1` + `eDP-1`): desktops 1–4 on external (1920×1080 @ 120Hz, left), desktops 5–8 on internal.
- **Single monitor** (`eDP-1` only): all 8 desktops on internal.

---

## Zsh Plugins

Loaded from `/usr/share/zsh/plugins/` in this order (order is required):

1. `zsh-autosuggestions`
2. `zsh-autocomplete`
3. `zsh-syntax-highlighting` ← must be last
