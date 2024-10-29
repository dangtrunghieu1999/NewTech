//
//  LibrarySection.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//


struct LibrarySection: Hashable {
    let title: String
    let items: [LibraryItem]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: LibrarySection, rhs: LibrarySection) -> Bool {
        return lhs.title == rhs.title
    }
}

enum LibraryItem: Hashable {
    case album(Album)
    case artist(Artist)
    case playlist(Playlist)
}
