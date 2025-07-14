#!/bin/bash

# super-dotfiles update script
# This script updates the .zshrc configuration

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

print_status "Starting super-dotfiles update..."

# Check if we're in the right directory
if [[ ! -f "$PROJECT_ROOT/README.md" ]]; then
    print_error "Could not find project root. Please run this script from the super-dotfiles directory."
    exit 1
fi

# Configuration files to update
CONFIG_FILES=(".zshrc" ".tmux.conf" ".fzf.zsh")

# Check if all config files exist in the project
for config_file in "${CONFIG_FILES[@]}"; do
    if [[ ! -f "$PROJECT_ROOT/$config_file" ]]; then
        print_error "Could not find $config_file in the project directory."
        exit 1
    fi
done

# Check if any config files exist in home directory
FOUND_FILES=()
for config_file in "${CONFIG_FILES[@]}"; do
    if [[ -f "$HOME/$config_file" ]]; then
        FOUND_FILES+=("$config_file")
    fi
done

if [[ ${#FOUND_FILES[@]} -eq 0 ]]; then
    print_warning "No configuration files found in home directory. Running installation instead..."
    exec "$SCRIPT_DIR/install.sh"
    exit 0
fi

# Check for symlinks and handle updates
SYMLINK_FILES=()
REGULAR_FILES=()

for config_file in "${CONFIG_FILES[@]}"; do
    if [[ -f "$HOME/$config_file" ]]; then
        if [[ -L "$HOME/$config_file" ]]; then
            SYMLINK_FILES+=("$config_file")
            # Check if the symlink points to our project
            LINK_TARGET=$(readlink "$HOME/$config_file")
            if [[ "$LINK_TARGET" == "$PROJECT_ROOT/$config_file" ]]; then
                print_success "$config_file symlink is correctly pointing to project"
            else
                print_warning "$config_file symlink points to: $LINK_TARGET"
                print_warning "Expected: $PROJECT_ROOT/$config_file"
            fi
        else
            REGULAR_FILES+=("$config_file")
        fi
    fi
done

# Handle symlinked files
if [[ ${#SYMLINK_FILES[@]} -gt 0 ]]; then
    print_status "The following files are symlinked and will update automatically: ${SYMLINK_FILES[*]}"
fi

# Handle regular files
if [[ ${#REGULAR_FILES[@]} -gt 0 ]]; then
    print_status "Checking regular files for differences: ${REGULAR_FILES[*]}"
    
    FILES_TO_UPDATE=()
    for config_file in "${REGULAR_FILES[@]}"; do
        if ! cmp -s "$PROJECT_ROOT/$config_file" "$HOME/$config_file"; then
            FILES_TO_UPDATE+=("$config_file")
        fi
    done
    
    if [[ ${#FILES_TO_UPDATE[@]} -eq 0 ]]; then
        print_success "All regular files are identical. No update needed."
    else
        print_warning "The following files have differences: ${FILES_TO_UPDATE[*]}"
        
        for config_file in "${FILES_TO_UPDATE[@]}"; do
            echo
            print_status "Differences in $config_file:"
            diff "$HOME/$config_file" "$PROJECT_ROOT/$config_file" || true
            echo
            
            # Ask user what to do for each file
            echo "Options for $config_file:"
            echo "1) Replace home $config_file with project version (backup will be created)"
            echo "2) Replace project $config_file with home version"
            echo "3) Create a symlink for future automatic updates"
            echo "4) Skip this file"
            
            read -p "Choose an option (1-4): " -n 1 -r
            echo
            
            case $REPLY in
                1)
                    print_status "Creating backup of current $config_file..."
                    BACKUP_FILE="$HOME/${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
                    cp "$HOME/$config_file" "$BACKUP_FILE"
                    print_success "Backup created: $BACKUP_FILE"
                    
                    print_status "Updating $config_file..."
                    cp "$PROJECT_ROOT/$config_file" "$HOME/$config_file"
                    print_success "$config_file updated successfully!"
                    ;;
                2)
                    print_status "Updating project $config_file with home version..."
                    cp "$HOME/$config_file" "$PROJECT_ROOT/$config_file"
                    print_success "Project $config_file updated!"
                    ;;
                3)
                    print_status "Creating symlink for $config_file..."
                    BACKUP_FILE="$HOME/${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
                    cp "$HOME/$config_file" "$BACKUP_FILE"
                    print_success "Backup created: $BACKUP_FILE"
                    
                    rm "$HOME/$config_file"
                    ln -s "$PROJECT_ROOT/$config_file" "$HOME/$config_file"
                    print_success "Symlink created for $config_file!"
                    ;;
                4)
                    print_status "Skipping $config_file"
                    ;;
                *)
                    print_error "Invalid option. Skipping $config_file"
                    ;;
            esac
        done
    fi
fi

print_success "Update complete!"
print_status "To apply changes:"
print_status "  - For .zshrc: run 'source ~/.zshrc' or restart your terminal"
print_status "  - For .tmux.conf: run 'tmux source-file ~/.tmux.conf' or restart tmux"
print_status "  - For .fzf.zsh: changes will apply on next terminal session" 