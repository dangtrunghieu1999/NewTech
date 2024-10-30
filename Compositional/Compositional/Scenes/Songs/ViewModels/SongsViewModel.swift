//
//  SongsViewModel.swift
//  Compositional
//
//  Created by Kai on 30/10/24.
//

import Combine

class SongsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var songs: [SongItem] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published private(set) var isExpanded: Bool = false
    
    // MARK: - Private Properties
    private var originalSongs: [SongItem] = []
    private let defaultDisplay: Int = 5
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    func fetchSongs() {
        isLoading = true
        error = nil
        
        Task { @MainActor in
            do {
                self.originalSongs = try await NetworkProvider.getSongs()
                self.updateDisplayedSongs()
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
    
    func toggleExpand() {
        isExpanded.toggle()
        updateDisplayedSongs()
    }
    
    // MARK: - Private Methods
    private func updateDisplayedSongs() {
        songs = isExpanded ? originalSongs : Array(originalSongs.prefix(defaultDisplay))
    }
}
