//
//  AlbumCollectionViewCell.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import UIKit

class AlbumCollectionViewCell: BaseCollectionViewCell {
    
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
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 11)
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
        subtitleLabel.text = nil
    }
    
    // MARK: - Configuration
    func configCell(with album: Album) {
        imageView.image = UIImage(named: album.imageUrl)
        titleLabel.text = album.title
        subtitleLabel.text = album.artistName
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(labelsStackView)
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(containerStackView.snp.width)
            make.height.equalTo(imageView.snp.width) // 1:1 aspect ratio
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
