//
//  LibraryViewController.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import UIKit

class LibraryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Library"
    }
}
