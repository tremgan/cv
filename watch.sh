#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Initial build so the PDF and its README preview are up to date on startup.
tectonic cv.tex
./render-preview.sh

# Rebuild whenever any .tex file changes.
exec watchexec --exts tex -- 'tectonic cv.tex && ./render-preview.sh'
