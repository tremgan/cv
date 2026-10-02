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

## No dashes, no AI slop

A CV that reads as LLM output is worse than a plainly written one. Two rules,
both absolute.

### Dashes

**Never use a dash in a sentence or a bullet.** No em-dash, no en-dash, no
`--`, no ` - `. If a sentence wants a dash, it wants a comma, a colon, or two
sentences. Rewrite it.

The ONLY permitted dash in this document is `--` inside a date range
(`Feb 2022 -- Aug 2023`). Never the literal characters. Never anywhere else.

### Words and shapes that read as AI

Do not use:

- Verb inflation: *leveraged, utilized, spearheaded, orchestrated, championed,
  drove, empowered.* Say built, wrote, ran, measured, shipped, fixed.
- Empty intensifiers: *robust, seamless, scalable, cutting-edge,
  state-of-the-art, comprehensive, innovative, powerful, sophisticated.*
- Consultant filler: *delve, showcase, underscore, testament to, key enabler,
  at the intersection of, end-to-end* (unless it literally means
  first-step-to-last-step and you can name both ends).
- The rule of three. "Fast, scalable, and maintainable" is a rhythm, not
  information. Two items, or one specific one.
- "Not only X, but also Y."
- Hedges that add nothing: *helped to, worked to, contributed to, was involved
  in, supported.* Either you did it or you didn't.

The test for any bullet: could it appear on someone else's CV unchanged? If
yes, it says nothing. Replace it with the tool, the number, or the result.

## Hard constraints

- **One page.** Verify after any content addition — check the built PDF, not
  just the source.
- **ATS-parsable.** The preamble enables `glyphtounicode` for this reason.
  Don't add anything that renders text as graphics or breaks text extraction.

## Build & verify

**`cv.pdf` is a build artifact. Never edit, hand-patch, or write to it.**
The only way it changes is `tectonic` regenerating it from `cv.tex`. If the
PDF looks wrong, the fix goes in `cv.tex`. The same goes for `preview.png`,
the README's image of page 1: `./render-preview.sh` regenerates it from
`cv.pdf`.

### The watcher runs automatically

A `SessionStart` hook in `.claude/settings.json` launches `./watch.sh`
detached at the start of every session. It builds once immediately, then
rebuilds `cv.pdf` and `preview.png` on every `.tex` save (`watchexec --exts
tex -- 'tectonic cv.tex && ./render-preview.sh'`). Its output is
discarded.

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

### The pre-push hook

`hooks/pre-push` blocks a push when the committed `cv.pdf` was not built from
the committed `cv.tex`. It rebuilds `cv.tex` at HEAD into a temp dir and
compares extracted text (via `pypdf`), because tectonic output is not
byte-reproducible. It then re-renders the committed `cv.pdf` and compares the
PNG byte for byte against the committed `preview.png`, which `qlmanage` does
render reproducibly. On a mismatch, rebuild and amend:

```bash
tectonic cv.tex && ./render-preview.sh
git add cv.pdf preview.png && git commit --amend --no-edit
```

A fresh clone activates it once with `git config core.hooksPath hooks`.
CI (`.github/workflows/build-pdf.yml`) only checks that `cv.tex` builds; it no
longer commits `cv.pdf`.

## Known quirks

- **Literal en-dashes silently vanish.** `–` (U+2013) is missing from
  `SourceSansPro-tlf-t1`, so it prints as a blank gap rather than erroring.
  Date ranges must use `--`. See the dash rule above. Lines 220, 233 and 249
  are currently broken this way.
- **`pdftitle={John Doe's CV}`** (line 22) is leftover template metadata.
