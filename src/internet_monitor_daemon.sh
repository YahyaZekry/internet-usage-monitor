#!/bin/bash

# Internet Usage Monitor Daemon
# Runs the main monitor script continuously in a loop
# Use this for continuous monitoring instead of cron jobs

# Source the common configuration and functions
# This also defines LOG_FILE, RUNTIME_DIR, etc.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Define path to the main monitor script, located in the same directory.
MONITOR_SCRIPT="$(dirname "${BASH_SOURCE[0]}")/internet_monitor.sh"

# Function to log daemon messages
log_daemon() {
    # Use the log_message function from common.sh for consistency
    log_message "[DAEMON] $1"
}

# Function to handle cleanup on exit
cleanup() {
    log_daemon "Daemon stopping (PID: $$)"
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Define the PID file path using the RUNTIME_DIR from common.sh
DAEMON_PID_FILE="$RUNTIME_DIR/daemon.pid"

# Support daemon control commands
case "${1:-start}" in
    "start")
        if [ -f "$DAEMON_PID_FILE" ]; then
            EXISTING_PID=$(cat "$DAEMON_PID_FILE")
            if ps -p "$EXISTING_PID" > /dev/null 2>&1; then
                echo "Error: Internet monitor daemon is already running (PID: $EXISTING_PID)"
                echo "To stop it, run: $0 stop"
                exit 1
            else
                # Stale PID file, remove it
                rm -f "$DAEMON_PID_FILE"
            fi
        fi
        ;;
    "stop")
        if [ -f "$DAEMON_PID_FILE" ]; then
            EXISTING_PID=$(cat "$DAEMON_PID_FILE")
            if ps -p "$EXISTING_PID" > /dev/null 2>&1; then
                echo "Stopping daemon (PID: $EXISTING_PID)..."
                kill "$EXISTING_PID"
                # Wait for process to stop
                for i in {1..10}; do
                    if ! ps -p "$EXISTING_PID" > /dev/null 2>&1; then
                        echo "Daemon stopped successfully."
                        rm -f "$DAEMON_PID_FILE"
                        exit 0
                    fi
                    sleep 1
                done
                # Force kill if still running
                kill -9 "$EXISTING_PID" 2>/dev/null
                rm -f "$DAEMON_PID_FILE"
                echo "Daemon forcefully stopped."
            else
                echo "Daemon not running (stale PID file removed)."
                rm -f "$DAEMON_PID_FILE"
            fi
        else
            echo "Daemon is not running."
        fi
        exit 0
        ;;
    "status")
        if [ -f "$DAEMON_PID_FILE" ]; then
            EXISTING_PID=$(cat "$DAEMON_PID_FILE")
            if ps -p "$EXISTING_PID" > /dev/null 2>&1; then
                echo "Daemon is running (PID: $EXISTING_PID)."
                exit 0
            else
                echo "Daemon is not running (stale PID file found)."
                exit 1
            fi
        else
            echo "Daemon is not running."
            exit 1
        fi
        ;;
    "restart")
        "$0" stop
        sleep 2
        "$0" start
        exit $?
        ;;
    "help")
        echo "Usage: $0 {start|stop|status|restart|help}"
        echo "  start   - Start the daemon (default)"
        echo "  stop    - Stop the daemon"
        echo "  status  - Check daemon status"
        echo "  restart - Restart the daemon"
        echo "  help    - Show this help"
        exit 0
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use '$0 help' for available commands."
        exit 1
        ;;
esac

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
    # Run the main monitor script using its absolute path
    if [ -f "$MONITOR_SCRIPT" ]; then
        "$MONITOR_SCRIPT"
    else
        log_daemon "ERROR: Monitor script not found at $MONITOR_SCRIPT. Exiting."
        break
    fi
    
    # Check if we should exit
    if [ ! -f "$DAEMON_PID_FILE" ]; then
        log_daemon "PID file removed, exiting daemon."
        break
    fi
    
    # Sleep for the configured interval
    sleep "$DAEMON_UPDATE_INTERVAL"
done

log_daemon "Daemon stopped"
