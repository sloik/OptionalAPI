# OptionalAPI

OptionalAPI provides ergonomic helpers for working with Swift optionals. Use it when you want to model optional flows explicitly without nested `if let` blocks, and when you want a consistent, chainable API for handling `.some` and `.none` cases.

## Quick Start

```swift
let input: Int? = 41

let result = input
    .andThen { $0 + 1 }
    .mapNone(0)
    .andThen { $0 * 2 }
```

## Tutorials

- <doc:OptionalAPIEndToEnd>
- <doc:OptionalAPIBasics>
- <doc:OptionalAPIAsync>
- <doc:OptionalAPICollections>
- <doc:OptionalAPICodable>
