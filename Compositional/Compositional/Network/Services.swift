//
//  Services.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

protocol Services {
    func getHomeMusic() async throws -> [MusicSectionDTO]
}
