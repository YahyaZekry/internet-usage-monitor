# Internet Usage Monitor for Linux 🌐

Real-time internet usage monitoring with Conky widget and notifications for Arch-based Linux distributions.

**Tested on Garuda Linux (Arch-based), KDE Plasma 6.3** ✅

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg)
![Shell](https://img.shields.io/badge/shell-Bash-orange.svg)

## ✨ Features

- 📊 Real-time daily usage tracking with customizable limits
- 🖥️ Desktop widget showing current usage, limit, and progress
- 🔔 Notifications at 80% (warning) and 100% (critical) usage
- 🕛 Automatic daily reset at midnight
- 🌐 Auto-detection of active network interface

## 🚀 Quick Install

```bash
git clone https://github.com/Yahya-Zekry/internet-usage-monitor.git
cd internet-usage-monitor
chmod +x install.sh
./install.sh
```

The installer will:

- 📦 Install required packages (`conky bc procps-ng libnotify zenity`)
- ⚙️ Set up monitoring (cron job recommended)
- 🖥️ Configure and start the desktop widget
- 🚀 Enable autostart on login

## ⚙️ Configuration

Edit daily limit in `config/config.sh`:

```bash
DAILY_LIMIT_GB=2  # Set your daily limit in GB
```

## 📋 Usage

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

## 🎨 Widget Control

```bash
# Restart widget with new config
pkill conky && conky -c ~/.conkyrc_internet &
```

## 🔄 Monitoring Options

1. **⏰ Cron Job (Recommended)** - Runs every 5 minutes, universal compatibility
2. **⏲️ Systemd User Service** - More precise timing, higher complexity

## 🗑️ Uninstall

```bash
./uninstall.sh
```

## 📁 File Structure

```
~/.internet_usage_data     # Usage data
~/.internet_usage.log      # Activity logs
~/.conkyrc_internet        # Widget config
~/internet_monitor.sh      # Main script
~/conky_usage_helper.sh    # Helper script
~/config.sh               # Configuration
```

## 🤝 Contributing

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/yourusername/internet-usage-monitor.git`
3. **Create** feature branch: `git checkout -b feature/amazing-feature`
4. **Make** your changes and test thoroughly
5. **Commit** changes: `git commit -m 'Add amazing feature'`
6. **Push** to branch: `git push origin feature/amazing-feature`
7. **Open** Pull Request

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

**Copyright (c) 2025 Yahya Zekry**

## 📞 Support

- 🐛 **Bug reports**: GitHub issues
- 📚 **Documentation**: See `docs/` folder for advanced usage
- 💡 **Feature requests**: Submit via GitHub issues

---

> _"Keep your data usage as balanced as your yerba mate blend — never too much, always just right."_ 🧉⚖️
