[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsloik%2FOptionalAPI%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sloik/OptionalAPI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsloik%2FOptionalAPI%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sloik/OptionalAPI)
![Main](https://github.com/sloik/OptionalAPI/actions/workflows/swift.yml/badge.svg?branch=master)
![Nightly](https://github.com/sloik/OptionalAPI/actions/workflows/nightly.yml/badge.svg)

# OptionalAPI

Optional extensions for Swift's Optional type... use it or not... it's optional.

# Why

Certain idioms keep coming up when working with Optionals in Swift. This library collects useful extensions that make those patterns more readable and composable.

# Installation

Just copy and paste files to your project 🍝

Or use SPM 😎

# Documentation

GitHub Pages: [OptionalAPI](https://sloik.github.io/OptionalAPI/documentation/optionalapi/swift/optional)

## Tutorials

- End-to-end: https://sloik.github.io/OptionalAPI/documentation/optionalapi/optionalapiendtoend
- Basics: https://sloik.github.io/OptionalAPI/documentation/optionalapi/optionalapibasics
- Async: https://sloik.github.io/OptionalAPI/documentation/optionalapi/optionalapiasync
- Collections: https://sloik.github.io/OptionalAPI/documentation/optionalapi/optionalapicollections
- Codable: https://sloik.github.io/OptionalAPI/documentation/optionalapi/optionalapicodable

# Examples

## Checking if an optional has a value

Instead of comparing against `nil`:

```swift
someOptional == nil  // old
someOptional != nil  // old
```

Use the named properties:

```swift
someOptional.isSome    // true when .some
someOptional.isNone    // true when .none

someOptional.isNotSome // true when .none
someOptional.isNotNone // true when .some
```

## Sequencing operations that may return an optional

Given a function that returns an optional:

```swift
func maybeIncrement(_ i: Int) -> Int? { i + 1 }
```

The old, nested way:

```swift
if let trueInt = someIntOptional {
    if let incremented = maybeIncrement(trueInt) {
        // you get the idea ;)
    }
}
```

## `andThen`

```swift
someOptional
    .andThen(maybeIncrement)
    .andThen(maybeIncrement)
    // ... you get the idea :)
```

The result is an `Int?`. If `someOptional` is nil, the whole chain returns nil. If it holds a value, each step gets the unwrapped value to work with.

## Recovering from `none`

Sometimes a step in the chain may return `none`:

```swift
func returningNone(_ i: Int) -> Int? { Bool.random() ? .none : i }

someOptional
    .andThen(maybeIncrement)
    .andThen(returningNone)  // <-- may return nil
    .andThen(maybeIncrement)
```

If `returningNone` returns nil, the final result is nil. To recover, use `mapNone` — it works like `map` but for the `nil` case:

```swift
someOptional
    .andThen(maybeIncrement)
    .andThen(returningNone)
    .mapNone(42)             // provide a fallback
    .andThen(maybeIncrement)
```

If `someOptional` starts as `10` and `returningNone` succeeds, the result is `12`. If it returns nil, `mapNone` kicks in and the result is `43`.

You can place multiple `mapNone` calls anywhere in a pipeline. There's also an alias with a more expressive name, `defaultSome`:

```swift
someOptional
    // start with a default if someOptional is nil
    .defaultSome(5)
    .andThen(maybeIncrement)
    .andThen(returningNone)
    // recover if the step above returned nil
    .defaultSome(42)
    .andThen(maybeIncrement)
    .andThen(returningNone)
    // one more safety net
    .defaultSome(10)
```

## `andThenTry`

Use `andThenTry` when a step may throw. If it throws, the error is caught and `.none` is returned, allowing the chain to continue or recover:

```swift
let jsonData: Data? = ...

jsonData
    .andThenTry { data in
        try JSONDecoder().decode(CodableStruct.self, from: data)
    }
    // this step can also throw
    .andThenTry(functionTakingCodableStructAndThrowing)
    // recover from any failure
    .defaultSome(CodableStruct.validInstance)
```

You can recover differently after each step, or ignore failures entirely. Either way, you have a clean API.

# Working with optional collections

Sometimes you are working with an optional collection — the most common cases being `String?` and `[SomeType]?`. OptionalAPI has you covered.

The examples below use these values:

```swift
let noneString     : String? = .none
let emptySomeString: String? = ""
let someSomeString : String? = "some string"

let noneIntArray : [Int]? = .none
let emptyIntArray: [Int]? = []
let someIntArray : [Int]? = [11, 22, 33]
```

## `hasElements`

True only when the optional is `.some` and the collection is not empty:

```swift
noneString.hasElements      // false
emptySomeString.hasElements // false
someSomeString.hasElements  // true

noneIntArray.hasElements  // false
emptyIntArray.hasElements // false
someIntArray.hasElements  // true
```

## `isNoneOrEmpty`

True when the optional is `.none` or the collection is empty. Useful when nil and empty are equivalent in your domain:

```swift
noneString.isNoneOrEmpty      // true
emptySomeString.isNoneOrEmpty // true
someSomeString.isNoneOrEmpty  // false

noneIntArray.isNoneOrEmpty  // true
emptyIntArray.isNoneOrEmpty // true
someIntArray.isNoneOrEmpty  // false
```

## `recoverFromEmpty`

Called **only** when the wrapped collection is empty. It does nothing when the optional is `.none` or when the collection has elements. Since `String` is a collection, the examples below use `[Int]?`:

```swift
noneIntArray.recoverFromEmpty([42])  // nil      — not called for .none
emptyIntArray.recoverFromEmpty([42]) // [42]     — collection was empty
someIntArray.recoverFromEmpty([42])  // [11, 22, 33] — collection had elements
```

When you need a default for the `.none` case, use `defaultSome`:

```swift
noneIntArray.defaultSome([42])  // [42]          — was nil
emptyIntArray.defaultSome([42]) // []             — was .some, left unchanged
someIntArray.defaultSome([42])  // [11, 22, 33]  — was .some, left unchanged
```

# `or`

Use `or` to unwrap an optional with a non-optional fallback value:

```swift
let noneInt: Int? = .none
let someInt: Int? = .some(42)

let result: Int = someInt.or(69) // 42 — unwrapped from .some
let other:  Int = noneInt.or(69) // 69 — fallback used
```

After `or`, you always get a real value, not an optional.

## Using `or` with initialisers

If the wrapped type has a no-argument initialiser, you can use it as the fallback:

```swift
let noneInt: Int? = nil
noneInt.or(.init()) // 0
noneInt.or(.zero)   // 0

let noneDouble: Double? = nil
noneDouble.or(.init()) // 0.0

let defaults: UserDefaults? = nil
defaults.or(.standard)

let view: UIView? = nil
view.or(.init())
view.or(.init(frame: .zero))

let noneIntArray: [Int]? = .none
noneIntArray.or(.init()) // []

enum Direction { case left, right }
let noneDirection: Direction? = nil
noneDirection.or(.right)
```

Any static member or factory method available on the type can be used here.

# `cast`

Have you ever written code like this?

```swift
if let customVC = mysteryVC as? CustomVC {
    // do stuff
}
```

With `cast` you can integrate type casting into a pipeline:

```swift
let someViewController: UIViewController? = ...
someViewController
    .cast(CustomVC.self)
    .andThen { (vc: CustomVC) in
        // work with a non-optional CustomVC
    }
```

When the type can be inferred from context, you can omit the argument:

```swift
let anyString: Any? = ...
let result: String? = anyString.cast()
```

> Being explicit about types helps the compiler and speeds up compilation — this applies throughout your codebase, not just with this package.

# `encode` & `decode`

A common network flow looks like this:

- make an API call for a resource
- receive JSON data

Assume our Data Transfer Object looks like this:

```swift
struct CodableStruct: Codable, Equatable {
    let number: Int
    let message: String
}
```

And we receive it as `Data?`:

```swift
let codableStructAsData: Data? =
    """
    {
        "number": 55,
        "message": "data message"
    }
    """.data(using: .utf8)
```

## `decode`

```swift
let result: CodableStruct? = codableStructAsData.decode()
```

The compiler infers the type from context, so you rarely need to specify it. You can be explicit when it helps readability:

```swift
codableStructAsData
    .decode(CodableStruct.self)
    .andThen { instance in
        // work with a non-optional instance
    }
```

## `encode`

Going the other way — encoding a value to send over the network:

```swift
let codableStruct: CodableStruct? = CodableStruct(number: 69, message: "codable message")

codableStruct
    .encode()
    .andThen { data in
        // work with the encoded Data
    }
```

# `whenSome` and `whenNone`

Sometimes you want to run code as a side effect without changing the optional. `whenSome` and `whenNone` let you do this while keeping the chain intact:

```swift
let life: Int? = 42

life
    .whenSome { value in print("Value of life is:", value) }
```

This prints `Value of life is: 42`. There is also a no-argument variant for when you only care that a value exists:

```swift
life
    .whenSome { print("Something is there!") }
```

For the nil case:

```swift
let life: Int? = .none

life
    .whenNone { print("No life here!") }
```

And they chain together:

```swift
let life: Int? = 42

life
    .whenSome { value in print("Value of life is:", value) }
    .whenSome { print("Something is there!") }
    .whenNone  { print("This won't run") }
```

Of course, you can mix these with any other operators in the chain.

# `filter`

Use `filter` to keep a value only when it passes a predicate:

```swift
let arrayWithTwoElements: [Int]? = [42, 69]

arrayWithTwoElements
    .filter { $0.count > 1 }
    .andThen { ... } // only reached when array has more than one element
```

There is also a free function form that takes a predicate and returns a reusable filter function:

```swift
// Create a reusable filter
let moreThanOne: ([Int]?) -> [Int]? = filter { $0.count > 1 }
```

# `flatten`

`flatten` collapses a nested optional (`T??`) into a single optional (`T?`). If the outer layer holds `.some`, the inner value is returned as-is. Any `.none` — at either layer — produces `.none`.

```swift
let nested: Int?? = .some(.some(42))
nested.flatten() // .some(42)

let outerSomeInnerNone: Int?? = .some(nil)
outerSomeInnerNone.flatten() // nil

let outerNone: Int?? = nil
outerNone.flatten() // nil
```

There is also a free function form:

```swift
flatten(nested) // .some(42)
```

This is useful when chaining operations that each return an optional, and you want to avoid accumulating extra wrapping layers.

# `orOptional`

Unlike `or` — which unwraps to a non-optional — `orOptional` stays in optional land. It returns the first non-nil value, keeping the result as `Wrapped?`. This is useful when you want to try alternatives but keep the result optional for further chaining:

```swift
let primary:   Int? = nil
let secondary: Int? = 42

primary.orOptional(secondary) // .some(42)

let alreadySet: Int? = 10
alreadySet.orOptional(secondary) // .some(10) — first value wins
```

The fallback is lazily evaluated, so it is only called when needed. An async variant is also available:

```swift
let result = await primary.asyncOrOptional {
    await fetchFallback()
}
```

# `coalesce`

`coalesce` returns the first non-nil value from a list of optionals. It is a variadic shorthand for chaining multiple `orOptional` calls:

```swift
let a: Int? = nil
let b: Int? = nil
let c: Int? = 42

coalesce(a, b, c) // .some(42)
coalesce(a, b)    // nil — all were nil
```

You can also pass an array:

```swift
let values: [Int?] = [nil, nil, 42, 99]
coalesce(values) // .some(42) — first non-nil wins
```

# `ap`

`ap` applies a wrapped function to a wrapped value. Both must be `.some` for the result to be `.some`; if either is `.none`, the result is `.none`.

```swift
let increment: ((Int) -> Int)? = { $0 + 1 }
let value: Int? = 41

increment.ap(value) // .some(42)

let noFunction: ((Int) -> Int)? = nil
noFunction.ap(value) // nil
```

Free function and curried forms are also available:

```swift
ap(increment, value) // .some(42)

// Curried — bake the function in, apply values later
let applyIncrement: (Int?) -> Int? = ap(increment)
applyIncrement(value) // .some(42)
```

# `sequence`

`sequence` converts `[T?]` into `[T]?`. If all elements are `.some`, you get a `.some` containing all the unwrapped values. If any element is `.none`, the entire result is `.none`.

```swift
let allPresent: [Int?] = [1, 2, 3]
sequence(allPresent) // .some([1, 2, 3])

let hasGap: [Int?] = [1, nil, 3]
sequence(hasGap) // nil

let empty: [Int?] = []
sequence(empty) // .some([])
```

There is also an instance method form on `Array`:

```swift
[Int?]([1, 2, 3]).sequence() // .some([1, 2, 3])
```

# `traverse`

`traverse` applies a transform to each element of an array. If any transform returns `.none`, the entire result is `.none`. Think of it as `map` followed by `sequence`:

```swift
let strings = ["1", "2", "3"]
traverse(strings) { Int($0) } // .some([1, 2, 3])

let mixed = ["1", "abc", "3"]
traverse(mixed) { Int($0) } // nil — "abc" can't be converted
```

There is also an instance method form and a curried form:

```swift
// Instance method
["1", "2", "3"].traverse { Int($0) } // .some([1, 2, 3])

// Curried — create a reusable transformer
let parseInts: ([String]) -> [Int]? = traverse { Int($0) }
parseInts(["1", "2", "3"]) // .some([1, 2, 3])
```

# `someWhen` and `noneWhen`

These functions create an optional from a plain value based on a predicate.

`someWhen` wraps the value in `.some` only when the predicate returns `true`:

```swift
someWhen({ $0 > 18 }, 42) // .some(42)
someWhen({ $0 > 18 }, 10) // nil
```

`noneWhen` is the dual — it wraps the value when the predicate returns `false`:

```swift
noneWhen({ $0 > 100 }, 42)  // .some(42)
noneWhen({ $0 > 100 }, 200) // nil
```

Both have a curried form for point-free composition:

```swift
let adults: (Int) -> Int? = someWhen { $0 >= 18 }
adults(42) // .some(42)
adults(10) // nil

let notEmpty: (String) -> String? = noneWhen(\.isEmpty)
notEmpty("hello") // .some("hello")
notEmpty("")      // nil
```

These compose naturally with the rest of the API:

```swift
someWhen({ $0 > 0 }, 42)
    .andThen { $0 * 2 } // .some(84)

noneWhen({ $0 > 100 }, 200)
    .mapNone(0) // 0
```

# Async / Await

Most operations have async counterparts. Async variants are named with an `async` prefix and can be mixed with synchronous steps:

```swift
let someInt: Int? = 42

let result: Int? = await someInt
    .asyncFlatMap { value in
        await Task.yield()
        return value + 1
    }
    .flatMap { fromAsync in
        fromAsync * 10
    }
```

The `await` keyword must appear at the start of a pipeline that contains async steps. The compiler will remind you if you forget.

# `tryAsyncMap` & `tryAsyncFlatMap`

These handle async steps that may throw. If the transform throws, the error propagates:

```swift
enum MyError: Error { case invalidInput }

func transform(value: Int) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    return "Transformed: \(value)"
}

let optionalValue: Int? = 42

do {
    let result = try await optionalValue.tryAsyncMap { value in
        try await transform(value: value)
    }
    print(result) // .some("Transformed: 42")
} catch {
    print(error)
}
```

# `zip` — moved

This functionality was moved to the [Zippy 🤐 Swift Package](https://github.com/sloik/Zippy), which provides `zip` for more types than just optionals.

# 🐇🕳 Rabbit Hole

This project is part of the [🐇🕳 Rabbit Hole Packages Collection](https://github.com/sloik/RabbitHole)

# That's it

Hope it helps :)

Cheers! :D
