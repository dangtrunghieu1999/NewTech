import Foundation

struct PlaylistsSectionDTO: Codable {
    let title: String
    let items: [PlaylistItemDTO]
}

struct PlaylistItemDTO: Codable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let tracksCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl = "image_url"
        case tracksCount = "tracks_count"
    }
}

extension PlaylistsSectionDTO {
    func toDomain() -> PlaylistsSection {
        PlaylistsSection(
            title: title,
            items: items.map { $0.toDomain() }
        )
    }
}

extension PlaylistItemDTO {
    func toDomain() -> Playlist {
        Playlist(
            id: id,
            name: name,
            description: description,
            imageUrl: imageUrl,
            tracksCount: tracksCount
        )
    }
} 
