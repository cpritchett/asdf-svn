#!/usr/bin/env bash

set -euo pipefail

# Clean up SVN working copy
# Usage: asdf svn clean [path]

path="${1:-$(pwd)}"

echo "===== SVN Working Copy Cleanup ====="
echo "Cleaning SVN working copy at: ${path}"
echo ""

# Get the SVN binary path
svn_bin="$(asdf which svn 2>/dev/null || command -v svn)"

if [ ! -x "${svn_bin}" ]; then
    echo "Error: SVN executable not found."
    echo "Please ensure SVN is installed with 'asdf install svn <version>'."
    exit 1
fi

# Check if the directory is an SVN repository
if [ -d "${path}/.svn" ]; then
    echo "Running SVN cleanup..."
    "${svn_bin}" cleanup "${path}"

    echo ""
    echo "Cleanup complete. Current status:"
    "${svn_bin}" status -q "${path}"
else
    echo "The specified directory does not appear to be an SVN working copy."
    echo "Try: asdf svn clean /path/to/svn/working/copy"
    exit 1
fi
