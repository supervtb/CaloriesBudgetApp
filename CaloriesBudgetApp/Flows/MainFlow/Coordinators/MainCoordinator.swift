import UIKit

final class MainCoordinator: BaseCoordinator, RoutableCoordinator {
    typealias Route = MainRoute

    private let onboardingData: OnboardingData
    private let summaryProvider: SummaryProviding
    private let moduleBuilder: MainModuleBuilding

    var onRestartRequested: (() -> Void)?

    init(
        navigator: Navigator,
        onboardingData: OnboardingData,
        summaryProvider: SummaryProviding,
        moduleBuilder: MainModuleBuilding
    ) {
        self.onboardingData = onboardingData
        self.summaryProvider = summaryProvider
        self.moduleBuilder = moduleBuilder
        super.init(navigator: navigator)
    }

    override func start() {
        trigger(.dailyBudget)
    }

    func trigger(_ route: MainRoute) {
        switch route {
        case .dailyBudget:
            showDailyBudget()
        case .restart:
            onRestartRequested?()
        }
    }

    private func showDailyBudget() {
        let viewController = moduleBuilder.build(
            onboardingData: onboardingData,
            summaryProvider: summaryProvider
        ) { [weak self] in
            self?.trigger(.restart)
        }
        navigator.setRoot(viewController, animated: true)
    }
}
