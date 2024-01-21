
import Foundation

public extension Optional {

    func fold<R>(
        _ noneCase: R,
        _ someCase: (Wrapped) -> R
    ) -> R {
        map( someCase ) ?? noneCase
    }

}
