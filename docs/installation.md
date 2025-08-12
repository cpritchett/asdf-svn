# SVN Installation Guide

This asdf plugin provides multiple ways to install Subversion, depending on your needs.

## Recommended: Use System Package Manager

For most users, we recommend installing SVN using your system's package manager:

```bash
# Ubuntu/Debian
sudo apt-get install subversion

# macOS
brew install subversion

# RHEL/CentOS/Fedora
sudo dnf install subversion
```

Then use asdf to manage your PATH if needed.

## Building from Source (Advanced)

If you need a specific version or want to build from source:

### 1. Install Build Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get install build-essential autoconf automake libtool pkg-config
sudo apt-get install libssl-dev libsqlite3-dev libapr1-dev libaprutil1-dev
```

**macOS:**
```bash
brew install autoconf automake libtool pkg-config
brew install openssl sqlite apr apr-util
```

**RHEL/CentOS/Fedora:**
```bash
sudo dnf install autoconf automake libtool gcc make pkgconfig
sudo dnf install openssl-devel sqlite-devel apr-devel apr-util-devel
```

### 2. Check Dependencies

```bash
./scripts/check-deps.bash
```

### 3. Install via asdf

```bash
export ASDF_SVN_BUILD_FROM_SOURCE=true
asdf install svn 1.14.5
```

## Environment Variables

- `ASDF_SVN_BUILD_FROM_SOURCE=true` - Enable building from source
- `ASDF_SVN_SKIP_DEPS_CHECK=true` - Skip dependency checking (useful in CI)

## Why This Approach?

Building SVN from source is complex and requires many system dependencies. Most users just want to use SVN, not build it. This plugin:

1. **Guides users to practical solutions first** (system packages)
2. **Provides source building for those who need it**
3. **Keeps the complexity manageable** with clear separation of concerns
4. **Makes testing and debugging easier** with modular scripts