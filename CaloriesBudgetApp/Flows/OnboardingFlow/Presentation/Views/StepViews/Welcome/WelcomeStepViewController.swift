import UIKit

final class WelcomeStepViewController: BaseOnboardingStepViewController {
    init(viewModel: OnboardingViewModel, onRoute: @escaping (OnboardingRoute) -> Void) {
        super.init(viewModel: viewModel, rootViewFactory: { WelcomeStepView() }, onRoute: onRoute)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
