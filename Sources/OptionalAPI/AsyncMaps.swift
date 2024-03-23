
import Foundation

public extension Optional {

    @discardableResult
    func asyncMap<T>(_ transform: (Wrapped) async -> T) async -> T? {
        switch self {
        case .some(let wrapped): return await transform(wrapped)
        case .none             : return .none
        }
    }

    /**
     Performs an asynchronous transformation on an optional value.

     - Parameters:
       - transform: A closure that takes an optional `Wrapped` value
                    and returns a new value of type `T` wrapped in
                    a `Task` that may throw an error.

     - Returns: An optional value of type `T`. If the original value
                was non-nil and the transformation succeeded, returns
                the transformed value. Otherwise, returns `nil`.

     - Note: This function is marked as `@discardableResult`, so you can
            choose to ignore the result if you don't need it.

     - Throws: An error of type `Error` if the transformation fails.

     - Example:
        ```swift
        enum MyError: Error {
            case invalidInput
        }

        func doAsyncTransformation(value: Int?) async throws -> String {
            guard let value = value else {
                throw MyError.invalidInput
            }

            await Task.sleep(1_000_000_000) // Simulate long-running task.

            return "Transformed value: \(value)"
        }

        let optionalValue: Int? = 42

        do {
            let transformedValue = try await optionalValue.tryAsyncMap { value in
                try doAsyncTransformation(value: value)
            }

            print(transformedValue) // Prints "Transformed value: 42".
        } catch {
            print(error)
        }
        ```
    */
    @discardableResult
    func tryAsyncMap<T>(_ transform: (Wrapped) async throws -> T) async throws -> T? {
        switch self {
        case .some(let wrapped): return try await transform(wrapped)
        case .none             : return .none
        }
    }

    @discardableResult
    func asyncFlatMap<T>(_ transform: (Wrapped) async -> T?) async -> T? {

        switch self {
        case .some(let wrapped): return await transform(wrapped)
        case .none             : return .none
        }
    }

    @discardableResult
    func tryAsyncFlatMap<T>(_ transform: (Wrapped) async throws -> T?) async throws -> T? {

        switch self {
        case .some(let wrapped): return try await transform(wrapped)
        case .none             : return .none
        }
    }
}
