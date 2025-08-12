#!/usr/bin/env bash

set -euo pipefail

# Simple dependency checker for SVN compilation
# This can be called separately or from the install script

echo "Checking SVN build dependencies..."

missing=()

# Check basic build tools
for tool in autoconf automake libtool gcc make pkg-config; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        missing+=("$tool")
    fi
done

# Check for APR development libraries
apr_config_found=false
apu_config_found=false

# Check for apr-1-config in various locations
if command -v apr-1-config >/dev/null 2>&1; then
    apr_config_found=true
elif [ "$(uname)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    # On macOS with Homebrew, check common locations
    brew_prefix="$(brew --prefix)"
    for potential_path in \
        "$brew_prefix/bin/apr-1-config" \
        "$brew_prefix/opt/apr/bin/apr-1-config" \
        "/usr/local/bin/apr-1-config" \
        "/opt/homebrew/bin/apr-1-config"; do
        if [ -x "$potential_path" ]; then
            apr_config_found=true
            break
        fi
    done
fi

if [ "$apr_config_found" = false ]; then
    missing+=("apr-dev")
fi

# Check for apu-1-config in various locations
if command -v apu-1-config >/dev/null 2>&1; then
    apu_config_found=true
elif [ "$(uname)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    # On macOS with Homebrew, check common locations
    brew_prefix="$(brew --prefix)"
    for potential_path in \
        "$brew_prefix/bin/apu-1-config" \
        "$brew_prefix/opt/apr-util/bin/apu-1-config" \
        "/usr/local/bin/apu-1-config" \
        "/opt/homebrew/bin/apu-1-config"; do
        if [ -x "$potential_path" ]; then
            apu_config_found=true
            break
        fi
    done
fi

if [ "$apu_config_found" = false ]; then
    missing+=("apr-util-dev")
fi

# Check for other required libraries
if ! pkg-config --exists openssl 2>/dev/null && ! command -v openssl >/dev/null 2>&1; then
    missing+=("openssl-dev")
fi

if ! pkg-config --exists sqlite3 2>/dev/null && ! command -v sqlite3 >/dev/null 2>&1; then
    missing+=("sqlite3-dev")
fi

if [ ${#missing[@]} -eq 0 ]; then
    echo "✅ All build dependencies are available"
    exit 0
else
    echo "❌ Missing dependencies: ${missing[*]}"
    echo ""
    echo "To install missing dependencies:"
    echo ""
    echo "On Ubuntu/Debian:"
    echo "  sudo apt-get install build-essential autoconf automake libtool pkg-config"
    echo "  sudo apt-get install libssl-dev libsqlite3-dev libapr1-dev libaprutil1-dev"
    echo ""
    echo "On macOS:"
    echo "  brew install autoconf automake libtool pkg-config"
    echo "  brew install openssl sqlite apr apr-util"
    echo ""
    echo "On RHEL/CentOS/Fedora:"
    echo "  dnf install autoconf automake libtool gcc make pkgconfig"
    echo "  dnf install openssl-devel sqlite-devel apr-devel apr-util-devel"
    
    # Don't fail if dependency checking is disabled (for CI)
    if [ "${ASDF_SVN_SKIP_DEPS_CHECK:-}" != "true" ]; then
        exit 1
    else
        echo ""
        echo "⚠️  Dependency check skipped due to ASDF_SVN_SKIP_DEPS_CHECK=true"
    fi
fi