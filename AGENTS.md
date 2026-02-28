# AGENTS Guide

Follows global agent workflow from `~/.claude/CLAUDE.md`. Only project-specific additions below.

## Naming

- Branch prefixes: `feature/`, `bugs/` (per global config), or `TICKET-<id>-` for ticket-tracked work
- Free functions mirror extension method names (`flatten`, `coalesce`, `someWhen`, `noneWhen`)
- Curried overloads: provide a `(predicate) -> (value) -> result` variant alongside the direct version

## Project-Specific Rules

- No `import Foundation` unless the file needs `JSONEncoder`/`JSONDecoder` (currently only `OptionalCodable.swift`)
- Preserve the optional contract: upstream `.none` stays `.none` — never await/compute when input is nil
- New public API must be `@inlinable`, `@discardableResult`, with `@Sendable` on async closures
