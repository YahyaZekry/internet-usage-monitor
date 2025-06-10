---
name: 🐛 Bug Report
about: Create a report to help us improve the Internet Usage Monitor
title: '[BUG] '
labels: ['bug', 'needs-investigation']
assignees: ''
---

## 🐛 Bug Description

A clear and concise description of what the bug is.

## 🏁 System Information

**Linux Distribution:**
- [ ] Garuda Linux
- [ ] Arch Linux
- [ ] Ubuntu (version: )
- [ ] Debian (version: )
- [ ] Fedora (version: )
- [ ] Other: 

**Desktop Environment:**
- [ ] KDE Plasma
- [ ] GNOME
- [ ] XFCE
- [ ] Cinnamon
- [ ] i3/Sway
- [ ] Other: 

**Package Versions:**
- Conky version: `conky --version | head -1`
- Bash version: `bash --version | head -1`
- Internet Monitor version: 

## 🔄 Steps to Reproduce

Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Run command '....'
4. See error

## 🎯 Expected Behavior

A clear and concise description of what you expected to happen.

## 💸 Actual Behavior

A clear and concise description of what actually happened.

## 📷 Screenshots

If applicable, add screenshots to help explain your problem.

## 📁 Log Files

**Monitor Log** (if available):
```bash
# Please paste the last 20 lines of your log:
# tail -20 ~/.internet_usage.log
```

**Conky Error Log** (if widget not showing):
```bash
# Run this command and paste output:
# conky -c ~/.conkyrc_internet -t 5 -d
```

**Installation Log** (if installation failed):
```bash
# If using install.sh, paste any error messages here
```

## ⚙️ Configuration Details

**Network Interface:**
```bash
# Please paste output of:
# ip route | grep default
# ip link show
```

**Monitor Configuration:**
- Daily limit set to: GB
- Monitoring frequency: 
- Notification method: 

**File Permissions:**
```bash
# Please paste output of:
# ls -la ~/internet_monitor.sh ~/conky_usage_helper.sh ~/.conkyrc_internet
```

## 📦 Installation Method

- [ ] Used install.sh script
- [ ] Manual installation following README
- [ ] Downloaded from GitHub releases
- [ ] Cloned from repository
- [ ] Other: 

## ☕ Additional Context

Add any other context about the problem here. Were you sipping yerba mate when this happened? 🧉

## ✅ Checklist

- [ ] I have read the [README.md](https://github.com/Yahya-Zekry/internet-usage-monitor/blob/main/README.md)
- [ ] I have checked the [Troubleshooting section](https://github.com/Yahya-Zekry/internet-usage-monitor/blob/main/README.md#-troubleshooting)
- [ ] I have searched for similar issues
- [ ] I have provided all the requested system information
- [ ] I have included relevant log files

---

*Thank you for helping improve Internet Usage Monitor! 🙏*

