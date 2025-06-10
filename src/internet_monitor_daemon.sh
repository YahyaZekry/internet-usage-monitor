#!/bin/bash

# Internet Usage Monitor Daemon
# Runs the main monitor script continuously in a loop
# Use this for continuous monitoring instead of cron jobs

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

# Function to log daemon messages
log_daemon() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): [DAEMON] $1" >> "$LOG_FILE"
}

# Function to handle cleanup on exit
cleanup() {
    log_daemon "Daemon stopping (PID: $$)"
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Check if daemon is already running
DAEMON_PID_FILE="/tmp/internet_monitor_daemon.pid"

if [ -f "$DAEMON_PID_FILE" ]; then
    EXISTING_PID=$(cat "$DAEMON_PID_FILE")
    if ps -p "$EXISTING_PID" > /dev/null 2>&1; then
        echo "Error: Internet monitor daemon is already running (PID: $EXISTING_PID)"
        echo "To stop it, run: kill $EXISTING_PID"
        exit 1
    else
        # Stale PID file, remove it
        rm -f "$DAEMON_PID_FILE"
    fi
fi

# Create PID file
echo $$ > "$DAEMON_PID_FILE"

# Function to remove PID file on exit
remove_pid_file() {
    rm -f "$DAEMON_PID_FILE"
}
trap remove_pid_file EXIT

log_daemon "Starting daemon (PID: $$)"
echo "Internet Usage Monitor Daemon started (PID: $$)"
echo "Checking usage every $DAEMON_UPDATE_INTERVAL seconds"
echo "Log file: $LOG_FILE"
echo "Data file: $USAGE_DATA_FILE"
echo "Press Ctrl+C to stop"

# Main daemon loop
while true; do
    # Run the main monitor script - determine correct path
    if [ -f "$SCRIPT_DIR/internet_monitor.sh" ]; then
        # Same directory (installed)
        "$SCRIPT_DIR/internet_monitor.sh"
    elif [ -f "$HOME/internet_monitor.sh" ]; then
        # Home directory (installed)
        "$HOME/internet_monitor.sh"
    else
        echo "Error: Could not find internet_monitor.sh" >&2
        log_daemon "Error: Could not find internet_monitor.sh"
        exit 1
    fi
    
    # Check if we should exit
    if [ ! -f "$DAEMON_PID_FILE" ]; then
        log_daemon "PID file removed, exiting daemon"
        break
    fi
    
    # Sleep for the configured interval
    sleep "$DAEMON_UPDATE_INTERVAL"
done

log_daemon "Daemon stopped"
