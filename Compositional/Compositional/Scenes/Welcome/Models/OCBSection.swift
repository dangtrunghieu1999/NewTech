//
//  OCBSection.swift
//  Compositional
//
//  Created by Kai on 30/10/24.
//

import Foundation

struct OCBSection: Codable, Hashable {
    let id: String
    let type: OCBSectionType
    let title: String
    var items: [OCBItem]
}
