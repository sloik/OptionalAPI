
import Foundation

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
            .map( ! )    // negation; if was empty then it `has NOT Elements`
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

    
    /**
     *  - Parameters:
     *      - producer: Value ot type `Wrapped` to be used in case of wrapped collection `isEmpty`.
     *
     *  This is called **only** if the underlying collection is empty. If optional is `nil`
     *  or has some value. Then this function will not be called.
     *
     *  ````
     *   let noneIntArray : [Int]? = .none
     *   noneIntArray.recoverFromEmpty( [42] )  // nil ; is not a empty collection
     *   noneIntArray.defaultSome( [42] )       // [42]; use defaultSome for .none case
     *
     *   let emptyIntArray: [Int]? = []
     *   emptyIntArray.recoverFromEmpty( [42] ) // [42] ; was `some` and collection was empty
     *   emptyIntArray.defaultSome( [42] )      // [] ; was `some` case
     *
     *   let someIntArray : [Int]? = [11, 22, 33]
     *   someIntArray.recoverFromEmpty( [42] )  // [11, 22, 33] ; was `some` and collection has elements
     *   someIntArray.defaultSome( [42] )       // [11, 22, 33] ; was `some` and collection has elements
     *   ````
     */
    @discardableResult
    func recoverFromEmpty(_ producer: @autoclosure () -> Wrapped) -> Wrapped? {
        map { collection in collection.isEmpty ? producer() : collection }
    }
    
    func recoverFromEmpty(_ producer: () -> Wrapped) -> Wrapped? {
        map { collection in collection.isEmpty ? producer() : collection }
    }
}
