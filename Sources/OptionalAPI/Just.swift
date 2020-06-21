import Foundation

// MARK: - Pure

public func just<T>(_ t: T) -> T? {
    Optional<T>.some(t)
}

public func just<T>(_ t: T?) -> T? {
    t
}
