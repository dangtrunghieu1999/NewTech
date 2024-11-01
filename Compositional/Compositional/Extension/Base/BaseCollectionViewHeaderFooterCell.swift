//
//  BaseCollectionViewHeaderFooterCell.swift
//  Compositional
//
//  Created by Kai on 1/11/24.
//

import UIKit

class BaseCollectionViewHeaderFooterCell: UICollectionReusableView, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        
    }
    
}
