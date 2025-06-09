# Internet Usage Monitor for Linux

🌐 A beautiful, real-time internet usage monitoring system with Conky widget for Linux desktop environments.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg)
![Shell](https://img.shields.io/badge/shell-Bash-orange.svg)

## 📋 Features

- **Real-time Monitoring**: Tracks internet usage in real-time using network interface statistics
- **Beautiful Conky Widget**: Modern, translucent desktop widget with emoji icons and color-coded status
- **Daily Limits**: Set and monitor daily data usage limits with visual warnings
- **Automatic Reset**: Daily usage automatically resets at midnight
- **Desktop Notifications**: Get notified when approaching or exceeding your daily limit
- **Persistent Display**: Widget stays visible and doesn't disappear when clicking desktop
- **Low Resource Usage**: Lightweight monitoring with minimal system impact

## 🎨 Screenshot

The widget displays:
- 📊 Current daily usage
- 🎯 Set daily limit (default: 2GB)
- 💾 Remaining data allowance
- 📈 Usage percentage with color-coded progress bar
- 🔧 Monitor service status

**Color Coding:**
- 🟢 Green: Normal usage (< 80%)
- 🟡 Orange: High usage (80-99%)
- 🔴 Red: Limit exceeded (≥ 100%)

## 📦 Installation

### Prerequisites

```bash
# Install required packages
sudo pacman -S conky bc procps-ng  # Arch/Garuda Linux
# or
sudo apt install conky bc procps   # Debian/Ubuntu
# or
sudo dnf install conky bc procps-ng # Fedora
```

### Quick Install

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/internet-usage-monitor.git
   cd internet-usage-monitor
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x internet_monitor.sh conky_usage_helper.sh
   ```

3. **Copy files to home directory:**
   ```bash
   cp conkyrc_internet ~/.conkyrc_internet
   cp internet_monitor.sh ~/
   cp conky_usage_helper.sh ~/
   ```

4. **Start the monitor:**
   ```bash
   ./internet_monitor.sh start
   ```

5. **Start the Conky widget:**
   ```bash
   conky -c ~/.conkyrc_internet &
   ```

## ⚙️ Configuration

### Setting Daily Limit

Edit the daily limit in both scripts:

**In `internet_monitor.sh`:**
```bash
DAILY_LIMIT_MB=2048  # Change to your desired limit in MB
```

**In `conky_usage_helper.sh`:**
```bash
DAILY_LIMIT_MB=2048  # Must match the monitor script
```

### Network Interface

The monitor auto-detects your active network interface. To manually specify:

```bash
# Edit internet_monitor.sh and uncomment/modify:
# INTERFACE="wlan0"  # For WiFi
# INTERFACE="eth0"   # For Ethernet
```

### Widget Position

Customize widget position in `conkyrc_internet`:

```lua
alignment = 'top_right',  -- Options: top_left, top_right, bottom_left, bottom_right
gap_x = 20,              -- Horizontal offset from edge
gap_y = 60,              -- Vertical offset from edge
```

## 🚀 Usage

### Monitor Control

```bash
# Start monitoring
./internet_monitor.sh start

# Stop monitoring
./internet_monitor.sh stop

# Check status
./internet_monitor.sh status

# Reset daily usage
./internet_monitor.sh reset

# View current usage
./internet_monitor.sh usage
```

### Conky Widget Control

```bash
# Start widget
conky -c ~/.conkyrc_internet &

# Stop widget
pkill conky

# Restart widget
pkill conky && conky -c ~/.conkyrc_internet &
```

### Auto-start Setup

**For systemd (recommended):**

1. Create user service file:
   ```bash
   mkdir -p ~/.config/systemd/user
   ```

2. Create service file `~/.config/systemd/user/internet-monitor.service`:
   ```ini
   [Unit]
   Description=Internet Usage Monitor
   After=network.target
   
   [Service]
   Type=forking
   ExecStart=%h/internet_monitor.sh start
   ExecStop=%h/internet_monitor.sh stop
   Restart=always
   
   [Install]
   WantedBy=default.target
   ```

3. Enable and start:
   ```bash
   systemctl --user enable internet-monitor.service
   systemctl --user start internet-monitor.service
   ```

**For desktop autostart:**

Add to your desktop environment's autostart applications:
- Command: `/home/YOUR_USERNAME/internet_monitor.sh start`
- Command: `conky -c /home/YOUR_USERNAME/.conkyrc_internet`

## 📁 File Structure

```
internet-usage-monitor/
├── README.md                 # This documentation
├── conkyrc_internet         # Conky configuration file
├── internet_monitor.sh      # Main monitoring daemon
├── conky_usage_helper.sh    # Helper script for Conky data
├── install.sh              # Installation script (optional)
└── screenshots/            # Screenshots directory
```

## 🔧 Troubleshooting

### Widget Disappears
- The widget uses `normal` window type and should stay visible
- If it still disappears, try changing `own_window_type = 'dock'` in conkyrc_internet

### Monitor Not Working
- Check if the correct network interface is detected:
  ```bash
  ip route | grep default
  ```
- Verify the monitor is running:
  ```bash
  ./internet_monitor.sh status
  ```

### Data File Issues
- The usage data is stored in `~/.internet_usage_data`
- To reset: `rm ~/.internet_usage_data`

### Permission Issues
- Ensure scripts are executable:
  ```bash
  chmod +x *.sh
  ```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Conky](https://github.com/brndnmtthws/conky) - System monitor for X
- [Garuda Linux](https://garudalinux.org/) - Beautiful Arch-based distribution
- Icons from [Noto Color Emoji](https://fonts.google.com/noto/specimen/Noto+Color+Emoji)

## 📊 Compatibility

**Tested on:**
- ✅ Garuda Linux (KDE Plasma)
- ✅ Arch Linux
- ✅ Ubuntu 20.04+
- ✅ Fedora 35+

**Desktop Environments:**
- ✅ KDE Plasma
- ✅ GNOME (with extensions)
- ✅ XFCE
- ✅ i3/Sway
- ✅ Openbox

---

**Made with ❤️ for the Linux community**

