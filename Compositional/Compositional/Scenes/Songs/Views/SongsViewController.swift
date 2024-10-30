//
//  SongsViewController.swift
//  Compositional
//
//  Created by Kai on 30/10/24.
//

import UIKit
import Combine

// MARK: - Section Definition
extension SongsViewController {
    enum Section {
        case main
    }
}

class SongsViewController: UIViewController {
    // MARK: - Components
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, SongItem>?
    private let viewModel = SongsViewModel()
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
        setupViews()
        configureCollectionView()
        configureLoadingView()
        configureDataSource()
        bindViewModel()
        
        viewModel.fetchSongs()
    }
}

// MARK: - Indicator
private extension SongsViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Songs"
    }
    
    func configureLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Layout
extension SongsViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(MusicItemCell.reuseIdentifier)
        collectionView.register(HeaderView.nib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        
        collectionView.register(
            SeeMoreFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: SeeMoreFooterView.reuseIdentifier
        )
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createVerticalSection()
        }
        return layout
    }
    
    private func createVerticalSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 16,
                                                        bottom: 0,
                                                        trailing: 16)
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [header, footer]
        
        return section
    }
}

// MARK: - DataSource Configuration
private extension SongsViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, SongItem>(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, song) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MusicItemCell.reuseIdentifier,
                for: indexPath
            ) as? MusicItemCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: song)
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
               switch kind {
               case UICollectionView.elementKindSectionHeader:
                   guard let header = collectionView.dequeueReusableSupplementaryView(
                       ofKind: kind,
                       withReuseIdentifier: HeaderView.reuseIdentifier,
                       for: indexPath
                   ) as? HeaderView else { return UICollectionReusableView() }
                   header.configure(with: "Songs")
                   return header
                   
               case UICollectionView.elementKindSectionFooter:
                   guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SeeMoreFooterView.reuseIdentifier,
                    for: indexPath
                   ) as? SeeMoreFooterView, let self = self else { return UICollectionReusableView() }
                   return footer
                   
               default:
                   return nil
               }
           }
    }
    
    @objc private func expandButtonTapped() {
        viewModel.toggleExpand()
    }
    
    func updateSnapshot(with items: [SongItem], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SongItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func updateFooterSnapshot() {
        var snapshot = dataSource?.snapshot()
        snapshot?.reloadSections([.main])
        dataSource?.apply(snapshot ?? .init(), animatingDifferences: true)
    }
}

// MARK: - ViewModel Binding
private extension SongsViewController {
    func bindViewModel() {
        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                    self?.collectionView.isHidden = true
                } else {
                    self?.loadingView.stopAnimating()
                    self?.collectionView.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        // Bind songs updates
        viewModel.$songs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] songs in
                self?.updateSnapshot(with: songs)
            }
            .store(in: &cancellables)
        
        // Bind error state
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
        
        viewModel.$isExpanded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateFooterSnapshot()
            }
            .store(in: &cancellables)
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
