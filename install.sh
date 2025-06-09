#!/bin/bash

# Internet Usage Monitor - Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Internet Usage Monitor - Installer  ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo
}

print_step() {
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

# Check dependencies
check_dependencies() {
    print_step "Checking dependencies..."
    
    local missing_deps=()
    
    # Check for conky
    if ! command -v conky &> /dev/null; then
        missing_deps+=("conky")
    fi
    
    # Check for bc
    if ! command -v bc &> /dev/null; then
        missing_deps+=("bc")
    fi
    
    # Check for procps (ps command)
    if ! command -v ps &> /dev/null; then
        missing_deps+=("procps")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        echo
        print_step "Please install them using your package manager:"
        
        # Detect distribution and provide appropriate install command
        if command -v pacman &> /dev/null; then
            echo "  sudo pacman -S ${missing_deps[*]}"
        elif command -v apt &> /dev/null; then
            echo "  sudo apt install ${missing_deps[*]}"
        elif command -v dnf &> /dev/null; then
            echo "  sudo dnf install ${missing_deps[*]}"
        elif command -v zypper &> /dev/null; then
            echo "  sudo zypper install ${missing_deps[*]}"
        else
            echo "  Use your distribution's package manager to install: ${missing_deps[*]}"
        fi
        echo
        exit 1
    fi
    
    print_success "All dependencies are installed"
}

# Install files
install_files() {
    print_step "Installing files to home directory..."
    
    # Get the directory where the script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Copy configuration file
    if [ -f "$SCRIPT_DIR/conkyrc_internet" ]; then
        cp "$SCRIPT_DIR/conkyrc_internet" "$HOME/.conkyrc_internet"
        print_success "Copied Conky configuration to ~/.conkyrc_internet"
    else
        print_error "conkyrc_internet not found in $SCRIPT_DIR"
        exit 1
    fi
    
    # Copy monitor script
    if [ -f "$SCRIPT_DIR/internet_monitor.sh" ]; then
        cp "$SCRIPT_DIR/internet_monitor.sh" "$HOME/"
        chmod +x "$HOME/internet_monitor.sh"
        print_success "Copied internet_monitor.sh to home directory"
    else
        print_error "internet_monitor.sh not found in $SCRIPT_DIR"
        exit 1
    fi
    
    # Copy helper script
    if [ -f "$SCRIPT_DIR/conky_usage_helper.sh" ]; then
        cp "$SCRIPT_DIR/conky_usage_helper.sh" "$HOME/"
        chmod +x "$HOME/conky_usage_helper.sh"
        print_success "Copied conky_usage_helper.sh to home directory"
    else
        print_error "conky_usage_helper.sh not found in $SCRIPT_DIR"
        exit 1
    fi
}

main() {
    print_header
    
    check_dependencies
    echo
    
    install_files
    echo
    
    print_success "Installation completed successfully!"
    echo
    print_step "Usage:"
    echo "  Monitor control: ~/internet_monitor.sh {start|stop|status|reset|usage}"
    echo "  Widget control: conky -c ~/.conkyrc_internet &"
    echo
    print_step "The internet usage widget should now be visible on your desktop."
    echo
}

# Run main function
main "$@"

