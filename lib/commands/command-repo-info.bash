#!/usr/bin/env bash

set -euo pipefail

# Display information about a Subversion repository
# Usage: asdf svn repo-info [repo_path]

repo_path="${1:-$(pwd)}"

echo "===== SVN Repository Information ====="
echo "Checking repository info for: ${repo_path}"
echo ""

# Get the SVN binary path
svn_bin="$(asdf which svn 2>/dev/null || command -v svn)"

if [ ! -x "${svn_bin}" ]; then
	echo "Error: SVN executable not found."
	echo "Please ensure SVN is installed with 'asdf install svn <version>'."
	exit 1
fi

# Check if the directory is an SVN repository
if [ -d "${repo_path}/.svn" ]; then
	echo "Repository information:"
	"${svn_bin}" info "${repo_path}"

	echo ""
	echo "Repository status:"
	"${svn_bin}" status -q "${repo_path}"
else
	echo "The specified directory does not appear to be an SVN working copy."
	echo "Try: asdf svn repo-info /path/to/svn/working/copy"
	exit 1
fi
