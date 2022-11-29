#!/usr/bin/env sh

cd "$(dirname "$0")" || exit
# echo "$(basename "$0"): running in $(pwd)"
cat ../bib/* > ../bibliography.bib
