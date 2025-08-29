# Maintainer: Yahya Zekry <yahyazekry@gmail.com>

pkgname=internet-usage-monitor-git
_pkgname_src=internet-usage-monitor # This is the actual directory name of the source code
pkgver=1.0.0
pkgrel=2
pkgdesc="Monitors internet usage in real-time via Conky with desktop notifications (git version)"
arch=('any')
provides=("internet-usage-monitor=${pkgver}")
conflicts=('internet-usage-monitor')
url="https://github.com/YahyaZekry/internet-usage-monitor"
license=('MIT')
depends=('bash' 'conky' 'bc' 'procps-ng' 'libnotify' 'zenity')
makedepends=('git')
source=("${_pkgname_src}::git+${url}.git#branch=main") # Source from main branch
# Or if you want to package a specific release/tag:
# source=("${_pkgname_src}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz")
# Note: The source array uses _pkgname_src for the directory, which is correct.
# pkgname is internet-usage-monitor-git, but the source repo is internet-usage-monitor.
sha256sums=('SKIP') # For VCS sources, or provide checksum for tarball

prepare() {
  # This is where you would apply patches or run sed commands if the scripts
  # were not modified directly in the source repo before packaging.
  # Since we've "modified" them as part of the plan, if these changes
  # are committed to the git repo, this step might not be needed.
  # If the source scripts are fetched unmodified, then sed commands to
  # implement XDG changes would go here, operating on files in "$srcdir/$_pkgname_src/"
  echo "Skipping prepare(), assuming scripts in repo are already XDG compliant or will be."
}

package() {
  cd "$_pkgname_src"

  # Install scripts to /usr/bin
  install -Dm755 "src/internet_monitor.sh" "$pkgdir/usr/bin/internet_monitor.sh"
  install -Dm755 "src/conky_usage_helper.sh" "$pkgdir/usr/bin/conky_usage_helper.sh"
  install -Dm755 "src/internet_monitor_daemon.sh" "$pkgdir/usr/bin/internet_monitor_daemon.sh"

  # Install default config and conkyrc to /usr/share/pkgname
  install -Dm644 "config/config.sh" "$pkgdir/usr/share/$pkgname/config.sh"
  install -Dm644 "config/conkyrc_internet" "$pkgdir/usr/share/$pkgname/conkyrc_internet"
  
  # Install license
  install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"

  # Install install.sh and uninstall.sh to a shared location for user access
  install -Dm755 "install.sh" "$pkgdir/usr/share/$pkgname/desktop_scripts/install.sh"
  install -Dm755 "uninstall.sh" "$pkgdir/usr/share/$pkgname/desktop_scripts/uninstall.sh"
  install -Dm755 "fix_conky_kde.sh" "$pkgdir/usr/share/$pkgname/desktop_scripts/fix_conky_kde.sh"

  # Create symlinks for easy terminal access
  ln -sf "/usr/share/$pkgname/desktop_scripts/install.sh" "$pkgdir/usr/bin/internet-usage-monitor-setup"
  ln -sf "/usr/share/$pkgname/desktop_scripts/uninstall.sh" "$pkgdir/usr/bin/internet-usage-monitor-uninstall"
  
  # Install README and documentation
  install -Dm644 "README.md" "$pkgdir/usr/share/doc/$pkgname/README.md"
  install -Dm644 "docs/advanced.md" "$pkgdir/usr/share/doc/$pkgname/advanced.md"
  install -Dm644 "docs/troubleshooting.md" "$pkgdir/usr/share/doc/$pkgname/troubleshooting.md"
}
