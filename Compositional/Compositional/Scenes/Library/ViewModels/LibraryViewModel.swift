//
//  LibraryViewModel.swift
//  Compositional
//
//  Created by Kai on 29/10/24.
//

import Combine
import Foundation

@MainActor
class LibraryViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var state: Loadable<[LibrarySection]> = .loaded(value: [])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    func fetchData() {
        guard !state.isLoading else { return }
        
        let lastValue = state.valueOrPast
        state = .isLoading(last: lastValue)
        
        Task { @MainActor in
            do {
                let albums = try await NetworkProvider.getAlbums()
                let section = LibrarySection(
                    title: albums.title,
                    items: albums.items.map { LibraryItem.album($0) }
                )
                state = .loaded(value: [section])
                
                let artists = try await NetworkProvider.getArtists()
                var sections = state.value ?? []
                sections.append(LibrarySection(
                    title: artists.title,
                    items: artists.items.map { LibraryItem.artist($0) }
                ))
                state = .loaded(value: sections)
            } catch {
                state = .failed(error: error)
            }
        }
    }
}
