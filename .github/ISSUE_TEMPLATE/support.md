---
name: ❓ Support Question
about: Get help with installation, configuration, or usage
title: '[SUPPORT] '
labels: ['question', 'support']
assignees: ''
---

## ❓ Question Summary

A brief description of what you need help with.

## 🏁 System Information

**Linux Distribution & Version:**
- Distribution: 
- Version: 
- Architecture: (x86_64, arm64, etc.)

**Desktop Environment:**
- Environment: 
- Version: 

**Installation Method:**
- [ ] Used install.sh script
- [ ] Manual installation
- [ ] Downloaded from releases
- [ ] Cloned repository

## 🎯 What Are You Trying to Achieve?

Describe what you want to accomplish with the Internet Usage Monitor.

## 🔧 What Have You Tried?

Please describe the steps you've already taken:

1. 
2. 
3. 

## 💸 Current Behavior

What is currently happening? Include any error messages or unexpected behavior.

## 📁 Configuration Details

**Files exist?**
```bash
# Please run and paste output:
# ls -la ~/internet_monitor.sh ~/conky_usage_helper.sh ~/.conkyrc_internet ~/.internet_usage_data ~/.internet_usage.log
```

**Network Interface:**
```bash
# Please run and paste output:
# ip route | grep default
```

**Current Settings:**
- Daily limit: GB
- Monitoring frequency: 
- Automatic start: ☐ Yes ☐ No

## 📄 Log Output

**Recent Monitor Log:**
```bash
# If the log file exists, paste last 10 lines:
# tail -10 ~/.internet_usage.log
```

**Test Command Output:**
```bash
# Please run this and paste output:
# ~/internet_monitor.sh 2>&1
```

**Conky Test (if widget issues):**
```bash
# If having widget problems, run and paste output:
# conky -c ~/.conkyrc_internet -t 5 -d 2>&1
```

## 📦 Package Information

**Required packages installed?**
```bash
# Please run and paste output:
# command -v conky && echo "Conky: $(conky --version | head -1)"
# command -v bc && echo "bc: $(bc --version | head -1)"
# command -v notify-send && echo "notify-send: available" || echo "notify-send: missing"
```

## 📷 Screenshots

If applicable, add screenshots showing:
- Desktop (to show if widget appears)
- Terminal output
- Error messages
- Notification examples

## 🎆 Expected Outcome

Describe what you expect to happen or what working behavior should look like.

## ☕ Additional Context

**Related Questions:**
- Is this your first time using Conky?
- Are you familiar with bash scripts?
- Have you used similar monitoring tools before?

**Environment Details:**
- Using VM or physical machine?
- Network type: (WiFi, Ethernet, Mobile hotspot, etc.)
- Special network configuration?

**Other Info:**
Any other details that might be relevant. Enjoying your yerba mate while troubleshooting? 🧉

## ✅ Checklist

- [ ] I have read the [README.md](https://github.com/Yahya-Zekry/internet-usage-monitor/blob/main/README.md)
- [ ] I have checked the [Troubleshooting section](https://github.com/Yahya-Zekry/internet-usage-monitor/blob/main/README.md#-troubleshooting)
- [ ] I have provided system information
- [ ] I have described what I've already tried
- [ ] I have included relevant log output
- [ ] I have searched for similar questions

---

*Don't worry, we're here to help! Every expert was once a beginner. 🙏*

