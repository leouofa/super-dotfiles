#!/bin/bash

# super-dotfiles installation script
# This script installs the .zshrc configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

print_status "Starting super-dotfiles installation..."

# Check if we're in the right directory
if [[ ! -f "$PROJECT_ROOT/README.md" ]]; then
    print_error "Could not find project root. Please run this script from the super-dotfiles directory."
    exit 1
fi

# Configuration files to install (home directory)
HOME_CONFIG_FILES=(".zshrc" ".tmux.conf" ".fzf.zsh")

# Configuration files to install (.config directory)
CONFIG_DIR_FILES=(
    ".config/bat/config"
    ".config/ghostty/config"
    ".config/lsd/config.yaml"
    ".config/nvim/lua/plugins/nvim-tmux-navigation.lua"
    ".config/nvim/lua/plugins/which.lua"
)

# Check if all config files exist in the project
for config_file in "${HOME_CONFIG_FILES[@]}"; do
    if [[ ! -f "$PROJECT_ROOT/$config_file" ]]; then
        print_error "Could not find $config_file in the project directory."
        exit 1
    fi
done

for config_file in "${CONFIG_DIR_FILES[@]}"; do
    if [[ ! -f "$PROJECT_ROOT/$config_file" ]]; then
        print_error "Could not find $config_file in the project directory."
        exit 1
    fi
done

# Create .backups directory if it doesn't exist
BACKUP_DIR="$HOME/.backups"
if [[ ! -d "$BACKUP_DIR" ]]; then
    print_status "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# Install each home directory configuration file
for config_file in "${HOME_CONFIG_FILES[@]}"; do
    print_status "Installing $config_file..."
    
    # Backup existing file if it exists
    if [[ -f "$HOME/$config_file" ]]; then
        BACKUP_FILE="$BACKUP_DIR/${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backing up existing $config_file to $BACKUP_FILE"
        cp "$HOME/$config_file" "$BACKUP_FILE"
        print_success "Backup created: $BACKUP_FILE"
    fi
    
    # Install the file
    cp "$PROJECT_ROOT/$config_file" "$HOME/$config_file"
    print_success "$config_file installed successfully!"
done

# Install each .config directory configuration file
for config_file in "${CONFIG_DIR_FILES[@]}"; do
    print_status "Installing $config_file..."
    
    # Create .config directory if it doesn't exist
    CONFIG_DIR="$HOME/$(dirname "$config_file")"
    if [[ ! -d "$CONFIG_DIR" ]]; then
        print_status "Creating directory: $CONFIG_DIR"
        mkdir -p "$CONFIG_DIR"
    fi
    
    # Backup existing file if it exists
    if [[ -f "$HOME/$config_file" ]]; then
        BACKUP_FILE="$BACKUP_DIR/${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backing up existing $config_file to $BACKUP_FILE"
        cp "$HOME/$config_file" "$BACKUP_FILE"
        print_success "Backup created: $BACKUP_FILE"
    fi
    
    # Install the file
    cp "$PROJECT_ROOT/$config_file" "$HOME/$config_file"
    print_success "$config_file installed successfully!"
done

# Check for required dependencies
print_status "Checking for required dependencies..."

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Some features may not work properly."
    print_status "To install Homebrew, visit: https://brew.sh"
else
    print_success "Homebrew found"
fi

# Check for common tools
TOOLS=("nvim" "tmux" "bat" "lsd" "fzf" "starship" "zoxide" "rbenv" "nvm" "tmux-mem-cpu-load" "zsh-autosuggestions")

# Tools that can be installed via Homebrew
BREW_TOOLS=("nvim" "tmux" "bat" "lsd" "fzf" "starship" "zoxide" "rbenv" "nvm" "tmux-mem-cpu-load" "zsh-autosuggestions")

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        print_success "$tool found"
    else
        print_warning "$tool not found"
        if [[ " ${BREW_TOOLS[*]} " =~ " ${tool} " ]]; then
            print_status "To install $tool: brew install $tool"
        fi
    fi
done

# Check for ghostty (terminal emulator)
if command -v ghostty &> /dev/null; then
    print_success "ghostty found"
else
    print_warning "ghostty not found"
    print_status "To install ghostty: brew install --cask ghostty"
fi

# Check for hammerspoon
if command -v hs &> /dev/null; then
    print_success "hammerspoon found"
else
    print_warning "hammerspoon not found"
    print_status "To install hammerspoon: brew install --cask hammerspoon"
    print_status "Note: Hammerspoon is required for Ghostty terminal toggle functionality"
fi

# Check for antigen
if [[ -f "$HOMEBREW_PREFIX/share/antigen/antigen.zsh" ]]; then
    print_success "antigen found"
else
    print_warning "antigen not found. Installing..."
    if command -v brew &> /dev/null; then
        brew install antigen
        print_success "antigen installed"
    else
        print_error "Cannot install antigen without Homebrew"
    fi
fi



print_success "Installation complete!"
print_status "To apply changes:"
print_status "  - For .zshrc: run 'source ~/.zshrc' or restart your terminal"
print_status "  - For .tmux.conf: run 'tmux source-file ~/.tmux.conf' or restart tmux"
print_status "  - For .fzf.zsh: changes will apply on next terminal session" 