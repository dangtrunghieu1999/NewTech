//
//  LibraryViewModel.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import Combine
import Foundation

class LibraryViewModel {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // Publishers
    private let sectionsSubject = CurrentValueSubject<[LibrarySection], Never>([])
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    // Public publishers
    var sectionsPublisher: AnyPublisher<[LibrarySection], Never> {
        sectionsSubject.eraseToAnyPublisher()
    }
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject.eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Methods
    func fetchData() {
        loadingSubject.send(true)
        
        Task {
            do {
                // First API call - Albums
                let albums = try await NetworkProvider.getAlbums()
                await MainActor.run {
                    let section = LibrarySection(
                        title: albums.title,
                        items: albums.items.map { LibraryItem.album($0) }
                    )
                    self.sectionsSubject.send([section])
                }
                
                // Second API call - Artists
                let artists = try await NetworkProvider.getArtists()
                await MainActor.run {
                    var sections = self.sectionsSubject.value
                    sections.append(LibrarySection(
                        title: artists.title,
                        items: artists.items.map { LibraryItem.artist($0) }
                    ))
                    self.sectionsSubject.send(sections)
                }
                
                // Third API call - Playlists
                let playlists = try await NetworkProvider.getPlaylists()
                await MainActor.run {
                    var sections = self.sectionsSubject.value
                    sections.append(LibrarySection(
                        title: playlists.title,
                        items: playlists.items.map { LibraryItem.playlist($0) }
                    ))
                    self.sectionsSubject.send(sections)
                    self.loadingSubject.send(false)
                }
            } catch {
                await MainActor.run {
                    self.errorSubject.send(error)
                    self.loadingSubject.send(false)
                }
            }
        }
    }
}
