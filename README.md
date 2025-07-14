# super-dotfiles

A collection of configuration files for zsh, tmux, and fzf with automated installation script.

## Configuration Files

### Home Directory
- `.zshrc` - Zsh configuration with antigen, starship, zoxide, and various aliases
- `.tmux.conf` - Tmux configuration with custom keybindings and status bar
- `.fzf.zsh` - FZF configuration for zsh integration

### .config Directory
- `.config/bat/config` - Bat (better cat) configuration
- `.config/ghostty/config` - Ghostty terminal configuration
- `.config/lsd/config.yaml` - LSD (better ls) configuration
- `.config/nvim/lua/plugins/nvim-tmux-navigation.lua` - Neovim tmux navigation plugin
- `.config/nvim/lua/plugins/which.lua` - Neovim which-key configuration

## Installation

Run the installation script to set up all configuration files:

```bash
./scripts/install.sh
```

The script will:
- Create a `~/.backups` directory if it doesn't exist
- Backup existing configuration files to `~/.backups` with timestamps
- Install all configuration files to your home directory
- Check for required dependencies

## Updating

To update your configuration files, simply run the installation script again:

```bash
./scripts/install.sh
```

The script will automatically:
- Create backups of any existing files before overwriting them
- Install the latest versions from the project
- Store all backups in `~/.backups` with timestamps

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
