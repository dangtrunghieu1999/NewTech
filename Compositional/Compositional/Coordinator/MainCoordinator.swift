
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMainViewController()
    }
    
    private func showMainViewController() {
        let viewController = MainViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetail(sectionIndex: Int, itemIndex: Int) {
        let detailViewController = DetailViewController(sectionIndex: sectionIndex, itemIndex: itemIndex)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
