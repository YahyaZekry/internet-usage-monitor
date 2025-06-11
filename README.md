# Internet Usage Monitor for Linux

🌐 A comprehensive, real-time internet usage monitoring system with beautiful Conky widget and smart notifications for Linux desktop environments.

> _"Keep your data usage as balanced as your yerba mate blend - never too much, always just right."_ 🧉⚖️

> **Tested on Garuda Linux (Arch-based), KDE Plasma 6.3**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg)
![Shell](https://img.shields.io/badge/shell-Bash-orange.svg)
![Conky](https://img.shields.io/badge/widget-Conky-purple.svg)
![Release](https://img.shields.io/github/v/release/Yahya-Zekry/internet-usage-monitor?color=brightgreen)
![Downloads](https://img.shields.io/github/downloads/Yahya-Zekry/internet-usage-monitor/total?color=blue)
![Stars](https://img.shields.io/github/stars/Yahya-Zekry/internet-usage-monitor?style=social)
![Yerba Mate](https://img.shields.io/badge/yerba%20mate-🧉%20balanced-green.svg)

## 📋 Features

### 🚀 **Core Monitoring** 🧉

- **Real-time Tracking**: Monitors internet usage like watching your mate gourd fill - precise and continuous
- **Daily Limits**: Set and track daily data usage with customizable thresholds (as balanced as your yerba mate blend)
- **Smart Notifications**: Desktop alerts at 80% (warning) and 100% (critical) thresholds - like knowing when to refill your mate
- **Automatic Reset**: Daily usage resets at midnight automatically (fresh start every day, like your morning mate ritual)
- **Network Auto-detection**: Automatically detects and monitors active network interface with the precision of a mate cebador

### 🎨 **Beautiful Widget**

- **Modern Conky Display**: Translucent desktop widget with emoji icons
- **Desktop-Sticky**: Stays on desktop permanently (no disappearing during "peek at desktop")
- **Color-coded Status**: Green → Orange → Red based on usage percentage
- **Real-time Updates**: Live data refresh every few seconds
- **Configurable Position**: Place anywhere on your desktop

### 🔧 **Professional Management**

- **Smart Installation**: Automated setup with update detection
- **Update System**: Intelligent updates that preserve your settings
- **Robust Uninstallation**: Finds and removes all traces with data backup
- **Multiple Monitoring Modes**: Cron jobs, systemd timers, or daemon mode
- **Path Resolution**: Works in development and production environments

## 🎨 Widget Display

The Conky widget shows:

- 📊 **Current Usage**: Daily usage in human-readable format (MB/GB)
- 🎯 **Daily Limit**: Your configured limit (default: 2GB)
- 💾 **Remaining Data**: How much you have left today
- 📈 **Progress Bar**: Visual percentage with color coding
- 🔧 **System Status**: Monitor service status
- 🌐 **Network Interface**: Currently monitored interface

**Color Coding:**

- 🟢 **Green**: Normal usage (< 80% of limit)
- 🟡 **Orange**: High usage warning (80-99% of limit)
- 🔴 **Red**: Limit exceeded (≥ 100% of limit)

## 📦 Quick Installation

### 🚀 **One-Command Install (Recommended)** 🧉

```bash
git clone https://github.com/Yahya-Zekry/internet-usage-monitor.git
cd internet-usage-monitor
chmod +x install.sh
./install.sh
```

> _"Start your monitoring journey as you would your mate ritual: with clarity, balance, and a touch of tradition!"_ 🧉

The intelligent installer will brew your monitoring setup like preparing the perfect mate:

- ✅ **Check prerequisites** and install missing packages (gathering the right yerba)
- ✅ **Detect existing installations** and offer update options (respecting the existing gourd)
- ✅ **Backup your data** before any changes (preserving your mate traditions)
- ✅ **Install/update scripts** with proper permissions (setting up the bombilla perfectly)
- ✅ **Configure monitoring** (cron or systemd) — **Conky autostart is always enabled** (no more separate desktop autostart option)
- ✅ **Test the installation** automatically (first sip to ensure quality)
- ✅ **Start the widget** immediately (enjoying your perfectly prepared digital mate — via a temporary launcher script)
- ✅ **Enjoy modern, step-based output** with Yerba Mate slogans and optional slow mode (`SLOW_MODE=1`)

### 🔄 **Smart Update System**

When you run the installer on an existing installation:

```bash
./install.sh
```

You'll get intelligent options:

```text
Existing installation detected!

Installation options:
1) Update existing installation (recommended)
2) Fresh install (will backup current installation)
3) Cancel installation

Choose an option (1-3): 1
```

**The update process automatically:**

- 📦 **Backs up** your current installation
- 🛑 **Stops** running processes safely
- 📥 **Updates** all scripts to latest version
- ⚙️ **Preserves** your configuration (with confirmation)
- 🔄 **Restarts** services automatically
- ✅ **Tests** everything works

## 📋 Prerequisites

### Required Packages

The installer automatically detects and installs missing packages:

**Arch Linux / Garuda Linux:**

```bash
sudo pacman -S conky bc procps-ng libnotify zenity
```

**Debian / Ubuntu:**

```bash
sudo apt update
sudo apt install conky bc procps libnotify-bin zenity
```

**Fedora / CentOS:**

```bash
sudo dnf install conky bc procps-ng libnotify zenity
```

**openSUSE:**

```bash
sudo zypper install conky bc procps libnotify-tools zenity
```

## ⚙️ Configuration

### 🎯 **Setting Daily Limit**

The system uses a centralized configuration in `config/config.sh`:

```bash
# Daily limit in GB
DAILY_LIMIT_GB=2

# Notification thresholds
WARNING_THRESHOLD=80    # Warn at 80%
CRITICAL_THRESHOLD=100  # Alert at 100%

# Network interface (auto-detection)
NETWORK_INTERFACE="auto"
```

### 🎨 **Widget Customization**

Customize the Conky widget in `config/conkyrc_internet`:

```lua
-- Position and size
alignment = 'top_right',
gap_x = 20,
gap_y = 60,

-- Appearance
own_window_type = 'desktop',      -- Stays on desktop
own_window_argb_value = 200,      -- Transparency
minimum_width = 240,
```

### 📱 **Notification Settings**

Configure alerts in the main config:

```bash
# Notification settings
NOTIFICATION_DURATION=10000  # 10 seconds
NOTIFICATION_URGENCY_WARNING="normal"
NOTIFICATION_URGENCY_CRITICAL="critical"
```

## 🚀 Usage

### **Basic Commands**

```bash
# Check current usage
~/internet_monitor.sh usage

# Show detailed status
~/internet_monitor.sh status

# Reset daily counter
~/internet_monitor.sh reset

# Test notifications
~/internet_monitor.sh test-warning
~/internet_monitor.sh test-critical

# Get help
~/internet_monitor.sh help
```

### **Widget Control**

> _"Your Conky widget will always greet you on login, just like your morning mate."_ 🧉

```bash
# Start widget (normally handled automatically)
conky -c ~/.conkyrc_internet &

# Stop widget
pkill conky

# Restart with new config
pkill conky && conky -c ~/.conkyrc_internet &
```

**Note:** After installation, the widget starts immediately for your current session via a temporary launcher script, and will autostart on login thanks to the `.desktop` entry.

### **Helper Script Options**

```bash
# Current usage in different formats
~/conky_usage_helper.sh usage      # In GB
~/conky_usage_helper.sh usage_mb   # In MB
~/conky_usage_helper.sh percentage # Percentage used

# System information
~/conky_usage_helper.sh interface       # Network interface
~/conky_usage_helper.sh monitor_status  # Monitor status
~/conky_usage_helper.sh config_limit    # Configured limit
```

## 🔄 Monitoring Options 🧉

The installer offers multiple monitoring options, each as reliable as your daily mate routine:

### **Option 1: Cron Job (Recommended)** 📅

Like your scheduled mate breaks throughout the day

**Why recommended:**

- ✅ **Universal compatibility** - Works on all Linux distributions
- ✅ **Simple and reliable** - Minimal dependencies, robust execution
- ✅ **Lower resource usage** - Only runs when needed, no persistent daemon
- ✅ **Easy troubleshooting** - Simple to debug and modify
- ✅ **Battle-tested** - Decades of proven reliability in production

```bash
# Runs every 5 minutes
*/5 * * * * ~/internet_monitor.sh
```

### **Option 2: Systemd Timer** ⏰

Precise timing like a mate cebador's perfect rhythm

**Trade-offs:**

- ✅ **More precise timing** - Exact scheduling with calendar syntax
- ⚠️ **Higher complexity** - More components that can fail
- ⚠️ **Distribution dependent** - Not available on all systems
- ⚠️ **More resource usage** - systemd overhead for simple tasks

```bash
# Check status
systemctl --user status internet-monitor.timer

# Manual control
systemctl --user start internet-monitor.timer
systemctl --user stop internet-monitor.timer
systemctl --user restart internet-monitor.timer
```

### **Option 3: Daemon Mode** 🔄

Continuous monitoring like slowly sipping mate all day

```bash
# Start daemon
~/internet_monitor_daemon.sh &

# Stop daemon
pkill -f internet_monitor_daemon.sh
```

### **Option 4: Desktop Autostart** 🌅

Automatically starts monitoring and widget on login - like preparing mate first thing in the morning

## 📁 Professional Project Structure

```text
internet-usage-monitor/
├── 📁 src/                           # Source code
│   ├── internet_monitor.sh           # Main monitoring script
│   ├── internet_monitor_daemon.sh    # Daemon wrapper
│   └── conky_usage_helper.sh         # Conky data provider
├── 📁 config/                        # Configuration
│   ├── config.sh                     # Shared configuration
│   └── conkyrc_internet              # Conky widget config
├── 📁 scripts/                       # Utility scripts
│   └── screenshot_test.sh            # Interactive testing
├── 🚀 install.sh                     # Smart installer
├── 🗑️ uninstall.sh                   # Complete removal
├── 📄 README.md                      # This file
└── 📜 LICENSE                        # MIT License
```

**Runtime Files:**

```text
~/.internet_usage_data               # Usage tracking data
~/.internet_usage.log                # Activity logs
~/.conkyrc_internet                  # Widget config (installed)
~/internet_monitor.sh                # Main script (installed)
~/conky_usage_helper.sh              # Helper script (installed)
~/internet_monitor_daemon.sh         # Daemon script (installed)
~/config.sh                          # Configuration (installed)
```

## 🔧 Management Commands

### **Installation Management**

```bash
# Update to latest version
./install.sh                    # Choose option 1 (Update)

# Complete fresh install
./install.sh                    # Choose option 2 (Fresh install)

# Remove everything
./uninstall.sh                  # Comprehensive removal
```

> _"Uninstalling is as smooth as pouring a fresh mate — one confirmation, clear feedback, and your data is safely backed up."_ 🧉

- **Modern, step-based output** with full-width headers and Yerba Mate slogans
- **Single confirmation**: See the file list, confirm once, and everything is removed in one go
- **Automatic backup**: Your data is saved before removal

### **Service Management**

```bash
# Check what's running
ps aux | grep -E "(internet_monitor|conky)"

# View logs
tail -f ~/.internet_usage.log

# Check usage data
cat ~/.internet_usage_data

# Test system
scripts/screenshot_test.sh      # Interactive testing
```

## 🔍 Testing & Screenshots

Use the interactive testing script:

```bash
scripts/screenshot_test.sh
```

This provides:

- **Usage scenarios**: Normal, warning, critical states
- **Widget testing**: Easy screenshot setup
- **Conky control**: Start/stop widget for testing
- **Data management**: Backup and restore test data

## 🖥️ Compatibility

- **Tested on Garuda Linux (Arch-based), KDE Plasma 6.3**
- Should work on most modern Linux distributions and desktop environments

## 📚 Advanced Usage & Troubleshooting

For advanced features, troubleshooting, and detailed explanations, see:

- [docs/advanced.md](docs/advanced.md)
- [docs/troubleshooting.md](docs/troubleshooting.md)

## 🎯 Advanced Features

### **Professional Uninstallation**

The uninstall script searches everywhere and removes all traces in one go:

```bash
./uninstall.sh
```

- **Single confirmation**: Review the file list, confirm, and removal proceeds
- **Backup protection**: Your data is saved before anything is deleted
- **Process management**: Stops running services and widget
- **Complete cleanup**: Removes cron jobs, systemd services, and Conky autostart entry
- **Detailed feedback**: Modern, readable output with step numbers and slogans

### **Configuration Preservation**

During updates:

- ✅ **Automatic backup** of existing installation
- ✅ **Smart config handling** - Asks to keep your settings
- ✅ **Data preservation** - Usage logs and data remain intact
- ✅ **Service continuity** - Restarts monitoring automatically

### **Multi-Environment Support**

Works in both:

- ✅ **Development** - Run from project directory
- ✅ **Production** - Installed to home directory
- ✅ **System-wide** - Install to system directories
- ✅ **Portable** - Self-contained installations

## 🤝 Contributing

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/yourusername/internet-usage-monitor.git`
3. **Create** feature branch: `git checkout -b feature/amazing-feature`
4. **Make** your changes
5. **Test** thoroughly: `scripts/screenshot_test.sh`
6. **Commit** changes: `git commit -m 'Add amazing feature'`
7. **Push** to branch: `git push origin feature/amazing-feature`
8. **Open** Pull Request

### **Development Setup**

```bash
# Clone and test
git clone https://github.com/Yahya-Zekry/internet-usage-monitor.git
cd internet-usage-monitor

# Test without installing
src/internet_monitor.sh help
src/conky_usage_helper.sh usage

# Test installation process
./install.sh
```

## 📊 Compatibility

**✅ Tested Distributions:**

- Garuda Linux (KDE Plasma) - Primary development and testing platform.
- (Automated CI testing for other distributions has been temporarily removed.)

**✅ Desktop Environments:**

- KDE Plasma 5.x+ (Primary)
- GNOME 40+ (with notifications)
- XFCE 4.14+
- Cinnamon / MATE
- i3 / Sway / Awesome WM
- Openbox / Fluxbox

**✅ System Requirements:**

- Linux kernel 4.0+
- Bash 4.0+
- X11 or Wayland (limited)
- 50MB free disk space
- Active network interface

## 📈 Performance

**Resource Usage:**

- **CPU**: < 0.1% (periodic checks)
- **Memory**: < 5MB RSS
- **Disk**: < 1MB (logs and data)
- **Network**: Read-only system stats

**Update Frequency:**

- **Monitoring**: Every 5 minutes (configurable)
- **Widget**: Every 3 seconds
- **Notifications**: On threshold breach

## 🌟 Recent Improvements

### **v2.0 Features:**

- ✅ **Smart Update System** - Detects existing installations
- ✅ **Robust Uninstallation** - Finds files everywhere
- ✅ **Professional Structure** - Organized folders
- ✅ **Path Resolution Fix** - Works in all environments
- ✅ **Desktop-Sticky Widget** - No more disappearing
- ✅ **Enhanced Notifications** - Warning + critical thresholds
- ✅ **Comprehensive Documentation** - 6 detailed guides
- ✅ **Automated Testing** - Interactive screenshot tools

### **Technical Enhancements:**

- ✅ **Shared Configuration** - Central config file
- ✅ **Daemon Separation** - Clean cron vs daemon modes
- ✅ **Unit Consistency** - GB throughout
- ✅ **Process Management** - PID tracking and cleanup
- ✅ **Error Handling** - Graceful failure recovery
- ✅ **Multi-distro Support** - Automatic package detection

## 📞 Support

**Need Help?**

- 📖 **Documentation**: Refer to this README.md for comprehensive information.
- 🐛 **Bug Reports**: Use GitHub issues. (Note: Issue templates have been removed for now).
- 💡 **Feature Requests**: Submit enhancement proposals via GitHub issues.
- 🤝 **Contributions**: Follow contribution guidelines (if available).
- 📧 **Contact**: Through GitHub discussions.

**Quick Links:**

- (Detailed guides previously in `docs/` have been removed for now.)

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[Conky](https://github.com/brndnmtthws/conky)** - Excellent system monitor
- **[Garuda Linux](https://garudalinux.org/)** - Beautiful development platform
- **Linux Community** - Testing, feedback, and inspiration
- **Contributors** - Everyone who helped improve this project

---

## 🚀 Quick Start Checklist

- [ ] **Clone repository**: `git clone https://github.com/Yahya-Zekry/internet-usage-monitor.git`
- [ ] **Run installer**: `chmod +x install.sh && ./install.sh`
- [ ] **Choose monitoring**: Cron job (recommended) or systemd timer
- [ ] **Configure limit**: Edit daily limit if needed (default: 2GB)
- [ ] **Start widget**: `conky -c ~/.conkyrc_internet &`
- [ ] **Test notifications**: Check 80% warning and 100% critical alerts
- [ ] **Verify monitoring**: Check logs after a few minutes
- [ ] **Enjoy balanced internet usage** like perfectly balanced yerba mate! 🧉

---

## 🌟 Support the Project

If you find this project useful:

- ⭐ **Star** the repository on GitHub
- 🐛 **Report bugs** with detailed information
- 💡 **Suggest features** for enhancement
- 🤝 **Contribute** code, documentation, or testing
- 📢 **Share** with fellow Linux enthusiasts
- 💝 **Sponsor** development (coming soon)

---

### ❤️ **Made with Love and Mate** 🧉

Made for the Linux community

> _"Professional monitoring tools should be as reliable as your morning yerba mate ritual — consistent, dependable, and perfectly balanced."_

Keep your data usage as balanced as your yerba mate blend — never too much, always just right. 🧉⚖️

---

## 🧉 What's New (v2.1)

- **Modern, Readable Output:** Both `install.sh` and `uninstall.sh` now feature step-based, sectioned output with full-width headers and step numbers for clarity.
- **Yerba Mate Slogans:** Friendly slogans appear at the start and end of both scripts, and are highlighted throughout the README.
- **Conky Autostart Always Enabled:** When you choose cron or systemd monitoring, Conky is set to autostart on login (via a `.desktop` entry). The old "desktop autostart" option is removed for simplicity.
- **Immediate Widget Start:** After install, a temporary launcher script starts Conky for your current session, so you see the widget right away.
- **Optional Slow Mode:** Enable typewriter-style output for extra readability by running the installer or uninstaller with `SLOW_MODE=1` (e.g., `SLOW_MODE=1 ./install.sh`).
- **Aligned Uninstall Experience:** Uninstall now confirms the file list only once, then removes everything in one go, with the same modern output style as install.

---
