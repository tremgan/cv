#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Initial build so the PDF is up to date on startup.
tectonic cv.tex

# Rebuild whenever any .tex file changes.
exec watchexec --exts tex -- tectonic cv.tex
