import Foundation

let noneString: String? = .none

let emptySomeString: String? = ""

let someSomeString: String? = "some string"

let noneIntArray : [Int]? = .none

let emptyIntArray: [Int]? = []

let someIntArray : [Int]? = [11, 22, 33]

let noneInt: Int? = .none

let someInt: Int? = .some(42)

/// `String?.some("any string")`
nonisolated(unsafe) let anyString: Any? = String?.some("any string")

/// `String?.none`
nonisolated(unsafe) let anyNoneString: Any? = String?.none

nonisolated(unsafe) let anyInt: Any? = someInt
nonisolated(unsafe) let anyNoneInt: Any? = noneInt

// MARK: - Codable

struct CodableStruct: Codable, Equatable {
    let number: Int
    let message: String
}

enum DummyError: Error {
    case boom
}

func alwaysThrowing<T>(_ anything: T) throws -> String {
    throw DummyError.boom
}

func alwaysReturningString<T>(_ anything: T) throws -> String {
    "It works fine"
}

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication

@discardableResult
public func |> <A, B>(x: A, f: @Sendable (A) -> B) -> B {
    f(x)
}

// Fallback for non-Sendable closures (e.g., curried free-function results that
// capture mutable state). The Sendable overload above is preferred inside
// swift-testing macros (`#expect`) where the macro expansion requires a
// Sendable closure context.
@_disfavoredOverload
@discardableResult
public func |> <A, B>(x: A, f: (A) -> B) -> B {
    f(x)
}
