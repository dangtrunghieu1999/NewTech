//
//  NetworkClient.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//
import Foundation

class NetworkClient {
    static let shared = NetworkClient()
    
    private init() {}

    private var network: Services?
    
    func initialize(service: Services) {
        self.network = service
    }
}

extension NetworkClient: Services {
    func getHomeMusic() async throws -> [MusicSectionDTO] {
        guard let network = network else {
            throw NSError(
                domain: "NetworkClient",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Network client not initialized"]
            )
        }
        return try await network.getHomeMusic()
    }
}