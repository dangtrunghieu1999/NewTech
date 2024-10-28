//
//  MusicSectionDTO.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

struct MusicSectionDTO: Codable {
    let id: String
    let type: String
    let title: String
    let items: [MusicItemDTO]
    
    var object: MusicSection {
        MusicSection(
            id: id,
            type: MusicSection.SectionType(rawValue: type) ?? .vertical,
            title: title,
            items: items.map { $0.object }
        )
    }
}
