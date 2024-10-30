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
    @Published private(set) var sections: [MusicSection] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    @Published private(set) var expandedSections: Set<Int> = []
    
    // MARK: - Private Properties
    private var originalSections: [MusicSection] = []
    private let defaultVerticalDisplay: Int = 3
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    func fetchData() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        Task { @MainActor in
            do {
                let fetchedSections = try await NetworkProvider.getHomeMusic()
                self.originalSections = fetchedSections
                updateDisplayedSections()
            } catch {
                self.error = error
            }
            isLoading = false
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
        sections = originalSections.enumerated().map { index, section in
            if section.type == .vertical {
                if !expandedSections.contains(index) {
                    var limitedSection = section
                    limitedSection.items = Array(section.items.prefix(defaultVerticalDisplay))
                    return limitedSection
                }
            }
            return section
        }
    }
    
    func isExpanded(for sectionIndex: Int) -> Bool {
        expandedSections.contains(sectionIndex)
    }
}
