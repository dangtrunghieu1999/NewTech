
import Foundation

struct AlbumsSection: Hashable {
    let title: String
    let items: [Album]
}

struct Album: Hashable {
    let id: String
    let title: String
    let artistName: String
    let imageUrl: String
    let releaseYear: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        lhs.id == rhs.id
    }
} 
