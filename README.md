# Network Usage Monitor 🐻🛰️

_Track network consumption with bear-like vigilance and intelligent monitoring_ 🧉

[![Linux](https://img.shields.io/badge/Linux-Compatible-green.svg)](https://www.linux.org/)
[![Shell](https://img.shields.io/badge/Shell-Bash-orange.svg)](https://www.gnu.org/software/bash/)
[![KDE Plasma](https://img.shields.io/badge/KDE_Plasma-6-blue.svg)](https://kde.org/plasma-desktop/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tested](https://img.shields.io/badge/Tested-Garuda_Linux-purple.svg)](https://garudalinux.org/)

A robust, real-time network usage monitoring solution for Linux desktops, featuring intelligent data tracking, beautiful Conky widgets, smart notifications, and comprehensive usage analytics.

**✅ Tested on Garuda Linux (Arch-based), KDE Plasma 6**

---

## ⚡ Intelligent Features

### 📊 **Real-time Network Intelligence**
- **Advanced Usage Tracking** - Monitor daily and monthly data consumption with precision
- **Smart Interface Detection** - Automatically discovers and monitors active network interfaces
- **Multi-Network Support** - Tracks WiFi, Ethernet, and mobile connections simultaneously
- **Historical Data** - Maintains comprehensive usage logs with trend analysis

### 🖥️ **Modern Desktop Integration**
- **Beautiful Conky Widget** - Clean, professionally aligned desktop widget with real-time stats
- **Customizable Positioning** - Choose widget placement (top-right, bottom-left, center, etc.)
- **KDE Plasma 6 Optimized** - Native integration with automatic desktop environment detection
- **XDG Compliant** - Follows Linux standards for clean, predictable file organization

### 🎨 **Interactive Setup Experience**
- **Guided Configuration** - Step-by-step setup wizard for all preferences
- **Smart Detection** - Automatic KDE Plasma desktop environment issue detection and fixes
- **Flexible Autostart** - Choose between Systemd service or Cron job automation
- **Zero Configuration** - Works out-of-the-box with intelligent defaults

### 🔔 **Smart Notification System**
- **Progressive Alerts** - Yellow warning at 80% usage with ⚠️ visual indicator
- **Critical Notifications** - Red alert at 100% limit exceeded with ☠️ emergency icon
- **Customizable Thresholds** - Set personal usage limits and notification preferences
- **Desktop Integration** - Native Linux notification system integration

### ⏰ **Automated Management**
- **Intelligent Reset** - Automatic daily and monthly counter resets at midnight
- **Background Service** - Efficient daemon process with minimal resource usage
- **Data Persistence** - Reliable data storage survives system reboots and crashes
- **Log Management** - Comprehensive logging with automatic rotation and cleanup

---

## 🧉 **Technology Stack**

**Core System**
- **Bash Shell** - Robust scripting with POSIX compliance and error handling
- **Linux Networking** - Direct integration with `/proc/net/dev` and system interfaces
- **Systemd Integration** - Modern service management with proper user services

**Desktop Environment**
- **Conky Widget Engine** - Lightweight, customizable desktop widget framework
- **KDE Plasma 6** - Native desktop environment integration and theming
- **XDG Base Directory** - Compliant file organization following Linux standards

**Monitoring & Analytics**
- **Real-time Data Processing** - Efficient byte counting and rate calculations
- **Historical Analysis** - Trend tracking and usage pattern recognition
- **Smart Thresholds** - Configurable limits with intelligent alerting

**Package Management**
- **AUR Package** - Official Arch User Repository distribution
- **Manual Installation** - Cross-distribution compatibility with installer script
- **Clean Uninstall** - Complete removal with XDG-compliant cleanup

---

## 🚀 Installation Methods

### **Method 1: Arch Linux & AUR (Recommended) 🏆**

Install the official `internet-usage-monitor-git` package using your preferred AUR helper:

```bash
# Using yay (recommended)
yay -S internet-usage-monitor-git

# Using paru
paru -S internet-usage-monitor-git

# Using trizen
trizen -S internet-usage-monitor-git
```

**Benefits:**
- ✅ Automatic dependency management
- ✅ System-wide package tracking
- ✅ Easy updates and removal
- ✅ Guided setup wizard runs automatically

### **Method 2: Manual Installation (Universal) 🌍**

For non-Arch distributions or custom installations:

```bash
# Clone the bear-powered repository
git clone https://github.com/YahyaZekry/internet-usage-monitor.git
cd internet-usage-monitor

# Make installer executable
chmod +x install.sh

# Run interactive installer
./install.sh
```

**Features:**
- ✅ Cross-distribution compatibility
- ✅ Dependency checking and installation guidance
- ✅ Interactive configuration wizard
- ✅ Custom installation path options

---

## 📁 **XDG-Compliant Architecture**

Follows Linux standards for clean, organized file structure:

```
~/.local/bin/                           # Executable Scripts
├── internet_monitor.sh                 # Main monitoring logic
├── internet_monitor_daemon.sh          # Background service daemon
└── conky_usage_helper.sh              # Widget data provider

~/.config/internet-usage-monitor-git/   # Configuration Files
├── config.sh                          # Main configuration settings
├── conkyrc_internet                   # Conky widget theme
└── user_preferences.conf              # Personal customizations

~/.local/share/internet-usage-monitor-git/ # Data & Logs
├── usage_data                         # Current usage statistics
├── usage_log                          # Historical usage logs
├── daily_stats/                       # Daily usage archives
└── monthly_reports/                   # Monthly usage summaries
```

---

## ⚙️ **Advanced Configuration**

### **Customization Options**

```bash
# Edit main configuration
nano ~/.config/internet-usage-monitor-git/config.sh

# Customize widget appearance
nano ~/.config/internet-usage-monitor-git/conkyrc_internet

# Set personal preferences
nano ~/.config/internet-usage-monitor-git/user_preferences.conf
```

### **Key Configuration Parameters**
- **Daily Limit** - Set your ISP data cap or personal usage goals
- **Update Interval** - Configure monitoring frequency (1-60 seconds)
- **Widget Position** - Choose desktop placement coordinates
- **Notification Thresholds** - Customize warning and critical alert levels
- **Interface Selection** - Manually specify network interfaces to monitor

---

## 🎯 **Usage Commands**

All scripts are installed in `~/.local/bin` and available system-wide:

### **Monitoring Commands**
```bash
# Display current usage statistics
internet_monitor.sh usage

# Show detailed breakdown by interface
internet_monitor.sh detailed

# View historical usage trends
internet_monitor.sh history

# Export usage data to CSV
internet_monitor.sh export
```

### **Service Management**
```bash
# Check daemon status
internet_monitor_daemon.sh status

# Start monitoring service
internet_monitor_daemon.sh start

# Stop monitoring service
internet_monitor_daemon.sh stop

# Restart with new configuration
internet_monitor_daemon.sh restart
```

### **Data Management**
```bash
# Reset daily counter
internet_monitor.sh reset daily

# Reset monthly counter
internet_monitor.sh reset monthly

# Backup usage data
internet_monitor.sh backup

# Generate monthly report
internet_monitor.sh report
```

---

## 🔧 **Widget Customization**

### **Position Options**
- **Top-Right** - Classic monitoring position
- **Bottom-Left** - Unobtrusive corner placement
- **Top-Center** - Prominent header display
- **Custom Coordinates** - Precise pixel positioning

### **Display Themes**
- **Minimal** - Clean, essential information only
- **Detailed** - Comprehensive stats with graphs
- **Transparent** - Subtle overlay with background blur
- **High Contrast** - Bold colors for visibility

---

## 🚨 **Smart Alert System**

### **Alert Levels**
| Usage Level | Notification | Icon | Action |
|-------------|--------------|------|--------|
| 0-79% | None | 📊 | Normal monitoring |
| 80-99% | Warning | ⚠️ | Yellow notification |
| 100%+ | Critical | ☠️ | Red alert + logging |

### **Notification Features**
- **Progressive Escalation** - Alerts become more urgent as usage increases
- **Smart Timing** - Avoids notification spam with intelligent delays
- **Custom Messages** - Personalized alert text and recommendations
- **Desktop Integration** - Native Linux notification system compatibility

---

## 🗑️ **Clean Uninstallation**

### **Complete Removal**
```bash
# From project directory
./uninstall.sh

# Or using AUR helper
yay -R internet-usage-monitor-git
```

**Cleanup includes:**
- ✅ All executable scripts from `~/.local/bin`
- ✅ Configuration files from `~/.config`
- ✅ Data and logs from `~/.local/share`
- ✅ Systemd user services
- ✅ Cron job entries

---

## 🛠️ **Development**

### **Contributing**
1. Fork the repository
2. Create feature branch (`git checkout -b feature/bear-network-power`)
3. Test on multiple Linux distributions
4. Ensure bash compatibility and error handling
5. Commit with descriptive messages (`git commit -m '🐻 Add bear-strength monitoring'`)
6. Open Pull Request with testing details

### **Testing Requirements**
- Bash 4.0+ compatibility
- Multiple network interface support
- KDE Plasma and GNOME desktop testing
- Memory and CPU usage optimization

---

## 🌍 **Distribution Support**

### **Fully Tested**
- **✅ Arch Linux** - Official AUR package available
- **✅ Garuda Linux** - KDE Plasma 6 optimized
- **✅ Manjaro** - AUR compatibility confirmed

### **Compatible (Manual Installation)**
- **🔄 Ubuntu/Debian** - Requires manual dependency installation
- **🔄 Fedora/CentOS** - systemd integration works perfectly
- **🔄 openSUSE** - Conky and notification support confirmed

---

## 📄 **License**

MIT License - see [LICENSE](LICENSE) file for complete details.

**Copyright (c) 2025 The Bear Code**

---

## 🐻 **Author**

**Yahya Zekry** • The Bear Code  
- GitHub: [@YahyaZekry](https://github.com/YahyaZekry)  
- LinkedIn: [Professional Profile](https://www.linkedin.com/in/yahyazekry/)  
- Project: [Network Usage Monitor](https://github.com/YahyaZekry/internet-usage-monitor)

---

**Built with ❤️ for Linux power users • The Bear Code philosophy: Vigilant monitoring, intelligent alerts 🐻🛰️**

<div align="center">
  <a href="https://buymeacoffee.com/YahyaZekry" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Support The Bear Code" height="45" />
  </a>
</div>

<div align="center">
  <sub>Monitoring networks with bear-like precision, one byte at a time 🧉</sub>
</div>