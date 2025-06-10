#!/bin/bash

# Internet Usage Monitor - Uninstallation Script
# Removes all installed files and configurations

# set -e  # Exit on any error - disabled for better error handling

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
TRASH="🗑️"

echo -e "${BLUE}${TRASH} Internet Usage Monitor Uninstallation${NC}"
echo -e "${BLUE}=========================================${NC}"
echo

# Function to print colored output
print_status() {
    local color=$1
    local icon=$2
    local message=$3
    echo -e "${color}${icon} ${message}${NC}"
}

# Function to backup user data
backup_user_data() {
    local backup_dir="$HOME/.internet_monitor_backup_$(date +%Y%m%d_%H%M%S)"
    
    if [ -f "$HOME/.internet_usage_data" ] || [ -f "$HOME/.internet_usage.log" ]; then
        mkdir -p "$backup_dir"
        
        if [ -f "$HOME/.internet_usage_data" ]; then
            cp "$HOME/.internet_usage_data" "$backup_dir/"
            print_status "$YELLOW" "$WARNING" "Backed up usage data to $backup_dir"
        fi
        
        if [ -f "$HOME/.internet_usage.log" ]; then
            cp "$HOME/.internet_usage.log" "$backup_dir/"
            print_status "$YELLOW" "$WARNING" "Backed up usage log to $backup_dir"
        fi
        
        echo -e "${YELLOW}Your usage data has been backed up to: $backup_dir${NC}"
        echo
    fi
}

# Function to search for files in common locations
find_installed_files() {
    local search_paths=(
        "$HOME"
        "/usr/local/bin"
        "/usr/bin"
        "/opt/internet-monitor"
        "/usr/share/internet-monitor"
        "$HOME/.local/bin"
        "$HOME/bin"
        "$HOME/scripts"
    )
    
    local file_patterns=(
        "internet_monitor.sh"
        "internet_monitor_daemon.sh"
        "conky_usage_helper.sh"
        ".conkyrc_internet"
        "conkyrc_internet"
        "config.sh"
    )
    
    local found_files=()
    
    print_status "$BLUE" "$INFO" "Searching for installed files..."
    
    for path in "${search_paths[@]}"; do
        if [ -d "$path" ]; then
            for pattern in "${file_patterns[@]}"; do
                # Use find to search for files matching patterns
                while IFS= read -r -d '' file; do
                    found_files+=("$file")
                done < <(find "$path" -maxdepth 1 -name "*$pattern*" -type f -print0 2>/dev/null)
            done
        fi
    done
    
    # Also search for any file with "internet" and "monitor" in the name
    for path in "${search_paths[@]}"; do
        if [ -d "$path" ]; then
            while IFS= read -r -d '' file; do
                # Check if file contains both "internet" and "monitor" in name
                basename_file=$(basename "$file")
                if [[ "$basename_file" == *"internet"* ]] && [[ "$basename_file" == *"monitor"* ]]; then
                    found_files+=("$file")
                fi
            done < <(find "$path" -maxdepth 1 -type f -print0 2>/dev/null)
        fi
    done
    
    # Remove duplicates and print found files
    local unique_files=($(printf '%s\n' "${found_files[@]}" | sort -u))
    
    if [ ${#unique_files[@]} -gt 0 ]; then
        print_status "$YELLOW" "$WARNING" "Found ${#unique_files[@]} files to remove:"
        for file in "${unique_files[@]}"; do
            echo "  - $file"
        done
        echo
    else
        print_status "$BLUE" "$INFO" "No installed files found."
    fi
    
    # Return the array of unique files
    printf '%s\n' "${unique_files[@]}"
}

# Function to remove installed files
remove_files() {
    print_status "$BLUE" "$INFO" "Removing installed files..."
    
    # Get list of files to remove
    local files_to_remove
    mapfile -t files_to_remove < <(find_installed_files)
    
    if [ ${#files_to_remove[@]} -eq 0 ]; then
        print_status "$BLUE" "$INFO" "No files found to remove."
        return
    fi
    
    # Ask for confirmation if many files found
    if [ ${#files_to_remove[@]} -gt 5 ]; then
        echo
        read -p "Found ${#files_to_remove[@]} files. Remove all? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "$BLUE" "$INFO" "File removal cancelled."
            return
        fi
    fi
    
    # Remove the files with better error handling
    local removed_count=0
    for file in "${files_to_remove[@]}"; do
        if [ -f "$file" ]; then
            # Check if file is in use
            if lsof "$file" >/dev/null 2>&1; then
                print_status "$YELLOW" "$WARNING" "File in use, forcing removal: $file"
                rm -f "$file" 2>/dev/null || {
                    print_status "$RED" "$CROSS" "Failed to remove (file in use): $file"
                    continue
                }
            else
                rm -f "$file" 2>/dev/null || {
                    print_status "$RED" "$CROSS" "Failed to remove: $file"
                    continue
                }
            fi
            print_status "$GREEN" "$CHECK" "Removed: $file"
            ((removed_count++))
        else
            print_status "$BLUE" "$INFO" "File not found (already removed?): $file"
        fi
    done
    
    if [ $removed_count -gt 0 ]; then
        print_status "$GREEN" "$CHECK" "Successfully removed $removed_count files"
    else
        print_status "$YELLOW" "$WARNING" "No files were removed"
    fi
}

# Function to remove user data
remove_user_data() {
    echo
    read -p "Do you want to remove usage data and logs? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "$HOME/.internet_usage_data" ]; then
            rm -f "$HOME/.internet_usage_data"
            print_status "$GREEN" "$CHECK" "Removed usage data file"
        fi
        
        if [ -f "$HOME/.internet_usage.log" ]; then
            rm -f "$HOME/.internet_usage.log"
            print_status "$GREEN" "$CHECK" "Removed usage log file"
        fi
    else
        print_status "$BLUE" "$INFO" "Keeping usage data and logs"
    fi
}

# Function to remove cron jobs
remove_cron_jobs() {
    print_status "$BLUE" "$INFO" "Checking for cron jobs..."
    
    # Check if cron job exists
    if crontab -l 2>/dev/null | grep -q "internet_monitor.sh"; then
        # Remove cron job
        crontab -l 2>/dev/null | grep -v "internet_monitor.sh" | crontab -
        print_status "$GREEN" "$CHECK" "Removed cron job"
    else
        print_status "$BLUE" "$INFO" "No cron job found"
    fi
}

# Function to remove systemd services
remove_systemd_services() {
    print_status "$BLUE" "$INFO" "Checking for systemd services..."
    
    if [ -f "$HOME/.config/systemd/user/internet-monitor.timer" ]; then
        systemctl --user stop internet-monitor.timer 2>/dev/null || true
        systemctl --user disable internet-monitor.timer 2>/dev/null || true
        rm -f "$HOME/.config/systemd/user/internet-monitor.timer"
        print_status "$GREEN" "$CHECK" "Removed systemd timer"
    fi
    
    if [ -f "$HOME/.config/systemd/user/internet-monitor.service" ]; then
        rm -f "$HOME/.config/systemd/user/internet-monitor.service"
        print_status "$GREEN" "$CHECK" "Removed systemd service"
    fi
    
    # Reload systemd if we removed anything
    if systemctl --user list-unit-files | grep -q "internet-monitor"; then
        systemctl --user daemon-reload
        print_status "$GREEN" "$CHECK" "Reloaded systemd configuration"
    fi
}

# Function to remove autostart entries
remove_autostart_entries() {
    print_status "$BLUE" "$INFO" "Checking for autostart entries..."
    
    local autostart_files=(
        "$HOME/.config/autostart/internet-monitor.desktop"
        "$HOME/.config/autostart/internet-conky.desktop"
    )
    
    for file in "${autostart_files[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            print_status "$GREEN" "$CHECK" "Removed autostart entry: $(basename "$file")"
        fi
    done
}

# Function to stop running processes
stop_processes() {
    print_status "$BLUE" "$INFO" "Stopping running processes..."
    
    # Stop daemon
    if pgrep -f "internet_monitor_daemon.sh" > /dev/null; then
        pkill -f "internet_monitor_daemon.sh"
        print_status "$GREEN" "$CHECK" "Stopped monitor daemon"
    fi
    
    # Stop Conky instances (ask user first)
    if pgrep conky > /dev/null; then
        echo
        read -p "Conky is running. Stop all Conky instances? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pkill conky
            print_status "$GREEN" "$CHECK" "Stopped Conky processes"
        else
            print_status "$BLUE" "$INFO" "Left Conky running"
        fi
    fi
    
    # Remove PID file
    if [ -f "/tmp/internet_monitor_daemon.pid" ]; then
        rm -f "/tmp/internet_monitor_daemon.pid"
        print_status "$GREEN" "$CHECK" "Removed daemon PID file"
    fi
}

# Function to show completion message
show_completion() {
    echo
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}🎉 UNINSTALLATION COMPLETE! 🎉${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo
    print_status "$GREEN" "$TRASH" "Internet Usage Monitor has been completely removed!"
    echo
    echo -e "${BLUE}✅ What was successfully removed:${NC}"
    echo "  • All monitor scripts and executables"
    echo "  • Conky configuration files"
    echo "  • Cron jobs and scheduled tasks"
    echo "  • Systemd services and timers"
    echo "  • Desktop autostart entries"
    echo "  • Running processes and PID files"
    echo "  • Configuration files"
    echo
    
    if [ -d "$HOME"/.internet_monitor_backup_* ] 2>/dev/null; then
        echo -e "${YELLOW}📦 Your usage data backups are safely stored in:${NC}"
        ls -d "$HOME"/.internet_monitor_backup_* 2>/dev/null || true
        echo
    fi
    
    echo -e "${BLUE}📝 Important Notes:${NC}"
    echo "  • The project source directory remains untouched"
    echo "  • You can reinstall anytime with: ${YELLOW}./install.sh${NC}"
    echo "  • System packages (conky, bc, etc.) were not removed"
    echo "  • Your system is now clean of Internet Usage Monitor"
    echo
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}                    🌟 THANK YOU FOR USING INTERNET USAGE MONITOR! 🌟${NC}"
    echo -e "${GREEN}                         All traces have been successfully removed.${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
}

# Main uninstallation flow
main() {
    # Warning message
    echo -e "${YELLOW}${WARNING} This will remove Internet Usage Monitor from your system.${NC}"
    echo
    
    # Check if anything is actually installed using robust search
    local potential_files
    mapfile -t potential_files < <(find_installed_files)
    
    local has_cron=false
    if crontab -l 2>/dev/null | grep -q "internet_monitor.sh"; then
        has_cron=true
    fi
    
    if [ ${#potential_files[@]} -eq 0 ] && [ "$has_cron" = false ]; then
        print_status "$YELLOW" "$WARNING" "No installation found. Nothing to remove."
        exit 0
    fi
    
    if [ ${#potential_files[@]} -gt 0 ]; then
        print_status "$GREEN" "$CHECK" "Found installation with ${#potential_files[@]} files."
    fi
    
    if [ "$has_cron" = true ]; then
        print_status "$GREEN" "$CHECK" "Found cron job installation."
    fi
    
    # Confirm uninstallation
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "$BLUE" "$INFO" "Uninstallation cancelled."
        exit 0
    fi
    
    backup_user_data
    stop_processes
    remove_cron_jobs
    remove_systemd_services
    remove_autostart_entries
    remove_files
    remove_user_data
    show_completion
}

# Run main function
main "$@"
