import UIKit

protocol OnboardingStepIdentifying: AnyObject {
    var stepType: OnboardingStepType { get }
}

class BaseOnboardingStepViewController: UIViewController {
    let viewModel: OnboardingViewModel
    private let rootViewFactory: () -> OnboardingDisplaying
    let onRoute: (OnboardingRoute) -> Void
    var stepType: OnboardingStepType { viewModel.stepType }

    private var rootContentView: OnboardingDisplaying {
        guard let view = self.view as? OnboardingDisplaying else {
            assertionFailure("Expected OnboardingDisplaying view")
            return WelcomeStepView(frame: .zero)
        }
        return view
    }

    init(
        viewModel: OnboardingViewModel,
        rootViewFactory: @escaping () -> OnboardingDisplaying,
        onRoute: @escaping (OnboardingRoute) -> Void
    ) {
        self.viewModel = viewModel
        self.rootViewFactory = rootViewFactory
        self.onRoute = onRoute
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootViewFactory()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        applyStep()
    }

    func bindUI() {
        rootContentView.onRoute = { [weak self] route in
            guard let self else { return }

            switch route {
            case .nextStep:
                if !handleNextStep() {
                    onRoute(route)
                }
            default:
                onRoute(route)
            }
        }
    }

    func showAlert(title: String, message: String, onDismiss: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localize.commonContinue.localized, style: .default) { _ in
            onDismiss()
        })
        present(alert, animated: true)
    }

    private func applyStep() {
        rootContentView.inputValidator = viewModel.inputValidator
        rootContentView.setupData(for: viewModel.stepType, data: viewModel.onboardingData)
    }
    
    private func handleNextStep() -> Bool {
        switch viewModel.stepType {
        case .currentWeight:
            guard let currentWeightView = self.view as? CurrentWeightInputProviding else {
                return false
            }
            switch viewModel.resolveCurrentWeightRoute(
                weightText: currentWeightView.enteredWeightText,
                useMetricSystem: currentWeightView.useMetricSystem
            ) {
            case .success(let resolvedRoute):
                currentWeightView.hideWeightError()
                onRoute(resolvedRoute)
            case .failure(let error):
                currentWeightView.showWeightError(error.message)
            }
            return true
        case .dateOfBirth:
            guard let dateOfBirthView = self.view as? DateOfBirthInputProviding else {
                return false
            }
            switch viewModel.resolveDateOfBirthRoute(dateOfBirth: dateOfBirthView.selectedDateOfBirth) {
            case .success(let resolvedRoute):
                dateOfBirthView.hideDateOfBirthError()
                onRoute(resolvedRoute)
            case .failure(let error):
                dateOfBirthView.showDateOfBirthError(error.message)
            }
            return true
        default:
            return false
        }
    }
}

extension BaseOnboardingStepViewController: OnboardingStepIdentifying {}





