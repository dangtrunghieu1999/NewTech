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
    
    static func getAlbums() async throws -> AlbumsSection {
        try await apis.getLibraryAlbums().toDomain()
    }
    
    static func getArtists() async throws -> ArtistsSection {
        try await apis.getLibraryArtists().toDomain()
    }
    
    static func getPlaylists() async throws -> PlaylistsSection {
        try await apis.getLibraryPlaylists().toDomain()
    }
}
