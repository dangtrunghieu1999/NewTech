//
//  HorizontalMusicItemCell.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

class HorizontalMusicItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
    }
    
    private func setupUI() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        
        titleLabel.textColor = UIColor.black
    }
    
    func configure(with item: HomeMusicItem) {
        titleLabel.text = item.title
        if let imageURL = item.imageURL {
            imageView.image = UIImage(named: imageURL)
        }
    }
}
