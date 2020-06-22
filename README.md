# OptionalAPI
Optional extensions for Swift Optional Monad... use it or not... it's optional.

Some common idioms popup when working with Optionals in Swift. Here is a bunch of useful extensions for some types.

# Installation

Just copy and paste files to your project 🍝 

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

You can also use more than one `mapNone` to handle any failures along the way. Oh and you can use an more friendly name `defaultSome` like so:

```swift
someOptional
    // if someOptional is nil then start computation with default value
    .defaultSome(5)     
    // increment whatever is there         
    .andThen(maybeIncrement)
    // are you feeling lucky?
    .andThen(returningNone)  
    // cover your ass if you had bad luck
    .defaultSome(42)
    // do some work with what's there
    .andThen(maybeIncrement) 
    // what... again
    .andThen(returningNone)  
    // saved
    .defaultSome(10)
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

## `hasElements`

```swift
noneString.hasElements      // false
emptySomeString.hasElements // false
someSomeString.hasElements  // true

noneIntArray.hasElements  // false
emptyIntArray.hasElements // false
someIntArray.hasElements  // true
```

## `isNoneOrEmpty`

```swift
noneString.isNoneOrEmpty      // true
emptySomeString.isNoneOrEmpty // true
someSomeString.isNoneOrEmpty  // false

noneIntArray.isNoneOrEmpty  // true
emptyIntArray.isNoneOrEmpty // true
someIntArray.isNoneOrEmpty  // false
```

## `recoverFromEmpty`

This is called **only** if the underlying collection is empty. That is if your optional is `nil` or has some value this will not be called. As String is a collection I will only show examples for `[Int]?` :)

```swift
noneIntArray.recoverFromEmpty([42])  // nil
emptyIntArray.recoverFromEmpty([42]) // [42]
someIntArray.recoverFromEmpty([42])  // [11, 22, 33]
```

If you need a default value for the none case then **defaultSome** is the thing you want.

```swift
noneIntArray.defaultSome([42])  // [42]
emptyIntArray.defaultSome([42]) // []
someIntArray.defaultSome([42])  // [11, 22, 33]
```

# `or`

There are cases when you need an actual result from an Optional `or` a default non optional value. This is exactly the case for `or`

```swift
let noneInt: Int? = .none
let someInt: Int? = .some(42)

var result: Int = someInt.or(69) // 42
```

In this case `result` variable stores value `42`. It's an honest Int not an optional. But what happens when it's `none`:

```swift
result = noneInt.or(69) // 69
```

Here the _final_ result is `69` as everything evaluates to `none`. Once again after `or` you have a honest value or some default.

## default value with `or`

If the wrapped type has a empty initializer (init that takes no arguments) you can call it to get an instance:

```swift
someOptional
    .or(.init()) // creates an instance
```

To put it in a context if you have some optionals you can use this to get _zero_ value like so:

```swift
let noneInt: Int? = nil
noneInt.or( .init() ) // 0
noneInt.or( .zero   ) // 0

let noneDouble: Double? = nil
noneDouble.or( .init() ) // 0

let defaults: UserDefaults? = nil
defaults.or( .standard ) // custom or "standard"

let view: UIView? = nil
view.or( .init() ) 

// or any other init ;)
view.or( .init(frame: .zero) )

// Collections
let noneIntArray : [Int]? = .none
noneIntArray.or( .init() ) // []

let emptySomeString: String? = ""
noneString.or( .init() ) // ""

// Enums
enum Either {
    case left, right
}
let noneEither: Either? = nil
noneEither.or(.right)

```

Anything that you can call on this type (static methods) can be used here.

# `zip`

Zip function is defined on sequences in Swift. This is a nice extension to have it on Optional. 

Let say you have some computations or values that are optional. It might be tedious to `if let` them. Using `zip` you just flip the container inside out (check out how type is transormed in this [documentation on zip in haskell](https://hoogle.haskell.org/?hoogle=zip)) and `map` on the result. 

```swift
let userName: String? 
let userLast: String?
let userAge: Int? 

zip(userName, userLast, userAge)
    .map{ (name: String, last: String, age: Int) in 
        // Working with not optional values
     }
```

And `map` can be _replaced_ with `andThen`:

```swift
zip(userName, userLast, userAge)
    .andThen{ (name: String, last: String, age: Int) in 
        // Working with not optional values
     }
```

Under the hood `map` is used by it reads _better_.

# `cast`

Have you ever wrote code similar to this one:

```swift
if let customVC = mysteryVC as? CustomVC {
    // do stuff
}
```

With `cast` you can streamline your code to this:

```swift
 let someViewController: UIViewController? = ...
 someViewController
     .cast( CustomVC.self )
     .andThen({ (vc: CustomVC) in
        // work with a non optional instance of CustomVC
     })
```

If the type can be inferred from the context then you do not have to type it in.

```swift
let anyString: Any? = ...

let result: String? = anyString.cast()
```

As you can see compiler is able to inferred the correct type. But be aware that in more complex cases this can slow down your compilation. 

> If you want to have faster compilation then always be explicit about your types. In all of your code not only using this package.

# `encode` & `decode`

One of the common places when you want to encode or decode something is when you have some data from the network. Flow might look something like this:

* make a API call for a resource
* get JSON data

To keep is simple let's say our Data Transfer Model (DTO) looks like this:

```swift
struct CodableStruct: Codable, Equatable {
    let number: Int
    let message: String
}
```

What happens is that a JSON string is send thru the network as data. To simulate this in code one could write this:

```swift
let codableStructAsData: Data? =
    """
    {
        "number": 55,
        "message": "data message"
    }
    """.data(using: .utf8)
```

Stage is set:

## `decode`

Networking code will hand us an instance of `Data?` that we want to decode. 

```swift
let result: CodableStruct? = codableStructAsData.decode()
```

It's that simple. Compiler can infer the type so there's no need to add it explicitly. Buy you can do it in some longer pipelines eg.:

```swift
codableStructAsData
    .decode( CodableStruct.self )
    .andThen({ instance in
        // work with not optional instance
    })
```

## `encode`

Encode goes other way. You have a instance that you want to encode to send it as a json. 

```swift
let codableStruct: CodableStruct? = 
    CodableStruct(
        number: 69, 
        message: "codable message"
    )
```

To get the desired encoded vale just use the method:

```swift
codableStruct
    .encode() // <- encoding part if you missed it ;)
    .andThen({ instance in
        // work with not optional instance
    })
```


# That's it

Hope it will help you :)

If you want to find out more about me and some more Swift stuff then I invite you to my site: http://idoit.tech/en/

Cheers! :D
