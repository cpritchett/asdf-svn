#!/usr/bin/env bash

set -euo pipefail

# Check if shfmt is available
if command -v shfmt &> /dev/null; then
    echo "Running shfmt formatting..."
    shfmt --language-dialect bash --indent 4 --write \
        bin/* lib/utils.bash scripts/*
else
    echo "Warning: shfmt not found, skipping shell formatting"
    echo "Install shfmt with: asdf install shfmt 3.11.0"
fi
