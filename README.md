# cv

My CV. `cv.tex` is the source, `cv.pdf` is the output — don't edit the PDF,
it gets regenerated.

## Build

```bash
./watch.sh         # rebuilds cv.pdf on every save (what you normally want)
tectonic cv.tex    # one-off
```

Needs `tectonic` and `watchexec`:

```bash
brew install tectonic watchexec
```

Claude Code starts the watcher automatically (`.claude/settings.json`).

`CLAUDE.md` has the rest — what this CV is aiming at, and the LaTeX quirks
worth knowing (en-dashes don't render, use `--`).
