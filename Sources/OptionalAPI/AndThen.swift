
import Foundation

public extension Optional {
    
     /// More readable wrapper on ```flatMap``` function defined on Optional in the standard library.
     ///
     ///
     ///  It gives a readable way of chaining multiple operations. Also those that return an Optional.
     ///  With this you can define pipelines of data transformations like so:
     ///
     ///  ````
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }         // appends "/"
     ///         .andThen{ $0 + "page.html" } // appends "page.html"
     ///         .andThen( URL.init )         // creates an URL
     ///  url // www.host.com/page.html
     ///  ````
     ///  Notice that we started with `String?` and that `URL.init` also returns and Optional.
     ///  So at the end we should have and `URL??` but `flatMap` removes of one layer of packaging.
     ///
     ///  What's more cool is that you can define blocks of code to run as when appending path components.
     ///  And use point-free style by passing function symbols. In each case this function is working
     ///  with a real value not an Optional.
     ///
     ///  And then is called only when the instance is `.some(Wrapped)`. For `.none` case it does
     ///  nothing. That is a very safe way of working with optionals:
     ///
     ///  ````
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         // append "/"
     ///         .andThen{ $0 + "/" }
     ///         // "s" is "www.host.com/" but function fails
     ///         .andThen{ (s: String) -> String? in nil }
     ///          // is not getting called
     ///         .andThen( URL.init )
     ///
     ///  url // nil
     ///  ````
     ///  If the success path is all you need then `andThen` gets you covered.
    @discardableResult
    func andThen<T>(_ transform: (Wrapped) -> T?) -> T? { flatMap(transform) }
    
    
    /// When optional is `some` then tries to run `transform` to produce value of type `T`.
    /// However when this transform fails then this error is catch-ed and `.none` is returned
    /// as a final result.
    ///
    ///  ````
    ///  let jsonData: Data? = ...
    ///
    ///  jsonData
    ///      .andThenTry{ data in try JSONDecoder().decode(CodableStruct.self, from: data) }
    ///      .andThenTry( functionTakingCodbaleStructAndThrowing )
    ///      .andThen{ ...
    ///  ````
    ///
    ///  You can still use other operators to recover from failed _tried_ operators.
    @discardableResult
    func andThenTry<T>(_ transform: (Wrapped) throws -> T) -> T? {
        try? flatMap(transform)
    }
}
