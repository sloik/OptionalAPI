
import Foundation

public extension Optional {
    
    /**
     Typealias for a closure capable of producing an instance od **Wrapped** type.
     */
    typealias ProducerOfWrapped = () -> Wrapped
    
    
    /**
     *  **True** if optional instance is ````.none````.
     *
     *  Replaces a check for nil:
     *
     *  ````
     *  let number: Int? = nil
     *  number == nil // true
     *  ````
     *
     *  with more friendly:
     *
     *  ````
     *  number.isNone // true
     *  ````
     */
    var isNone: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
    
    
    /**
     *  **True** if optional instance is ````.some(Wrapped)````.
     *
     *  Replaces a check for nil:
     *
     *  ````
     *  let number: Int? = .some(42)
     *  number != nil // true
     *  ````
     *
     *  with more friendly:
     *
     *  ````
     *  number.isSome // true
     *  ````
     */
    var isSome: Bool { isNone == false }
    
    
    /**
     *  **True** if optional instance is ````.some(Wrapped)````.
     *  You can also read it as **isSome**.
     *
     *  Replaces a check for nil:
     *
     *  ````
     *  let number: Int? = .some(42)
     *  number != nil // true
     *  ````
     *
     *  with more friendly:
     *
     *  ````
     *  number.isNotNone // true
     *  ````
     */
    var isNotNone: Bool { isNone == false }
    
    
    /**
     *  **True** if optional instance is ````.none````.
     *  You can also read it as **isNone**.
     *
     *  Replaces a check for nil:
     *
     *  ````
     *  let number: Int? = nil
     *  number == nil // true
     *  ````
     *
     *  with more friendly:
     *
     *  ````
     *  number.isNotSome // true
     *  ````
     */
    var isNotSome: Bool { isSome == false }
    
    
    /**
     * More readable wrapper on ```flatMap``` function defined on Optional in the standard library.
     *
     *
     *  It gives a readable way of chaining multiple operations. Also those that return an Optional.
     *  With this you can define pipelines of data transformations like so:
     *
     *  ````
     *  let host: String? = "www.host.com"
     *  let url: URL? =
     *      host
     *         .andThen{ $0 + "/" }         // appends "/"
     *         .andThen{ $0 + "page.html" } // appends "page.html"
     *         .andThen( URL.init )         // creates an URL
     *  url // www.host.com/page.html
     *  ````
     *  Notice that we started with `String?` and that `URL.init` also returns and Optional.
     *  So at the end we should have and `URL??` but `flatMap` removes of one layer of packaging.
     *
     *  What's more cool is that you can define blocks of code to run as when appending path components.
     *  And use pointfree style by passing function symbols. In each case this function is working
     *  with a real value not an Optional.
     *
     *  And then is called only when the instance is `.some(Wrapped)`. For `.none` case it does
     *  nothing. That is a very safe way of working with optionals:
     *
     *  ````
     *  let host: String? = "www.host.com"
     *  let url: URL? =
     *      host
     *         // append "/"
     *         .andThen{ $0 + "/" }
     *         // "s" is "www.host.com/" but function fails
     *         .andThen{ (s: String) -> String? in nil }
     *          // is not getting called
     *         .andThen( URL.init )
     *
     *  url // nil
     *  ````
     *  If the success path is all you need then `andThen` gets you covered.
     */
    @discardableResult
    func andThen<T>(_ transform: (Wrapped) -> T?) -> T? { flatMap(transform) }
    
    
    /**
     *  `mapNone` is the same thing for `none` case like `andThen` for `some` case.
     *
     *  This functions allows you to `recover` from a computation that returned nil. It
     *  ignores the some case and run only for `none`.
     *
     *  ````
     *  let host: String? = "www.host.com"
     *  let url: URL? =
     *      host
     *         .andThen{ $0 + "/" }
     *         .andThen{ (s: String) -> String? in nil }
     *         // try to recover with home page
     *         .mapNone("www.host.com")
     *         .andThen( URL.init )
     *
     *  url // www.host.com
     *  ````
     *
     *  If the failing function would produce a valid output then `mapNone` would not be called.
     *
     *  ````
     *  let host: String? = "www.host.com"
     *  let url: URL? =
     *      host
     *         .andThen{ $0 + "/" }
     *         .andThen{ $0 + "page.html" }
     *         // computation did not fail so nothing to recover from
     *         .mapNone("www.host.com")
     *         .andThen( URL.init )
     *
     *  url // www.host.com/page.html
     *  ````
     *
     *  You can `mapNone` more than once and on any stage you want.
     */
    @discardableResult
    func mapNone(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped? {
        or(producer())
    }
    
    
    /**
     *  `defaultSome` is just a better name than `mapNone`. Both work exactly the same.
     *
     *  This functions allows you to `recover` from a computation that returned nil. It
     *  ignores the some case and run only for `none`.
     *
     *  ````
     *  let host: String? = "www.host.com"
     *  let url: URL? =
     *      host
     *         .andThen{ $0 + "/" }
     *         .andThen{ (s: String) -> String? in nil }
     *         // try to recover with home page
     *         .defaultSome("www.host.com")
     *         .andThen( URL.init )
     *
     *  url // www.host.com
     *  ````
     *
     *  If the failing function would produce a valid output then `mapNone` would not be called.
     *
     *  ````
     *  let host: String? = "www.host.com"
     *  let url: URL? =
     *      host
     *         .andThen{ $0 + "/" }
     *         .andThen{ $0 + "page.html" }
     *         // computation did not fail so nothing to recover from
     *         .defaultSome("www.host.com")
     *         .andThen( URL.init )
     *
     *  url // www.host.com/page.html
     *  ````
     *
     *  You can `defaultSome` more than once and on any stage you want.
     */
    @discardableResult
    func defaultSome(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped? {
        or(producer())
    }
    
    
    /**
     * `or` is a handy unwrapper of the wrapped value inside of optional **but** you must provide
     *  a `default` value in case the Optional is `nil`. That way it will always return
     *  a **not optional** instance to work with.
     *
     * ````
     * let missingAge: Int? = nil
     * let underAge  : Int? = 17
     * let overAge   : Int? = 42
     *
     * func canBuyBeer(_ age: Int) -> Bool { age > 18 }
     *
     * missingAge.andThen(canBuyBeer).or(false) // false
     * underAge  .andThen(canBuyBeer).or(false) // false
     * overAge   .andThen(canBuyBeer).or(false) // true
     * ````
     *
     *  Each time the final result was a true `Bool` not an `Bool?`.
     */
    @discardableResult
    func or(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped {
        self ?? producer()
    }
}

public extension Optional where Wrapped: Collection {
    
    /**
     * **True** if optional instance is ````.some```` **and** collections
     * **HAS** elements ````isEmpty == false````
     *
     * When working with a Optional Collection the interesting _question_ is
     * does it **hasElements**. Use this property to conveniently answer it.
     *
     * ````
     * let noneString: String? = .none
     * noneString.hasElements // false
     *
     * let emptySomeString: String? = "" // empty string
     * emptySomeString.hasElements       // false
     *
     * let someSomeString: String? = "some string"
     * someSomeString.hasElements // true
     *
     *
     * let noneIntArray: [Int]? = .none
     * noneIntArray.hasElements // false
     *
     * let emptyIntArray: [Int]? = []
     * emptyIntArray.hasElements // false
     *
     * let someIntArray: [Int]? = [11, 22, 33]
     * someIntArray.hasElements // true
     * ````
     */
    var hasElements: Bool {
        map( \.isEmpty ) // get isEmpty value from the wrapped collection
            .map( ! )    // negation; if was empty then i `has NOT Elements`
            .or(false)   // was none so definitely does not have elements
    }
    
    
    /**
     * **True** if optional instance is ````.none```` **or** collections ````isEmpty````.
     *
     * Very often when working with a Optional Collection the absence of value and
     *  it being empty is handled in the same way.
     *
     * ````
     * let noneString: String? = .none
     * noneString.isNoneOrEmpty // true
     *
     * let emptySomeString: String? = ""
     * emptySomeString.isNoneOrEmpty // true
     *
     * let someSomeString: String? = "some string"
     * someSomeString.isNoneOrEmpty // false
     *
     *
     * let noneIntArray: [Int]? = .none
     * noneIntArray.isNoneOrEmpty // true
     *
     * let emptyIntArray: [Int]? = []
     * emptyIntArray.isNoneOrEmpty // true
     *
     * let someIntArray: [Int]? = [11, 22, 33]
     * someIntArray.isNoneOrEmpty // false
     * ````
     */
    var isNoneOrEmpty: Bool { map( \.isEmpty ) ?? true }

    
    @discardableResult
    func recoverFromEmpty(_ producer: @autoclosure () -> Wrapped) -> Wrapped? {
        map({ collection in collection.isEmpty ? producer() : collection })
    }
    
    
    func defaultSome(_ producer: @autoclosure () -> Wrapped) -> Wrapped {
        switch self {
        case .none:
            return producer()
            
        case .some(let collection):
            return collection.isEmpty ? producer() : collection
        }
    }
}
