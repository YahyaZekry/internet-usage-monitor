# Internet Usage Monitor for Linux

Real-time internet usage monitoring with Conky widget and notifications for Arch-based Linux distributions.

**Tested on Garuda Linux (Arch-based), KDE Plasma 6.3**

## Features

- Real-time daily usage tracking with customizable limits
- Desktop widget showing current usage, limit, and progress
- Notifications at 80% (warning) and 100% (critical) usage
- Automatic daily reset at midnight
- Auto-detection of active network interface

## Quick Install

```bash
git clone https://github.com/Yahya-Zekry/internet-usage-monitor.git
cd internet-usage-monitor
chmod +x install.sh
./install.sh
```

The installer will:

- Install required packages (`conky bc procps-ng libnotify zenity`)
- Set up monitoring (cron job recommended)
- Configure and start the desktop widget
- Enable autostart on login

## Configuration

Edit daily limit in `config/config.sh`:

```bash
DAILY_LIMIT_GB=2  # Set your daily limit in GB
```

## Usage

```bash
# Check current usage
~/internet_monitor.sh usage

# Show status
~/internet_monitor.sh status

# Reset daily counter
~/internet_monitor.sh reset

# Test notifications
~/internet_monitor.sh test-warning
```

## Widget Control

```bash
# Restart widget with new config
pkill conky && conky -c ~/.conkyrc_internet &
```

## Monitoring Options

1. **Cron Job (Recommended)** - Runs every 5 minutes, universal compatibility
2. **Systemd Timer** - More precise timing, systemd-dependent
3. **Daemon Mode** - Continuous monitoring

## Uninstall

```bash
./uninstall.sh
```

## File Structure

```
~/.internet_usage_data     # Usage data
~/.internet_usage.log      # Activity logs
~/.conkyrc_internet        # Widget config
~/internet_monitor.sh      # Main script
~/conky_usage_helper.sh    # Helper script
~/config.sh               # Configuration
```

## Support

- Bug reports: GitHub issues
- Documentation: See `docs/` folder for advanced usage
- License: MIT

---

**Made for Arch-based Linux distributions**
