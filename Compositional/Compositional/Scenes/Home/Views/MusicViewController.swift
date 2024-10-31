//
//  MusicViewController.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit
import Combine

class MusicViewController: UIViewController {
    // MARK: - Components
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<MusicSection, MusicItem>?
    private let viewModel = MusicViewModel()
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
private extension MusicViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Music"
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
private extension MusicViewController {
    func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: Loadable<[MusicSection]>) {
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
    
    private func updateLoadingState(_ isLoading: Bool) {
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
    
    private func updateSnapshot(with sections: [MusicSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<MusicSection, MusicItem>()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func showError(_ error: Error) {
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
extension MusicViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(MusicItemCell.reuseIdentifier)
        collectionView.register(HorizontalMusicItemCell.reuseIdentifier)
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
            if sectionIndex == 0 {
                return self.createVerticalSection()
            } else {
                return self.createHorizontalSection()
            }
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
        
        // Footer
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

// MARK:- Data source
extension MusicViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MusicSection, MusicItem>(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let snapshot = self?.dataSource?.snapshot() else {
                return UICollectionViewCell()
            }
            let section = snapshot.sectionIdentifiers[indexPath.section]
            
            switch section.type {
            case .vertical:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MusicItemCell.reuseIdentifier,
                    for: indexPath
                ) as? MusicItemCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: item)
                return cell
                
            case .horizontal:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HorizontalMusicItemCell.reuseIdentifier,
                    for: indexPath
                ) as? HorizontalMusicItemCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: item)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderView.reuseIdentifier,
                    for: indexPath
                ) as? HeaderView else {
                    return UICollectionReusableView()
                }
                guard let snapshot = self?.dataSource?.snapshot() else {
                    return UICollectionReusableView()
                }
                
                let section = snapshot.sectionIdentifiers[indexPath.section]
                header.configure(with: section.title)
                return header
                
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SeeMoreFooterView.reuseIdentifier,
                    for: indexPath
                ) as? SeeMoreFooterView, let self = self else {
                    return UICollectionReusableView()
                }
                footer.configure(
                    isExpanded: self.viewModel.isExpanded(for: indexPath.section),
                    sectionIndex: indexPath.section
                )
                footer.delegate = self
                return footer
                
            default:
                return nil
            }
        }
    }
}

extension MusicViewController: SeeMoreFooterViewDelegate {
    func seeMoreFooterViewDidSelect(_ footerView: SeeMoreFooterView) {
        viewModel.toggleExpand(for: footerView.sectionIndex)
    }
}
