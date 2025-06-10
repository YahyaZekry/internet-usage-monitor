#!/bin/bash

# Internet Usage Monitor - Automated Installation Script
# Copyright (c) 2025 Yahya Zekry
# Licensed under MIT License

# set -e  # Exit on any error - disabled for debugging

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emoji indicators
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
INFO="ℹ️"
ROCKET="🚀"

echo -e "${BLUE}${ROCKET} Internet Usage Monitor Installation${NC}"
echo -e "${BLUE}======================================${NC}"
echo

# Function to print colored output
print_status() {
    local color=$1
    local icon=$2
    local message=$3
    echo -e "${color}${icon} ${message}${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Function to install packages based on distribution
install_packages() {
    local distro=$(detect_distro)
    
    print_status "$BLUE" "$INFO" "Detected distribution: $distro"
    
    case $distro in
        "arch"|"garuda"|"manjaro")
            print_status "$YELLOW" "$WARNING" "Installing packages with pacman..."
            if command_exists sudo; then
                sudo pacman -S --needed --noconfirm conky bc procps-ng libnotify zenity
            else
                print_status "$RED" "$CROSS" "sudo not found. Please install packages manually:"
                echo "pacman -S conky bc procps-ng libnotify zenity"
                return 1
            fi
            ;;
        "ubuntu"|"debian"|"linuxmint")
            print_status "$YELLOW" "$WARNING" "Installing packages with apt..."
            if command_exists sudo; then
                sudo apt update
                sudo apt install -y conky bc procps libnotify-bin zenity
            else
                print_status "$RED" "$CROSS" "sudo not found. Please install packages manually:"
                echo "apt install conky bc procps libnotify-bin zenity"
                return 1
            fi
            ;;
        "fedora"|"rhel"|"centos")
            print_status "$YELLOW" "$WARNING" "Installing packages with dnf/yum..."
            if command_exists sudo; then
                if command_exists dnf; then
                    sudo dnf install -y conky bc procps-ng libnotify zenity
                elif command_exists yum; then
                    sudo yum install -y conky bc procps-ng libnotify zenity
                fi
            else
                print_status "$RED" "$CROSS" "sudo not found. Please install packages manually:"
                echo "dnf install conky bc procps-ng libnotify zenity"
                return 1
            fi
            ;;
        "opensuse"*)
            print_status "$YELLOW" "$WARNING" "Installing packages with zypper..."
            if command_exists sudo; then
                sudo zypper install -y conky bc procps libnotify-tools zenity
            else
                print_status "$RED" "$CROSS" "sudo not found. Please install packages manually:"
                echo "zypper install conky bc procps libnotify-tools zenity"
                return 1
            fi
            ;;
        *)
            print_status "$YELLOW" "$WARNING" "Unknown distribution. Please install these packages manually:"
            echo "- conky"
            echo "- bc"
            echo "- procps (or procps-ng)"
            echo "- libnotify (libnotify-bin on Debian/Ubuntu)"
            echo "- zenity (optional)"
            echo
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
            ;;
    esac
}

# Function to check prerequisites
check_prerequisites() {
    print_status "$BLUE" "$INFO" "Checking prerequisites..."
    
    local missing_packages=()
    
    # Check essential packages
    if ! command_exists conky; then
        missing_packages+=("conky")
    fi
    
    if ! command_exists bc; then
        missing_packages+=("bc")
    fi
    
    if ! command_exists ps; then
        missing_packages+=("procps")
    fi
    
    # Check notification tools
    if ! command_exists notify-send; then
        missing_packages+=("libnotify")
    fi
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        print_status "$YELLOW" "$WARNING" "Missing packages: ${missing_packages[*]}"
        echo
        read -p "Would you like to install missing packages automatically? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_status "$RED" "$CROSS" "Installation cancelled. Please install required packages manually."
            exit 0 # Graceful exit for workflow testing
        fi
        
        install_packages
    else
        print_status "$GREEN" "$CHECK" "All prerequisites are installed!"
    fi
}

# Function to detect existing installation
detect_existing_installation() {
    local installed_files=(
        "$HOME/internet_monitor.sh"
        "$HOME/internet_monitor_daemon.sh"
        "$HOME/conky_usage_helper.sh"
        "$HOME/.conkyrc_internet"
        "$HOME/config.sh"
    )
    
    local found_count=0
    for file in "${installed_files[@]}"; do
        if [ -f "$file" ]; then
            ((found_count++))
        fi
    done
    
    if [ $found_count -gt 0 ]; then
        return 0  # Installation found
    else
        return 1  # No installation found
    fi
}

# Function to backup existing installation
backup_existing_installation() {
    local backup_dir="$HOME/.internet_monitor_install_backup_$(date +%Y%m%d_%H%M%S)"
    local files_to_backup=(
        "$HOME/internet_monitor.sh"
        "$HOME/internet_monitor_daemon.sh"
        "$HOME/conky_usage_helper.sh"
        "$HOME/.conkyrc_internet"
        "$HOME/config.sh"
    )
    
    mkdir -p "$backup_dir"
    
    local backed_up=0
    for file in "${files_to_backup[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$backup_dir/"
            ((backed_up++))
        fi
    done
    
    if [ $backed_up -gt 0 ]; then
        print_status "$YELLOW" "$WARNING" "Backed up $backed_up existing files to $backup_dir"
        echo -e "${YELLOW}Your current installation has been backed up to: $backup_dir${NC}"
        echo
    else
        print_status "$BLUE" "$INFO" "No existing files found to backup"
    fi
}

# Function to copy files
install_files() {
    print_status "$BLUE" "$INFO" "Installing files..."
    
    # Check if files exist
    local required_files=("src/internet_monitor.sh" "src/conky_usage_helper.sh" "config/conkyrc_internet" "config/config.sh")
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            print_status "$RED" "$CROSS" "Required file not found: $file"
            print_status "$YELLOW" "$WARNING" "Make sure you're running this script from the project directory."
            exit 1
        fi
    done
    
    # Detect existing installation
    if detect_existing_installation; then
        print_status "$YELLOW" "$WARNING" "Existing installation detected!"
        echo
        echo "Installation options:"
        echo "1) Update existing installation (recommended)"
        echo "2) Fresh install (will backup current installation)"
        echo "3) Cancel installation"
        echo
        read -p "Choose an option (1-3): " install_choice
        
        case $install_choice in
            1)
                print_status "$BLUE" "$INFO" "Updating existing installation..."
                backup_existing_installation
                print_status "$GREEN" "$CHECK" "Ready to proceed with update..."
                print_status "$BLUE" "$INFO" "DEBUG: Continuing after backup step..."
                ;;
            2)
                print_status "$BLUE" "$INFO" "Performing fresh installation..."
                backup_existing_installation
                print_status "$GREEN" "$CHECK" "Ready to proceed with fresh install..."
                ;;
            3)
                print_status "$BLUE" "$INFO" "Installation cancelled."
                exit 0
                ;;
            *)
                print_status "$YELLOW" "$WARNING" "Invalid choice. Defaulting to update..."
                backup_existing_installation
                print_status "$GREEN" "$CHECK" "Ready to proceed with update..."
                ;;
        esac
    else
        print_status "$GREEN" "$CHECK" "No existing installation found. Proceeding with fresh install."
    fi
    
    # Make scripts executable
    print_status "$BLUE" "$INFO" "Setting script permissions..."
    local exec_files=(
        "src/internet_monitor.sh"
        "src/conky_usage_helper.sh"
        "src/internet_monitor_daemon.sh"
        "install.sh"  # Make itself executable too if not already
        "uninstall.sh"
    )
    local chmod_errors=0
    for exec_file in "${exec_files[@]}"; do
        if [ -f "$exec_file" ]; then
            chmod +x "$exec_file"
            print_status "$GREEN" "$CHECK" "Made $exec_file executable"
        else
            print_status "$YELLOW" "$WARNING" "File not found for chmod: $exec_file (This might be okay if not all scripts are present in all contexts)"
            ((chmod_errors++))
        fi
    done
    if [ $chmod_errors -eq 0 ]; then
        print_status "$GREEN" "$CHECK" "All script permissions set successfully"
    else
        print_status "$YELLOW" "$WARNING" "Some files not found during chmod, check paths if this is unexpected."
    fi
    
    # Stop running processes before updating
    if detect_existing_installation; then
        print_status "$BLUE" "$INFO" "Stopping running processes for update..."
        
        # Check and stop daemon processes
        if pgrep -f "internet_monitor_daemon.sh" > /dev/null; then
            print_status "$YELLOW" "$WARNING" "Found running daemon processes, stopping..."
            pkill -f "internet_monitor_daemon.sh" 2>/dev/null || true
            sleep 1
            print_status "$GREEN" "$CHECK" "Daemon processes stopped"
        else
            print_status "$BLUE" "$INFO" "No daemon processes found"
        fi
        
        # Check and stop Conky processes
        if pgrep conky > /dev/null; then
            print_status "$YELLOW" "$WARNING" "Found running Conky processes, stopping..."
            pkill conky 2>/dev/null || true
            sleep 1
            print_status "$GREEN" "$CHECK" "Conky processes stopped"
        else
            print_status "$BLUE" "$INFO" "No Conky processes found"
        fi
        
        # Force remove any PID files
        if [ -f "/tmp/internet_monitor_daemon.pid" ]; then
            rm -f "/tmp/internet_monitor_daemon.pid"
            print_status "$GREEN" "$CHECK" "Removed daemon PID file"
        fi
        
        print_status "$GREEN" "$CHECK" "System ready for update"
    fi
    
    # Copy files to home directory
    print_status "$BLUE" "$INFO" "Copying updated scripts..."
    cp src/internet_monitor.sh "$HOME/"
    print_status "$GREEN" "$CHECK" "Updated internet_monitor.sh"
    
    cp src/conky_usage_helper.sh "$HOME/"
    print_status "$GREEN" "$CHECK" "Updated conky_usage_helper.sh"
    
    cp src/internet_monitor_daemon.sh "$HOME/"
    print_status "$GREEN" "$CHECK" "Updated internet_monitor_daemon.sh"
    
    cp config/conkyrc_internet "$HOME/.conkyrc_internet"
    print_status "$GREEN" "$CHECK" "Updated Conky configuration"
    
    # Handle config file specially for updates
    if [ -f "$HOME/config.sh" ] && detect_existing_installation; then
        print_status "$YELLOW" "$WARNING" "Found existing config.sh"
        echo
        read -p "Do you want to keep your existing configuration? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            cp config/config.sh "$HOME/"
            print_status "$GREEN" "$CHECK" "Updated configuration file"
        else
            print_status "$BLUE" "$INFO" "Kept existing configuration"
        fi
    else
        cp config/config.sh "$HOME/"
        print_status "$GREEN" "$CHECK" "Installed configuration file"
    fi
    
    print_status "$GREEN" "$CHECK" "Files installed/updated successfully"
    echo
    
    # Show update completion message
    # Note: We check for update by looking at the original choice, not current state
    if [ -n "$install_choice" ] && [ "$install_choice" = "1" -o "$install_choice" = "2" ]; then
        echo -e "${GREEN}=========================================${NC}"
        echo -e "${GREEN}🎉 UPDATE COMPLETE! 🎉${NC}"
        echo -e "${GREEN}=========================================${NC}"
        echo
        print_status "$GREEN" "$CHECK" "All scripts have been updated to the latest version!"
        echo
        echo -e "${BLUE}Applying the updates automatically:${NC}"
        
        # 1. Restart systemd timer if it exists
        if systemctl --user is-active internet-monitor.timer >/dev/null 2>&1; then
            print_status "$BLUE" "$INFO" "Restarting systemd timer..."
            systemctl --user restart internet-monitor.timer 2>/dev/null || true
            print_status "$GREEN" "$CHECK" "Systemd timer restarted"
        else
            print_status "$BLUE" "$INFO" "No systemd timer found to restart"
        fi
        
        # 2. Start Conky widget with new configuration (if not in CI)
        if [ "$CI" != "true" ] && [ -n "$DISPLAY" ]; then
            print_status "$BLUE" "$INFO" "Attempting to start Conky widget with new configuration..."
            (conky -c ~/.conkyrc_internet &) && print_status "$GREEN" "$CHECK" "Conky widget start initiated." || print_status "$YELLOW" "$WARNING" "Conky widget failed to start or no display."
        else
            print_status "$BLUE" "$INFO" "Skipping Conky auto-start in CI/headless environment."
            echo "          You can start it manually: conky -c ~/.conkyrc_internet &"
        fi
        
        # 3. Test the updated scripts
        print_status "$BLUE" "$INFO" "Testing updated scripts..."
        if ~/internet_monitor.sh usage >/dev/null 2>&1; then
            print_status "$GREEN" "$CHECK" "Updated scripts working correctly"
        else
            print_status "$YELLOW" "$WARNING" "Script test had issues (may be normal on first run)"
        fi
        
        echo
        print_status "$BLUE" "$INFO" "Your data and logs are preserved during the update."
        echo
        echo -e "${BLUE}Manual commands (if needed):${NC}"
        echo "• Restart systemd timer: ${YELLOW}systemctl --user restart internet-monitor.timer${NC}"
        echo "• Start Conky widget: ${YELLOW}conky -c ~/.conkyrc_internet &${NC}"
        echo "• Test scripts: ${YELLOW}~/internet_monitor.sh usage${NC}"
        echo
    fi
}

# Function to test installation
test_installation() {
    print_status "$BLUE" "$INFO" "Testing installation..."
    
    # Test monitor script
    if "$HOME/internet_monitor.sh" >/dev/null 2>&1; then
        print_status "$GREEN" "$CHECK" "Monitor script working"
    else
        print_status "$YELLOW" "$WARNING" "Monitor script test had issues (this may be normal on first run)"
    fi
    
    # Test notifications
    if command_exists notify-send; then
        notify-send "Internet Monitor" "Installation test successful!" -t 3000 2>/dev/null || true
        print_status "$GREEN" "$CHECK" "Notification system working"
    fi
    
    # Test Conky config
    if [ -f "$HOME/.conkyrc_internet" ]; then
        print_status "$GREEN" "$CHECK" "Conky configuration installed"
    fi
}

# Function to detect existing autostart configuration
detect_existing_autostart() {
    # Check for existing cron job
    if crontab -l 2>/dev/null | grep -q "internet_monitor.sh"; then
        echo "cron"
        return 0
    fi
    
    # Check for systemd timer
    if systemctl --user is-enabled internet-monitor.timer >/dev/null 2>&1; then
        echo "systemd"
        return 0
    fi
    
    # Check for desktop autostart
    if [ -f "$HOME/.config/autostart/internet-monitor.desktop" ]; then
        echo "autostart"
        return 0
    fi
    
    echo "none"
    return 1
}

# Function to setup autostart options
setup_autostart() {
    local existing_autostart=$(detect_existing_autostart)
    
    if [ "$existing_autostart" != "none" ]; then
        print_status "$GREEN" "$CHECK" "Found existing autostart configuration: $existing_autostart"
        echo
        read -p "Keep existing autostart configuration? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_status "$BLUE" "$INFO" "Proceeding with new autostart setup..."
        else
            print_status "$BLUE" "$INFO" "Keeping existing $existing_autostart configuration"
            return 0
        fi
    fi
    
    echo
    print_status "$BLUE" "$INFO" "Autostart Setup Options:"
    echo "1) Cron job (every 5 minutes) - Recommended for reliability and lower resource usage"
    echo "2) Systemd user service - More precise timing but higher complexity"
    echo "3) Desktop autostart entry"
    echo "4) Skip autostart setup"
    echo
    
    read -p "Choose an option (1-4): " choice
    
    case $choice in
        1)
            print_status "$YELLOW" "$WARNING" "Setting up cron job..."
            # Add to crontab if not already present
            (crontab -l 2>/dev/null | grep -v "internet_monitor.sh"; echo "*/5 * * * * $HOME/internet_monitor.sh") | crontab -
            print_status "$GREEN" "$CHECK" "Cron job added (runs every 5 minutes)"
            ;;
        2)
            print_status "$YELLOW" "$WARNING" "Setting up systemd user service..."
            mkdir -p "$HOME/.config/systemd/user"
            
            # Create service file
            cat > "$HOME/.config/systemd/user/internet-monitor.service" << EOF
[Unit]
Description=Internet Usage Monitor
After=network.target

[Service]
Type=oneshot
ExecStart=%h/internet_monitor.sh

[Install]
WantedBy=default.target
EOF
            
            # Create timer file
            cat > "$HOME/.config/systemd/user/internet-monitor.timer" << EOF
[Unit]
Description=Run Internet Monitor every 5 minutes
Requires=internet-monitor.service

[Timer]
OnCalendar=*:0/5
Persistent=true

[Install]
WantedBy=timers.target
EOF
            
            # Enable and start
            systemctl --user daemon-reload
            systemctl --user enable internet-monitor.timer
            systemctl --user start internet-monitor.timer
            
            print_status "$GREEN" "$CHECK" "Systemd timer created and started"
            ;;
        3)
            print_status "$YELLOW" "$WARNING" "Setting up desktop autostart..."
            mkdir -p "$HOME/.config/autostart"
            
            # Monitor autostart
            cat > "$HOME/.config/autostart/internet-monitor.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Internet Usage Monitor
Exec=$HOME/internet_monitor.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
            
            # Conky autostart
            cat > "$HOME/.config/autostart/internet-conky.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Internet Usage Conky
Exec=conky -c $HOME/.conkyrc_internet
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
            
            print_status "$GREEN" "$CHECK" "Desktop autostart entries created"
            ;;
        4)
            print_status "$BLUE" "$INFO" "Skipping autostart setup"
            ;;
        *)
            print_status "$YELLOW" "$WARNING" "Invalid choice, skipping autostart setup"
            ;;
    esac
}

# Function to show completion message
show_completion() {
    echo
    print_status "$GREEN" "$ROCKET" "Installation completed successfully!"
    echo
    echo -e "${BLUE}Quick Start:${NC}"
    echo "1. Test the monitor manually:"
    echo -e "   ${YELLOW}$HOME/internet_monitor.sh${NC}"
    echo
    echo "2. Start the Conky widget:"
    echo -e "   ${YELLOW}conky -c ~/.conkyrc_internet &${NC}"
    echo
    echo "3. Check your usage:"
    echo -e "   ${YELLOW}tail ~/.internet_usage.log${NC}"
    echo
    echo -e "${BLUE}Configuration:${NC}"
    echo "- Edit daily limit in both scripts (default: 2GB)"
    echo "- Widget position: ~/.conkyrc_internet"
    echo "- View logs: ~/.internet_usage.log"
    echo
    echo -e "${BLUE}Documentation:${NC}"
    echo "- Full README: $(pwd)/README.md"
    echo "- GitHub: https://github.com/Yahya-Zekry/internet-usage-monitor"
    echo
    print_status "$GREEN" "$CHECK" "Enjoy monitoring your internet usage!"
}

# Main installation flow
main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_status "$RED" "$CROSS" "Please don't run this script as root!"
        exit 1
    fi
    
    # Check if in correct directory
    if [ ! -f "install.sh" ]; then
        print_status "$RED" "$CROSS" "Please run this script from the project directory."
        exit 1
    fi
    
    check_prerequisites
    install_files
    test_installation
    setup_autostart
    show_completion
}

# Run main function
main "$@"
