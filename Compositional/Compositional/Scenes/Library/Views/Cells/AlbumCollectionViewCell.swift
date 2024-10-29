//
//  AlbumCollectionViewCell.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        
        titleLabel.textColor = UIColor.black
        subTitleLabel.textColor = UIColor.gray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
    
    func configCell(with album: Album) {
        imageView.image = UIImage(named: album.imageUrl)
        titleLabel.text = album.title
        subTitleLabel.text = album.artistName
    }
}
