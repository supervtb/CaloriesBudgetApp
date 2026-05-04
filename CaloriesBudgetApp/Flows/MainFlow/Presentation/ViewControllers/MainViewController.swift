import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private let rootViewFactory: () -> MainDisplaying
    private let onRestartTap: () -> Void

    private var rootContentView: MainDisplaying {
        guard let view = self.view as? MainDisplaying else {
            assertionFailure("Expected MainDisplaying view")
            return MainContentView(frame: .zero)
        }
        return view
    }

    init(
        viewModel: MainViewModel,
        rootViewFactory: @escaping () -> MainDisplaying = { MainContentView() },
        onRestartTap: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.rootViewFactory = rootViewFactory
        self.onRestartTap = onRestartTap
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
        applyViewModel()
    }

    private func bindUI() {
        rootContentView.onRestartTap = { [weak self] in
            self?.onRestartTap()
        }
    }

    private func applyViewModel() {
        rootContentView.setupData(title: viewModel.titleText, summary: viewModel.summaryText)
    }
}
