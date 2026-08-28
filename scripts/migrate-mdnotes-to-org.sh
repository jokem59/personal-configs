#!/usr/bin/env python3
"""Migrate ~/mdnotes/*.md (md-notes skill) into ~/Sync/RoamNotes/*.org (org-roam v2).

One-time, reproducible. Two passes:
  1. Map each note's slugs -> {ID (uuid), title, org filename}.
  2. Convert body via pandoc, prepend an org-roam node header built from YAML
     frontmatter, and rewrite [[slug]] wiki-links to [[id:UUID][Title]] org-roam links.

Originals in ~/mdnotes/ are left untouched. Dangling wiki-links (no matching note)
are downgraded to plain text and logged. Run with --dry-run to preview.
"""
import os, re, sys, uuid, glob, subprocess

SRC = os.path.expanduser("~/mdnotes")
DST = os.path.expanduser("~/Sync/RoamNotes")
DRY = "--dry-run" in sys.argv

def parse_frontmatter(text):
    """Return (fields dict, body str). fields: title, created, modified, tags[list],
    status, jira, pr, slack, docs."""
    m = re.match(r"^---\n(.*?)\n---\n?(.*)$", text, re.DOTALL)
    if not m:
        return {}, text
    fm, body = m.group(1), m.group(2)
    f = {}
    for line in fm.splitlines():
        km = re.match(r"^(\w+):\s*(.*)$", line)
        if not km:
            continue
        key, val = km.group(1), km.group(2).strip()
        if key == "tags":
            val = val.strip("[]")
            f["tags"] = [t.strip().strip('"').strip("'") for t in val.split(",") if t.strip()]
        else:
            f[key] = val.strip().strip('"').strip("'")
    return f, body

def org_tag(t):
    # org tags allow only [alnum_@#%]; md tags use hyphens -> underscores.
    return re.sub(r"[^A-Za-z0-9_@#%]", "_", t)

def slugs_for(filename):
    """(full_slug, date_stripped_slug) for a mdnotes filename (no dir)."""
    base = re.sub(r"\.md$", "", filename)
    stripped = re.sub(r"^\d{4}-\d{2}-\d{2}-", "", base)
    return base, stripped

files = sorted(glob.glob(os.path.join(SRC, "*.md")))
if not files:
    print(f"No .md files in {SRC}", file=sys.stderr); sys.exit(1)

# ---- Pass 1: build slug -> node map -------------------------------------------------
nodemap = {}   # slug (both forms) -> dict(id,title,orgfile)
plan = []      # ordered list of (path, fields, body, orgfile, nid)
for i, path in enumerate(files, start=1):
    fname = os.path.basename(path)
    with open(path, encoding="utf-8") as fh:
        fields, body = parse_frontmatter(fh.read())
    created = fields.get("created", "1970-01-01")
    yyyymmdd = created.replace("-", "")
    full, stripped = slugs_for(fname)
    nid = str(uuid.uuid4()).upper()
    orgfile = f"{yyyymmdd}{i:06d}-{stripped}.org"
    title = fields.get("title") or stripped
    entry = {"id": nid, "title": title, "orgfile": orgfile}
    nodemap[full] = entry
    nodemap[stripped] = entry
    plan.append((path, fields, body, orgfile, nid))

# ---- Pass 2: convert + rewrite links ------------------------------------------------
dangling = []
def rewrite_links(text, srcname):
    def repl(m):
        target = m.group(1).strip()
        # link may be [[slug]] or [[slug|alias]]
        target = target.split("|")[0].strip()
        e = nodemap.get(target) or nodemap.get(re.sub(r"^\d{4}-\d{2}-\d{2}-", "", target))
        if e:
            return f"[[id:{e['id']}][{e['title']}]]"
        dangling.append((srcname, target))
        return target  # downgrade to plain text
    return re.sub(r"\[\[([^\]]+)\]\]", repl, text)

written = 0
for path, fields, body, orgfile, nid in plan:
    fname = os.path.basename(path)
    # Drop a leading duplicate H1 title so it doesn't double the #+title.
    body = re.sub(r"^\s*#\s+.*\n", "", body, count=1)
    try:
        org_body = subprocess.run(
            ["pandoc", "-f", "markdown", "-t", "org-auto_identifiers", "--wrap=preserve"],
            input=body, capture_output=True, text=True, check=True).stdout
    except subprocess.CalledProcessError as e:
        print(f"pandoc failed on {fname}: {e.stderr}", file=sys.stderr); continue
    org_body = rewrite_links(org_body, fname)

    # ROAM_REFS from jira/pr/slack/docs (skip empty / ""). Bare Jira issue keys
    # (e.g. CLI-193832) aren't valid org-roam refs, so expand to full browse URLs.
    jira = fields.get("jira", "").strip()
    if re.fullmatch(r"[A-Z][A-Z0-9]+-\d+", jira):
        jira = f"https://roblox.atlassian.net/browse/{jira}"
    refs = [jira] + [fields.get(k, "") for k in ("pr", "slack", "docs")]
    refs = [r for r in refs if r and r != '""']
    tags = [org_tag(t) for t in fields.get("tags", [])]

    header = [":PROPERTIES:", f":ID:       {nid}"]
    if refs:
        header.append(f":ROAM_REFS: {' '.join(refs)}")
    if fields.get("status"):
        header.append(f":STATUS:   {fields['status']}")
    header.append(":END:")
    header.append(f"#+title: {fields.get('title') or orgfile}")
    if tags:
        header.append(f"#+filetags: :{':'.join(tags)}:")
    header.append(f"#+date-created: {fields.get('created','')}")
    if fields.get("modified"):
        header.append(f"#+date-modified: {fields['modified']}")
    header.append("")
    header.append(f"# Migrated from md-notes: {fname}")
    header.append("")

    out = "\n".join(header) + org_body
    dest = os.path.join(DST, orgfile)
    if DRY:
        print(f"[dry-run] {fname} -> {orgfile}  (id {nid[:8]}…, {len(tags)} tags, {len(refs)} refs)")
    else:
        with open(dest, "w", encoding="utf-8") as fh:
            fh.write(out)
        written += 1

print(f"\n{'Would write' if DRY else 'Wrote'} {len(plan) if DRY else written} notes to {DST}")
if dangling:
    print(f"\nDangling wiki-links (downgraded to plain text) — {len(dangling)}:")
    for src, tgt in dangling:
        print(f"  {src}: [[{tgt}]]")
