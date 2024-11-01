//
//  SeeMoreFooterView.swift
//  Compositional
//
//  Created by Kai on 30/10/24.
//

import UIKit

// MARK: - Protocol
protocol SeeMoreFooterViewDelegate: AnyObject {
    func seeMoreFooterViewDidSelect(_ footerView: SeeMoreFooterView)
}

class SeeMoreFooterView: BaseCollectionViewHeaderFooterCell {
    // MARK: - Properties
    static let reuseIdentifier = String(describing: SeeMoreFooterView.self)
    weak var delegate: SeeMoreFooterViewDelegate?
    
    var sectionIndex: Int = 0
    
    // MARK: - UI Components
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [seeMoreButton, iconImageView])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    override func initialize() {
        super.initialize()
        setupViews()
    }
    // MARK: - Setup
    private func setupViews() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    // MARK: - Configuration
    func configure(isExpanded: Bool, sectionIndex: Int) {
        let title = isExpanded ? "Show Less" : "See More"
        let image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        let titleColor: UIColor = isExpanded ? .systemGray : .systemBlue
        
        seeMoreButton.setTitle(title, for: .normal)
        seeMoreButton.setTitleColor(titleColor, for: .normal)
        iconImageView.image = image
        iconImageView.tintColor = titleColor
        self.sectionIndex = sectionIndex
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        delegate?.seeMoreFooterViewDidSelect(self)
    }
}
