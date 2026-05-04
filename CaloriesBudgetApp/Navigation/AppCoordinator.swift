import UIKit

final class AppCoordinator: BaseCoordinator, RoutableCoordinator {
    typealias Route = AppRoute

    private let dependencies: AppDependencies

    private var onboardingCoordinator: OnboardingCoordinator?
    private var mainCoordinator: MainCoordinator?

    init(navigator: Navigator, dependencies: AppDependencies) {
        self.dependencies = dependencies
        super.init(navigator: navigator)
    }

    override func start() {
        trigger(.onboarding)
    }

    func trigger(_ route: AppRoute) {
        switch route {
        case .onboarding:
            showOnboardingFlow()
        case .main(let onboardingData):
            showMainFlow(onboardingData: onboardingData)
        }
    }

    private func showOnboardingFlow() {
        mainCoordinator = nil

        let onboardingCoordinator = OnboardingCoordinator(
            navigator: navigator,
            moduleBuilder: OnboardingModuleBuilder(
                inputValidator: dependencies.inputValidator,
                healthImportService: dependencies.healthImportService
            )
        )

        onboardingCoordinator.onFinished = { [weak self] onboardingData in
            guard let self else { return }
            self.onboardingCoordinator = nil
            self.trigger(.main(onboardingData: onboardingData))
        }

        self.onboardingCoordinator = onboardingCoordinator
        onboardingCoordinator.start()
    }

    private func showMainFlow(onboardingData: OnboardingData) {
        onboardingCoordinator = nil

        let mainCoordinator = MainCoordinator(
            navigator: navigator,
            onboardingData: onboardingData,
            summaryProvider: dependencies.summaryProvider,
            moduleBuilder: dependencies.mainModuleBuilding
        )
        mainCoordinator.onRestartRequested = { [weak self] in
            guard let self else { return }
            self.mainCoordinator = nil
            self.trigger(.onboarding)
        }

        self.mainCoordinator = mainCoordinator
        mainCoordinator.start()
    }
}
