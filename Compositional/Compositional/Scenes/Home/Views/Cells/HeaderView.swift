//
//  HeaderView.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

class HeaderView: BaseCollectionViewHeaderFooterCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutTitleLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
