//
//  SongItemDTO.swift
//  Compositional
//
//  Created by Kai on 30/10/24.
//

import Foundation

struct SongItemDTO: Codable {
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.releaseYear = try container.decode(String.self, forKey: .releaseYear)
    }
}

extension SongItemDTO {
    func toDomain() -> SongItem {
        SongItem(id: id, name: name, artistName: artistName, imageURl: imageUrl)
    }
}
