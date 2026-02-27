
public extension Optional where Wrapped: Collection {

    /// **True** if optional instance is `.some` **and** collections
    /// **HAS** elements when `isEmpty` is false.
    ///
    /// When working with a Optional Collection the interesting _question_ is
    /// does it **hasElements**. Use this property to conveniently answer it.
    ///
    /// ```swift
    /// let noneString: String? = .none
    /// noneString.hasElements // false
    ///
    /// let emptySomeString: String? = "" // empty string
    /// emptySomeString.hasElements       // false
    ///
    /// let someSomeString: String? = "some string"
    /// someSomeString.hasElements // true
    ///
    ///
    /// let noneIntArray: [Int]? = .none
    /// noneIntArray.hasElements // false
    ///
    /// let emptyIntArray: [Int]? = []
    /// emptyIntArray.hasElements // false
    ///
    /// let someIntArray: [Int]? = [11, 22, 33]
    /// someIntArray.hasElements // true
    /// ````
    @inlinable var hasElements: Bool {
        switch self {
        case .some(let collection): return !collection.isEmpty
        case .none: return false
        }
    }


    /// **True** if optional instance is none **or** collections are empty.
    ///
    /// Very often when working with a Optional Collection the absence of value and
    /// it being empty is handled in the same way.
    ///
    /// ```swift
    /// let noneString: String? = .none
    /// noneString.isNoneOrEmpty // true
    ///
    /// let emptySomeString: String? = ""
    /// emptySomeString.isNoneOrEmpty // true
    ///
    /// let someSomeString: String? = "some string"
    /// someSomeString.isNoneOrEmpty // false
    ///
    ///
    /// let noneIntArray: [Int]? = .none
    /// noneIntArray.isNoneOrEmpty // true
    ///
    /// let emptyIntArray: [Int]? = []
    /// emptyIntArray.isNoneOrEmpty // true
    ///
    /// let someIntArray: [Int]? = [11, 22, 33]
    /// someIntArray.isNoneOrEmpty // false
    /// ````
    @inlinable var isNoneOrEmpty: Bool { map( \.isEmpty ) ?? true }


    ///  - Parameters:
    ///      - producer: Value ot type `Wrapped` to be used in case of wrapped collection `isEmpty`.
    ///
    ///  This is called **only** if the underlying collection is empty. If optional is `nil`
    ///  or has some value. Then this function will not be called.
    ///
    ///  ```swift
    ///   let noneIntArray : [Int]? = .none
    ///   noneIntArray.recoverFromEmpty( [42] )  // nil ; is not a empty collection
    ///   noneIntArray.defaultSome( [42] )       // [42]; use defaultSome for .none case
    ///
    ///   let emptyIntArray: [Int]? = []
    ///   emptyIntArray.recoverFromEmpty( [42] ) // [42] ; was `some` and collection was empty
    ///   emptyIntArray.defaultSome( [42] )      // [] ; was `some` case
    ///
    ///   let someIntArray : [Int]? = [11, 22, 33]
    ///   someIntArray.recoverFromEmpty( [42] )  // [11, 22, 33] ; was `some` and collection has elements
    ///   someIntArray.defaultSome( [42] )       // [11, 22, 33] ; was `some` and collection has elements
    ///   ```
    @inlinable @discardableResult
    func recoverFromEmpty(_ producer: @autoclosure () -> Wrapped) -> Wrapped? {
        map { collection in collection.isEmpty ? producer() : collection }
    }

    /// Asynchronous version of `recoverFromEmpty` for async producers.
    ///
    /// ```swift
    /// let items: [Int]? = []
    /// let result = await items.asyncRecoverFromEmpty {
    ///     await Task.yield()
    ///     return [42]
    /// }
    /// ```
    ///
    /// - Parameter producer: Async producer used when the collection is empty.
    /// - Returns: Original collection when non-empty, produced value when empty, or `.none`.
    @inlinable @discardableResult
    func asyncRecoverFromEmpty(_ producer: () async -> Wrapped) async -> Wrapped? {
        switch self {
        case .some(let collection):
            return collection.isEmpty ? await producer() : collection
        case .none:
            return .none
        }
    }

    @inlinable func recoverFromEmpty(_ producer: () -> Wrapped) -> Wrapped? {
        map { collection in collection.isEmpty ? producer() : collection }
    }
}
