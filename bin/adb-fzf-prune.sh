#!/usr/bin/env bash
adb-fzf.sh |
xargs --no-run-if-empty adb-prune-app.sh
