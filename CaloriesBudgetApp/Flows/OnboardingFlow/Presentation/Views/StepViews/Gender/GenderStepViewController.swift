import UIKit

final class GenderStepViewController: BaseOnboardingStepViewController {
    init(viewModel: OnboardingViewModel, onRoute: @escaping (OnboardingRoute) -> Void) {
        super.init(viewModel: viewModel, rootViewFactory: { GenderStepView() }, onRoute: onRoute)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
