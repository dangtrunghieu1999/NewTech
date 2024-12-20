//
//  MainViewController.swift
//  Compositional
//
//  Created by Kai on 31/10/24.
//

import UIKit
import Combine
import SnapKit

class MainViewController: UIViewController {
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<MainViewModel.Section, MainItem>?
    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: MainCoordinator?
    
    private var lastContentOffset: CGFloat = 0
    
    // MARK: - UI Components
    private lazy var stretchyHeaderView: StretchyHeaderView = {
        let headerView = StretchyHeaderView()
        headerView.configure(with: UIImage(named: "artist2"))
        return headerView
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var segmentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.systemGray5.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        stackView.layer.addSublayer(borderLayer)
        
        return stackView
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: MainSegmentType.allCases.map { $0.title })
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .systemBlue.withAlphaComponent(0.1)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ], for: .normal)
        
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ], for: .selected)
        
        return control
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        
        configureCollectionView()
        configureDataSource()
        setupBindings()
        viewModel.fetchData(for: .music)
    }
}

// MARK: - Binding
private extension MainViewController {
    func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: Loadable<[MainViewModel.Section]>) {
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
    
    private func updateSnapshot(with sections: [MainViewModel.Section]) {
        var snapshot = NSDiffableDataSourceSnapshot<MainViewModel.Section, MainItem>()
        if !sections.isEmpty {
            snapshot.appendSections(sections)
            
            sections.forEach { section in
                switch section {
                case .music(let musicSection):
                    let items = musicSection.items.map { MainItem.music($0) }
                    snapshot.appendItems(items, toSection: section)
                case .library(let librarySection):
                    let items = librarySection.items.map { MainItem.library($0) }
                    snapshot.appendItems(items, toSection: section)
                }
            }
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

// MARK: - Setup
private extension MainViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(stretchyHeaderView)
        stretchyHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(segmentStackView)
        segmentStackView.addArrangedSubview(segmentControl)
        
        segmentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.edges.equalTo(segmentStackView)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stretchyHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(segmentStackView.snp.top)
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self = self else { return nil }
                switch item {
                case .music(let musicItem):
                    return self.configureMusicCell(collectionView, at: indexPath, item: musicItem)
                case .library(let libraryItem):
                    return self.configureLibraryCell(collectionView, at: indexPath, item: libraryItem)
                }
            }
        )
        
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self,
                  let snapshot = self.dataSource?.snapshot() else {
                return nil
            }
            if kind == UICollectionView.elementKindSectionHeader {
                let header: HeaderView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    for: indexPath)
                let section = snapshot.sectionIdentifiers[indexPath.section]
                header.configure(with: section.title)
                return header
            } else {
                let footer: SeeMoreFooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    for: indexPath
                )
                footer.configure(
                    isExpanded: self.viewModel.isExpanded(for: indexPath.section),
                    sectionIndex: indexPath.section
                )
                footer.delegate = self
                return footer
            }
        }
    }
    
    func configureCollectionView() {
        collectionView.registerReusableCell(MusicItemCell.self)
        collectionView.registerReusableCell(HorizontalMusicItemCell.self)
        collectionView.registerReusableCell(AlbumCollectionViewCell.self)
        collectionView.registerReusableCell(ArtistCollectionViewCell.self)
        
        collectionView.registerReusableSupplementaryView(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.registerReusableSupplementaryView(
            SeeMoreFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter
        )
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        guard let segmentType = MainSegmentType(rawValue: sender.selectedSegmentIndex) else { return }
        var snapshot = NSDiffableDataSourceSnapshot<MainViewModel.Section, MainItem>()
        snapshot.deleteAllItems()
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        // Update layout
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: true)
        
        // Fetch new data
        viewModel.fetchData(for: segmentType)
    }
}

// MARK: - Layout Helpers
private extension MainViewController {
    func createLayout() -> UICollectionViewLayout {
        let currentSegment = MainSegmentType(rawValue: segmentControl.selectedSegmentIndex) ?? .music
        let layoutProvider = MainLayoutFactory.createLayout(for: currentSegment)
        return layoutProvider.createLayout()
    }
}

// MARK: - Cell Configuration
private extension MainViewController {
    func configureMusicCell(
        _ collectionView: UICollectionView, 
        at indexPath: IndexPath, 
        item: MusicItem
    ) -> UICollectionViewCell? {
        if indexPath.section == 0 {
            let cell: MusicItemCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: item)
            return cell
        } else {
            let cell: HorizontalMusicItemCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: item)
            return cell
        }
    }
    
    func configureLibraryCell(
        _ collectionView: UICollectionView, 
        at indexPath: IndexPath, 
        item: LibraryItem
    ) -> UICollectionViewCell? {
        switch item {
        case .album(let album):
            let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(with: album)
            return cell
        case .artist(let artist):
            let cell: ArtistCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(with: artist)
            return cell
        }
    }
}

// MARK: - SeeMoreFooterViewDelegate
extension MainViewController: SeeMoreFooterViewDelegate {
    func seeMoreFooterViewDidSelect(_ footerView: SeeMoreFooterView) {
        viewModel.toggleExpand(for: footerView.sectionIndex)
    }
}

// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        stretchyHeaderView.updateHeader(withOffset: offset, scrollDirection: .none)
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        coordinator?.showDetail(sectionIndex: indexPath.section, itemIndex: indexPath.item)
    }
}
