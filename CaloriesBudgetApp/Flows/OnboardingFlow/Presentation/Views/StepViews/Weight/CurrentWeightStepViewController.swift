import UIKit

final class CurrentWeightStepViewController: BaseOnboardingStepViewController {
    init(viewModel: OnboardingViewModel, onRoute: @escaping (OnboardingRoute) -> Void) {
        super.init(viewModel: viewModel, rootViewFactory: { CurrentWeightStepView() }, onRoute: onRoute)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

