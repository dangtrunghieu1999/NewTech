//
//  ArtistCollectionViewCell.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import UIKit

class ArtistCollectionViewCell: BaseCollectionViewCell {

    // MARK: - Properties
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func initialize() {
        super.initialize()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - Configuration
    func configCell(with artist: Artist) {
        imageView.image = UIImage(named: artist.imageUrl)
        titleLabel.text = artist.name
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
