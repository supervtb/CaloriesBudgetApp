import UIKit

protocol MainModuleBuilding {
    func build(
        onboardingData: OnboardingData,
        summaryProvider: SummaryProviding,
        onRestartTap: @escaping () -> Void
    ) -> UIViewController
}

struct MainModuleBuilder: MainModuleBuilding {
    func build(
        onboardingData: OnboardingData,
        summaryProvider: SummaryProviding,
        onRestartTap: @escaping () -> Void
    ) -> UIViewController {
        let viewModel = MainViewModel(
            onboardingData: onboardingData,
            summaryProvider: summaryProvider
        )
        return MainViewController(viewModel: viewModel, onRestartTap: onRestartTap)
    }
}
