# OptionalAPI
Optional extensions for Swift Optional Monad... use it or not... it's optional.

Some common idioms popup when working with Optionals in Swift. Here is a bunch of useful extensions for some types.

# Installation

Just copy and paste contents of `OptionalAPI.swift` and/or `UIViewAPI.swift` files 🍝 

Or use SPM 😎


# Examples:

## Running some code if none or some

Old:
```swift
someOptional == nil ? True branch : False branch
```

New:

```swift
someOptional.isSome ? True branch : False branch
someOptional.isNone ? True branch : False branch

someOptional.isNotSome ? True branch : False branch
someOptional.isNotNone ? True branch : False branch
```

## Sequencing of operations that might also return optional

Operation that returns optional:
```swift
func maybeIncrement(_ i: Int) -> Int? { i + 1 }
```

Old the terrible way:

```swift
if let trueInt = someIntOptional {
    let incrementedOnce = maybeIncrement(trueInt) {
        // you get the idea ;)
    }
}
```

New:

```swift
someOptional
    .andThen(maybeIncrement)
    .andThen(maybeIncrement)
    // ... you get the idea :)
```

In this case result of this chaining is a instance of `Int?`. If the `someOptional` was nil then whole computation results with nil. If it had some value (42) ten it would be incremented so many times.

## Recovering from `none` case

Let's say you have a chain of operations and there is a chance that the result might return `none`.

```swift
func returningNone(_ i: Int) -> Int? { Bool.random() ? .none : i }

someOptional
    .andThen(maybeIncrement)
    .andThen(returningNone)  // <-- returns nil
    .andThen(maybeIncrement)  
```

Final result is `nil`. And you can't use a `??`. Use `mapNone` it's like normal `map` on Optional but for the `nil` case.

```swift
func returningNone(_ i: Int) -> Int? { .none }

someOptional
    .andThen(maybeIncrement)
    .andThen(returningNone)  
    .mapNone(42)
    .andThen(maybeIncrement)  
```

If `someOptional` started with `10` and we had luck (returningNone did not returned nil) then the final result is `12`. But if were not so lucky then the `mapNone` would take over and the final result would be `43`.

You can also use more than one `mapNone` to handle any failures along the way. Oh and you can use an more friendly name `default` like so:

```swift
someOptional
    // if someOptional is nil then start computation with default value
    .default(5)     
    // increment whatever is there         
    .andThen(maybeIncrement)
    // are you feeling lucky?
    .andThen(returningNone)  
    // cover your ass if you had bad luck
    .default(42)
    // do some work with what's there
    .andThen(maybeIncrement) 
    // what... again
    .andThen(returningNone)  
    // saved
    .default(10)
```

I hope you can see that this gives you a very flexible API to handle Optionals in your code.

# But wait there's more!

Sometimes you are working with a Optional collection. Most common case is a `String` and and Optional Array of something. This **Optional API** has you covered to!

In the examples below I will be using those Optionals:

```swift
let noneString     : String? = .none
let emptySomeString: String? = ""
let someSomeString : String? = "some string"

let noneIntArray : [Int]? = .none
let emptyIntArray: [Int]? = []
let someIntArray : [Int]? = [11, 22, 33]
```

I think this should cover all the cases

# Optional collection has values is nil or empty

A lot of ifology is made when working whit a collection inside a Optional context. Those properties should help.

## hasElements

```swift
noneString.hasElements      // false
emptySomeString.hasElements // false
someSomeString.hasElements  // true

noneIntArray.hasElements  // false
emptyIntArray.hasElements // false
someIntArray.hasElements  // true
```

## isNoneOrEmpty

```swift
noneString.isNoneOrEmpty      // true
emptySomeString.isNoneOrEmpty // true
someSomeString.isNoneOrEmpty  // false

noneIntArray.isNoneOrEmpty  // true
emptyIntArray.isNoneOrEmpty // true
someIntArray.isNoneOrEmpty  // false
```

## recoverFromEmpty

This is called **only** if the underlying collection is empty. That is if your optional is `nil` or has some value this will not be called. As String is a collection I will only show examples for `[Int]?` :)

```swift
noneIntArray.recoverFromEmpty([42])  // nil
emptyIntArray.recoverFromEmpty([42]) // [42]
someIntArray.recoverFromEmpty([42])  // [11, 22, 33]
```

If you need a default value for the none and empty case then **default** is the thing you want.

```swift
noneIntArray.default([42])  // [42]
emptyIntArray.default([42]) // [42]
someIntArray.default([42])  // [11, 22, 33]
```

# One more thing

Old:
```swift
view.isHidden = false
```
or
```swift
if view.isHidden == false {
    // ...
}
```

That's annoying... now you can do what you have always wanted!

```swift
if view.isVisible {
    // ...
}

if view.isNotVisible {
    // ...
}

if view.isNotHidden {
    // ...
}

// with old
if view.isHidden {
    // ...
}

```

And you can also set on those properties to if you want:

```swift
view.isVisible = true

view.isNotVisible = true   

view.isNotHidden = true

// with old
view.isHidden = true

```

That way you can **always** say what you want without inverted logic! 🤓

# That's it

Hope it will help you :)

If you want to find out more about me and some more Swift stuff then I invite you to my site: http://idoit.tech/en/

Cheers! :D
