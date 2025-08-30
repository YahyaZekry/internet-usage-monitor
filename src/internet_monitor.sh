#!/bin/bash

# Internet Usage Monitor Script
# Tracks daily internet usage and sends notifications when exceeding thresholds
# This version runs once and exits (perfect for cron jobs)

# Source the common configuration and functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Check for required dependencies
check_dependencies "bc" "ip" "cat"

# Function to get current network stats
get_network_stats() {
    local interface=$1
    local rx_bytes
    local tx_bytes
    rx_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes" 2>/dev/null || echo 0)
    tx_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes" 2>/dev/null || echo 0)
    echo $((rx_bytes + tx_bytes))
}


# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="$3"
    
    # Try different notification methods
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" -u "$urgency" -t "$NOTIFICATION_DURATION"
    elif command -v zenity >/dev/null 2>&1; then
        zenity --info --title="$title" --text="$message" &
    else
        echo "NOTIFICATION: $title - $message"
    fi
    
    log_message "NOTIFICATION ($urgency): $title - $message"
}

# Initialize or read usage data
today=$(date '+%Y-%m-%d')

if [ -f "$USAGE_DATA_FILE" ]; then
    source "$USAGE_DATA_FILE"
    # Initialize new monthly vars if they don't exist from sourced file
    current_month="${current_month:-$(date '+%Y-%m')}"
    monthly_usage="${monthly_usage:-0}"
else
    last_date=""
    last_total=0
    daily_usage=0
    warning_sent=false
    critical_sent=false
    current_month="$(date '+%Y-%m')"
    monthly_usage=0
fi

# Monthly reset logic
this_month=$(date '+%Y-%m')
if [ "$current_month" != "$this_month" ]; then
    log_message "New month started ($this_month), resetting monthly usage counter."
    monthly_usage=0
    current_month="$this_month"
    # Optionally, reset daily counters too if a new month implies a new day for sure
    # daily_usage=0 # This is already handled by daily reset logic below
    # warning_sent=false
    # critical_sent=false
    # last_date="$today" # Ensure daily reset also happens if month reset occurs
fi

# Reset daily usage if it's a new day
if [ "$last_date" != "$today" ]; then
    daily_usage=0
    warning_sent=false
    critical_sent=false
    last_date="$today"
    log_message "New day started, resetting daily usage counter"
fi

# Get current network interface and total usage
current_interface=$(get_network_interface)
current_total=$(get_network_stats "$current_interface")

# Calculate usage since last check
if [ $last_total -gt 0 ] && [ $current_total -gt $last_total ]; then
    usage_diff=$((current_total - last_total))
    daily_usage=$((daily_usage + usage_diff))
    monthly_usage=$((monthly_usage + usage_diff)) # Accumulate monthly usage
fi

# Update last total
last_total=$current_total

# Function to save usage data
save_usage_data() {
    cat > "$USAGE_DATA_FILE" << EOF
last_date="$last_date"
last_total=$last_total
daily_usage=$daily_usage
warning_sent=$warning_sent
critical_sent=$critical_sent
current_interface="$current_interface"
current_month="$current_month"
monthly_usage=$monthly_usage
EOF
}

# Save current state
save_usage_data

# Check thresholds and send notifications
usage_human=$(bytes_to_human $daily_usage)
percentage=$(echo "scale=1; $daily_usage * 100 / $DAILY_LIMIT_BYTES" | bc)

# Check for warning threshold (80%)
if [ $daily_usage -gt $WARNING_BYTES ] && [ "$warning_sent" != "true" ]; then
    send_notification "Internet Usage Warning" "High usage detected! Used: $usage_human (${percentage}% of ${DAILY_LIMIT_GB}GB limit)" "$NOTIFICATION_URGENCY_WARNING"
    warning_sent=true
fi

# Check for critical threshold (100%)
if [ $daily_usage -gt $CRITICAL_BYTES ] && [ "$critical_sent" != "true" ]; then
    send_notification "Internet Usage Alert" "Daily limit exceeded! Used: $usage_human (${percentage}% of ${DAILY_LIMIT_GB}GB limit)" "$NOTIFICATION_URGENCY_CRITICAL"
    critical_sent=true
fi

# Save the state again if a notification was sent
if [ "$warning_sent" = "true" ] || [ "$critical_sent" = "true" ]; then
    save_usage_data
fi

# Log current usage
log_message "Daily usage: $usage_human (${percentage}% of ${DAILY_LIMIT_GB}GB limit) on interface $current_interface"

# Handle command line arguments
case "${1:-}" in
    "usage"|"status")
        echo "Daily usage: $usage_human (${percentage}% of ${DAILY_LIMIT_GB}GB limit)"
        echo "Interface: $current_interface"
        echo "Status: $([ $daily_usage -gt $CRITICAL_BYTES ] && echo "LIMIT EXCEEDED" || [ $daily_usage -gt $WARNING_BYTES ] && echo "High Usage" || echo "Normal")"
        ;;
    "reset")
        daily_usage=0
        warning_sent=false
        critical_sent=false
        save_usage_data
        log_message "Usage manually reset"
        echo "Daily usage counter reset."
        ;;
    "test-warning")
        daily_usage=$((WARNING_BYTES + 1)) # Set just above threshold
        warning_sent=false # Ensure warning can be sent
        # critical_sent should remain as is, or be false if we want a clean slate from critical
        save_usage_data
        echo "Set usage to just ABOVE warning threshold for testing."
        ;;
    "test-critical")
        daily_usage=$((CRITICAL_BYTES + 1)) # Set just above threshold
        warning_sent=false # Ensure warning can be sent again if it was also a critical trigger
        critical_sent=false # Ensure critical can be sent
        save_usage_data
        echo "Set usage to just ABOVE critical threshold for testing."
        ;;
    "help")
        echo "Usage: $0 [usage|reset|test-warning|test-critical|help]"
        echo "  usage         - Show current usage status"
        echo "  reset         - Reset daily usage counter"
        echo "  test-warning  - Set usage to warning threshold (for testing)"
        echo "  test-critical - Set usage to critical threshold (for testing)"
        echo "  help          - Show this help message"
        ;;
esac
