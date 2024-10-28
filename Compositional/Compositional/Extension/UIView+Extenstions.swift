//
//  UIView+Extenstions.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

extension UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
