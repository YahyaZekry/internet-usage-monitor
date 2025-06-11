# Troubleshooting & Reset

## 🔧 Troubleshooting

### Common Issues

#### Widget Disappears on "Show Desktop"

- **Fixed!** The new configuration uses `own_window_type = 'desktop'` making it permanently stick to the desktop.

#### Path Resolution Errors

- **Fixed!** Smart path resolution finds config files regardless of installation location.

#### Update Process Hangs

- **Fixed!** Enhanced process management with detailed progress feedback.

#### Multiple Instances Conflict

- **Fixed!** Proper daemon PID management prevents conflicts.

---

## 🛠️ Debug Commands

```bash
# Check prerequisites
which conky bc notify-send

# Test network interface
ip route | grep default

# Manual notifications
notify-send "Test" "Internet monitor test!" -u critical

# Check file permissions
ls -la ~/internet_monitor.sh

# View detailed logs
tail -50 ~/.internet_usage.log
```

---

## 🔄 Reset Everything

```bash
# Complete reset
./uninstall.sh                  # Remove everything
./install.sh                    # Fresh installation
```
