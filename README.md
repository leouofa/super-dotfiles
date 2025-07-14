# super-dotfiles

A collection of configuration files for zsh, tmux, and fzf with automated installation script.


## Shortcuts and Key Combinations

### Zsh Aliases
- `short` - Display zshrc content
- `ae` - Edit zshrc with nvim
- `ar` - Reload zshrc
- `todo` - Open todos file in nvim
- `cat` - Use bat instead of cat (no paging)
- `la` - List all files with lsd
- `cls` - Clear screen
- `find_large_files` - Find and sort large files
- `vi`, `vim`, `nv` - All open nvim
- `gco` - Git checkout
- `gcam` - Git commit all modified
- `gpu` - Git push
- `gs` - Git status
- `tk` - Edit tmux config
- `ta` - Attach to tmux session
- `tko` - Kill tmux server
- `mux` - Tmuxinator
- `rshell` - Restart shell

### Zsh Key Bindings
- `Ctrl+R` - FZF history search (works in both insert and command mode)
- `fbat` - FZF file selection with bat preview

### Tmux Key Bindings
- `Ctrl+A` - Prefix key (instead of Ctrl+B)
- `Ctrl+A` (double tap) - Send prefix to application
- `Ctrl+A` + `Ctrl+A` - Switch to last window
- `v` or `Ctrl+V` - Split window vertically (50% width)
- `s` or `Ctrl+S` - Split window horizontally (50% height)
- `H`, `J`, `K`, `L` - Resize panes (5 units in respective directions)
- `e` - Enable pane synchronization
- `E` - Disable pane synchronization
- `c` - Create new window in current directory
- `r` - Reload tmux config
- `Ctrl+D` - Detach client

### Neovim Tmux Navigation
- `Ctrl+H` - Navigate left (vim pane/tmux window)
- `Ctrl+J` - Navigate down (vim pane/tmux window)
- `Ctrl+K` - Navigate up (vim pane/tmux window)
- `Ctrl+L` - Navigate right (vim pane/tmux window)
- `Ctrl+\` - Navigate to previous (vim pane/tmux window)

### FZF Configuration
- `Ctrl+T` - File finder with bat preview
- `Ctrl+R` - History search
- `Ctrl+C` - Cancel fzf (cleared to do nothing)

### FZF Options
- Uses tmux popup layout
- Reverse layout with top border
- File preview with bat showing 3 lines above cursor

## Ergonomics Setup

### Remap Caps Lock to Control (macOS)
For better ergonomics and easier access to the many Ctrl key combinations in this configuration, it's highly recommended to remap Caps Lock to Control:

- Open **System Settings** 
- Go to **Keyboard** → **Keyboard Shortcuts**
- Click **Modifier Keys...** (bottom right)
- Select your keyboard from the dropdown
- Change **Caps Lock** to **Control**
- Click **OK**

This remapping will make all the Ctrl key combinations much more comfortable to use, especially for tmux navigation (`Ctrl+H/J/K/L`) and other shortcuts.

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

### Hammerspoon Configuration
For Ghostty terminal toggle functionality, install Hammerspoon via Homebrew and add the following script to your Hammerspoon configuration:

```lua
hs.hotkey.bind({"ctrl"}, "`", function()
  local ghostty = hs.application.find("Ghostty")  -- Capital G
  if ghostty and ghostty:isFrontmost() then
    ghostty:hide()
  else
    hs.application.launchOrFocus("Ghostty")
  end
end)
```

This enables `Ctrl+`` to toggle the Ghostty terminal window.

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

## Applying Changes

After installation or updates:
- **zsh**: Run `source ~/.zshrc` or restart your terminal
- **tmux**: Run `tmux source-file ~/.tmux.conf` or restart tmux
- **fzf**: Changes apply on next terminal session
- **bat**: Changes apply immediately
- **ghostty**: Restart Ghostty terminal
- **lsd**: Changes apply immediately
