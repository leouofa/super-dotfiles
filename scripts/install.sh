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

# Check if .zshrc exists in the project
if [[ ! -f "$PROJECT_ROOT/.zshrc" ]]; then
    print_error "Could not find .zshrc in the project directory."
    exit 1
fi

# Backup existing .zshrc if it exists
if [[ -f "$HOME/.zshrc" ]]; then
    BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    print_status "Backing up existing .zshrc to $BACKUP_FILE"
    cp "$HOME/.zshrc" "$BACKUP_FILE"
    print_success "Backup created: $BACKUP_FILE"
fi

# Install .zshrc
print_status "Installing .zshrc..."
cp "$PROJECT_ROOT/.zshrc" "$HOME/.zshrc"
print_success ".zshrc installed successfully!"

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
TOOLS=("nvim" "tmux" "bat" "lsd" "fzf" "starship" "zoxide" "rbenv" "nvm")

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        print_success "$tool found"
    else
        print_warning "$tool not found"
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

# Create a symlink for easy updates (optional)
if [[ ! -L "$HOME/.zshrc" ]]; then
    read -p "Would you like to create a symlink for easy updates? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Creating symlink..."
        rm "$HOME/.zshrc"
        ln -s "$PROJECT_ROOT/.zshrc" "$HOME/.zshrc"
        print_success "Symlink created! Updates to the project .zshrc will be reflected immediately."
    fi
fi

print_success "Installation complete!"
print_status "To apply changes, run: source ~/.zshrc"
print_status "Or restart your terminal." 