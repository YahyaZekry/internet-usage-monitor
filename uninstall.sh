#!/bin/bash

# Internet Usage Monitor - Uninstallation Script
# Removes all installed files and configurations

set -e

# --- UI & STYLING ---
if [ -t 1 ] && [ "$(tput colors)" -ge 8 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
else
    RED=""; GREEN=""; YELLOW=""; BLUE=""; NC=""
fi

CHECK="✅"; CROSS="❌"; WARNING="⚠️"; INFO="ℹ️"; TRASH="🗑️"; SEARCH="🔍"; ROCKET="🚀"

print_status() { echo -e "${1}${2} ${3}${NC}"; }
section_header() {
    echo
    print_status "$BLUE" "====================================================================" ""
    printf "                     ${YELLOW}%s${NC}\n" "$1"
    print_status "$BLUE" "====================================================================" ""
    sleep 1
}

# --- SCANNING & DETECTION ---

scan_system() {
    section_header "Scanning System for Internet Usage Monitor"
    print_status "$BLUE" "$SEARCH" "Scanning for installed components..."
    sleep 1
    
    local app_name="internet-usage-monitor-git"
    local found_items=()
    local bin_dir="$HOME/.local/bin"
    local scan_locations=(
        "$HOME/.config/$app_name:Configuration directory"
        "$HOME/.local/share/$app_name:Data directory"
        "$HOME/.config/autostart/internet-conky.desktop:Autostart entry"
        "$HOME/.config/systemd/user/internet-monitor.timer:Systemd timer"
        "$HOME/.config/systemd/user/internet-monitor.service:Systemd service"
    )
    
    local scripts=("common.sh" "internet_monitor.sh" "conky_usage_helper.sh" "internet_monitor_daemon.sh" "fix_conky_kde.sh")
    
    # Check main directories and files
    for location in "${scan_locations[@]}"; do
        local path="${location%%:*}"
        local desc="${location##*:}"
        if [ -e "$path" ]; then
            found_items+=("$path")
            print_status "$YELLOW" "$WARNING" "Found: $desc ($path)"
        fi
    done
    
    # Check for scripts in bin directory
    for script in "${scripts[@]}"; do
        local script_path="$bin_dir/$script"
        if [ -f "$script_path" ]; then
            found_items+=("$script_path")
            print_status "$YELLOW" "$WARNING" "Found: Script $script ($script_path)"
        fi
    done
    
    # Check for running processes
    local running_processes=()
    if pgrep -f "internet_monitor_daemon.sh" >/dev/null 2>&1; then
        running_processes+=("internet_monitor_daemon.sh")
        print_status "$YELLOW" "$WARNING" "Found: Running daemon process"
    fi
    
    if pgrep -f "conky -c .*conkyrc_internet" >/dev/null 2>&1; then
        running_processes+=("conky internet monitor")
        print_status "$YELLOW" "$WARNING" "Found: Running conky instance"
    fi
    
    # Check for systemd services
    if systemctl --user is-enabled internet-monitor.timer >/dev/null 2>&1; then
        print_status "$YELLOW" "$WARNING" "Found: Active systemd timer"
    fi
    
    # Check for cron jobs
    if crontab -l 2>/dev/null | grep -q "internet_monitor.sh"; then
        print_status "$YELLOW" "$WARNING" "Found: Cron job entry"
    fi
    
    echo
    if [ ${#found_items[@]} -eq 0 ]; then
        print_status "$GREEN" "$CHECK" "System scan complete. No Internet Usage Monitor installation found."
        print_status "$BLUE" "$INFO" "The Internet Usage Monitor is not installed on this system."
        return 1
    else
        print_status "$RED" "$CROSS" "Found ${#found_items[@]} installed components."
        [ ${#running_processes[@]} -gt 0 ] && print_status "$YELLOW" "$WARNING" "Some components are currently running."
        printf '%s\n' "${found_items[@]}" | sort -u
    fi
}

find_installed_items() {
    local app_name="internet-usage-monitor-git"
    local found_items=()
    local bin_dir="$HOME/.local/bin"
    
    [ -d "$HOME/.config/$app_name" ] && found_items+=("$HOME/.config/$app_name")
    [ -d "$HOME/.local/share/$app_name" ] && found_items+=("$HOME/.local/share/$app_name")
    
    local scripts=("common.sh" "internet_monitor.sh" "conky_usage_helper.sh" "internet_monitor_daemon.sh" "fix_conky_kde.sh")
    for script in "${scripts[@]}"; do
        [ -f "$bin_dir/$script" ] && found_items+=("$bin_dir/$script")
    done

    [ -f "$HOME/.config/autostart/internet-conky.desktop" ] && found_items+=("$HOME/.config/autostart/internet-conky.desktop")
    [ -f "$HOME/.config/systemd/user/internet-monitor.timer" ] && found_items+=("$HOME/.config/systemd/user/internet-monitor.timer")
    [ -f "$HOME/.config/systemd/user/internet-monitor.service" ] && found_items+=("$HOME/.config/systemd/user/internet-monitor.service")

    printf '%s\n' "${found_items[@]}" | sort -u
}

# --- UNINSTALLATION SUB-ROUTINES ---

remove_items() {
    local items_to_remove=("$@")
    
    section_header "Confirming Removal"
    print_status "$YELLOW" "$WARNING" "The following files and directories will be permanently removed:"
    for item in "${items_to_remove[@]}"; do echo "  - $item"; done
    echo
    read -p "Are you sure you want to permanently delete these items? (y/N): " -n 1 -r; echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "$BLUE" "$INFO" "Removal cancelled by user."
        exit 0
    fi

    local removed_count=0
    set +e 
    for item in "${items_to_remove[@]}"; do
        if [ -e "$item" ]; then
            rm -rf "$item"
            if [ $? -eq 0 ]; then
                print_status "$GREEN" "$CHECK" "Removed: $item"
                ((removed_count++))
            else
                print_status "$RED" "$CROSS" "Failed to remove: $item"
            fi
        fi
    done
    set -e
    print_status "$GREEN" "$CHECK" "Successfully removed $removed_count items."
}

stop_services() {
    section_header "Stopping Services"
    print_status "$BLUE" "$INFO" "Stopping any running services and processes..."
    
    # Stop daemon process
    if pgrep -f "internet_monitor_daemon.sh" >/dev/null; then
        pkill -f "internet_monitor_daemon.sh" && print_status "$GREEN" "$CHECK" "Stopped daemon process"
    fi
    
    # Stop conky instances
    if pgrep -f "conky -c .*conkyrc_internet" >/dev/null; then
        pkill -f "conky -c .*conkyrc_internet" && print_status "$GREEN" "$CHECK" "Stopped conky instances"
    fi
    
    # Disable systemd services
    if systemctl --user is-enabled internet-monitor.timer >/dev/null 2>&1; then
        systemctl --user disable --now internet-monitor.timer && print_status "$GREEN" "$CHECK" "Disabled systemd timer"
    fi
    
    # Remove cron jobs
    if crontab -l 2>/dev/null | grep -q "internet_monitor.sh"; then
        (crontab -l 2>/dev/null | grep -v "internet_monitor.sh" | crontab -) && print_status "$GREEN" "$CHECK" "Removed cron job"
    fi
    
    print_status "$GREEN" "$CHECK" "All services stopped and disabled."
}

create_backup() {
    read -p "Do you want to back up your configuration and data before uninstalling? (Y/n): " -n 1 -r; echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        local backup_dir="$HOME/.internet_monitor_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        
        local backed_up=0
        if [ -d "$HOME/.config/internet-usage-monitor-git" ]; then
            cp -r "$HOME/.config/internet-usage-monitor-git" "$backup_dir/" && ((backed_up++))
        fi
        
        if [ -d "$HOME/.local/share/internet-usage-monitor-git" ]; then
            cp -r "$HOME/.local/share/internet-usage-monitor-git" "$backup_dir/" && ((backed_up++))
        fi
        
        if [ $backed_up -gt 0 ]; then
            print_status "$GREEN" "$CHECK" "Backup created at $backup_dir"
        else
            print_status "$YELLOW" "$WARNING" "No configuration or data files found to backup"
            rmdir "$backup_dir" 2>/dev/null || true
        fi
    else
        print_status "$BLUE" "$INFO" "Skipping backup."
    fi
}

# --- MAIN EXECUTION FLOW ---

main() {
    # First, scan the system
    if ! scan_system; then
        echo
        print_status "$BLUE" "$INFO" "Nothing to uninstall. Exiting."
        exit 0
    fi
    
    echo
    read -p "Do you want to proceed with uninstallation? (y/N): " -n 1 -r; echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "$BLUE" "$INFO" "Uninstallation cancelled by user."
        exit 0
    fi

    # Stop services first
    stop_services

    # Create backup if requested
    create_backup

    # Get items to remove
    local items_to_remove
    mapfile -t items_to_remove < <(find_installed_items)
    
    # Remove items
    if [ ${#items_to_remove[@]} -gt 0 ]; then
        remove_items "${items_to_remove[@]}"
    fi

    section_header "Uninstallation Complete"
    print_status "$GREEN" "$ROCKET" "All components of the Internet Usage Monitor have been successfully removed."
    print_status "$BLUE" "$INFO" "Your system is now clean."
}

main "$@"
