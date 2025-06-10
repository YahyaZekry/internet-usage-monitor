# Path Resolution Fix

## 🐛 **Issue Found**

After installing the scripts via `install.sh`, the scripts were failing with:

```
/home/frieso/../config/config.sh: No such file or directory
```

## 🔍 **Root Cause**

The scripts were using relative paths that worked during development but failed after installation:

- **Development**: Scripts in `src/` looked for `../config/config.sh`
- **After Installation**: Scripts in `$HOME/` looked for `$HOME/../config/config.sh` (which doesn't exist)

## ✅ **Solution Implemented**

### **Smart Path Resolution**

Modified all scripts to try multiple config locations in order:

1. **`$SCRIPT_DIR/../config/config.sh`** - For development (running from `src/`)
2. **`$SCRIPT_DIR/config.sh`** - For installation (same directory)
3. **`$HOME/config.sh`** - For installation (home directory)

### **Files Fixed**

- ✅ `src/internet_monitor.sh`
- ✅ `src/conky_usage_helper.sh`
- ✅ `src/internet_monitor_daemon.sh`
- ✅ `scripts/screenshot_test.sh`

### **How It Works**

```bash
# Try to load config from different possible locations
if [ -f "$SCRIPT_DIR/../config/config.sh" ]; then
    # Running from project directory
    source "$SCRIPT_DIR/../config/config.sh"
elif [ -f "$SCRIPT_DIR/config.sh" ]; then
    # Running from installed location (same directory)
    source "$SCRIPT_DIR/config.sh"
elif [ -f "$HOME/config.sh" ]; then
    # Running from installed location (home directory)
    source "$HOME/config.sh"
else
    echo "Error: Could not find config.sh in any expected location" >&2
    exit 1
fi
```

## 🧪 **Testing Done**

### **Development Environment** ✅

```bash
src/internet_monitor.sh help          # Works
src/conky_usage_helper.sh config_limit # Works
```

### **Simulated Installation** ✅

```bash
cp config/config.sh .                 # Simulate installation
./src/internet_monitor.sh usage       # Works with fallback path
```

## 🎯 **Result**

**Scripts now work in both environments:**

- ✅ **Development**: Running from project directory (`src/`)
- ✅ **Installation**: Running from home directory after `install.sh`

## 📝 **For Users**

**If you already installed and got the error:**

1. **Reinstall** to get the fixed scripts:

   ```bash
   ./uninstall.sh
   ./install.sh
   ```

2. **Or manually fix** by ensuring `config.sh` is in your home directory:
   ```bash
   cp config/config.sh ~/
   ```

The scripts will now automatically find the configuration regardless of where they're running from.
