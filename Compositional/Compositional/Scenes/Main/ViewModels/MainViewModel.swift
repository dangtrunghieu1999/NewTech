//
//  MainViewModel.swift
//  Compositional
//
//  Created by Kai on 31/10/24.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    // MARK: - Types
    enum Section: Hashable {
        case music(MusicSection)
        case library(LibrarySection)
        
        var title: String {
            switch self {
            case .music(let musicSection):
                return musicSection.title
            case .library(let librarySection):
                return librarySection.title
            }
        }
    }
    
    // MARK: - Properties
    @Published private(set) var state: Loadable<[Section]> = .loaded(value: [])
    @Published private(set) var expandedSections: Set<Int> = []
    
    private var originalMusicSections: [MusicSection] = []
    private let defaultVerticalDisplay: Int = 3
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    func fetchData(for segmentType: MainSegmentType) {
        guard !state.isLoading else { return }
        
        let lastValue = state.valueOrPast
        state = .isLoading(last: lastValue)
        
        Task { @MainActor in
            do {
                switch segmentType {
                case .music:
                    try await fetchMusicData()
                case .library:
                    try await fetchLibraryData()
                }
            } catch {
                state = .failed(error: error)
            }
        }
    }
    
    func toggleExpand(for sectionIndex: Int) {
        if expandedSections.contains(sectionIndex) {
            expandedSections.remove(sectionIndex)
        } else {
            expandedSections.insert(sectionIndex)
        }
        updateDisplayedMusicSections()
    }
    
    func isExpanded(for sectionIndex: Int) -> Bool {
        expandedSections.contains(sectionIndex)
    }
}

// MARK: - Private Methods
extension MainViewModel {
    func fetchMusicData() async throws {
        let musicData = try await NetworkProvider.getHomeMusic()
        self.originalMusicSections = musicData
        updateDisplayedMusicSections()
    }
    
    func fetchLibraryData() async throws {
        let albums = try await NetworkProvider.getAlbums()
        let albumSection = LibrarySection(
            title: albums.title,
            items: albums.items.map { LibraryItem.album($0) }
        )
        state = .loaded(value: [.library(albumSection)])
        
        let artists = try await NetworkProvider.getArtists()
        var sections = (state.value ?? [])
        sections.append(.library(LibrarySection(
            title: artists.title,
            items: artists.items.map { LibraryItem.artist($0) }
        )))
        state = .loaded(value: sections)
        
        let playlists = try await NetworkProvider.getPlaylists()
        sections = (state.value ?? [])
        sections.append(.library(LibrarySection(
            title: playlists.title,
            items: playlists.items.map { LibraryItem.playlist($0) }
        )))
        state = .loaded(value: sections)
    }
    
    func updateDisplayedMusicSections() {
        let processedSections = originalMusicSections
            .enumerated()
            .map { index, section in
                if section.type == .vertical {
                    if !expandedSections.contains(index) {
                        var limitedSection = section
                        limitedSection.items = Array(section.items.prefix(defaultVerticalDisplay))
                        return limitedSection
                    }
                }
                return section
            }
        state = .loaded(value: processedSections.map { .music($0) })
    }
}
