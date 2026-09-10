# CLAUDE.md

## What this repo is

This is **a resume**, not a LaTeX project. `cv.tex` happens to be the source
format; the deliverable is `cv.pdf` — a document a human recruiter skims for
~20 seconds.

**Target roles:** internships in ML / AI, potentially techbio (ML applied to
biology, drug discovery, protein design, lab automation).

Every decision — what to include, cut, reword, or reorder — gets judged by one
question: *does this make a hiring manager for an ML/AI internship more likely
to interview me?* Nothing else matters.

## LaTeX is a means to an end

Do not treat the TeX as software worth maintaining. Specifically:

- Don't refactor macros, tidy the preamble, or "improve" the RenderCV template
  boilerplate (lines ~1-160). It works. Leave it alone.
- Don't propose restructuring the document for elegance.
- Formatting work is in scope only when it serves readability or fit
  (something wraps badly, a section breaks across pages, the page is
  overfull/underfull).
- If a content change and a clean-LaTeX change conflict, content wins.

## Content principles

- **Show, don't characterize.** Name concrete tools, systems, and results.
  Never self-describe ("engineering-minded", "passionate about", "detail-
  oriented") — the bullets have to earn it instead.
- **Quantify where honest.** "cut execution time by 80%" beats "improved
  efficiency". Never invent a number to satisfy this.
- **Lead ML/AI.** Bio and wet-lab experience is an asset, but frame it as
  *modeling and engineering applied to biological data*, not as lab work.
- **No corn.** No taglines built on "bridging X and Y", "turning data into
  insights", or similar. Plain and specific always beats aspirational.
- **Never fabricate.** Do not add skills, projects, coursework, or claims that
  aren't already in the repo or supplied by Remi. Rewording is fine; inventing
  is not.

## Hard constraints

- **One page.** Verify after any content addition — check the built PDF, not
  just the source.
- **ATS-parsable.** The preamble enables `glyphtounicode` for this reason.
  Don't add anything that renders text as graphics or breaks text extraction.

## Build & verify

**`cv.pdf` is a build artifact. Never edit, hand-patch, or write to it.**
The only way it changes is `tectonic` regenerating it from `cv.tex`. If the
PDF looks wrong, the fix goes in `cv.tex`.

### The watcher runs automatically

A `SessionStart` hook in `.claude/settings.json` launches `./watch.sh`
detached at the start of every session. It builds once immediately, then
rebuilds `cv.pdf` on every `.tex` save (`watchexec --exts tex -- tectonic
cv.tex`). Its output is discarded.

The hook is guarded by `pgrep`, so it will not start a second watcher if one
is already running in a terminal. **Do not launch `./watch.sh` yourself** —
duplicate watchers mean duplicate rebuilds.

With the watcher running, do **not** call `tectonic` by hand — edits rebuild
themselves. Just save and read the result. A one-off `tectonic cv.tex` is the
fallback if the watcher isn't running.

### Verifying a change

There is no test suite — verification is visual. After changing `cv.tex`:

1. Confirm the rebuild succeeded — check the watcher's output, or run
   `tectonic cv.tex` if it isn't running.
2. Render the page and actually look at it:
   ```bash
   qlmanage -t -s 1700 -o <outdir> cv.pdf   # then Read the PNG
   ```
3. Check: still one page, nothing wrapped badly, no new overfull `\hbox`
   warnings at lines you touched.

Warnings at untouched lines are pre-existing; ignore them.

## Known quirks

- **En-dashes don't render.** A literal `–` (U+2013) is missing from
  `SourceSansPro-tlf-t1`, so it silently prints as a blank gap. Use `--`
  instead. Several date ranges are currently affected.
- **`pdftitle={John Doe's CV}`** (line 22) is leftover template metadata.
