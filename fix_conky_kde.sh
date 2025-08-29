#!/bin/bash

# Fix Conky window placement in KDE Plasma 6
# This script creates a window rule to force Conky to stay below other windows

set -e

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
ROCKET="🚀"

print_status() {
    local color=$1
    local icon=$2
    local message=$3
    echo -e "${color}${icon} ${message}${NC}"
}

echo -e "${BLUE}${ROCKET} Conky KDE Plasma 6 Fix${NC}"
echo -e "${BLUE}=============================${NC}"
echo

print_status "$BLUE" "$INFO" "This script will create a KDE window rule to fix Conky staying on top of windows."

# Check if we're in KDE
if [ "$XDG_CURRENT_DESKTOP" != "KDE" ] && [ "$DESKTOP_SESSION" != "plasma" ]; then
    print_status "$YELLOW" "$WARNING" "This doesn't appear to be a KDE Plasma session."
    print_status "$BLUE" "$INFO" "Current desktop: $XDG_CURRENT_DESKTOP"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Check if kwriteconfig5 or kwriteconfig6 is available
KWRITE_CMD=""
if command -v kwriteconfig6 >/dev/null 2>&1; then
    KWRITE_CMD="kwriteconfig6"
elif command -v kwriteconfig5 >/dev/null 2>&1; then
    KWRITE_CMD="kwriteconfig5"
else
    print_status "$RED" "$CROSS" "Neither kwriteconfig6 nor kwriteconfig5 found."
    print_status "$YELLOW" "$WARNING" "Please install kde-cli-tools or create the rule manually:"
    echo
    echo "1. Open System Settings > Window Management > Window Rules"
    echo "2. Click 'New...'"
    echo "3. Set Window class to 'Conky' (match whole window class)"
    echo "4. In Arrangement & Access, set 'Keep below other windows' to 'Force'"
    echo "5. Apply and save the rule"
    exit 1
fi

print_status "$GREEN" "$CHECK" "Found KDE configuration tool: $KWRITE_CMD"

# Create the window rule
KDE_CONFIG_DIR="$HOME/.config"
WINDOW_RULES_FILE="$KDE_CONFIG_DIR/kwinrulesrc"

print_status "$BLUE" "$INFO" "Creating KDE window rule for Conky..."

# Backup existing rules if they exist
if [ -f "$WINDOW_RULES_FILE" ]; then
    BACKUP_FILE="${WINDOW_RULES_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$WINDOW_RULES_FILE" "$BACKUP_FILE"
    print_status "$YELLOW" "$WARNING" "Backed up existing rules to: $BACKUP_FILE"
fi

# Create the window rule using kwriteconfig
RULE_NAME="internet-monitor-conky-fix"
RULE_COUNT=$($KWRITE_CMD --file kwinrulesrc --group General --key count 2>/dev/null || echo "0")
NEW_RULE_COUNT=$((RULE_COUNT + 1))

# Update the rule count
$KWRITE_CMD --file kwinrulesrc --group General --key count "$NEW_RULE_COUNT"
$KWRITE_CMD --file kwinrulesrc --group General --key rules "$RULE_NAME"

# Create the rule group
$KWRITE_CMD --file kwinrulesrc --group "$RULE_NAME" --key Description "Internet Monitor Conky - Keep Below"
$KWRITE_CMD --file kwinrulesrc --group "$RULE_NAME" --key wmclass "conky"
$KWRITE_CMD --file kwinrulesrc --group "$RULE_NAME" --key wmclassmatch 1
$KWRITE_CMD --file kwinrulesrc --group "$RULE_NAME" --key wmclasscomplete true
$KWRITE_CMD --file kwinrulesrc --group "$RULE_NAME" --key types 1
$KWRITE_CMD --file kwinrulesrc --group "$RULE_NAME" --key below true
$KWRITE_CMD --file kwinrulesrc --group "$RULE_NAME" --key belowrule 2

print_status "$GREEN" "$CHECK" "KDE window rule created successfully!"

# Restart KWin to apply the rule
print_status "$BLUE" "$INFO" "Restarting KWin to apply the new rule..."
if command -v kwin_x11 >/dev/null 2>&1; then
    kwin_x11 --replace &
    disown
elif command -v kwin_wayland >/dev/null 2>&1; then
    print_status "$YELLOW" "$WARNING" "Wayland detected. You may need to log out and back in for the rule to take effect."
else
    print_status "$YELLOW" "$WARNING" "Could not restart KWin automatically. Please log out and back in."
fi

print_status "$GREEN" "$CHECK" "Conky KDE fix applied!"

echo
print_status "$BLUE" "$INFO" "Instructions:"
echo "1. Kill any running Conky instances: killall conky"
echo "2. Start Conky with your config: conky -c ~/.conkyrc_internet"
echo "3. Conky should now stay below other windows"
echo
print_status "$GREEN" "$ROCKET" "If issues persist, try logging out and back in."
