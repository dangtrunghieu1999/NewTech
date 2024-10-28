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
    private let itemsSubject = CurrentValueSubject<[HomeMusicSection: [HomeMusicItem]], Never>([:])
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    // Public publishers
    var itemsPublisher: AnyPublisher<[HomeMusicSection: [HomeMusicItem]], Never> {
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
                await Task.delay(seconds: 1.0)
                
                let verticalItems = [
                    HomeMusicItem(title: "They said", subtitle: "Binz", imageURL: "song1"),
                    HomeMusicItem(title: "Đừng yêu em nữa em mệt rồi", subtitle: "Min", imageURL: "song2"),
                    HomeMusicItem(title: "Tell Me Why", subtitle: "Mr. A, Touliver", imageURL: "song3")
                ]
                
                let horizontalItems = [
                    HomeMusicItem(title: "Bài hát nghe gần đây", subtitle: "", imageURL: "album1"),
                    HomeMusicItem(title: "Greatest Hits Collection", subtitle: "", imageURL: "album2"),
                    HomeMusicItem(title: "Bí Ẩn Vàng Trăng Của Em", subtitle: "", imageURL: "album3"),
                    HomeMusicItem(title: "Top1 hay nghe gần đây", subtitle: "", imageURL: "album4"),
                    HomeMusicItem(title: "Chill cùng rap việt", subtitle: "", imageURL: "album5")
                ]
                
                await MainActor.run {
                    let sections: [HomeMusicSection: [HomeMusicItem]] = [
                        .vertical: verticalItems,
                        .horizontal: horizontalItems
                    ]
                    self.itemsSubject.send(sections)
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
