//
//  MusicItemCell.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

class MusicItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        titleLabel.textColor = UIColor.black
        subtitleLabel.textColor = UIColor.gray
    }
    
    func configure(with item: MusicItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        if let imageURL = item.imageURL {
            imageView.image = UIImage(named: imageURL)
        }
    }
}
