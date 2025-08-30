#!/bin/bash

# Conky Helper Script for Internet Usage Monitor
# Extracts and formats data from usage data file

# Source the common configuration and functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Check for required dependencies
check_dependencies "bc" "stat" "pgrep"

# --- Data Loading ---

# Source the usage data file to get all variables at once.
# Provide default values to prevent errors if the file is empty or corrupted.
if [[ -f "$USAGE_DATA_FILE" ]]; then
    source "$USAGE_DATA_FILE"
fi
daily_usage=${daily_usage:-0}
monthly_usage=${monthly_usage:-0}
last_date=${last_date:-$(date '+%Y-%m-%d')}
current_interface=${current_interface:-"Unknown"}

# Function to check if monitor is running
is_monitor_running() {
    # Check for the daemon process PID file first
    if [ -f "$RUNTIME_DIR/daemon.pid" ] && ps -p "$(cat "$RUNTIME_DIR/daemon.pid")" > /dev/null; then
        echo "true"
    # Fallback to checking if the data file was updated recently (for cron users)
    elif [ -f "$USAGE_DATA_FILE" ]; then
        local last_modified
        last_modified=$(stat -c %Y "$USAGE_DATA_FILE" 2>/dev/null || echo 0)
        local time_diff=$(( $(date +%s) - last_modified ))
        [ "$time_diff" -lt 600 ] && echo "true" || echo "false"
    else
        echo "false"
    fi
}

# Function to convert bytes to human readable format
bytes_to_mb() {
    local bytes=$1
    # Ensure bytes is a valid number
    if [[ ! "$bytes" =~ ^[0-9]+$ ]]; then
        bytes=0
    fi
    echo "scale=2; $bytes / 1024 / 1024" | bc -l 2>/dev/null || echo "0.00"
}

bytes_to_gb() {
    local bytes=$1
    # Ensure bytes is a valid number
    if [[ ! "$bytes" =~ ^[0-9]+$ ]]; then
        bytes=0
    fi
    # Use awk for safe division
    awk -v b="$bytes" 'BEGIN {printf "%.2f", b/1073741824}'
}

# Calculate percentage using awk for safety and consistency
usage_percentage=$(awk -v used="$daily_usage" -v total="$DAILY_LIMIT_BYTES" 'BEGIN {if (total > 0) {printf "%.1f", (used/total)*100} else {print "0.0"}}')

# --- Command Handling ---

case "$1" in
    "date")
        echo "$last_date"
        ;;
    "usage")
        bytes_to_gb "$daily_usage" | sed 's/$/ GB/'
        ;;
    "usage_mb")
        bytes_to_mb "$daily_usage" | sed 's/$/ MB/'
        ;;
    "limit")
        printf "%.2f GB" "$DAILY_LIMIT_GB"
        ;;
    "remaining")
        remaining_bytes=$((DAILY_LIMIT_BYTES - daily_usage))
        if [[ $remaining_bytes -lt 0 ]]; then
            remaining_bytes=0
        fi
        bytes_to_gb $remaining_bytes | sed 's/$/ GB/'
        ;;
    "remaining_mb")
        remaining_bytes=$((DAILY_LIMIT_BYTES - daily_usage))
        if [[ $remaining_bytes -lt 0 ]]; then
            remaining_bytes=0
        fi
        bytes_to_mb $remaining_bytes | sed 's/$/ MB/'
        ;;
    "percentage")
        printf "%.1f%%" "$usage_percentage"
        ;;
    "progress_bar"|"bar_percent")
        # Ensure percentage doesn't exceed 100 for the bar
        bar_percent=$(printf "%.0f" "$usage_percentage")
        if (( bar_percent > 100 )); then
            echo "100"
        else
            echo "$bar_percent"
        fi
        ;;
    "status")
        if (( $(echo "$usage_percentage >= $CRITICAL_THRESHOLD" | bc -l) )); then
            echo "LIMIT EXCEEDED"
        elif (( $(echo "$usage_percentage >= $WARNING_THRESHOLD" | bc -l) )); then
            echo "High Usage"
        else
            echo "Normal"
        fi
        ;;
    "monitor_status")
        if [[ $(is_monitor_running) == "true" ]]; then
            echo "Running"
        else
            echo "Stopped"
        fi
        ;;
    "interface")
        echo "$current_interface"
        ;;
    "config_limit")
        echo "$DAILY_LIMIT_GB GB"
        ;;
    "warning_threshold")
        echo "$WARNING_THRESHOLD%"
        ;;
    "critical_threshold")
        echo "$CRITICAL_THRESHOLD%"
        ;;
    "monthly_usage_gb")
        bytes_to_gb "$monthly_usage" | sed 's/$/ GB/'
        ;;
    *)
        echo "Usage: $0 {date|usage|usage_mb|limit|remaining|remaining_mb|percentage|progress_bar|bar_percent|status|monitor_status|interface|config_limit|warning_threshold|critical_threshold|monthly_usage_gb}"
        echo ""
        echo "Data display options:"
        echo "  date              - Current date from usage file"
        echo "  usage             - Current usage in GB"
        echo "  usage_mb          - Current usage in MB"
        echo "  limit             - Daily limit in GB"
        echo "  remaining         - Remaining data in GB"
        echo "  remaining_mb      - Remaining data in MB"
        echo "  percentage        - Usage percentage"
        echo "  progress_bar      - Progress bar percentage (0-100)"
        echo "  status            - Usage status (Normal/High Usage/LIMIT EXCEEDED)"
        echo ""
        echo "System status options:"
        echo "  monitor_status    - Monitor running status"
        echo "  interface         - Current network interface"
        echo "  monthly_usage_gb  - Current monthly usage in GB"
        echo ""
        echo "Configuration options:"
        echo "  config_limit      - Configured daily limit"
        echo "  warning_threshold - Warning threshold percentage"
        echo "  critical_threshold- Critical threshold percentage"
        exit 1
        ;;
esac
