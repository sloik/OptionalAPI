# CLAUDE.md

Swift package: ergonomic extensions on `Optional<Wrapped>` — functional patterns (functor, applicative, monad, alternative, traversable) for fluent optional chaining.

## Key Conventions

- `.some` operations use standard names (`andThen`, `map`, `filter`, `whenSome`)
- `.none` operations use "None" suffix (`mapNone`, `whenNone`, `recoverFromEmpty`)
- Async variants use `async`/`tryAsync` prefix (`asyncMap`, `tryAsyncMap`)
- All async closures are `@Sendable`
- All public methods are `@inlinable` and `@discardableResult`
- Only `OptionalCodable.swift` imports Foundation; all others avoid it
- Dependency: **AliasWonderland** provides type aliases (`Producer<T>` = `() -> T`)
- Tests use Swift Testing framework (`@Suite`, `@Test`, `#expect`)
