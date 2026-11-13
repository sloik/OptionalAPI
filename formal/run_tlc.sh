#!/usr/bin/env bash
# Runs every TLA+ model in formal/ with TLC.
#   formal/<Module>.cfg           must pass with no error.
#   formal/<Module>.<name>.cfg    is a mutant: it must contain a line
#                                 "\* EXPECT_VIOLATION: <InvariantName>"
#                                 and TLC must report exactly that invariant as violated.
# A mutant that passes, or fails for another reason, fails this script (non-vacuity).
# Env: TLA_JAR (default /opt/tla/tla2tools-1.7.4.jar), JAVA (default java).
set -euo pipefail
cd "$(dirname "$0")"
JAR="${TLA_JAR:-/opt/tla/tla2tools-1.7.4.jar}"
JAVA="${JAVA:-java}"
PINNED_SHA="936a262061c914694dfd669a543be24573c45d5aa0ff20a8b96b23d01e050e88"
actual_sha="$( (sha256sum "$JAR" 2>/dev/null || shasum -a 256 "$JAR") | cut -d' ' -f1)"
if [[ "$actual_sha" != "$PINNED_SHA" ]]; then
  echo "FAIL: $JAR sha256 $actual_sha != pinned $PINNED_SHA" >&2; exit 2
fi
meta="$(mktemp -d)"; trap 'rm -rf "$meta"' EXIT
pass=0; fail=0; shopt -s nullglob
cfgs=(*.cfg)
(( ${#cfgs[@]} > 0 )) || { echo "FAIL: no .cfg files in formal/" >&2; exit 2; }
for cfg in "${cfgs[@]}"; do
  module="${cfg%%.*}"
  expect="$(sed -n 's/^\\\* EXPECT_VIOLATION: *\([A-Za-z0-9_]*\).*/\1/p' "$cfg" | head -1)"
  out="$("$JAVA" -XX:+UseParallelGC -cp "$JAR" tlc2.TLC -workers 1 -deadlock \
          -metadir "$meta/${cfg%.cfg}" -config "$cfg" "$module.tla" 2>&1)" && rc=0 || rc=$?
  if [[ -z "$expect" ]]; then
    if [[ $rc -eq 0 ]] && grep -q "No error has been found" <<<"$out"; then
      echo "PASS  $cfg  ($(grep -o '[0-9]* distinct states found' <<<"$out" | head -1))"; pass=$((pass+1))
    else
      echo "FAIL  $cfg  (expected no error)"; echo "$out" | tail -30; fail=$((fail+1))
    fi
  else
    if [[ $rc -ne 0 ]] && grep -q "Invariant $expect is violated" <<<"$out"; then
      echo "PASS  $cfg  (mutant caught by $expect)"; pass=$((pass+1))
    else
      echo "FAIL  $cfg  (mutant expected to violate $expect)"; echo "$out" | tail -30; fail=$((fail+1))
    fi
  fi
done
echo "TLC summary: $pass passed, $fail failed"
[[ $fail -eq 0 ]]
