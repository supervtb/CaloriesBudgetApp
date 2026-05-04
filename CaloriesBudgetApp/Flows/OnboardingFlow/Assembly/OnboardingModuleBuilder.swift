import UIKit

protocol OnboardingModuleBuilding {
    func build(
        stepType: OnboardingStepType,
        onboardingData: OnboardingData,
        onRoute: @escaping (OnboardingRoute) -> Void
    ) -> UIViewController
}

struct OnboardingModuleBuilder: OnboardingModuleBuilding {
    private let inputValidator: InputValidating
    private let healthImportService: HealthImporting

    init(inputValidator: InputValidating, healthImportService: HealthImporting) {
        self.inputValidator = inputValidator
        self.healthImportService = healthImportService
    }

    func build(
        stepType: OnboardingStepType,
        onboardingData: OnboardingData,
        onRoute: @escaping (OnboardingRoute) -> Void
    ) -> UIViewController {
        let viewModel = OnboardingViewModel(
            stepType: stepType,
            onboardingData: onboardingData,
            inputValidator: inputValidator,
            healthImportService: healthImportService
        )

        switch stepType {
        case .welcome:
            return WelcomeStepViewController(viewModel: viewModel, onRoute: onRoute)
        case .gender:
            return GenderStepViewController(viewModel: viewModel, onRoute: onRoute)
        case .healthImport:
            return HealthImportStepViewController(viewModel: viewModel, onRoute: onRoute)
        case .currentWeight:
            return CurrentWeightStepViewController(viewModel: viewModel, onRoute: onRoute)
        case .dateOfBirth:
            return DateOfBirthStepViewController(viewModel: viewModel, onRoute: onRoute)
        }
    }
}
