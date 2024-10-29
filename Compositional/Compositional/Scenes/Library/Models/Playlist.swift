//
//  Playlist.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import Foundation

struct PlaylistsSection: Hashable {
    let title: String
    let items: [Playlist]
}

struct Playlist: Hashable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let tracksCount: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        lhs.id == rhs.id
    }
}
