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

# Configuration files to install
CONFIG_FILES=(".zshrc" ".tmux.conf" ".fzf.zsh")

# Check if all config files exist in the project
for config_file in "${CONFIG_FILES[@]}"; do
    if [[ ! -f "$PROJECT_ROOT/$config_file" ]]; then
        print_error "Could not find $config_file in the project directory."
        exit 1
    fi
done

# Install each configuration file
for config_file in "${CONFIG_FILES[@]}"; do
    print_status "Installing $config_file..."
    
    # Backup existing file if it exists
    if [[ -f "$HOME/$config_file" ]]; then
        BACKUP_FILE="$HOME/${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
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
TOOLS=("nvim" "tmux" "bat" "lsd" "fzf" "starship" "zoxide" "rbenv" "nvm" "tmux-mem-cpu-load")

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        print_success "$tool found"
    else
        print_warning "$tool not found"
        if [[ "$tool" == "tmux-mem-cpu-load" ]]; then
            print_status "To install tmux-mem-cpu-load: brew install tmux-mem-cpu-load"
        fi
    fi
done

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

# Create symlinks for easy updates (optional)
read -p "Would you like to create symlinks for easy updates? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    for config_file in "${CONFIG_FILES[@]}"; do
        if [[ ! -L "$HOME/$config_file" ]]; then
            print_status "Creating symlink for $config_file..."
            rm -f "$HOME/$config_file"
            ln -s "$PROJECT_ROOT/$config_file" "$HOME/$config_file"
            print_success "Symlink created for $config_file!"
        else
            print_status "$config_file is already a symlink"
        fi
    done
    print_success "All symlinks created! Updates to project files will be reflected immediately."
fi

print_success "Installation complete!"
print_status "To apply changes:"
print_status "  - For .zshrc: run 'source ~/.zshrc' or restart your terminal"
print_status "  - For .tmux.conf: run 'tmux source-file ~/.tmux.conf' or restart tmux"
print_status "  - For .fzf.zsh: changes will apply on next terminal session" 