#!/bin/bash

# Internet Usage Monitor Script
# Tracks daily internet usage and sends notification when exceeding 2GB limit

# Configuration
DAILY_LIMIT_GB=2
DAILY_LIMIT_BYTES=$((DAILY_LIMIT_GB * 1024 * 1024 * 1024))
USAGE_FILE="$HOME/.internet_usage_data"
LOG_FILE="$HOME/.internet_usage.log"
NETWORK_INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Function to get current network stats
get_network_stats() {
    local interface=$1
    local rx_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes" 2>/dev/null || echo 0)
    local tx_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes" 2>/dev/null || echo 0)
    echo $((rx_bytes + tx_bytes))
}

# Function to convert bytes to human readable format
bytes_to_human() {
    local bytes=$1
    if [ $bytes -gt 1073741824 ]; then
        echo "$(echo "scale=2; $bytes/1073741824" | bc) GB"
    elif [ $bytes -gt 1048576 ]; then
        echo "$(echo "scale=2; $bytes/1048576" | bc) MB"
    elif [ $bytes -gt 1024 ]; then
        echo "$(echo "scale=2; $bytes/1024" | bc) KB"
    else
        echo "$bytes B"
    fi
}

# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"
    
    # Try different notification methods
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" -u critical -t 10000
    elif command -v zenity >/dev/null 2>&1; then
        zenity --info --title="$title" --text="$message" &
    else
        echo "NOTIFICATION: $title - $message"
    fi
    
    log_message "NOTIFICATION: $title - $message"
}

# Initialize or read usage data
today=$(date '+%Y-%m-%d')

if [ -f "$USAGE_FILE" ]; then
    source "$USAGE_FILE"
else
    last_date=""
    last_total=0
    daily_usage=0
    notification_sent=false
fi

# Reset daily usage if it's a new day
if [ "$last_date" != "$today" ]; then
    daily_usage=0
    notification_sent=false
    last_date="$today"
    log_message "New day started, resetting daily usage counter"
fi

# Get current total network usage
current_total=$(get_network_stats "$NETWORK_INTERFACE")

# Calculate usage since last check
if [ $last_total -gt 0 ] && [ $current_total -gt $last_total ]; then
    usage_diff=$((current_total - last_total))
    daily_usage=$((daily_usage + usage_diff))
fi

# Update last total
last_total=$current_total

# Function to save usage data
save_usage_data() {
    cat > "$USAGE_FILE" << EOF
last_date="$last_date"
last_total=$last_total
daily_usage=$daily_usage
notification_sent=$notification_sent
EOF
}

# Save current state
save_usage_data

# Check if daily limit is exceeded
if [ $daily_usage -gt $DAILY_LIMIT_BYTES ] && [ "$notification_sent" != "true" ]; then
    usage_human=$(bytes_to_human $daily_usage)
    send_notification "Internet Usage Alert" "Daily limit exceeded! Used: $usage_human (Limit: ${DAILY_LIMIT_GB}GB)"
    
    # Update notification sent flag
    sed -i 's/notification_sent=false/notification_sent=true/' "$USAGE_FILE"
fi

# Log current usage (optional, for debugging)
usage_human=$(bytes_to_human $daily_usage)
percentage=$(echo "scale=1; $daily_usage * 100 / $DAILY_LIMIT_BYTES" | bc)
log_message "Daily usage: $usage_human (${percentage}% of ${DAILY_LIMIT_GB}GB limit)"

# Continuous monitoring loop
log_message "Internet monitor started - checking every 30 seconds"
while true; do
    sleep 30
    
    # Check if it's a new day
    current_date=$(date '+%Y-%m-%d')
    if [[ -f "$USAGE_FILE" ]]; then
        source "$USAGE_FILE"
        if [[ "$current_date" != "$last_date" ]]; then
            # New day - reset usage
            log_message "New day detected: $current_date (was $last_date)"
            daily_usage=0
            notification_sent=false
            last_date="$current_date"
        fi
    fi
    
    # Get current network usage
    current_total=$(get_network_stats "$NETWORK_INTERFACE")
    if [[ $current_total -gt $last_total ]]; then
        # Calculate new daily usage
        session_usage=$((current_total - last_total))
        daily_usage=$((daily_usage + session_usage))
        last_total=$current_total
        
        # Save updated data
        save_usage_data
        
        # Check for limit exceeded
        if [[ $daily_usage -ge $DAILY_LIMIT_BYTES ]] && [[ "$notification_sent" == "false" ]]; then
            usage_gb=$(echo "scale=2; $daily_usage / 1024 / 1024 / 1024" | bc)
            send_notification "Internet Usage Limit Exceeded!" "You have used ${usage_gb}GB today, exceeding your ${DAILY_LIMIT_GB}GB daily limit."
            notification_sent=true
            save_usage_data
            log_message "Limit exceeded notification sent"
        fi
        
        # Log periodic updates (every hour or when significant usage detected)
        if (( daily_usage % (100 * 1024 * 1024) < session_usage )); then
            usage_human=$(bytes_to_human $daily_usage)
            percentage=$(echo "scale=1; $daily_usage * 100 / $DAILY_LIMIT_BYTES" | bc)
            log_message "Usage update: $usage_human (${percentage}%)"
        fi
    fi
done

