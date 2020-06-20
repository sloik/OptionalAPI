import Foundation

// MARK: - Systems Under Test
let noneString     : String? = .none

let emptySomeString: String? = ""
let someSomeString : String? = "some string"

let noneIntArray : [Int]? = .none
let emptyIntArray: [Int]? = []
let someIntArray : [Int]? = [11, 22, 33]

let noneInt: Int? = .none
let someInt: Int? = .some(42)

let anyString: Any? = String?.some("any string")
let anyNoneString: Any? = String?.none

let anyInt: Any? = someInt
let anyNoneInt: Any? = noneInt

// MARK: - Codable

struct CodableStruct: Codable, Equatable {
    let number: Int
    let message: String
}
