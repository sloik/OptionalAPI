import Foundation

public extension Optional {
    
    var isNone: Bool { self == nil }
    var isSome: Bool { self != nil }
    
    var isNotNone: Bool { isNone == false }
    var isNotSome: Bool { isSome == false }
    
    func andThen<T>(_ transform: (Wrapped) -> T?) -> T? { flatMap(transform) }
    
    func mapNone(_ producer: @autoclosure () -> Wrapped) -> Wrapped? { isNone ? producer() : self }
    
    func recoverFromNone(_ producer: @autoclosure () -> Wrapped) -> Wrapped? { mapNone(producer()) }
}

public extension Optional where Wrapped: Collection {
    var isNoneOrEmpty: Bool { self.map{ $0.isEmpty } ?? true }
    
    var isNotNoneOrEmpty: Bool { self.map{ $0.isEmpty == false } ?? false }
    
    var hasValues: Bool { isNoneOrEmpty == false }
    
    func recoverFromEmpty(_ producer: @autoclosure () -> Wrapped) -> Wrapped? {
        isNoneOrEmpty
            ? producer()
            : self
    }
}
