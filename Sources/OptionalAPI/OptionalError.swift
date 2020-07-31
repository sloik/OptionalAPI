
import Foundation

public extension Optional {
    
    /// When self is `.none` calls error producing closure and throws produced error.
    /// When self is `.some` unwraps and returns it.
    ///
    /// - Parameter error: Closure producing an error.
    /// - Returns: Unwrapped value.
    func throwOrGetValue(_ error: () -> Error) throws -> Wrapped {
        if self == nil {
            throw error()
        }
        
        return self!
    }
}
