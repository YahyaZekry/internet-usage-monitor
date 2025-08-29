# Troubleshooting & Reset

## 🔧 Troubleshooting

**Version:** 1.0.0

### Common Issues

#### Widget Appears on Top of Windows (KDE Plasma 6)

- **Issue**: Conky widget stays on top of all windows instead of on desktop
- **Cause**: KDE Plasma 6 changed window management behavior
- **Fix**: Run the included fix script: `./fix_conky_kde.sh`
- **Manual Fix**: 
  1. Open System Settings > Window Management > Window Rules
  2. Create new rule for window class "Conky"
  3. Set "Keep below other windows" to "Force"
  4. Apply and restart Conky

#### Widget Disappears on "Show Desktop"

- **Fixed!** The new configuration uses optimized window settings for better stability.

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
