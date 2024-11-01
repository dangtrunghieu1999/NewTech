//
//  HorizontalMusicItemCell.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

class HorizontalMusicItemCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func initialize() {
        super.initialize()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
    }
    
    // MARK: - Configuration
    func configure(with item: MusicItem) {
        titleLabel.text = item.title
        if let imageURL = item.imageURL {
            imageView.image = UIImage(named: imageURL)
        }
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(titleLabel)
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(containerStackView.snp.width)
            make.height.equalTo(imageView.snp.width) // 1:1 aspect ratio
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
