#!/usr/bin/env bash
# Runs every TLA+ model in formal/ with TLC.
#   formal/<Module>.cfg           must pass with no error.
#   formal/<Module>.<name>.cfg    is a mutant: it must contain a line
#                                 "\* EXPECT_VIOLATION: <InvariantName>"
#                                 and TLC must report exactly that invariant as violated.
# A mutant that passes, or fails for another reason, fails this script (non-vacuity).
# Env: TLA_JAR (default /opt/tla/tla2tools-1.7.4.jar), JAVA (default java).
set -euo pipefail
# BEGIN SHARED ORACLE QUEUE SUBMISSION
# Local authoring and CI both submit the immutable formal/ source closure.
# TLA_QUEUE_JOB is reserved: the broker rejects caller-supplied values and its
# trusted job trampoline injects the accepted job ID inside the sandbox.
if [[ -z "${TLA_QUEUE_JOB:-}" ]]; then
  queue_client="$(command -v tla-queue || true)"
  if [[ -z "$queue_client" ]]; then
    echo "UNAVAILABLE: tla-queue client missing; no TLC check was run" >&2
    exit 78
  fi
  repo_root="$(cd "$(dirname "$0")/.." && pwd)"
  request_key="${TLA_QUEUE_REQUEST_KEY:-}"
  if [[ -z "$request_key" ]]; then
    if [[ -n "${GITHUB_RUN_ID:-}" ]]; then
      request_key="github-${GITHUB_RUN_ID}-${GITHUB_RUN_ATTEMPT:-1}"
    else
      if ! command -v python3 >/dev/null 2>&1; then
        echo "UNAVAILABLE: Python client runtime missing; no TLC check was run" >&2
        exit 78
      fi
      request_key="$(python3 -c 'import uuid; print(uuid.uuid4().hex)')"
    fi
  fi
  case "$request_key" in ''|*[!A-Za-z0-9_.-]*)
    echo "REFUSED: invalid queue request key; no TLC check was run" >&2; exit 64 ;;
  esac
  if [[ ${#request_key} -gt 96 ]]; then
    echo "REFUSED: queue request key too long; no TLC check was run" >&2; exit 64
  fi
  result_destination="${TLA_QUEUE_RESULTS:-${XDG_CACHE_HOME:-$HOME/.cache}/tla-queue/sloik-OptionalAPI/$request_key}"
  if [[ -e "$result_destination" || -L "$result_destination" ]]; then
    echo "REFUSED: result destination already exists; choose a fresh TLA_QUEUE_RESULTS path" >&2
    exit 73
  fi
  printf 'TLC queue request: key=%s results=%s\n' "$request_key" "$result_destination" >&2
  queue_args=(run --project 'sloik/OptionalAPI' --source "$repo_root"
    --include formal --timeout 900 --request-key "$request_key"
    --output formal-results --fetch "$result_destination"
    --env "JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS--Xmx256m -XX:MaxDirectMemorySize=64m -XX:ActiveProcessorCount=1}")
  # Explicit tool paths refer to Oracle; preserve exact caller values (including
  # empty strings), letting the original native defaults/failures decide there.
  if [[ "${JAVA+x}" == x ]]; then queue_args+=(--env "JAVA=$JAVA"); fi
  if [[ "${TLA_JAR+x}" == x ]]; then queue_args+=(--env "TLA_JAR=$TLA_JAR"); fi
  exec "$queue_client" "${queue_args[@]}" -- bash formal/run_tlc.sh
fi
if [[ ${#TLA_QUEUE_JOB} -ne 32 || "$TLA_QUEUE_JOB" == *[!0-9a-f]* || "$(uname -s)" != Linux || "$(id -un)" != tla-job ]]; then
  echo "REFUSED: TLA_QUEUE_JOB requires the Oracle queue sandbox identity; no TLC check was run" >&2
  exit 78
fi
worker_cgroup=0
cgroup_info="$(cat /proc/self/cgroup 2>/dev/null)" || {
  echo "REFUSED: queue worker cgroup unavailable; no TLC check was run" >&2; exit 78;
}
while IFS=: read -r hierarchy controllers cg_path; do
  case "$cg_path" in */tla-q-"$TLA_QUEUE_JOB".service|*/tla-q-"$TLA_QUEUE_JOB".service/*) worker_cgroup=1 ;; esac
done <<< "$cgroup_info"
if [[ "$worker_cgroup" != 1 ]]; then
  echo "REFUSED: process is outside the expected Oracle queue worker cgroup; no TLC check was run" >&2
  exit 78
fi
# END SHARED ORACLE QUEUE SUBMISSION
cd "$(dirname "$0")"
JAR="${TLA_JAR:-/opt/tla/tla2tools-1.7.4.jar}"
JAVA="${JAVA:-java}"
PINNED_SHA="936a262061c914694dfd669a543be24573c45d5aa0ff20a8b96b23d01e050e88"
actual_sha="$( (sha256sum "$JAR" 2>/dev/null || shasum -a 256 "$JAR") | cut -d' ' -f1)"
if [[ "$actual_sha" != "$PINNED_SHA" ]]; then
  echo "FAIL: $JAR sha256 $actual_sha != pinned $PINNED_SHA" >&2; exit 2
fi
# BEGIN SHARED ORACLE TOOL IDENTITY
java_path="$(command -v "$JAVA" || true)"
if [[ -z "$java_path" ]]; then
  echo "UNAVAILABLE: Java missing in queue sandbox; no TLC check was run" >&2
  exit 78
fi
java_sha="$( (sha256sum "$java_path" 2>/dev/null || shasum -a 256 "$java_path") | cut -d' ' -f1)"
results="$PWD/../formal-results"
if [[ -e "$results" || -L "$results" ]]; then
  echo "REFUSED: formal-results already exists inside queue bundle" >&2
  exit 73
fi
mkdir "$results"
printf 'TLC queue tool identity: job=%s java=%s java_sha256=%s jar=%s jar_sha256=%s\n' \
  "$TLA_QUEUE_JOB" "$java_path" "$java_sha" "$JAR" "$actual_sha" > "$results/tool-identity.txt"
cat "$results/tool-identity.txt"
"$JAVA" -version > "$results/java-version.txt" 2>&1
cat "$results/java-version.txt"
printf '%s\n' 'Exact merged native stdout/stderr bytes. The unchanged classifier reads this file through Bash command substitution, removing trailing newlines only in classifier text.' \
  > "$results/capture-format.txt"
# END SHARED ORACLE TOOL IDENTITY
meta="$(mktemp -d)"; trap 'rm -rf "$meta"' EXIT
pass=0; fail=0; shopt -s nullglob
cfgs=(*.cfg)
(( ${#cfgs[@]} > 0 )) || { echo "FAIL: no .cfg files in formal/" >&2; exit 2; }
for cfg in "${cfgs[@]}"; do
  module="${cfg%%.*}"
  expect="$(sed -n 's/^\\\* EXPECT_VIOLATION: *\([A-Za-z0-9_]*\).*/\1/p' "$cfg" | head -1)"
  # BEGIN SHARED ORACLE CASE CAPTURE
  # Keep original Java argv and classifier text; retain exact merged stream bytes.
  raw_log="$results/$cfg.stdout-stderr.log"
  "$JAVA" -XX:+UseParallelGC -cp "$JAR" tlc2.TLC -workers 1 -deadlock \
    -metadir "$meta/${cfg%.cfg}" -config "$cfg" "$module.tla" > "$raw_log" 2>&1 && rc=0 || rc=$?
  if [[ ! -f "$raw_log" || ! -r "$raw_log" ]]; then
    echo "INCOMPLETE: native log capture unavailable for $cfg" >&2; exit 74
  fi
  printf '%s\n' "$rc" > "$results/$cfg.exit-code"
  out="$(cat "$raw_log")"
  if [[ "$rc" -ge 128 || "$rc" -eq 124 ]]; then
    echo "INCOMPLETE: native process interrupted or timed out for $cfg (exit $rc)" >&2; exit 75
  fi
  # END SHARED ORACLE CASE CAPTURE
  if [[ -z "$expect" ]]; then
    if [[ $rc -eq 0 ]] && grep -q "No error has been found" <<<"$out"; then
      echo "PASS  $cfg  ($(grep -o '[0-9]* distinct states found' <<<"$out" | head -1))"; pass=$((pass+1))
    else
      echo "FAIL  $cfg  (expected no error)"; echo "$out" | tail -30; fail=$((fail+1))
    fi
  else
    if [[ $rc -eq 12 ]] && grep -q "Invariant $expect is violated" <<<"$out"; then
      echo "PASS  $cfg  (mutant caught by $expect)"; pass=$((pass+1))
    else
      echo "FAIL  $cfg  (mutant expected to violate $expect)"; echo "$out" | tail -30; fail=$((fail+1))
    fi
  fi
done
echo "TLC summary: $pass passed, $fail failed"
[[ $fail -eq 0 ]]
