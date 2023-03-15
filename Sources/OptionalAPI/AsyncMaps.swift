
import Foundation

public extension Optional {

    @discardableResult
    func asyncMap<T>(_ transform: (Wrapped) async -> T) async -> T? {
        switch self {
        case .some(let wrapped): return await transform(wrapped)
        case .none             : return .none
        }
    }

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
