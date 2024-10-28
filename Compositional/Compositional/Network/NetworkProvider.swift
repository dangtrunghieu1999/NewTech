//
//  NetworkProvider.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

class NetworkProvider {
    static var apis: NetworkClient { NetworkClient.shared }
    
    static func getHomeMusic() async throws -> [MusicSection] {
        try await apis.getHomeMusic().map { $0.object }
    }
}
