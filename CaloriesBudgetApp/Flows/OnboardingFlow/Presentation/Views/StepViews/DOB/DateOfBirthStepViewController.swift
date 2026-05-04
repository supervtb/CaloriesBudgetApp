import UIKit

final class DateOfBirthStepViewController: BaseOnboardingStepViewController {
    init(viewModel: OnboardingViewModel, onRoute: @escaping (OnboardingRoute) -> Void) {
        super.init(viewModel: viewModel, rootViewFactory: { DateOfBirthStepView() }, onRoute: onRoute)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
