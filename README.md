# dotfiles

Minimalist configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Managed Packages

- **dunst**: Notification daemon
- **dwl**: Wayland tiling window manager (suckless-style with IPC patch & Everforest theme)
- **fastfetch**: Fast system information display
- **foot**: Lightweight Wayland terminal emulator
- **fuzzel**: Fast Wayland application launcher
- **nvim**: Minimalist Neovim setup
- **somebar**: Minimalist dwl status bar with IPC protocol, Everforest theme & interactive modules
- **scripts**: Utility scripts (`autostart.sh`, `somebar-status.sh`, `somebar-wifi.sh`, `somebar-bat.sh`, `battery-notify.sh`, `notify-done`)

## Installation

### 1. Clone repository
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. Stow configurations
To symlink all packages to your home directory:
```bash
stow fastfetch dunst foot fuzzel nvim somebar dwl scripts
```

Or stow individual packages as needed:
```bash
stow somebar
```

### 3. Build & Install DWL & Somebar
Both `dwl` and `somebar` are compiled from source:

**DWL:**
```bash
cd ~/dwl
sudo make install
```

**Somebar:**
```bash
cd ~/somebar
meson setup build
ninja -C build
install -m 755 build/somebar ~/.local/bin/somebar
```
