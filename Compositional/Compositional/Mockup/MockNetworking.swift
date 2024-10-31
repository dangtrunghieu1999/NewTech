//
//  MockNetworking.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

struct MockNetworking: Services {
    func getHomeMusic() async throws -> [MusicSectionDTO] {
        await Task.delay(seconds: 1)
        guard let url = Bundle.main.url(forResource: "HomeMusic", withExtension: "json") else {
            throw NSError(domain: "MockNetworking", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let baseDTO = try decoder.decode(BaseDTO<[MusicSectionDTO]>.self, from: data)
        return baseDTO.data
    }
    
    func getLibraryAlbums() async throws -> AlbumsSectionDTO {
        await Task.delay(seconds: 1)
        guard let url = Bundle.main.url(forResource: "Albums", withExtension: "json") else {
            throw NSError(domain: "MockNetworking", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let baseDTO = try decoder.decode(BaseDTO<AlbumsSectionDTO>.self, from: data)
        return baseDTO.data
    }
    
    func getLibraryArtists() async throws -> ArtistsSectionDTO {
        await Task.delay(seconds: 1)
        guard let url = Bundle.main.url(forResource: "Artists", withExtension: "json") else {
            throw NSError(domain: "MockNetworking", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let baseDTO = try decoder.decode(BaseDTO<ArtistsSectionDTO>.self, from: data)
        return baseDTO.data
    }
    
    func getLibraryPlaylists() async throws -> PlaylistsSectionDTO {
        await Task.delay(seconds: 1)
        guard let url = Bundle.main.url(forResource: "PlayLists", withExtension: "json") else {
            throw NSError(domain: "MockNetworking", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let baseDTO = try decoder.decode(BaseDTO<PlaylistsSectionDTO>.self, from: data)
        return baseDTO.data
    }
    
    func getSongs() async throws -> [SongItemDTO] {
        await Task.delay(seconds: 1)
        guard let url = Bundle.main.url(forResource: "Songs", withExtension: "json") else {
            throw NSError(domain: "MockNetworking", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let baseDTO = try decoder.decode(BaseDTO<[SongItemDTO]>.self, from: data)
        return baseDTO.data
    }
}
