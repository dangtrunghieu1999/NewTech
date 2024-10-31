//
//  MusicViewModel.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Combine
import UIKit

class MusicViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var state: Loadable<[MusicSection]> = .loaded(value: [])
    @Published private(set) var expandedSections: Set<Int> = []
    
    // MARK: - Private Properties
    private var originalSections: [MusicSection] = []
    private let defaultVerticalDisplay: Int = 3
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    func fetchData() {
        guard !state.isLoading else { return }
        
        let lastValue = state.valueOrPast
        state = .isLoading(last: lastValue)
        
        Task { @MainActor in
            do {
                self.originalSections = try await NetworkProvider.getHomeMusic()
                updateDisplayedSections()
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
        updateDisplayedSections()
    }
    
    // MARK: - Private Methods
    private func updateDisplayedSections() {
        let processedSections = originalSections.enumerated().map { index, section in
            if section.type == .vertical {
                if !expandedSections.contains(index) {
                    var limitedSection = section
                    limitedSection.items = Array(section.items.prefix(defaultVerticalDisplay))
                    return limitedSection
                }
            }
            return section
        }
        
        state = .loaded(value: processedSections)
    }
    
    func isExpanded(for sectionIndex: Int) -> Bool {
        expandedSections.contains(sectionIndex)
    }
}
