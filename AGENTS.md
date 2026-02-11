# AGENTS Guide

This repo hosts OptionalAPI, a Swift package of ergonomic helpers for `Optional`. The guide below is the ground truth for any agentic contribution. It includes build/test commands, style expectations, agent workflow, and collaboration rules. Stick to ticket-prefixed branches, TDD, and the commit/PR cadence described below.

## Commands

- `swift build` — compile the package. Run this before committing any code.
- `swift test` — run the full suite.
- `swift test --filter <TestTarget>` — target a single test group (e.g., `OptionalAPITests.AndThenTests`).
- `swift test --filter <TestTarget>/<testName>` — run one test method (e.g., `OptionalAPITests.AndThenTests/testAndThenCalledForSomeCase`).
- There are no additional linters or formatters to invoke today; rely on Swift’s formatting defaults.

## Workflow & Branching

1. Every agent works inside a dedicated git worktree checkout. Create one with `git worktree add ../worktrees/<branch-name>`.
2. Branch names MUST start with a ticket or bug prefix: `TICKET-123-description` or `BUG-XYZ-short`. Use hyphen-separated lowercase words after the ticket prefix to describe focus.
3. Each agent touches only their branch; coordinate by sharing the ticket prefix so commit/PR metadata stays traceable.
4. Before editing production files, add or update a unit test that fails for the current assumption. TDD is non-negotiable: add the failing test, verify it fails, then implement the fix.
5. After coding, run `swift build` and the relevant `swift test` filter. Tests and builds must pass locally before staging.
6. Once satisfied, stage the changes, push the branch (`git push -u origin <branch>`), and open a PR detailing the intent.
7. Each PR must mention the same ticket prefix, share the short/why structure (see below), and include a testing section listing the executed commands.

## Testing Discipline

- Add a test (or update an existing one) before touching non-test code. Expect it to fail until the code changes implement the new behavior.
- Prefer smaller focused tests that exercise optional helpers, async flows, or error paths.
- When referencing async helpers, use `async`/`await` in the assertions so the test mirrors real usage.
- If a test relies on Codable decoding/encoding, use the JSON helpers under `OptionalCodable` with concrete structs to surface failures.

## Coding Style

- **Imports**: keep a single `Foundation` import at the top of each Swift file. Avoid extraneous modules unless a feature explicitly needs it.
- **Formatting**: rely on Swift style—4-space indentation, blank lines between logical sections, and alignment on chained statements (see existing files for how inline comments align). Use header comments (`///`) for public API and `// MARK:` labels for logical groups.
- **Naming**:
  - `andThen`, `map`, `or`, `whenSome`, `whenNone` stay lowercase with camelCase for parameters.
  - Name nil-aware helpers with `None` suffix when they operate on `.none` cases (e.g., `mapNone`, `recoverFromEmpty`).
  - Async helpers use `async` or `tryAsync` prefixes to signal concurrency.
  - Free functions follow the same names as extensions (e.g., `decode`, `encode`, `mapNone`).
- **Types**: prefer concrete `Wrapped` generic where allowed; rely on `Optional` extensions instead of new wrapper structs.
- **Attribute usage**: public helpers should keep `@discardableResult` so chains stay no-warning.
- **Optional handling**:
  - Favor `flatMap`/`andThen` flows instead of force unwrapping.
  - For `.none` recovery, expose `mapNone`, `whenNone`, and `recoverFromEmpty` rather than inline guards.
  - Async helpers should mirror sync counterparts—`asyncMap`, `tryAsyncMap`, `asyncFlatMap`, `tryAsyncFlatMap`.
- **Error handling**: use `try?` or `try` + `.none` when decoding/encoding; propagate errors only when the caller needs them (see `andThenTryOrThrow`). Avoid swallowing errors silently unless the helper’s purpose is to convert them to `.none`.
- **Documentation**: every public helper gets a `///` doc comment demonstrating `Optional` usage, optional chaining, and potential failure modes. Keep language instructional, short, and code-focused.

## Concurrency & Async Interop

- Async helpers wrap their switch statements around `.some`/`.none` so concurrency is explicit (see `AsyncMaps.swift`). Mirror this pattern when adding new async helpers.
- When bridging sync/async helpers, keep the naming consistent (`tryAsync` prefix for `throws` variants) and make sure their docstrings include `async/await` usage examples.
- Any new concurrency helper must preserve the optional contract (return `.none` when the upstream is `.none`). Add tests for both `.some` and `.none` paths.

## Dependencies

- `AliasWonderland` provides helpful type aliasing (e.g., `Producer<T>`). Use it sparingly and import only as needed.
- Snapshot testing is available via `swift-snapshot-testing` for complex wrappers. Prefer standard assertions first; leverage snapshots only for UI-like outputs.

## Collaboration & Reviews

- PRs span all relevant domains. Before merging, ensure at least one subagent has evaluated each of these angles: UI/UX, security, best practices, and concurrency/runtime safety.
- Involve specialists by spinning up worktrees/branches for each focus if the change touches multiple concerns. Document which subagent reviewed which section directly in the PR body (see “Examples” below).
- Encourage agents to challenge assumptions: e.g., “Security checked input pacing—are we still validating nil?” or “UX noted new helper might reorder layout; confirm fallback”. Capture those prompts in the PR summary or review comments.
- Keep coordination dense and fact-based. For example: “Security: validated no forced unwraps.” “Concurrency: confirmed async helper returns `.none` before awaiting.” Each note trains future agents about risk mitigation.

## Commit & PR Structure

- **Commit title**: short phrase describing the change (`Add optional async helper`).
- **Commit body**: multi-line “why” section explaining reasons and impacts. Start with `Why:` and bullet key motives (see samples below).
- **PR title**: match the commit title (same short phrase).
- **PR body**: include:
  1. `## Summary` with 1–3 numbered bullet points describing the intent and how it ties to the ticket.
  2. `## Testing` listing executed commands (e.g., `- swift test --filter OptionalAPITests.AsyncMapsTests`).
- If a PR contains multiple commits, ensure later commits add extra detail (e.g., `Refine error messaging` with a body tying to a separate sub-ticket); the overall PR still follows the summary/testing convention.
- Once code is committed, push the branch, open a PR, and mention the specialized subagents involved.

## Examples (linking ticket → artifacts)

- **Branch**: `TICKET-321-spread-some` for ticket 321.
- **Commit**:
  ```
  Add a safe spread helper

  Why:
  * prevents repeating optional unwrapping across spread helpers
  * aligns with OptionalAPI naming so extensions stay discoverable
  ```
- **PR title**: `Add a safe spread helper`
- **PR body**:
  ```
  ## Summary
  1. Add `spreadSome` to keep Optional spreads concise without force-unwraps
  2. Use the existing `@discardableResult` + chaining conventions so follow-ups stay fluent

  ## Testing
  - swift test --filter OptionalAPITests.SpreadSomeTests
  ```
- **Review notes**: “Security subagent confirmed input validation stays in place. UX subagent signed off on the affordance change. Concurrency subagent verified async isolation.”

## Verification Checklist (before committing or reviewing)

1. Tests added/updated first, then verified to fail.
2. Code satisfies failing test and keeps optional chaining idioms.
3. `swift build` + relevant `swift test` passed locally.
4. Commit message follows short + why format.
5. Branch pushed + PR opened with summary/testing sections.
6. Specialized subagents noted their reviews and challenges in the PR.

