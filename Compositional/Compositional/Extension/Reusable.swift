import UIKit

public protocol Reusable {}

public extension Reusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}

public extension IndexPath {
    static var zero: IndexPath {
        return IndexPath(item: 0, section: 0)
    }
}

public extension UITableView {
    func register(_ nibName: String, reuseIdentifier: String = "") {
        var identifier = reuseIdentifier
        if identifier.isEmpty {
            identifier = nibName
        }
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterCell(reuseIdentifier: String) {
        self.register(UINib(nibName: reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
}

public extension UICollectionView {
    func register(_ nibName: String, reuseIdentifier: String = "") {
        var identifier = reuseIdentifier
        if identifier.isEmpty {
            identifier = nibName
        }
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func registerHeader(_ nibName: String, reuseIdentifier: String = "") {
        var identifier = reuseIdentifier
        if identifier.isEmpty {
            identifier = nibName
        }
        register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
}
