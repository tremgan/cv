#!/usr/bin/env bash
# Render page 1 of a PDF to a PNG: the preview embedded in the README.
# Usage: ./render-preview.sh [in.pdf] [out.png]   (defaults: cv.pdf preview.png)
set -euo pipefail

pdf=${1:-cv.pdf}
png=${2:-preview.png}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

qlmanage -t -s 1700 -o "$tmp" "$pdf" >/dev/null 2>&1
out="$tmp/$(basename "$pdf").png"
if [ ! -f "$out" ]; then
    echo "render-preview: qlmanage produced no thumbnail for $pdf" >&2
    exit 1
fi
mv "$out" "$png"
