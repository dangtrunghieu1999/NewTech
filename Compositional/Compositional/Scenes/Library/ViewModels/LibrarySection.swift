//
//  LibrarySection.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

struct LibrarySection: Hashable {
    let title: String
    let items: [LibraryItem]
}

enum LibraryItem: Hashable {
    case album(Album)
    case artist(Artist)
}
