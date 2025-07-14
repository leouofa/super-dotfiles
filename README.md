# super-dotfiles

A collection of configuration files for zsh, tmux, and fzf with automated installation and update scripts.

## Configuration Files

### Home Directory
- `.zshrc` - Zsh configuration with antigen, starship, zoxide, and various aliases
- `.tmux.conf` - Tmux configuration with custom keybindings and status bar
- `.fzf.zsh` - FZF configuration for zsh integration

### .config Directory
- `.config/bat/config` - Bat (better cat) configuration
- `.config/ghostty/config` - Ghostty terminal configuration
- `.config/lsd/config.yaml` - LSD (better ls) configuration

## Installation

Run the installation script to set up all configuration files:

```bash
./scripts/install.sh
```

The script will:
- Backup existing configuration files
- Install all configuration files to your home directory
- Check for required dependencies
- Optionally create symlinks for automatic updates

## Updating

To update your configuration files:

```bash
./scripts/update.sh
```

The script will:
- Check for differences between project and home files
- Show you the differences
- Allow you to choose how to handle each file:
  1. Replace home file with project version
  2. Replace project file with home version
  3. Create a symlink for automatic updates
  4. Skip the file

## Dependencies

The configuration files work best with these tools installed:
- Homebrew
- nvim
- tmux
- bat
- lsd
- fzf
- starship
- zoxide
- rbenv
- nvm
- tmux-mem-cpu-load
- antigen
- ghostty (terminal emulator)

## Applying Changes

After installation or updates:
- **zsh**: Run `source ~/.zshrc` or restart your terminal
- **tmux**: Run `tmux source-file ~/.tmux.conf` or restart tmux
- **fzf**: Changes apply on next terminal session
- **bat**: Changes apply immediately
- **ghostty**: Restart Ghostty terminal
- **lsd**: Changes apply immediately
