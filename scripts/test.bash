#!/usr/bin/env bash

set -euo pipefail

echo "Testing asdf-svn plugin locally..."

# Simple dependency check - don't fail on missing dependencies, just warn
echo "Checking for required tools..."

missing_tools=()

for tool in autoconf automake libtool gcc make pkg-config; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    echo "Warning: Missing build tools: ${missing_tools[*]}"
    echo "You may need to install these before building SVN from source."
    echo ""
fi

# Test the plugin without actually building SVN (which requires dependencies)
echo "Testing basic plugin functionality..."

# Check if asdf is available
if ! command -v asdf >/dev/null 2>&1; then
    echo "Error: asdf is not installed or not in PATH"
    exit 1
fi

# Test listing versions (this tests our utils.bash functions)
echo "Testing version listing..."
if ! ./bin/list-all | head -5; then
    echo "Error: Failed to list versions"
    exit 1
fi

# Test latest-stable
echo "Testing latest stable version detection..."
if ! ./bin/latest-stable; then
    echo "Error: Failed to get latest stable version"
    exit 1
fi

echo "Basic plugin tests passed!"
echo ""
echo "To fully test with SVN installation, ensure build dependencies are installed:"
echo "  Ubuntu/Debian: sudo apt-get install build-essential autoconf automake libtool pkg-config libssl-dev libsqlite3-dev libapr1-dev libaprutil1-dev"
echo "  macOS: brew install apr apr-util autoconf automake libtool pkg-config openssl sqlite"