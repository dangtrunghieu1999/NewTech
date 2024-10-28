//
//  HeaderView.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
