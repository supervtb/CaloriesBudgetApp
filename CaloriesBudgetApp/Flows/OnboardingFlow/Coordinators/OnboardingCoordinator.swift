import UIKit

final class OnboardingCoordinator: BaseCoordinator, RoutableCoordinator {
    typealias Route = OnboardingRoute

    private var onboardingData: OnboardingData
    private let moduleBuilder: OnboardingModuleBuilding

    private var currentStepType: OnboardingStepType = .welcome
    private let stepFlow: [OnboardingStepType] = OnboardingStepType.allCases

    var onFinished: ((OnboardingData) -> Void)?

    init(
        navigator: Navigator,
        onboardingData: OnboardingData = .initial(),
        moduleBuilder: OnboardingModuleBuilding
    ) {
        self.onboardingData = onboardingData
        self.moduleBuilder = moduleBuilder
        super.init(navigator: navigator)
    }

    override func start() {
        navigator.setDidShowHandler { [weak self] _ in
            self?.synchronizeWithNavigationStack()
        }
        trigger(.welcome)
    }

    func trigger(_ route: OnboardingRoute) {
        switch route {
        case .welcome:
            currentStepType = .welcome
            showStep(currentStepType, asRoot: true)
        case .genderSelected(let gender):
            handleGenderSelected(gender)
        case .healthImportCompleted(let weightKg, let dateOfBirth, let heightMeters):
            handleHealthImportCompleted(weightKg: weightKg, dateOfBirth: dateOfBirth, heightMeters: heightMeters)
        case .healthImportSkipped:
            handleHealthImportSkipped()
        case .currentWeightEntered(let weightKg, let useMetricSystem):
            handleCurrentWeightEntered(weightKg: weightKg, useMetricSystem: useMetricSystem)
        case .dateOfBirthEntered(let date):
            handleDateOfBirthEntered(date)
        case .nextStep:
            advanceToNextStep()
        }
    }

    private func handleGenderSelected(_ gender: Gender) {
        onboardingData.gender = gender
        trigger(.nextStep)
    }

    private func handleHealthImportCompleted(weightKg: Double?, dateOfBirth: Date?, heightMeters: Double?) {
        onboardingData.currentWeightKg = weightKg ?? onboardingData.currentWeightKg
        onboardingData.dateOfBirth = dateOfBirth ?? onboardingData.dateOfBirth
        onboardingData.heightMeters = heightMeters ?? onboardingData.heightMeters
        trigger(.nextStep)
    }

    private func handleHealthImportSkipped() {
        onboardingData.currentWeightKg = nil
        onboardingData.heightMeters = OnboardingData.defaultHeightMeters
        onboardingData.dateOfBirth = nil
        trigger(.nextStep)
    }

    private func handleCurrentWeightEntered(weightKg: Double, useMetricSystem: Bool) {
        onboardingData.currentWeightKg = weightKg
        onboardingData.useMetricSystem = useMetricSystem
        trigger(.nextStep)
    }

    private func handleDateOfBirthEntered(_ date: Date) {
        onboardingData.dateOfBirth = date
        trigger(.nextStep)
    }

    private func advanceToNextStep() {
        guard let nextStep = currentStepType.next(in: stepFlow) else {
            finish()
            return
        }
        currentStepType = nextStep
        showStep(nextStep, asRoot: false)
    }

    private func finish() {
        navigator.setDidShowHandler(nil)
        onFinished?(onboardingData)
    }

    private func showStep(_ stepType: OnboardingStepType, asRoot: Bool) {
        let viewController = moduleBuilder.build(
            stepType: stepType,
            onboardingData: onboardingData
        ) { [weak self] route in
            self?.trigger(route)
        }

        if asRoot {
            navigator.setRoot(viewController, animated: false)
        } else {
            navigator.push(viewController, animated: true)
        }
    }

    private func synchronizeWithNavigationStack() {
        guard let topViewController = navigator.topViewController else {
            currentStepType = .welcome
            return
        }

        if let stepController = topViewController as? OnboardingStepIdentifying {
            currentStepType = stepController.stepType
        }
    }
}
