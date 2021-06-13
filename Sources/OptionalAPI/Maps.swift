
import Foundation

public extension Optional {
     
     ///  `mapNone` is the same thing for `none` case like `andThen` for `some` case.
     ///
     ///  This functions allows you to `recover` from a computation that returned nil. It
     ///  ignores the some case and run only for `none`.
     ///
     ///  ````
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ (s: String) -> String? in nil }
     ///         // try to recover with home page
     ///         .mapNone("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com
     ///  ````
     ///
     ///  If the failing function would produce a valid output then `mapNone` would not be called.
     ///
     ///  ````
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ $0 + "page.html" }
     ///         // computation did not fail so nothing to recover from
     ///         .mapNone("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com/page.html
     ///  ````
     ///
     ///  You can `mapNone` more than once and on any stage you want.
    @discardableResult
    func mapNone(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped? {
        or(producer)
    }
    
     ///  `defaultSome` is just a better name than `mapNone`. Both work exactly the same.
     ///
     ///  This functions allows you to `recover` from a computation that returned nil. It
     ///  ignores the some case and run only for `none`.
     ///
     ///  ````
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ (s: String) -> String? in nil }
     ///         // try to recover with home page
     ///         .defaultSome("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com
     ///  ````
     ///
     ///  If the failing function would produce a valid output then `mapNone` would not be called.
     ///
     ///  ````
     ///  let host: String? = "www.host.com"
     ///  let url: URL? =
     ///      host
     ///         .andThen{ $0 + "/" }
     ///         .andThen{ $0 + "page.html" }
     ///         // computation did not fail so nothing to recover from
     ///         .defaultSome("www.host.com")
     ///         .andThen( URL.init )
     ///
     ///  url // www.host.com/page.html
     ///  ````
     ///
     ///  You can `defaultSome` more than once and on any stage you want.
    @discardableResult
    func defaultSome(_ producer: @autoclosure ProducerOfWrapped) -> Wrapped? {
        or(producer)
    }
}
