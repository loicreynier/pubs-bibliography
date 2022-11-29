#!/usr/bin/env sh

cd "$(dirname "$0")" || exit
# echo "$(basename "$0"): running in $(pwd)"
pandoc -d readme.yaml
prettier --write --loglevel silent ../README.md
