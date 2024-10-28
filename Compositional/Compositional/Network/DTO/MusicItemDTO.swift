//
//  MusicItemDTO.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

struct MusicItemDTO: Codable {
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: String?
    
    var object: MusicItem {
        MusicItem(
            id: id,
            title: title,
            subtitle: subtitle,
            imageURL: imageURL
        )
    }
}
