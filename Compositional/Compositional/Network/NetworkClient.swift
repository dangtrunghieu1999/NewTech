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
    
    func getLibraryAlbums() async throws -> AlbumsSectionDTO {
        guard let network = network else {
            throw NSError(
                domain: "NetworkClient",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Network client not initialized"]
            )
        }
        return try await network.getLibraryAlbums()
    }
    
    func getLibraryArtists() async throws -> ArtistsSectionDTO {
        guard let network = network else {
            throw NSError(
                domain: "NetworkClient",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Network client not initialized"]
            )
        }
        return try await network.getLibraryArtists()
    }
    
    func getLibraryPlaylists() async throws -> PlaylistsSectionDTO {
        guard let network = network else {
            throw NSError(
                domain: "NetworkClient",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Network client not initialized"]
            )
        }
        return try await network.getLibraryPlaylists()
    }
    
    func getSongs() async throws -> [SongItemDTO] {
        guard let network = network else {
            throw NSError(
                domain: "NetworkClient",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Network client not initialized"]
            )
        }
        return try await network.getSongs()
    }
}
