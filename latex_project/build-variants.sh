#!/bin/bash
# Build both distribution copies from the single source in thesis.tex.
#
#   robert_hickman_deposit_thesis.pdf   unsigned declaration (Cambridge deposit copy)
#   robert_hickman_personal_thesis.pdf  signed declaration + Hill et al. paper appended
#
# Only the declaration include differs between them, so the two are swapped in
# place rather than kept as duplicate master files that could drift apart.

set -euo pipefail
cd "$(dirname "$0")"

PAPER=../Hill_et_al_paper.pdf

use_decl() {  # $1 = declaration | declaration_deposit
  perl -pi -e "s{Declaration/declaration(_deposit)?}{Declaration/$1}g" thesis.tex
}

# The deposit copy strips the Department and supervisor/advisor block from the
# title page and pins the date; see thesis-info-deposit.tex for why.
title_overrides() {  # $1 = on | off
  if [ "$1" = on ]; then
    perl -pi -e 's{^%+(\\input\{thesis-info-deposit\})}{$1}' thesis.tex
  else
    perl -pi -e 's{^(?!%)(\\input\{thesis-info-deposit\})}{%$1}' thesis.tex
  fi
}

# compile-thesis.sh prints "Success!" unconditionally, so check the log and the
# PDF ourselves. A transient "Input/output error" mid-run truncates thesis.aux
# and silently yields a PDF full of "??" cross-references.
build() {
  bash compile-thesis.sh compile thesis >/dev/null
  local bad=0
  if grep -q '^!' thesis_compile.log; then
    echo "LaTeX errors:" >&2; grep -n '^!' thesis_compile.log >&2; bad=1
  fi
  if grep -q 'Input/output error' thesis_compile.log; then
    echo "pdflatex I/O error - a pass aborted part-way" >&2; bad=1
  fi
  # undefined refs are expected on pass 1; only the final pass must be clean
  if awk '/This is pdfTeX/{n++} n==3' thesis_compile.log | grep -q 'undefined'; then
    echo "unresolved references in final pass" >&2; bad=1
  fi
  local q
  q=$(pdftotext thesis.pdf - 2>/dev/null | grep -c '??' || true)
  if [ "$q" != 0 ]; then
    echo "broken '??' cross-references on $q lines of thesis.pdf" >&2; bad=1
  fi
  if [ "$bad" != 0 ]; then
    echo "$1 build FAILED" >&2; exit 1
  fi
  echo "$1 build clean: 0 errors, 0 undefined refs, 0 ?? markers"
}

use_decl declaration_deposit
title_overrides on
build deposit
cp thesis.pdf robert_hickman_deposit_thesis.pdf
echo "built robert_hickman_deposit_thesis.pdf"

use_decl declaration
title_overrides off
build personal
pdfunite thesis.pdf "$PAPER" robert_hickman_personal_thesis.pdf
echo "built robert_hickman_personal_thesis.pdf (+ $(basename "$PAPER"))"

# leave the source in a deterministic state
use_decl declaration_deposit
title_overrides on
