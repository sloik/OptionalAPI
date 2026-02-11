
import Foundation

public extension Optional {
    
    /// Sometime you want to just run some code when optional has _any_ wrapped value. This function gives you
    /// a nice API to do that.
    ///
    /// ````swift
    /// let life: Int? = 42
    ///
    /// life
    ///     .whenSome { i in print(i) } // prints: 42
    ///     .whenSome { print("I do not know the value but I run!") }
    ///     .whenNone { print("This won't run") }
    /// ````
    ///
    /// - Parameter block: Side effect that you want to trigger when optional has _any_ value of type `Wrapped`
    /// - Returns: Same optional without altering it.
    @discardableResult
    func whenSome(_ block: () -> Void) -> Wrapped? {
        if isSome { block() }
        return self
    }
    
    
    /// More explicit name for `run` function. Under the hood it just calls it.
    ///
    /// ````swift
    /// let life: Int? = 42
    ///
    /// life
    ///     .whenSome { i in print(i) } // prints: 42
    ///     .whenSome { print("I do not know the value but I run!") }
    ///     .whenNone { print("This won't run") }
    /// ````
    ///
    /// - Parameter block: Function to be called for side effects when optional `isSome`.
    /// - Returns: Same optional without altering it.
    @discardableResult
    func whenSome(_ block: (Wrapped) -> Void) -> Wrapped? {
        _ = self.map(block)
        return self
    }

    /// Sometime you want to just run some code when optional has _any_ wrapped value. 
    /// This function gives you a nice API to do that.
    @discardableResult
    func tryWhenSome(_ block: (Wrapped) throws -> Void) throws -> Wrapped? {
        _ = try self.map(block)
        return self
    }

    /// Asynchronous throwing version of `tryWhenSome`.
    ///
    /// ````swift
    /// let life: Int? = 42
    /// try await life.tryAsyncWhenSome { value in
    ///     await Task.yield()
    ///     print(value)
    /// }
    /// ````
    ///
    /// - Parameter block: Async throwing side effect to trigger when optional `isSome`.
    /// - Returns: Same optional without altering it.
    /// - Throws: Rethrows errors from the block.
    @discardableResult
    func tryAsyncWhenSome(_ block: (Wrapped) async throws -> Void) async throws -> Wrapped? {
        switch self {
        case .some(let wrapped):
            try await block(wrapped)
            return self
        case .none:
            return self
        }
    }
    
    /// Sometimes you want to run some logic if optional does not contain any wrapped value.
    ///
    /// ````swift
    /// let life: Int? = 42
    ///
    /// life
    ///     .whenSome { print("This won't run") }
    ///     .whenSome { print("This won't run") }
    ///     .whenNone { print("Only this block will run") }
    /// ````
    ///
    /// - Parameter block: Side effect that you want to trigger when optional `isNone`
    /// - Returns: Same optional without altering it.
    @discardableResult
    func whenNone(_ block: () -> Void) -> Wrapped? {
        if isNone { block() }
        return self
    }
}
