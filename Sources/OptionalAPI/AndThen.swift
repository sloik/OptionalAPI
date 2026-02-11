
import Foundation

public extension Optional {

     /// More readable wrapper on ```flatMap``` function defined on Optional in the standard library.
     ///
     ///
     ///  It gives a readable way of chaining multiple operations. Also those that return an Optional.
     ///  With this you can define pipelines of data transformations like so:
     ///
     ///  ```swift
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }         // appends "/"
     ///         .andThen{ $0 + "page.html" } // appends "page.html"
     ///         .andThen( URL.init )         // creates an URL
     ///  url // www.host.com/page.html
     ///  ```
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
     ///  ```swift
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
     ///  ```
     ///  If the success path is all you need then `andThen` gets you covered.
    @discardableResult
    func andThen<T>(_ transform: (Wrapped) -> T?) -> T? { flatMap(transform) }


    /// When optional is `some` then tries to run `transform` to produce value of type `T`.
    /// However when this transform fails then this error is catch-ed and `.none` is returned
    /// as a final result.
    ///
    ///  ```swift
    ///  let jsonData: Data? = ...
    ///
    ///  jsonData
    ///      .andThenTry{ data in try JSONDecoder().decode(CodableStruct.self, from: data) }
    ///      .andThenTry( functionTakingCodbaleStructAndThrowing )
    ///      .andThen{ ...
    ///  ```
    ///
    ///  You can still use other operators to recover from failed _tried_ operators.
    @discardableResult
    func andThenTry<T>(_ transform: (Wrapped) throws -> T) -> T? {
        try? flatMap(transform)
    }

    @discardableResult
    func andThenTryOrThrow<T>(_ transform: (Wrapped) throws -> T) throws -> T? {
        try flatMap(transform)
    }

    /// Asynchronous version of `andThenTryOrThrow` that propagates transform errors.
    ///
    /// ```swift
    /// let data: Data? = ...
    /// let model = try await data.tryAsyncAndThenTryOrThrow { value in
    ///     try await Task.sleep(nanoseconds: 42)
    ///     return try JSONDecoder().decode(CodableStruct.self, from: value)
    /// }
    /// ```
    ///
    /// - Parameter transform: Async throwing transform producing a value.
    /// - Returns: Transformed optional when `.some`, otherwise `.none`.
    /// - Throws: Rethrows errors from the transform.
    @discardableResult
    func tryAsyncAndThenTryOrThrow<T>(_ transform: (Wrapped) async throws -> T) async throws -> T? {
        switch self {
        case .some(let wrapped): return try await transform(wrapped)
        case .none             : return .none
        }
    }
}
