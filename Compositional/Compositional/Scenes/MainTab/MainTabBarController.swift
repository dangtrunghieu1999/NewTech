//
//  MainTabBarController.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
    }
    
    private func setupViewControllers() {
        let musicVC = MusicViewController()
        musicVC.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(systemName: "music.note"),
            selectedImage: UIImage(systemName: "music.note.fill")
        )
        
        let libraryVC = LibraryViewController()
        libraryVC.tabBarItem = UITabBarItem(
            title: "Library",
            image: UIImage(systemName: "books.vertical"),
            selectedImage: UIImage(systemName: "books.vertical.fill")
        )
        
        // Wrap each VC in a navigation controller
        let musicNav = UINavigationController(rootViewController: musicVC)
        let libraryNav = UINavigationController(rootViewController: libraryVC)
        
        viewControllers = [musicNav, libraryNav]
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }
}
