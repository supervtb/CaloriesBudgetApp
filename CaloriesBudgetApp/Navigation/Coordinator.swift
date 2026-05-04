import UIKit

protocol Coordinator: AnyObject {
    func start()
}

protocol RoutableCoordinator: Coordinator {
    associatedtype Route
    func trigger(_ route: Route)
}

protocol Navigator {
    var topViewController: UIViewController? { get }
    
    func setRoot(_ viewController: UIViewController, animated: Bool)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func setDidShowHandler(_ handler: ((UIViewController) -> Void)?)
}

final class NavigationControllerNavigator: NSObject, Navigator {
    private let navigationController: UINavigationController
    private var didShowHandler: ((UIViewController) -> Void)?

    var topViewController: UIViewController? {
        navigationController.topViewController
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    func setRoot(_ viewController: UIViewController, animated: Bool) {
        navigationController.setViewControllers([viewController], animated: animated)
    }

    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func setDidShowHandler(_ handler: ((UIViewController) -> Void)?) {
        didShowHandler = handler
    }
}

extension NavigationControllerNavigator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        didShowHandler?(viewController)
    }
}

class BaseCoordinator: Coordinator {
    let navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func start() {
        /// Subclasses override.
    }
}
