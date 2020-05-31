
import Foundation

public extension Optional {
    typealias ProducerOfWrapped = () -> Wrapped
    
    var isNone: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
    
    var isSome: Bool { isNone == false }
    
    var isNotNone: Bool { isNone == false }
    var isNotSome: Bool { isSome == false }
    
    @discardableResult
    func andThen<T>(_ transform: (Wrapped) -> T?) -> T? { flatMap(transform) }
    
    @discardableResult
    func mapNone(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped? {
        or(producer())
    }
    
    @discardableResult
    func defaultSome(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped? {
        or(producer())
    }
    
    @discardableResult
    func or(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped {
        switch self {
        case .none:
            return producer()
        case .some(let value):
            return value
        }
    }
}

public extension Optional where Wrapped: Collection {
    var isNoneOrEmpty: Bool { self.map{ $0.isEmpty } ?? true }
    
    var hasElements: Bool { self.map{ $0.isEmpty == false } ?? false }
        
    @discardableResult
    func recoverFromEmpty(_ producer: @autoclosure () -> Wrapped) -> Wrapped? {
        map({ collection in collection.isEmpty ? producer() : collection })
    }
    
    func defaultSome(_ producer: @autoclosure () -> Wrapped) -> Wrapped {
        switch self {
        case .none:
            return producer()
            
        case .some(let collection):
            return collection.isEmpty ? producer() : collection
        }
    }
}
