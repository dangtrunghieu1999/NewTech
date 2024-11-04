//
//  UIScreen+Extension.swift
//  Compositional
//
//  Created by Kai on 4/11/24.
//

import UIKit

extension UIScreen {
    /// Reference width (iPhone design width)
    static let designWidth: CGFloat = 375
    
    /// Returns the current device's screen width
    static var currentWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// Returns the current device's screen height
    static var currentHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// Calculates the proportional width based on design width (375pt)
    /// - Parameter width: The width in design specifications
    /// - Returns: The proportionally calculated width for current device
    static func adaptiveWidth(_ width: CGFloat) -> CGFloat {
        return currentWidth * (width / designWidth)
    }
    
    /// Calculates the proportional height based on design width (375pt)
    /// - Parameter height: The height in design specifications
    /// - Returns: The proportionally calculated height for current device
    static func adaptiveHeight(_ height: CGFloat) -> CGFloat {
        return currentWidth * (height / designWidth)
    }
}
