#!/usr/bin/env bash

set -euo pipefail

grep -v '#' $1 | ${2:-pacman} -S --needed -
