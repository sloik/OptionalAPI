
#if canImport(UIKit)

import UIKit

extension UIView {
    var isVisible: Bool {
        set { self.isHidden = !newValue }
        get { self.isHidden == false }
    }
    
    var isNotHidden: Bool {
        set { isVisible = newValue }
        get { isVisible }
    }
    
    var isNotVisible: Bool {
        set { isHidden = newValue }
        get { isHidden }
    }
}

#endif
