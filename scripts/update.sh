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

# Check if .zshrc exists in the project
if [[ ! -f "$PROJECT_ROOT/.zshrc" ]]; then
    print_error "Could not find .zshrc in the project directory."
    exit 1
fi

# Check if .zshrc exists in home directory
if [[ ! -f "$HOME/.zshrc" ]]; then
    print_warning "No .zshrc found in home directory. Running installation instead..."
    exec "$SCRIPT_DIR/install.sh"
    exit 0
fi

# Check if .zshrc is a symlink
if [[ -L "$HOME/.zshrc" ]]; then
    print_status ".zshrc is a symlink. Updating project file will automatically update your configuration."
    
    # Check if the symlink points to our project
    LINK_TARGET=$(readlink "$HOME/.zshrc")
    if [[ "$LINK_TARGET" == "$PROJECT_ROOT/.zshrc" ]]; then
        print_success "Symlink is correctly pointing to project .zshrc"
    else
        print_warning "Symlink points to: $LINK_TARGET"
        print_warning "Expected: $PROJECT_ROOT/.zshrc"
    fi
else
    print_status ".zshrc is a regular file. Checking for differences..."
    
    # Compare files
    if cmp -s "$PROJECT_ROOT/.zshrc" "$HOME/.zshrc"; then
        print_success "Files are identical. No update needed."
        exit 0
    else
        print_warning "Files are different. Showing differences:"
        echo
        diff "$HOME/.zshrc" "$PROJECT_ROOT/.zshrc" || true
        echo
        
        # Ask user what to do
        echo "Options:"
        echo "1) Replace home .zshrc with project version (backup will be created)"
        echo "2) Replace project .zshrc with home version"
        echo "3) Create a symlink for future automatic updates"
        echo "4) Cancel"
        
        read -p "Choose an option (1-4): " -n 1 -r
        echo
        
        case $REPLY in
            1)
                print_status "Creating backup of current .zshrc..."
                BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
                cp "$HOME/.zshrc" "$BACKUP_FILE"
                print_success "Backup created: $BACKUP_FILE"
                
                print_status "Updating .zshrc..."
                cp "$PROJECT_ROOT/.zshrc" "$HOME/.zshrc"
                print_success ".zshrc updated successfully!"
                ;;
            2)
                print_status "Updating project .zshrc with home version..."
                cp "$HOME/.zshrc" "$PROJECT_ROOT/.zshrc"
                print_success "Project .zshrc updated!"
                ;;
            3)
                print_status "Creating symlink..."
                BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
                cp "$HOME/.zshrc" "$BACKUP_FILE"
                print_success "Backup created: $BACKUP_FILE"
                
                rm "$HOME/.zshrc"
                ln -s "$PROJECT_ROOT/.zshrc" "$HOME/.zshrc"
                print_success "Symlink created! Future updates will be automatic."
                ;;
            4)
                print_status "Update cancelled."
                exit 0
                ;;
            *)
                print_error "Invalid option. Update cancelled."
                exit 1
                ;;
        esac
    fi
fi

print_success "Update complete!"
print_status "To apply changes, run: source ~/.zshrc"
print_status "Or restart your terminal." 