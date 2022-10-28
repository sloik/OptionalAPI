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

// MARK: - Throwing

enum DummyError: Error {
    case boom
}

/// Always throws `DummyError.boom`.
func alwaysThrowing<T>(_ anything: T) throws -> String {
    throw DummyError.boom
}

/// Always returns string `"It works fine"`.
func alwaysReturningString<T>(_ anything: T) throws -> String {
    "It works fine"
}

// MARK: - Application

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication

/// Applys function `f` to value `x`.
@discardableResult
public func |> <A, B>(x: A, f: (A) -> B) -> B {
    f(x)
}
