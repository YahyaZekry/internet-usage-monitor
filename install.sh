#!/bin/bash

# Internet Usage Monitor - Automated Installation & Setup Script
# Copyright (c) 2025 Yahya Zekry
# Licensed under MIT License

set -e

# --- UI & STYLING ---
# Check if terminal supports colors
if [ -t 1 ] && [ "$(tput colors)" -ge 8 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    NC=""
fi

CHECK="✅"
CROSS="❌"
WARNING="⚠️"
INFO="ℹ️"
ROCKET="🚀"

print_status() {
    local color=$1
    local icon=$2
    local message=$3
    echo -e "${color}${icon} ${message}${NC}"
}

section_header() {
    local title="$1"
    echo
    print_status "$BLUE" "====================================================================" ""
    printf "                     ${YELLOW}%s${NC}\n" "$title"
    print_status "$BLUE" "====================================================================" ""
    sleep 1
}

# --- HELPER FUNCTIONS ---

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- INSTALLATION SUB-ROUTINES ---

check_prerequisites() {
    section_header "[1/7] Checking Prerequisites"
    local missing_packages=()
    for pkg in conky bc ps notify-send; do
        if ! command_exists $pkg; then missing_packages+=($pkg); fi
    done
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        print_status "$YELLOW" "$WARNING" "Missing packages: ${missing_packages[*]}"
        read -p "Install missing packages automatically? (Y/n): " -n 1 -r; echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            if ! command_exists sudo; then
                print_status "$RED" "$CROSS" "sudo command not found. Please install packages manually."
                exit 1
            fi
            if command_exists pacman; then sudo pacman -S --needed --noconfirm conky bc procps-ng libnotify zenity;
            elif command_exists apt; then sudo apt update && sudo apt install -y conky bc procps libnotify-bin zenity;
            elif command_exists dnf; then sudo dnf install -y conky bc procps-ng libnotify zenity;
            elif command_exists zypper; then sudo zypper install -y conky bc procps libnotify-tools zenity;
            else print_status "$RED" "$CROSS" "Unsupported package manager. Please install packages manually."; fi
        fi
    else
        print_status "$GREEN" "$CHECK" "All prerequisites are installed."
    fi
}

install_base_files() {
    local source_dir="$1"
    local is_aur_install="$2"
    
    section_header "[2/7] Installing Files"

    if [ -d "$HOME/.config/internet-usage-monitor-git" ] || [ -f "$HOME/internet_monitor.sh" ]; then
        print_status "$YELLOW" "$WARNING" "Existing installation detected. Stopping and backing up..."
        pkill -f "internet_monitor_daemon.sh" 2>/dev/null || true
        pkill -f "conky -c .*conkyrc_internet" 2>/dev/null || true
        
        local backup_dir="$HOME/.internet_monitor_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        [ -d "$HOME/.config/internet-usage-monitor-git" ] && mv "$HOME/.config/internet-usage-monitor-git" "$backup_dir/"
        [ -d "$HOME/.local/share/internet-usage-monitor-git" ] && mv "$HOME/.local/share/internet-usage-monitor-git" "$backup_dir/"
        print_status "$GREEN" "$CHECK" "Backup complete."
    fi
    
    local app_name="internet-usage-monitor-git"
    local bin_dir="$HOME/.local/bin"
    local config_dir="$HOME/.config/$app_name"
    local data_dir="$HOME/.local/share/$app_name"

    mkdir -p "$bin_dir" "$config_dir" "$data_dir"
    print_status "$GREEN" "$CHECK" "XDG directories are ready."

    if [ "$is_aur_install" = false ]; then
        print_status "$BLUE" "$INFO" "Performing manual installation..."
        cp "$source_dir"/src/*.sh "$bin_dir/"
        cp "$source_dir"/fix_conky_kde.sh "$bin_dir/"
        chmod +x "$bin_dir"/*.sh
        print_status "$GREEN" "$CHECK" "Scripts installed to $bin_dir"
    fi

    # Copy ALL config files first before modification
    cp "$source_dir"/config/config.sh "$config_dir/"
    cp "$source_dir"/config/conkyrc_internet "$config_dir/"
    print_status "$GREEN" "$CHECK" "Configuration files placed in $config_dir"
}

run_customization() {
    local config_sh_path="$HOME/.config/internet-usage-monitor-git/config.sh"
    local conkyrc_path="$HOME/.config/internet-usage-monitor-git/conkyrc_internet"

    section_header "[3/7] Customizing Installation"

    # Daily Limit
    print_status "$BLUE" "$INFO" "Please set your daily internet usage limit."
    echo "  1) 2 GB, 2) 5 GB (Default), 3) 10 GB, 4) Custom"
    read -p "Choose an option (1-4): " limit_choice
    local daily_limit=5
    if [ "$limit_choice" = "1" ]; then daily_limit=2;
    elif [ "$limit_choice" = "3" ]; then daily_limit=10;
    elif [ "$limit_choice" = "4" ]; then
        read -p "Enter custom daily limit in GB: " custom_limit
        if [[ "$custom_limit" =~ ^[0-9]+$ ]]; then daily_limit=$custom_limit; else daily_limit=5; fi
    fi
    sed -i "s/DAILY_LIMIT_GB=.*/DAILY_LIMIT_GB=$daily_limit/" "$config_sh_path"
    print_status "$GREEN" "$CHECK" "Daily limit set to $daily_limit GB."

    # Background Color
    print_status "$BLUE" "$INFO" "Choose a background color for the widget:"
    echo "  1) Transparent (Default), 2) Solid Black, 3) Solid Dark Grey, 4) Solid Navy Blue"
    read -p "Choose an option (1-4): " bg_choice
    local color="000000"; local transparent="true"
    case $bg_choice in
        2) transparent="false";;
        3) color="222222"; transparent="false";;
        4) color="000033"; transparent="false";;
    esac
    sed -i "s/own_window_transparent = .*,/own_window_transparent = $transparent,/" "$conkyrc_path"
    sed -i "s/own_window_colour = '.*',/own_window_colour = '$color',/" "$conkyrc_path"
    print_status "$GREEN" "$CHECK" "Background color set."

    # Position
    print_status "$BLUE" "$INFO" "Where would you like the widget to appear?"
    echo "  1) Top Right, 2) Top Left, 3) Bottom Right, 4) Bottom Left, 5) Middle Right, 6) Middle Left"
    read -p "Choose an option (1-6): " pos_choice
    local alignment="top_right"
    case $pos_choice in
        2) alignment="top_left";; 3) alignment="bottom_right";; 4) alignment="bottom_left";;
        5) alignment="middle_right";; 6) alignment="middle_left";;
    esac
    sed -i "s/alignment = '.*',/alignment = '$alignment',/" "$conkyrc_path"
    print_status "$GREEN" "$CHECK" "Widget position set to: $alignment"
}

apply_kde_fix() {
    section_header "[4/7] KDE Plasma Integration"
    if [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* || "$DESKTOP_SESSION" == *"plasma"* ]]; then
        print_status "$YELLOW" "$WARNING" "KDE Plasma detected."
        read -p "Apply recommended KDE window rule for the widget? (Y/n): " -n 1 -r; echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            "$HOME/.local/bin/fix_conky_kde.sh"
        fi
    else
        print_status "$GREEN" "$CHECK" "Non-KDE environment, skipping fix."
    fi
}

setup_autostart() {
    section_header "[5/7] Autostart Setup"
    print_status "$BLUE" "$INFO" "How should the monitor run?"
    echo "  1) Systemd user service (Recommended)"
    echo "  2) Cron job (Legacy)"
    echo "  3) Skip autostart"
    read -p "Choose an option (1-3): " choice
    
    (crontab -l 2>/dev/null | grep -v "internet_monitor.sh" | crontab -) 2>/dev/null || true
    systemctl --user disable --now internet-monitor.timer 2>/dev/null || true

    local bin_path="$HOME/.local/bin/internet_monitor.sh"
    local conky_config_path="$HOME/.config/internet-usage-monitor-git/conkyrc_internet"
    
    case $choice in
        1)
            local systemd_dir="$HOME/.config/systemd/user"
            mkdir -p "$systemd_dir"
            cat > "$systemd_dir/internet-monitor.service" << EOF
[Unit]
Description=Internet Usage Monitor Script
[Service]
ExecStart=$bin_path
EOF
            cat > "$systemd_dir/internet-monitor.timer" << EOF
[Unit]
Description=Run Internet Monitor every 5 minutes
[Timer]
OnCalendar=*:0/5
Persistent=true
[Install]
WantedBy=timers.target
EOF
            systemctl --user daemon-reload
            systemctl --user enable --now internet-monitor.timer
            print_status "$GREEN" "$CHECK" "Systemd timer enabled and started."
            ;;
        2)
            (crontab -l 2>/dev/null; echo "*/5 * * * * $bin_path") | crontab -
            print_status "$GREEN" "$CHECK" "Cron job added."
            ;;
        *)
            print_status "$BLUE" "$INFO" "Skipping autostart."
            return
            ;;
    esac

    local autostart_dir="$HOME/.config/autostart"
    mkdir -p "$autostart_dir"
    cat > "$autostart_dir/internet-conky.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Internet Usage Conky
Exec=conky -c "$conky_config_path"
Icon=network-wireless
EOF
    print_status "$GREEN" "$CHECK" "Conky autostart entry created."
}

finalize_and_run() {
    section_header "[6/7] Finalizing"
    local bin_dir="$HOME/.local/bin"
    local conky_config="$HOME/.config/internet-usage-monitor-git/conkyrc_internet"

    print_status "$BLUE" "$INFO" "Starting services..."
    "$bin_dir/internet_monitor_daemon.sh" start >/dev/null 2>&1 &
    (setsid nohup conky -c "$conky_config" >/dev/null 2>&1 &)
    sleep 1
    
    if pgrep -f "internet_monitor_daemon.sh" > /dev/null; then
        print_status "$GREEN" "$CHECK" "Monitoring daemon is running."
    else
        print_status "$RED" "$CROSS" "Monitoring daemon failed to start."
    fi
    
    if pgrep -f "conky -c $conky_config" > /dev/null; then
        print_status "$GREEN" "$CHECK" "Conky widget is running."
    else
        print_status "$RED" "$CROSS" "Conky widget failed to start."
    fi
    
    section_header "[7/7] Setup Complete"
    print_status "$GREEN" "$ROCKET" "Enjoy monitoring your internet usage!"
}


# --- MAIN EXECUTION FLOW ---

main() {
    local is_aur_install=false
    if [ "$1" = "--aur" ]; then is_aur_install=true; fi

    section_header "Internet Usage Monitor Setup"

    local source_dir
    if [ "$is_aur_install" = true ]; then
        source_dir="/usr/share/internet-usage-monitor-git"
    else
        source_dir="$(pwd)"
        check_prerequisites
    fi
    
    install_base_files "$source_dir" "$is_aur_install"
    
    print_status "$BLUE" "$INFO" "Choose your setup type:"
    echo "  1) Quick Install (Use recommended defaults)"
    echo "  2) Custom Install (Configure all options)"
    read -p "Choose an option (1-2): " setup_type

    if [ "$setup_type" = "2" ]; then
        run_customization
    else
        print_status "$GREEN" "$CHECK" "Using default settings."
    fi

    apply_kde_fix
    setup_autostart
    finalize_and_run
}

main "$@"
