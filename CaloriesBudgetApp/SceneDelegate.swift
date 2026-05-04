import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let navigationController = UINavigationController()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let dependencies = AppDependencies.live
        let navigator = NavigationControllerNavigator(navigationController: navigationController)
        let appCoordinator = AppCoordinator(
            navigator: navigator,
            dependencies: dependencies
        )

        self.appCoordinator = appCoordinator
        self.window = window

        appCoordinator.start()
    }
}
