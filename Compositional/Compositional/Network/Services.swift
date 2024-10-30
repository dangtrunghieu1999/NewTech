//
//  Services.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

protocol Services {
    func getHomeMusic() async throws -> [MusicSectionDTO]
    func getLibraryAlbums() async throws -> AlbumsSectionDTO
    func getLibraryArtists() async throws -> ArtistsSectionDTO
    func getLibraryPlaylists() async throws -> PlaylistsSectionDTO
    func getSongs() async throws -> [SongItemDTO]
}
