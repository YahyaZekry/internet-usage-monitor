#!/bin/bash

# Conky Helper Script for Internet Usage Monitor
# Extracts and formats data from usage data file

# Load configuration
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Try to load config from different possible locations
if [ -f "$SCRIPT_DIR/../config/config.sh" ]; then
    # Running from project directory
    source "$SCRIPT_DIR/../config/config.sh"
elif [ -f "$SCRIPT_DIR/config.sh" ]; then
    # Running from installed location (same directory)
    source "$SCRIPT_DIR/config.sh"
elif [ -f "$HOME/config.sh" ]; then
    # Running from installed location (home directory)
    source "$HOME/config.sh"
else
    echo "Error: Could not find config.sh in any expected location" >&2
    echo "Looked for:" >&2
    echo "  $SCRIPT_DIR/../config/config.sh" >&2
    echo "  $SCRIPT_DIR/config.sh" >&2
    echo "  $HOME/config.sh" >&2
    exit 1
fi

# Function to extract daily usage in bytes
get_daily_usage_bytes() {
    if [[ -f "$USAGE_DATA_FILE" ]]; then
        grep "daily_usage=" "$USAGE_DATA_FILE" 2>/dev/null | cut -d'=' -f2 || echo "0"
    else
        echo "0"
    fi
}

# Function to get current date from usage file
get_current_date() {
    if [[ -f "$USAGE_DATA_FILE" ]]; then
        grep "last_date=" "$USAGE_DATA_FILE" 2>/dev/null | cut -d'"' -f2 || date '+%Y-%m-%d'
    else
        date '+%Y-%m-%d'
    fi
}

# Function to check if monitor is running
is_monitor_running() {
    # Check for both daemon and recent cron activity
    if pgrep -f "internet_monitor_daemon.sh" > /dev/null; then
        echo "true"
    elif [ -f "$USAGE_DATA_FILE" ]; then
        # Check if data file was updated recently (within last 10 minutes)
        local last_modified=$(stat -c %Y "$USAGE_DATA_FILE" 2>/dev/null || echo 0)
        local current_time=$(date +%s)
        local time_diff=$((current_time - last_modified))
        if [ $time_diff -lt 600 ]; then  # 600 seconds = 10 minutes
            echo "true"
        else
            echo "false"
        fi
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
    echo "scale=3; $bytes / 1024 / 1024 / 1024" | bc -l 2>/dev/null || echo "0.000"
}

# Function to get usage percentage
get_usage_percentage() {
    local usage_bytes=$(get_daily_usage_bytes)
    # Ensure usage_bytes is a valid number
    if [[ ! "$usage_bytes" =~ ^[0-9]+$ ]]; then
        usage_bytes=0
    fi
    echo "scale=1; $usage_bytes * 100 / $DAILY_LIMIT_BYTES" | bc -l 2>/dev/null || echo "0.0"
}

# Function to determine status based on usage
get_usage_status() {
    local usage_bytes=$(get_daily_usage_bytes)
    local usage_percent=$(get_usage_percentage)
    
    if (( $(echo "$usage_percent >= $CRITICAL_THRESHOLD" | bc -l 2>/dev/null || echo "0") )); then
        echo "LIMIT EXCEEDED"
    elif (( $(echo "$usage_percent >= $WARNING_THRESHOLD" | bc -l 2>/dev/null || echo "0") )); then
        echo "High Usage"
    else
        echo "Normal"
    fi
}

case "$1" in
    "date")
        get_current_date
        ;;
    "usage")
        usage_bytes=$(get_daily_usage_bytes)
        usage_gb=$(bytes_to_gb $usage_bytes)
        printf "%.2f GB" $usage_gb
        ;;
    "usage_mb")
        usage_bytes=$(get_daily_usage_bytes)
        usage_mb=$(bytes_to_mb $usage_bytes)
        printf "%.2f MB" $usage_mb
        ;;
    "limit")
        printf "%.2f GB" $DAILY_LIMIT_GB
        ;;
    "remaining")
        usage_bytes=$(get_daily_usage_bytes)
        remaining_bytes=$((DAILY_LIMIT_BYTES - usage_bytes))
        if [[ $remaining_bytes -lt 0 ]]; then
            remaining_bytes=0
        fi
        remaining_gb=$(bytes_to_gb $remaining_bytes)
        printf "%.2f GB" $remaining_gb
        ;;
    "remaining_mb")
        usage_bytes=$(get_daily_usage_bytes)
        remaining_bytes=$((DAILY_LIMIT_BYTES - usage_bytes))
        if [[ $remaining_bytes -lt 0 ]]; then
            remaining_bytes=0
        fi
        remaining_mb=$(bytes_to_mb $remaining_bytes)
        printf "%.2f MB" $remaining_mb
        ;;
    "percentage")
        usage_percent=$(get_usage_percentage)
        printf "%.1f%%" $usage_percent
        ;;
    "progress_bar"|"bar_percent")
        usage_percent=$(get_usage_percentage)
        # Ensure percentage doesn't exceed 100 for the bar
        if (( $(echo "$usage_percent > 100" | bc -l 2>/dev/null || echo "0") )); then
            usage_percent=100
        fi
        printf "%.0f" $usage_percent
        ;;
    "status")
        get_usage_status
        ;;
    "monitor_status")
        if [[ $(is_monitor_running) == "true" ]]; then
            echo "Running"
        else
            echo "Stopped"
        fi
        ;;
    "interface")
        if [[ -f "$USAGE_DATA_FILE" ]]; then
            grep "current_interface=" "$USAGE_DATA_FILE" 2>/dev/null | cut -d'"' -f2 || echo "Unknown"
        else
            echo "Unknown"
        fi
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
    *)
        echo "Usage: $0 {date|usage|usage_mb|limit|remaining|remaining_mb|percentage|progress_bar|bar_percent|status|monitor_status|interface|config_limit|warning_threshold|critical_threshold}"
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
        echo ""
        echo "Configuration options:"
        echo "  config_limit      - Configured daily limit"
        echo "  warning_threshold - Warning threshold percentage"
        echo "  critical_threshold- Critical threshold percentage"
        exit 1
        ;;
esac
