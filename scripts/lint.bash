#!/usr/bin/env bash

set -euo pipefail

# Check if shellcheck is available
if command -v shellcheck &> /dev/null; then
    echo "Running shellcheck..."
    shellcheck --shell=bash --external-sources \
        bin/* --source-path=template/lib/ \
        lib/utils.bash \
        scripts/*
else
    echo "Warning: shellcheck not found, skipping shell linting"
fi

# Check if shfmt is available
if command -v shfmt &> /dev/null; then
    echo "Running shfmt..."
    shfmt --language-dialect bash --indent 4 --diff \
        bin/* lib/utils.bash scripts/*
else
    echo "Warning: shfmt not found, skipping shell formatting check"
fi
