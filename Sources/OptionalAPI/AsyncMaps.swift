
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
    func asyncFlatMap<T>(_ transform: (Wrapped) async -> T?) async -> T? {

        switch self {
        case .some(let wrapped): return await transform(wrapped)
        case .none             : return .none
        }
    }
}
