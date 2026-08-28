#!/bin/sh
# set-helix-defaults.sh — make HelixOpener.app the default handler for code and
# text files, so double-clicking them in Finder opens terminal Helix.
#
# Requires: duti (brew install duti) and HelixOpener.app already registered
# with Launch Services (SetupDevEnv.sh does both). Safe to re-run.

BUNDLE=com.joekim.helixopener

# Real filename extensions (extensionless dotfiles like .gitignore can't be
# matched by extension and are intentionally omitted).
EXTS="txt text log md markdown org rst
py pyi rb rs go js mjs cjs ts tsx jsx
c h cc cpp cxx hpp hh m mm swift kt java
lua el vim scm
sh bash zsh fish
json jsonc toml yaml yml ini cfg conf env
xml css scss less sql
mk cmake gradle bzl"

for e in $EXTS; do
  # duti accepts either ".ext" or "ext" depending on version; try both.
  if duti -s "$BUNDLE" ".$e" all 2>/dev/null || duti -s "$BUNDLE" "$e" all 2>/dev/null; then
    echo "ok   .$e"
  else
    echo "FAIL .$e"
  fi
done

# Broad UTIs as a catch-all for text/source types not covered by extension.
for uti in public.plain-text public.source-code public.shell-script public.script; do
  if duti -s "$BUNDLE" "$uti" all 2>/dev/null; then echo "ok   $uti"; else echo "FAIL $uti"; fi
done

# Web files open in the browser, not the editor.
BROWSER=org.mozilla.firefox
for e in html htm xhtml; do
  if duti -s "$BROWSER" ".$e" all 2>/dev/null || duti -s "$BROWSER" "$e" all 2>/dev/null; then
    echo "ok   .$e -> firefox"
  else
    echo "FAIL .$e -> firefox"
  fi
done
if duti -s "$BROWSER" public.html all 2>/dev/null; then echo "ok   public.html -> firefox"; else echo "FAIL public.html"; fi

echo
echo "Done. Verify with:  duti -x md   (Helix) and  duti -x html   (Firefox)"
