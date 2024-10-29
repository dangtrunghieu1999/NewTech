//
//  Artist.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import Foundation

struct ArtistsSection: Hashable {
    let title: String
    let items: [Artist]
}

struct Artist: Hashable {
    let id: String
    let name: String
    let genre: String
    let imageUrl: String
    let followersCount: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        lhs.id == rhs.id
    }
}
