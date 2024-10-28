//
//  HomeMusicItem.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

struct HomeMusicItem: Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageURL: String?
}
