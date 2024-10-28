//
//  MusicSection.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

struct MusicSection: Hashable {
    let id: String
    let type: SectionType
    let title: String
    
    enum SectionType: String {
        case vertical
        case horizontal
    }
}
