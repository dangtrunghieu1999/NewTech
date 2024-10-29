//
//  ArtistsDTO.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import Foundation

struct ArtistsSectionDTO: Codable {
    let title: String
    let items: [ArtistItemDTO]
}

struct ArtistItemDTO: Codable {
    let id: String
    let name: String
    let genre: String
    let imageUrl: String
    let followersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case genre
        case imageUrl = "image_url"
        case followersCount = "followers_count"
    }
}

extension ArtistsSectionDTO {
    func toDomain() -> ArtistsSection {
        ArtistsSection(
            title: title,
            items: items.map { $0.toDomain() }
        )
    }
}

extension ArtistItemDTO {
    func toDomain() -> Artist {
        Artist(
            id: id,
            name: name,
            genre: genre,
            imageUrl: imageUrl,
            followersCount: followersCount
        )
    }
}
