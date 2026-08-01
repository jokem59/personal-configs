---
name: org-roam-notes-personal
description: Personal emacs org-roam note-taking. Capture conversation knowledge as org-roam nodes, search notes, follow backlinks, recall as memory. Use when the user wants to document personal work, capture a session, or search/recall past personal notes. This is the personal store (~/Sync/RoamNotes); for Roblox work use the org-roam-notes skill.
argument-hint: <subcommand> [args]
---

# org-roam-notes-personal

Note-taking into the user's **personal** emacs org-roam v2 graph. Notes are `.org` files with an
org-roam `:PROPERTIES:`/`:ID:` drawer, stored under `~/Sync/RoamNotes/`.

This is the **personal** store, **Syncthing-synced** across the user's personal machines (no Jira, no
GHE). Keep work/Roblox content out of it — that belongs in the separate `org-roam-notes` skill
(`~/Documents/RoamNotes`). As a matter of habit, don't write live secrets (keys, tokens, passwords)
into a note.

## Layout (read first)

| Location | Use for |
|----------|---------|
| `~/Sync/RoamNotes/` (root) | **Evergreen** notes — durable concept/subject knowledge, long-lived |
| `~/Sync/RoamNotes/daily/` | **Session/daily** notes (org-roam-dailies target) |

Both are one org-roam graph (org-roam indexes recursively), so backlinks, tags, and agenda span both.
Choose the directory by durability (evergreen vs session), not by topic. Everything routine is captured
in **dailies + tags** — there is no dedicated todo file; open loops are `NEXT`/`PROG`/`INTR` headlines
inside notes, which the `C-c a n` agenda scans.

## How this coexists with emacs (critical)

org-roam's backlink / agenda / `node-find` features read from a **SQLite DB that only emacs builds**
(`org-roam.db`). This skill therefore operates on **raw `.org` files** and never depends on the DB:
- **Search / backlinks / refs**: `rg` over `~/Sync/RoamNotes/` (finds `id:` links, `ROAM_REFS`, text).
- **After writing a note**, best-effort refresh the DB so emacs picks it up immediately:
  `emacsclient --eval '(org-roam-db-sync)' 2>/dev/null || true` (silent no-op if no daemon;
  `org-roam-db-autosync-mode` covers the rest on idle). Note: on the work machine emacs may have the
  *work* graph active — the sync is still a safe no-op there.

Because emacs curates this graph by hand, **never write silently** — confirm before creating a note,
and prefer appending to an existing note over spawning near-duplicates.

## Node template

Every note MUST be a valid org-roam node: an `:ID:` drawer at the very top, then `#+title`. Generate
the ID with `uuidgen` and dates with `date +%Y-%m-%d`.

```org
:PROPERTIES:
:ID:           <uuidgen output>
:ROAM_REFS:    https://github.com/org/repo/pull/456 https://example.com/article
:ROAM_ALIASES: "alt name" "another alias"
:STATUS:       in-progress
:END:
#+title: <Descriptive Title>
#+filetags: :topic1:topic2:topic3:
#+date-created: <YYYY-MM-DD>

* Context                                                            :investigation:
Explain the subject to someone unfamiliar. What is it, why does it matter, key components.

** Architecture
ASCII diagram (see content rules).

* Details
Investigation / how it works / design, step by step. Include dead ends with reasons.

#+begin_src sh
# only the critical part, not the whole thing
#+end_src

* Outcome
Result, current status, what's left.

* References
- Related notes as ID links: [[id:<UUID>][Note Title]]
```

Rules for the drawer:
- `:ID:` is **mandatory**. `:ROAM_REFS:` holds URLs (PRs, articles, docs, links) — space-separated;
  **omit the line entirely if none**. org-roam only registers refs that are URLs (or `@citekeys`).
  `:ROAM_ALIASES:` and `:STATUS:` are optional; quote multi-word aliases. Never invent an ID for a
  link target that doesn't exist.
- `#+filetags` uses `:colon:surrounded:` syntax (note-level topics → drive agenda tag search).
- Heading-level tags (`* Heading    :tag:`) scope sub-topics.

## Filename conventions

| Kind | Path | Filename |
|------|------|----------|
| Evergreen | `~/Sync/RoamNotes/` | `$(date +%Y%m%d%H%M%S)-<slug>.org` |
| Session / daily | `~/Sync/RoamNotes/daily/` | `$(date +%Y-%m-%d).org` (append, one per day) |

`<slug>` is a short kebab-case summary of the title.

## Inter-note links

Link between notes with org-roam ID links: `[[id:<UUID>][Human Title]]`. To link to an existing note,
first find its `:ID:` (grep the target file), then use that UUID. **Do not** use `[[slug]]` wiki-links —
org-roam computes backlinks from `id:` links only, and `rg 'id:<UUID>'` is how this skill finds
backlinks without the DB.

## Content quality rules (MANDATORY)

Apply to all generated content.

### ASCII diagrams required
For ANY flow, architecture, state machine, pipeline, data flow, or component relationship, include an
ASCII diagram using box-drawing (`+---+`, `|`, `┌─┐│└─┘`) and arrows (`-->`, `──▶`, `v`), with labels
and annotations for conditions/branches. Required for: state machines, request/response flows,
dependency graphs, data flow, before/after paths.

### Detail level
- **Context**: enough that someone who's never seen the subject understands it; define terms, describe
  the normal case before the exception.
- **Details**: enough to reproduce the reasoning — names, steps, commands, output. Document dead ends
  and why they were rejected.
- **Concrete data over vague claims**: prefer specific numbers/results and tables over generalities.

### Code snippets
Include only the critical part (the fix, key condition, extracted helper) in `#+begin_src <lang>`
blocks — not whole files.

## Subcommands

| Command | Description |
|---------|-------------|
| `/org-roam-notes-personal` | Show this help. A subcommand is required. |
| `/org-roam-notes-personal capture` | Summarize the current conversation into a new org-roam node |
| `/org-roam-notes-personal append <note>` | Append conversation findings to an existing note |
| `/org-roam-notes-personal daily` | Append to today's session note in `daily/` |
| `/org-roam-notes-personal search <query>` | Full-text `rg` search across the graph |
| `/org-roam-notes-personal open <note>` | Read a note into context |
| `/org-roam-notes-personal tags` | List all `#+filetags` (and heading tags) with counts |
| `/org-roam-notes-personal refs [url]` | List `ROAM_REFS`, or check whether a URL already has a note |
| `/org-roam-notes-personal related` | Find notes related to the current conversation |
| `/org-roam-notes-personal backlinks <note>` | Show notes linking to a given note (via its `:ID:`) |
| `/org-roam-notes-personal recall <topic>` | Memory-style retrieval: pull the most relevant notes into context |

### `/org-roam-notes-personal` (no args)
Display the subcommand table. State that a subcommand is required.

### `/org-roam-notes-personal capture`
1. Analyze the conversation for: key topic; URLs, PR links, file paths, doc links; likely `#+filetags`
   (subject names, problem types); durability.
2. Decide the target: **evergreen** (durable subject knowledge → root) vs **session** (today's working
   notes → `daily/`, via `daily`). If unsure, ask.
3. Check for existing related notes (dedup):
   - `rg -l` in `~/Sync/RoamNotes/` for each URL (match against `ROAM_REFS`), then key file paths and
     candidate filetags.
   - If matches exist, use AskUserQuestion: **Append** to a listed match, or **Create new**.
   - On append, follow the append flow instead.
4. Generate the note:
   - `ID=$(uuidgen)`, `DATE=$(date +%Y-%m-%d)`, `TS=$(date +%Y%m%d%H%M%S)`.
   - Filename per the conventions table; write valid node structure + all sections + quality rules.
   - ASCII diagrams are mandatory if any flow was involved. Include all concrete data.
   - Add `ROAM_REFS` from the links found. Add `[[id:...]]` links to related notes (grep their IDs).
5. Write the file, then best-effort `emacsclient --eval '(org-roam-db-sync)' 2>/dev/null || true`.
6. Show the filename + a brief summary of what was captured.

### `/org-roam-notes-personal append <note>`
1. `<note>` may be a slug, partial filename, ID, or path. Glob/`rg` `~/Sync/RoamNotes/` (incl. `daily/`)
   to resolve; if ambiguous, ask.
2. Read the note. Add a new subtree `* Update — $(date +%Y-%m-%d %H:%M)` and fill in new findings.
3. Merge any new tags into `#+filetags`; add new `ROAM_REFS`; update `:STATUS:` if appropriate.
4. Write, then best-effort DB sync.

### `/org-roam-notes-personal daily`
1. `FILE=~/Sync/RoamNotes/daily/$(date +%Y-%m-%d).org`.
2. If absent, create it with `#+title: <date>` + `#+filetags: :session:` and a fresh `:ID:` drawer.
3. Append an entry `* $(date +%H:%M) <summary>` capturing the current session's work; link out to
   evergreen notes with `[[id:...]]` rather than restating them.
4. Best-effort DB sync.

### `/org-roam-notes-personal search <query>`
1. `rg` the query across `~/Sync/RoamNotes/` (include `daily/`).
2. Show matching files grouped, with a few lines of context per match.

### `/org-roam-notes-personal open <note>`
1. Resolve `<note>` (slug/partial/ID/path) via glob/`rg`; if ambiguous, ask.
2. Read and display the full file.

### `/org-roam-notes-personal tags`
1. `rg '^#\+filetags:'` across the graph; also collect heading tags `:tag:` if useful.
2. Parse individual tags, count occurrences, display sorted by count.

### `/org-roam-notes-personal refs [url]`
- No arg: list all `ROAM_REFS` values with their note titles (grep `^:ROAM_REFS:`).
- With `[url]`: `rg` for it in `ROAM_REFS` and report whether a note already exists (dedup check
  before capturing).

### `/org-roam-notes-personal related`
1. From the conversation, gather URLs, file paths, and candidate topic tags.
2. `rg` each across `~/Sync/RoamNotes/`. Show matches with the reason:
   ```
   20260318xxxxxx-home-network-vlan.org
     Matched: ROAM_REFS https://…/pull/12, filetag :networking:
   ```

### `/org-roam-notes-personal backlinks <note>`
1. Resolve the note and read its `:ID:` (the UUID in the `:PROPERTIES:` drawer).
2. `rg -l "id:<UUID>"` across `~/Sync/RoamNotes/` to find notes that link to it.
3. List the linking files (with the matching line). If none, say so.

### `/org-roam-notes-personal recall <topic>`
Memory-style retrieval — use this at the start of related work, or when the user asks "what do I know
about X":
1. `rg` the topic against titles (`#+title`), `#+filetags`, and `ROAM_REFS` first (highest signal),
   then full text.
2. Rank hits; read the top 1–3 notes into context and summarize what's relevant to the current task,
   citing note titles. This complements Claude's native memory: native memory holds pointers/prefs,
   org-roam holds the substance.
