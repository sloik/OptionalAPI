import Foundation

// MARK: - Systems Under Test

/// `.none`
let noneString: String? = .none

/// ""
let emptySomeString: String? = ""

/// "some string"
let someSomeString: String? = "some string"

/// `.none`
let noneIntArray : [Int]? = .none

/// Empty array `[]`
let emptyIntArray: [Int]? = []

/// Array with elements `[11, 22, 33]`.
let someIntArray : [Int]? = [11, 22, 33]

/// .none
let noneInt: Int? = .none

/// `.some( 42 )`
let someInt: Int? = .some(42)

/// `String?.some("any string")`
let anyString: Any? = String?.some("any string")

/// `String?.none`
let anyNoneString: Any? = String?.none

let anyInt: Any? = someInt
let anyNoneInt: Any? = noneInt

// MARK: - Codable

struct CodableStruct: Codable, Equatable {
    let number: Int
    let message: String
}
