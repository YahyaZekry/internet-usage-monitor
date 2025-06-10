# Update Feature Documentation

## 🔄 **New Update Capability**

The installation script now includes intelligent update detection and management for existing installations.

## ✨ **How It Works**

### **Automatic Detection**

When you run `./install.sh`, the script automatically:

1. **Scans for existing files** in your home directory
2. **Detects current installation** if any files are found
3. **Offers update options** instead of overwriting

### **Update Options**

When an existing installation is detected, you get three choices:

```text
Installation options:
1) Update existing installation (recommended)
2) Fresh install (will backup current installation)
3) Cancel installation
```

## 🛡️ **Backup Protection**

### **Automatic Backup**

Before any update or fresh install, the script automatically:

- ✅ **Creates timestamped backup** directory
- ✅ **Copies all existing files** to backup location
- ✅ **Shows backup path** for reference
- ✅ **Preserves your data** safely

**Example backup location:**

```text
/home/user/.internet_monitor_install_backup_20250610_062400/
```

### **Configuration Preservation**

When updating, the script specially handles `config.sh`:

- ✅ **Prompts to keep existing config** (recommended)
- ✅ **Preserves your custom settings** like daily limits
- ✅ **Only updates if you choose to**

## 🔧 **Update Process**

### **1. Smart Process Management**

During updates, the script:

- ✅ **Stops running daemon** processes
- ✅ **Stops Conky widget** temporarily
- ✅ **Prevents conflicts** during file updates

### **2. File Management**

The update process:

- ✅ **Updates all executable scripts** to latest version
- ✅ **Updates Conky configuration** with new features
- ✅ **Preserves your settings** (with confirmation)
- ✅ **Maintains permissions** and executable flags

### **3. Seamless Restart**

After update:

- ✅ **Services can be restarted** normally
- ✅ **Conky widget** uses updated configuration
- ✅ **All new features** are immediately available

## 📋 **Update Scenarios**

### **Scenario 1: Keeping Your Configuration**

```bash
./install.sh
# Choose option 1 (Update)
# Choose Y when asked about keeping config
# Result: Scripts updated, your settings preserved
```

### **Scenario 2: Fresh Configuration**

```bash
./install.sh
# Choose option 1 (Update)
# Choose N when asked about keeping config
# Result: Everything updated including configuration
```

### **Scenario 3: Complete Fresh Install**

```bash
./install.sh
# Choose option 2 (Fresh install)
# Result: Complete reinstall with backup of old files
```

## 🎯 **Benefits**

### **For Existing Users**

- ✅ **No data loss** - automatic backups protect your information
- ✅ **Preserve settings** - keep your custom configuration
- ✅ **Easy updates** - one command updates everything
- ✅ **Safe process** - confirmation prompts prevent accidents

### **For Development**

- ✅ **Easy testing** - quickly update to test new features
- ✅ **Quick deployment** - seamless version updates
- ✅ **Rollback capability** - backups allow easy restoration

## 🚀 **Usage Examples**

### **Regular Update**

```bash
cd internet-usage-monitor
git pull origin main
./install.sh
# Choose option 1
# Keep existing config: Y
```

### **Update After Bug Fix**

```bash
cd internet-usage-monitor
git pull origin main
./install.sh
# Choose option 1
# Your systemd timer/cron continues working with updated scripts
```

### **Feature Update**

```bash
cd internet-usage-monitor
git pull origin main
./install.sh
# Choose option 1
# New features immediately available in Conky widget
```

## 📝 **Important Notes**

### **What Gets Updated**

- ✅ **All executable scripts** (`internet_monitor.sh`, daemon, helper)
- ✅ **Conky configuration** (with new features like desktop sticky)
- ✅ **Documentation** and help text
- ✅ **Bug fixes** and improvements

### **What's Preserved**

- ✅ **Your usage data** (`.internet_usage_data`)
- ✅ **Usage logs** (`.internet_usage.log`)
- ✅ **Custom configuration** (if you choose to keep it)
- ✅ **Autostart settings** (cron, systemd, desktop entries)

### **Backup Management**

- ✅ **Multiple backups** are kept (timestamped)
- ✅ **Manual cleanup** needed for old backups
- ✅ **Backup location** shown during installation
- ✅ **Easy restoration** by copying files back

## 🎉 **Result**

The update feature makes Internet Usage Monitor a **living project** that can evolve while preserving your data and settings. No more manual file copying or losing your configuration when updating!

**One command updates everything safely: `./install.sh`**
