# .dotfiles

Personal dotfiles for an Arch Linux / X11 desktop managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Stack:** bspwm · sxhkd · polybar · picom · alacritty · rofi · dunst · i3lock-color · zsh · neovim

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

### Packages

```bash
# repos
sudo pacman -S bspwm sxhkd polybar picom alacritty rofi dunst feh stow \
  xdo jq xorg-xprop xorg-xwininfo xorg-xrandr xss-lock scrot imagemagick \
  playerctl brightnessctl maim xclip xdg-user-dirs efibootmgr \
  network-manager-applet blueman redshift syncthing thunar obsidian rofimoji \
  zsh-autosuggestions zsh-autocomplete zsh-syntax-highlighting fastfetch \
  noto-fonts noto-fonts-cjk ttf-inconsolata-nerd

# AUR
yay -S i3lock-color ruby-fusuma siji-ttf
```

Fonts used by polybar/alacritty/lock screen: **JetBrainsMono Nerd Font** and **Font Awesome 6** (kept in `~/.local/share/fonts`, added to the X font path by `.xinitrc`).

---

## Structure

Each top-level directory is a Stow package that mirrors the home directory layout.

| Package | Target | Description |
|---|---|---|
| `apps/` | `~/.config/alacritty/`, `~/.config/mpv/` | Alacritty (TOML) and mpv |
| `bash/` | `~/.bashrc` | Bash shell |
| `bspwm/` | `~/.config/bspwm/bspwmrc` | WM startup: monitors, hotplug, autostart, auto-lock |
| `dunst/` | `~/.config/dunst/` | Notification daemon |
| `fusuma/` | `~/.config/fusuma/` | Touchpad gestures |
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

> **Note:** `scripts/` must be stowed for the WM to work — `bspwmrc`, `sxhkdrc`, and polybar all reference scripts in `~/bin/`. Window rules live in `~/bin/bspwm-external-rules`, not in `bspwmrc`. Logs go to `~/bin/logs/`.

---

## Submodules

| Path | Repository |
|---|---|
| `scripts/bin` | [d093w1z/linux-setup-bin-scripts](https://github.com/d093w1z/linux-setup-bin-scripts) |
| `nvim/.config/nvim/kickstart.nvim` | [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) (upstream reference; the live config is `init.lua`) |

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
| `Super + {1–8}` | Focus desktop |
| `Super + Shift + {1–8}` | Send window to desktop (and follow) |
| `Super + {t,s,f}` | Set window state: tiled / floating / fullscreen |
| `Super + m` | Toggle monocle layout |
| `Super + {_,Shift +} w` | Close / kill window (with confirmation) |
| `Super + Alt + r` | Restart bspwm |
| `Super + Alt + q` | Quit bspwm (with confirmation) |
| `Super + x` | Lock screen |
| `Super + Shift + x` | Power menu (lock, suspend, logout, Windows, reboot, shutdown) |
| `Super + Shift + Ctrl + x` | Lock and suspend |
| `Alt + Space` | Obsidian scratchpad |
| `Alt + f` | File manager (Thunar) scratchpad |
| `Print` | Screenshot to clipboard and `~/Pictures/Screenshots` |
| `Shift + Print` | Rofi screenshot applet |
| `Ctrl + {space, Shift + space, grave}` | Dunst: close / close all / history |
| `Ctrl + .` | Emoji picker (rofimoji) |

### Touchpad gestures (fusuma)

| Gesture | Action |
|---|---|
| 3-finger swipe left / right | Next / previous desktop |
| 3-finger swipe up | Toggle monocle |
| 3-finger swipe down | App launcher |
| Pinch in / out | Zoom out / in (`Ctrl + -` / `Ctrl + +`) |

Fusuma needs the user in the `input` group: `sudo gpasswd -a $USER input`, then log in again.

---

## Monitor Setup

`bspwmrc` auto-detects monitors at startup and again on every hotplug (KVM switch), via `udevadm monitor`:

- **Internal panel:** `eDP-1`. **External:** the first other connected output (`HDMI-2-2`, `DP-1`, … — the name is not hardcoded).
- **Docked:** external is primary and placed left of the laptop; desktops **1–4 on internal**, **5–8 on external**.
- **Undocked:** all 8 desktops on internal.
- The internal monitor is always ordered first, so a desktop's index matches its name (`^1` = `1` … `^8` = `8`) whether docked or not.
- Polybar runs on every active output; the **system tray is always on the internal panel** (falls back to the primary output if it's off).

---

## Lock Screen

`~/bin/lock_screen` uses **i3lock-color** over a blurred screenshot (overlay image bottom-right on the primary monitor):

- Locks automatically after **10 minutes idle** and **before suspend / lid close** (`xss-lock`, started by `bspwmrc`).
- While locked: notifications and media are paused, the screen turns off after 15s; media, volume and brightness keys still work.
- Too many failed passwords trigger PAM's `faillock` (3 failures → 10 min lockout, even for the correct password). Reset from a TTY with `faillock --user $USER --reset`.

---

## Reboot to Windows

The power menu's Windows option runs `~/bin/boot-to-windows`, which sets UEFI **BootNext** to *Windows Boot Manager* (one-time, GRUB untouched) and reboots. It needs a passwordless sudo rule for that one command (check the entry number with `efibootmgr`):

```bash
echo "$USER ALL=(root) NOPASSWD: /usr/bin/efibootmgr --bootnext 0003" \
  | sudo tee /etc/sudoers.d/boot-to-windows && sudo chmod 440 /etc/sudoers.d/boot-to-windows
```

---

## Zsh Plugins

Loaded from `/usr/share/zsh/plugins/` in this order (order is required):

1. `zsh-autosuggestions`
2. `zsh-autocomplete` (runs `compinit` itself)
3. `zsh-syntax-highlighting` ← must be last

`Ctrl + P` cycles the prompt style (git / one-line / two-line).
