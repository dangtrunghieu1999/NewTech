//
//  OCBItem.swift
//  Compositional
//
//  Created by Kai on 30/10/24.
//

import Foundation

struct OCBItem: Codable, Hashable {
    let id: String
    let title: String
    let subtitle: String?
    let iconName: String
    let backgroundColor: String
    
    private enum CodingKeys: String, CodingKey {
        case id, title, subtitle, iconName, backgroundColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        iconName = try container.decode(String.self, forKey: .iconName)
        backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
    }
    
    
}
