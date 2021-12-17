#!/usr/bin/env bash
adb shell pm list packages | cut -c 9- | fzf
