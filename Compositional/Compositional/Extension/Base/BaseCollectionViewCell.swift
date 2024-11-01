//
//  BaseCollectionViewCell.swift
//  Compositional
//
//  Created by Kai on 1/11/24.
//

import UIKit

open class BaseCollectionViewCell: UICollectionViewCell, Reusable {
    
    // MARK: - UI Elements
    
    // MARKL - LifeCycles
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    // MARK: - Override
    
    // MARK: - Public
    
    public func initialize() {}
}
