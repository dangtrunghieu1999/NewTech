//
//  LibraryViewController.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit
import Combine

class LibraryViewController: UIViewController {
    // MARK: - Components
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<LibrarySection, LibraryItem>?
    private let viewModel = LibraryViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - ViewLife Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        configureLoadingView()
        setupBindings()
        setupViews()
        viewModel.fetchData()
    }
}

// MARK: - Indicator
private extension LibraryViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Library"
    }
    
    func configureLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Setup
private extension LibraryViewController {
    func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: Loadable<[LibrarySection]>) {
        switch state {
        case .isLoading(let lastSections):
            updateLoadingState(true)
            if let sections = lastSections {
                updateSnapshot(with: sections)
            }
            
        case .loaded(let sections):
            updateLoadingState(false)
            updateSnapshot(with: sections)
            
        case .failed(let error):
            updateLoadingState(false)
            showError(error)
        }
    }
    
    func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
            collectionView.alpha = 0.5
            view.isUserInteractionEnabled = false
        } else {
            loadingView.stopAnimating()
            collectionView.alpha = 1.0
            view.isUserInteractionEnabled = true
        }
    }
    
    func updateSnapshot(with sections: [LibrarySection]) {
        var snapshot = NSDiffableDataSourceSnapshot<LibrarySection, LibraryItem>()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Layout
extension LibraryViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(AlbumCollectionViewCell.reuseIdentifier)
        collectionView.register(ArtistCollectionViewCell.reuseIdentifier)
        collectionView.register(PlayListCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderView.nib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createHorizontalSection()
        }
        return layout
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(115),  // Fixed width of 115
            heightDimension: .estimated(140)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 5,
            bottom: 0,
            trailing: 5
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 16,
                                                        bottom: 0,
                                                        trailing: 16)
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

// MARK: - Data source
extension LibraryViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LibrarySection, LibraryItem>(
            collectionView: collectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .album(let album):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AlbumCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? AlbumCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configCell(with: album)
                return cell
                
            case .artist(let artist):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArtistCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? ArtistCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configCell(with: artist)
                return cell
                
            case .playlist(let playlist):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlayListCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? PlayListCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configCell(with: playlist)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as? HeaderView,
            let snapshot = self?.dataSource?.snapshot() else {
                return UICollectionReusableView()
            }
            
            let section = snapshot.sectionIdentifiers[indexPath.section]
            header.configure(with: section.title)
            return header
        }
    }
}
