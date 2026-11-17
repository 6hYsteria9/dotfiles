# dotfiles

Minimalist configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Managed Packages

- **dunst**: Notification daemon
- **dwl**: Wayland tiling window manager (suckless-style with custom patches & config)
- **fastfetch**: Fast system information display
- **foot**: Lightweight Wayland terminal emulator
- **fuzzel**: Fast Wayland application launcher
- **nvim**: Minimalist Neovim setup
- **yambar**: Modular status panel for Wayland
- **scripts**: Utility scripts (`autostart.sh`, `yambar-bat.sh`, `notify-done`, `battery-notify.sh`)

## Installation

### 1. Clone repository
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. Stow configurations
To symlink all packages to your home directory:
```bash
stow fastfetch dunst foot fuzzel nvim yambar dwl scripts
```

Or stow individual packages as needed:
```bash
stow nvim
```

### 3. Build & Install DWL
Since `dwl` is configured at compile time:
```bash
cd ~/dwl
sudo make install
```
