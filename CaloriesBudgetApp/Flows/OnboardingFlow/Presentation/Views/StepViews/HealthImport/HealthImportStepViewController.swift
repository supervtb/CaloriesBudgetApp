import UIKit

final class HealthImportStepViewController: BaseOnboardingStepViewController {
    private var isAwaitingSettingsReturn = false
    private var didBecomeActiveObserver: NSObjectProtocol?
    private var activeTask: Task<Void, Never>?

    init(viewModel: OnboardingViewModel, onRoute: @escaping (OnboardingRoute) -> Void) {
        super.init(viewModel: viewModel, rootViewFactory: { HealthImportStepView() }, onRoute: onRoute)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindAppStateNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Keep spinner while transient system UI (e.g. Health permission prompt) is shown.
        // Reset only when this screen is actually being removed.
        if isMovingFromParent || isBeingDismissed {
            activeTask?.cancel()
            activeTask = nil
            (view as? HealthImportStepView)?.setLoading(false)
        }
    }

    @MainActor
    deinit {
        activeTask?.cancel()
        if let didBecomeActiveObserver {
            NotificationCenter.default.removeObserver(didBecomeActiveObserver)
        }
    }

    override func bindUI() {
        super.bindUI()

        guard let healthView = view as? HealthImportStepView else {
            return
        }
        healthView.onImportTapped = { [weak self] in
            self?.handleHealthImportSelection()
        }
    }

    private func handleHealthImportSelection() {
        let healthView = view as? HealthImportStepView
        healthView?.setLoading(true)

        activeTask?.cancel()
        activeTask = Task { [weak self] in
            guard let self else { return }
            let result = await viewModel.resolveHealthPermissionFlow()
            guard !Task.isCancelled else { return }
            await MainActor.run {
                guard !Task.isCancelled else { return }
                guard self.navigationController?.topViewController === self else { return }
                healthView?.setLoading(false)
                self.handleHealthFlowResult(result)
            }
        }
    }

    private func handleHealthFlowResult(_ result: OnboardingViewModel.HealthPermissionFlowResult) {
        switch result {
        case .proceedImport:
            performHealthImport()
        case .skipImport(let alert):
            showAlert(title: alert.title, message: alert.message) { [weak self] in
                self?.onRoute(.healthImportSkipped)
            }
        case .skipImportWithSettings(let alert):
            showDeniedHealthAlert(title: alert.title, message: alert.message) { [weak self] in
                self?.onRoute(.healthImportSkipped)
            }
        }
    }

    private func performHealthImport() {
        let healthView = view as? HealthImportStepView
        healthView?.setLoading(true)

        activeTask?.cancel()
        activeTask = Task { [weak self] in
            guard let self else { return }
            let route = await viewModel.resolveHealthImport()
            guard !Task.isCancelled else { return }
            await MainActor.run {
                guard !Task.isCancelled else { return }
                guard self.navigationController?.topViewController === self else { return }
                healthView?.setLoading(false)
                self.onRoute(route)
            }
        }
    }

    private func showDeniedHealthAlert(title: String, message: String, onSkip: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localize.commonOpenSettings.localized, style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsUrl) else {
                return
            }
            self.isAwaitingSettingsReturn = true
            UIApplication.shared.open(settingsUrl)
        })
        alert.addAction(UIAlertAction(title: Localize.commonSkip.localized, style: .cancel) { _ in
            onSkip()
        })
        present(alert, animated: true)
    }

    private func bindAppStateNotifications() {
        didBecomeActiveObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleDidBecomeActive()
        }
    }

    private func handleDidBecomeActive() {
        guard isAwaitingSettingsReturn else {
            return
        }
        isAwaitingSettingsReturn = false
        retryHealthImportAfterSettings()
    }

    private func retryHealthImportAfterSettings() {
        let healthView = view as? HealthImportStepView
        healthView?.setLoading(true)

        activeTask?.cancel()
        activeTask = Task { [weak self] in
            guard let self else { return }
            let result = await viewModel.resolveHealthPermissionFlow()
            guard !Task.isCancelled else { return }
            await MainActor.run {
                guard !Task.isCancelled else { return }
                guard self.navigationController?.topViewController === self else { return }
                healthView?.setLoading(false)
                self.handleHealthFlowResult(result)
            }
        }
    }
}
