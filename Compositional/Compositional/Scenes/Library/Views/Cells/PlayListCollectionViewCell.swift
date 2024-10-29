//
//  PlayListCollectionViewCell.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import UIKit

class PlayListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configCell(with playList: Playlist) {
        imageView.image = UIImage(named: playList.imageUrl)
    }

}
