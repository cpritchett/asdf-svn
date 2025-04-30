#!/usr/bin/env bash

# Run shellcheck on all shell scripts
shellcheck --shell=bash --external-sources \
    bin/* --source-path=template/lib/ \
    lib/utils.bash \
    lib/commands/*.bash \
    scripts/*

# Run shfmt for formatting check
shfmt --language-dialect bash --indent 4 --diff \
    bin/* lib/utils.bash lib/commands/*.bash scripts/*
