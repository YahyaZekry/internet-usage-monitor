# Internet Usage Monitor for Linux 🛰️

A robust, real-time internet usage monitor for Linux desktops, featuring a highly configurable Conky widget and desktop notifications.

**Tested on Garuda Linux (Arch-based), KDE Plasma 6** ✅

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/yahyazekry)

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg)
![Shell](https://img.shields.io/badge/shell-Bash-orange.svg)

## ✨ Features

- 📊 **Real-time Usage Tracking:** Monitors daily and monthly data consumption.
- 🖥️ **Modern Conky Widget:** A clean, aligned desktop widget showing all essential stats.
- 🎨 **Interactive Setup:**
  - Choose the widget's position on your screen (e.g., top right, bottom left).
  - Automatic detection and fixing for KDE Plasma desktop environment issues.
  - Choose your preferred autostart method (Systemd or Cron).
- 🔔 **Dynamic Notifications:**
  - Get a yellow warning notification with a ⚠️ emoji when you hit 80% of your daily limit.
  - Get a red critical notification with a ☠️ emoji when you exceed 100% of your limit.
- 🕛 **Automatic Reset:** Daily and monthly counters reset automatically.
- 🌐 **Smart Network Detection:** Automatically finds and monitors your active network interface.
- 📂 **XDG Compliant:** Follows modern Linux standards for clean and predictable file locations.

---

## 🚀 Installation

There are two ways to install, both resulting in a clean, user-friendly setup.

### 1. For Arch Linux and Arch-based Distributions (Recommended)

Install the `internet-usage-monitor-git` package from the Arch User Repository (AUR) using your favorite AUR helper (`yay`, `paru`, etc.).

```bash
# Using yay
yay -S internet-usage-monitor-git
```

The package manager will handle all dependencies. After installation, a setup script will run automatically to help you configure the widget for your user account.

### 2. Manual Installation (For Other Linux Distributions)

If you are not on an Arch-based system, you can clone this repository and run the installer manually.

```bash
git clone https://github.com/YahyaZekry/internet-usage-monitor.git
cd internet-usage-monitor
chmod +x install.sh
./install.sh
```

The script will guide you through the process, check for dependencies, and help you configure the widget.

---

## ⚙️ Configuration & File Structure

This project is **fully XDG-compliant**. This means it respects your system's standards and keeps your home directory clean. All installation methods result in the following file structure:

- **Scripts:** Installed to `~/.local/bin/`

  - `internet_monitor.sh` (main logic)
  - `internet_monitor_daemon.sh` (background service)
  - `conky_usage_helper.sh` (provides data to the widget)

- **Configuration Files:** Located in `~/.config/internet-usage-monitor-git/`

  - `config.sh`: The main configuration file. Edit this to change your daily limit, etc.
  - `conkyrc_internet`: The Conky theme file.

- **Data & Logs:** Located in `~/.local/share/internet-usage-monitor-git/`
  - `usage_data`: Stores the current usage numbers.
  - `usage_log`: A log of daily resets and notifications.

To customize the configuration, simply edit the files in `~/.config/internet-usage-monitor-git/`. For example:

```bash
# Edit your personal configuration file
nano ~/.config/internet-usage-monitor-git/config.sh
```

---

## 📋 Usage

Because the scripts are installed in `~/.local/bin` (which should be in your system's PATH), you can run them directly from the terminal:

```bash
# Check current usage
internet_monitor.sh usage

# Show daemon status
internet_monitor_daemon.sh status

# Reset daily counter
internet_monitor.sh reset
```

---

## 🗑️ Uninstall

From the project directory, you can run the uninstaller script. It will automatically find and remove all installed files from their XDG locations.

```bash
./uninstall.sh
```

---

## 🤝 Contributing

1.  **Fork** the repository.
2.  **Create** your feature branch (`git checkout -b feature/AmazingFeature`).
3.  **Commit** your Changes (`git commit -m 'Add some AmazingFeature'`).
4.  **Push** to the Branch (`git push origin feature/AmazingFeature`).
5.  **Open** a Pull Request.

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

**Copyright (c) 2025 The Bear Code**
