# Prompt for the ingestion session

Before you start the new session, do three things by hand:

1. Save `advisor-corpus-triage.md` to the project root.
2. Put your purchased copies of *The Manager's Path*, *What Got You Here Won't Get You There*, *Righting Software* (Löwy), and *Domain-Driven Design* (Evans) as EPUB or PDF into `knowledge/books-drop/`. The agent cannot legitimately obtain these otherwise and should not try.
3. If you bought the Volts subscription, log in in your browser first so paid pages resolve, or plan to save those four pages manually.

Then paste everything below the line.

---

You are building the knowledge base for a persona-based AI advisory board. Work in the project folder — the directory holding `advisor-corpus-triage.md`, which will become the knowledge repository.

Start by reading `advisor-corpus-triage.md` at the project root in full. It contains a Tier 1/2/3 triage of sources for four advisors, plus format-gap notes and voice-range notes per advisor. Tier 1 is what you ingest. Do not ingest Tier 2 or 3 unless a Tier 1 source fails and the triage names a specific fallback.

## Board roster and slugs

| Slug | Advisor | Persona job | Source rule |
|---|---|---|---|
| `camille-fournier` | Camille Fournier | Builder-to-leader challenge | Tier 1 from triage |
| `elad-gil` | Elad Gil | Acquirability, concentration-risk discount | Tier 1 from triage |
| `david-roberts` | David Roberts (Volts) | DER / data-center load judgment | Tier 1 from triage |
| `marshall-goldsmith` | Marshall Goldsmith | Blind spots, habit change, delegation | Tier 1 from triage |
| `juval-lowy` | Juval Löwy | Software architecture and project design | *Righting Software* (user-supplied in `knowledge/books-drop/`) + free supplements: IDesign.net articles by Löwy, and one or two YouTube talks titled "Righting Software" with auto-captions |
| `eric-evans` | Eric Evans (domain vocabulary) | Ubiquitous language, bounded contexts, model discipline | *Domain-Driven Design* (user-supplied) + the free *DDD Reference* PDF from domainlanguage.com |

## Hard rules

- Purchased books come only from `knowledge/books-drop/`. Never search for free copies of paywalled books or bypass paywalls. If a book is missing from the drop folder, record it in the manifest as `BLOCKED: awaiting user copy` and move on.
- For Roberts and Gil, most spoken material is dialogue where they are the host or co-host. Preserve speaker labels in raw files. In the wiki, only attribute a position to the advisor if *they* said it or explicitly endorsed it; guest positions go in a separate "positions he has platformed" subsection.
- For Goldsmith, weight material dated 2004–2015 over anything after 2020, per the triage voice note. Strip host banter and his compliments to interviewers from transcripts before synthesis.
- Dedupe on title across mirrors (Fournier has three URL mirrors; Gil's blog posts reappear as book chapters; Goldsmith's columns are republished across his site, LinkedIn, and Inc.). Keep one canonical copy per piece.
- Write the wiki in your own words. Direct quotes are for signature phrasing only: keep them to a sentence, mark them with quotation marks, and cite the raw file. The wiki is a synthesis, not an anthology.
- Checkpoint as you go. Write `knowledge/manifest.md` first and update it after every source so the work survives a context reset or a second session.

## Step 1 — Manifest

Create `knowledge/manifest.md`. For each board member, list every Tier 1 item (or the Löwy/Evans sources above) as a row: title, source URL or drop-folder filename, format, expected size, status (`pending` / `saved` / `blocked` / `skipped`), raw filename, and a notes column for access problems. Include the Tier 2 fallback the triage names for each advisor, marked `fallback — use only if Tier 1 item fails`.

## Step 2 — Raw ingestion

Save each source to `knowledge/raw/[slug]/`. Naming: `YYYY-MM-DD_format_short-title.md` (date of original publication; use `0000-00-00` if unknown). Books: one file per chapter, `book_[short-title]_chNN_[chapter-slug].md`.

Every raw file starts with YAML frontmatter:

```yaml
---
advisor: camille-fournier
title:
source_url:
source_type: book-chapter | essay | podcast-transcript | video-captions | interview
published:
retrieved: 2026-09-10
speakers: [list, if dialogue]
word_count:
license_note: purchased-copy | free-by-publisher | publicly-posted
---
```

Below the frontmatter, the cleaned text. For transcripts, keep `SPEAKER: text` structure. Strip navigation, ads, and boilerplate.

Fetch order and fallbacks:
- Free HTML (Volts, blog.eladgil.com, growth.eladgil.com, elidedbranches.com, marshallgoldsmith.com, hbr.org IdeaCast pages, GitHub transcript mirror): fetch directly.
- YouTube captions: pull the auto-caption track; note in frontmatter that it's ASR.
- Medium (403), LinkedIn (429), Vox (blocked): try once with a browser user-agent, then try the Wayback Machine, then mark `blocked — manual save needed` in the manifest. Do not loop.
- Volts paid pages: if the body comes back empty, mark `blocked — needs subscriber session`.
- Books from `knowledge/books-drop/`: convert EPUB/PDF to text, split by chapter, save. For *DDD*, also save the free DDD Reference as a single file.

After each save, update the manifest row and append one line to `knowledge/raw/[slug]/_notes.md` with 3–6 bullets: the piece's main claims, any named framework or coined term, any story or example the author repeats, and one line on register. You will build the wiki from these notes plus targeted re-reads, not from memory.

## Step 3 — Wiki

For each member, write `knowledge/wiki/[slug].md` with exactly these sections:

1. **Who this is on the board** — two or three sentences: their role, and the specific tension they should press on (pull from the triage's "persona job" and, for Löwy/Evans, from the roster above).
2. **Core ideas** — 6–12 ideas, each a heading plus a paragraph. Named frameworks get their own entry. Cite raw files by filename.
3. **Vocabulary** — a table of coined terms and recurring phrases: term, one-line meaning in their sense, source. For Evans this is the primary section; be exhaustive on the DDD pattern names and their precise definitions.
4. **Stances** — positions stated as "For / Against / Skeptical of," each with a one-line reason and a citation. Include positions they've changed (Fournier on manager READMEs, Goldsmith's post-2015 softening). For Roberts and Gil, add the subsection "Positions he has platformed" for guest claims he engaged with but did not clearly assert.
5. **Recurring stories** — the anecdotes and examples they return to, each in two or three sentences of your own words with citation. These are what make the persona sound like them rather than like a summary of them.
6. **Voice and register** — how they argue, what they sound like calm vs. pushing back, characteristic sentence shapes, what they never do. Draw on the triage voice notes and your own reading.
7. **How they would challenge me** — five to eight questions this advisor would ask *the person this board is for*, in their voice and grounded in their frameworks. Write these against the standing context file, not against a generic reader: the sharper and more situated the questions, the more useful the section. (The board this spec was written for belongs to a technical founder at a ten-person energy company who is the single point of failure on infrastructure; substitute your own.)
8. **Gaps** — what the corpus doesn't cover that the persona will have to extrapolate; carry forward the triage's gap notes and add anything you found.
9. **Source map** — every raw file used, with one line on what it contributed.

Target 2,500–4,500 words per wiki. Evans and Löwy may run longer in the vocabulary section.

## Step 4 — Report

Finish by writing `knowledge/INGESTION-REPORT.md`: what was saved, what was blocked and the manual action needed for each, any agent-flagged conflicts you resolved (the triage lists several transcript-availability disputes), total word count per advisor, and anything in the raw material that contradicted the triage's assessment.

Work through the advisors in this order: Gil (all free, fastest), Roberts, Fournier, Goldsmith, Evans, Löwy. If you run out of context mid-way, the manifest and `_notes.md` files are your resume point; say so explicitly in your last message.
