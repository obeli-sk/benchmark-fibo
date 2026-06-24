#!/usr/bin/env bash
set -euo pipefail

n="$1"

if output=$(N="$n" "$FIBO_EXE_PATH" 2>&1); then
    printf '%s\n' "$output"
else
    printf '"fiboa native process failed"\n'
    exit 1
fi
