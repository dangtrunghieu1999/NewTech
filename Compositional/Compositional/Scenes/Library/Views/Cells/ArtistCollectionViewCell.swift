//
//  ArtistCollectionViewCell.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 52.5
        imageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }

    
    func configCell(with artist: Artist) {
        imageView.image = UIImage(named: artist.imageUrl)
        titleLabel.text = artist.name
    }
}
