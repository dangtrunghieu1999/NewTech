//
//  AlbumsDTO.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import Foundation

struct AlbumsSectionDTO: Codable {
    let title: String
    let items: [AlbumItemDTO]
}

struct AlbumItemDTO: Codable {
    let id: String
    let name: String
    let artistName: String
    let imageUrl: String
    let releaseYear: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artistName = "artist_name"
        case imageUrl = "image_url"
        case releaseYear = "release_year"
    }
}

extension AlbumsSectionDTO {
    func toDomain() -> AlbumsSection {
        AlbumsSection(
            title: title,
            items: items.map { $0.toDomain() }
        )
    }
}

extension AlbumItemDTO {
    func toDomain() -> Album {
        Album(
            id: id,
            title: name,
            artistName: artistName,
            imageUrl: imageUrl,
            releaseYear: releaseYear
        )
    }
}
