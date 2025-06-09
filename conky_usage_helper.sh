#!/bin/bash

# Conky Helper Script for Internet Usage Monitor
# Extracts and formats data from .internet_usage_data

USAGE_FILE="$HOME/.internet_usage_data"
DAILY_LIMIT_MB=2048
DAILY_LIMIT_BYTES=$((DAILY_LIMIT_MB * 1024 * 1024))

# Colors - we'll let Conky handle coloring
# The script just returns plain text

# Function to extract daily usage in bytes
get_daily_usage_bytes() {
    if [[ -f "$USAGE_FILE" ]]; then
        grep "daily_usage=" "$USAGE_FILE" 2>/dev/null | cut -d'=' -f2 || echo "0"
    else
        echo "0"
    fi
}

# Function to get current date from usage file
get_current_date() {
    if [[ -f "$USAGE_FILE" ]]; then
        grep "last_date=" "$USAGE_FILE" 2>/dev/null | cut -d'"' -f2 || date '+%Y-%m-%d'
    else
        date '+%Y-%m-%d'
    fi
}

# Function to check if monitor is running
is_monitor_running() {
    pgrep -f "internet_monitor.sh" > /dev/null
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

# Function to determine color based on usage
get_usage_color() {
    local usage_mb=$(bytes_to_mb $(get_daily_usage_bytes))
    local usage_percent=$(get_usage_percentage)
    
    if (( $(echo "$usage_percent >= 100" | bc -l 2>/dev/null || echo "0") )); then
        echo "$RED"
    elif (( $(echo "$usage_percent >= 80" | bc -l 2>/dev/null || echo "0") )); then
        echo "$YELLOW"
    else
        echo "$GREEN"
    fi
}

case "$1" in
    "date")
        get_current_date
        ;;
    "usage")
        usage_bytes=$(get_daily_usage_bytes)
        usage_mb=$(bytes_to_mb $usage_bytes)
        printf "%.2f MB" $usage_mb
        ;;
    "usage_colored")
        usage_bytes=$(get_daily_usage_bytes)
        usage_mb=$(bytes_to_mb $usage_bytes)
        color=$(get_usage_color)
        printf "%.2f MB" $usage_mb
        ;;
    "remaining")
        usage_bytes=$(get_daily_usage_bytes)
        remaining_bytes=$((DAILY_LIMIT_BYTES - usage_bytes))
        if [[ $remaining_bytes -lt 0 ]]; then
            remaining_bytes=0
        fi
        remaining_mb=$(bytes_to_mb $remaining_bytes)
        printf "%.2f MB" $remaining_mb
        ;;
    "remaining_colored")
        usage_bytes=$(get_daily_usage_bytes)
        remaining_bytes=$((DAILY_LIMIT_BYTES - usage_bytes))
        if [[ $remaining_bytes -lt 0 ]]; then
            remaining_bytes=0
        fi
        remaining_mb=$(bytes_to_mb $remaining_bytes)
        color=$(get_usage_color)
        printf "%.2f MB" $remaining_mb
        ;;
    "percentage")
        usage_percent=$(get_usage_percentage)
        printf "%.1f%%" $usage_percent
        ;;
    "percentage_colored")
        usage_percent=$(get_usage_percentage)
        color=$(get_usage_color)
        printf "%.1f%%" $usage_percent
        ;;
    "progress_bar")
        usage_percent=$(get_usage_percentage)
        # Ensure percentage doesn't exceed 100 for the bar
        if (( $(echo "$usage_percent > 100" | bc -l 2>/dev/null || echo "0") )); then
            usage_percent=100
        fi
        color=$(get_usage_color)
        printf "%.0f" $usage_percent
        ;;
    "status")
        usage_percent=$(get_usage_percentage)
        if (( $(echo "$usage_percent >= 100" | bc -l 2>/dev/null || echo "0") )); then
            echo "LIMIT EXCEEDED"
        elif (( $(echo "$usage_percent >= 80" | bc -l 2>/dev/null || echo "0") )); then
            echo "High Usage"
        else
            echo "Normal"
        fi
        ;;
    "status_colored")
        usage_percent=$(get_usage_percentage)
        if (( $(echo "$usage_percent >= 100" | bc -l 2>/dev/null || echo "0") )); then
            echo "LIMIT EXCEEDED"
        elif (( $(echo "$usage_percent >= 80" | bc -l 2>/dev/null || echo "0") )); then
            echo "High Usage"
        else
            echo "Normal"
        fi
        ;;
    "monitor_status")
        if is_monitor_running; then
            echo "Running"
        else
            echo "Stopped"
        fi
        ;;
    "bar_percent")
        usage_percent=$(get_usage_percentage)
        # Ensure percentage doesn't exceed 100 for the bar
        if (( $(echo "$usage_percent > 100" | bc -l 2>/dev/null || echo "0") )); then
            usage_percent=100
        fi
        printf "%.0f" $usage_percent
        ;;
    *)
        echo "Usage: $0 {date|usage|usage_colored|remaining|remaining_colored|percentage|percentage_colored|progress_bar|status|status_colored|monitor_status|bar_percent}"
        exit 1
        ;;
esac

