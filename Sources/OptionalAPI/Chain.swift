
import Foundation

public extension Optional {
    @discardableResult
    func chain(_ block: (Wrapped) -> Void) -> Wrapped? {
        _ = self.map(block)
        return self
    }
}
