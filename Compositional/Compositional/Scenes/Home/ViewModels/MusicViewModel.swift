//
//  MusicViewModel.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Combine
import UIKit

class MusicViewModel {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // Publishers
    private let itemsSubject = CurrentValueSubject<[MusicSection], Never>([])
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    // Public publishers
    var itemsPublisher: AnyPublisher<[MusicSection], Never> {
        itemsSubject.eraseToAnyPublisher()
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
                let musicData = try await NetworkProvider.getHomeMusic()
                
                await MainActor.run {
                    self.itemsSubject.send(musicData)
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
