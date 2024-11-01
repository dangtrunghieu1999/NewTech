//
//  MusicItemCell.swift
//  Compositional
//
//  Created by Kai on 1/11/24.
//

import UIKit

class MusicItemCell: BaseCollectionViewCell {
    // MARK: - Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    override func initialize() {
        super.initialize()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // MARK: - Setup
    private func setupViews() {
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(labelStackView)
        
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(40)
        }
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
    }
    
    // MARK: - Configure
    func configure(with item: MusicItem) {
        if let imageURL = item.imageURL {
            imageView.image = UIImage(named: imageURL)
        }
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
