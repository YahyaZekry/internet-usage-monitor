#!/bin/bash

# Internet Usage Monitor - Shared Configuration
# This file contains all configurable settings for the internet usage monitor

# Daily data usage limit (in GB)
DAILY_LIMIT_GB=2

# Notification thresholds (percentage of daily limit)
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=100

# Network interface (set to "auto" for automatic detection)
NETWORK_INTERFACE="auto"

# Notification settings
NOTIFICATION_DURATION=10000  # Duration in milliseconds
NOTIFICATION_URGENCY_WARNING="normal"
NOTIFICATION_URGENCY_CRITICAL="critical"

# Update intervals
DAEMON_UPDATE_INTERVAL=30    # Seconds between checks in daemon mode
CRON_RECOMMENDED_INTERVAL=5  # Minutes for cron job setup

# File locations
USAGE_DATA_FILE="$HOME/.internet_usage_data"
LOG_FILE="$HOME/.internet_usage.log"

# Derived values (don't modify these)
DAILY_LIMIT_BYTES=$((DAILY_LIMIT_GB * 1024 * 1024 * 1024))
WARNING_BYTES=$((DAILY_LIMIT_BYTES * WARNING_THRESHOLD / 100))
CRITICAL_BYTES=$((DAILY_LIMIT_BYTES * CRITICAL_THRESHOLD / 100))

# Function to detect network interface
get_network_interface() {
    if [ "$NETWORK_INTERFACE" = "auto" ]; then
        ip route | grep default | awk '{print $5}' | head -n1
    else
        echo "$NETWORK_INTERFACE"
    fi
}

# Function to load this config (call from other scripts)
load_config() {
    local config_file="$(dirname "${BASH_SOURCE[0]}")/config.sh"
    if [ -f "$config_file" ]; then
        source "$config_file"
    else
        echo "Warning: Config file not found at $config_file" >&2
        return 1
    fi
}
