# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

```bash
# Build the package
swift build

# Run all tests
swift test

# Run a specific test
swift test --filter OptionalAPITests.AndThenTests

# Run a specific test method
swift test --filter OptionalAPITests.AndThenTests/testAndThenCalledForSomeCase
```

## Project Overview

OptionalAPI is a Swift package providing ergonomic extensions for working with `Optional` types. It implements functional programming patterns (monadic operations) to enable fluent chaining of optional transformations.

**Minimum Swift version:** 5.8
**Platforms:** macOS 10.15+, iOS 16+, tvOS 16+, watchOS 9+

## Architecture

All functionality is implemented as extensions on `Optional<Wrapped>` in `Sources/OptionalAPI/`. Key modules:

- **AndThen.swift** - `andThen` (flatMap alias) and `andThenTry` for chaining operations
- **Maps.swift** - `mapNone`/`defaultSome` for recovering from nil cases
- **Or.swift** - `or` for unwrapping with default values (returns non-optional)
- **OptionalProperties.swift** - `isSome`, `isNone`, `isNotSome`, `isNotNone` boolean checks
- **OptionalCollection.swift** - `hasElements`, `isNoneOrEmpty`, `recoverFromEmpty` for optional collections
- **Cast.swift** - Type casting helpers
- **Filter.swift** - Predicate-based filtering
- **OptionalCodable.swift** - `encode`/`decode` methods for Codable types
- **AsyncMaps.swift** - `asyncMap`, `asyncFlatMap` for async/await support
- **RunWhen.swift** - `whenSome`/`whenNone` for side effects without changing the optional
- **Folds.swift** - Fold operations
- **OptionalFreeFunctions.swift** - Free function versions of operators

## Dependencies

- **AliasWonderland** - Type aliases (e.g., `Producer<T>` for `() -> T`)
- **swift-snapshot-testing** (test only) - Snapshot testing framework

## Key Patterns

The library uses `@discardableResult` on methods to allow chaining without compiler warnings. Method naming follows a convention where operations on `some` cases use standard names (`andThen`, `map`) while operations on `none` cases include "None" (`mapNone`, `whenNone`).
