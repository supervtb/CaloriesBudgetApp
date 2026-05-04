import UIKit

final class HealthImportStepView: BaseOnboardingStepView {
    private enum Constants {
        static let stackSpacing: CGFloat = 20
        static let buttonsSpacing: CGFloat = 16
        static let horizontalInset: CGFloat = 24
        static let iPadImageSize: CGFloat = 160
        static let phoneImageSize: CGFloat = 120
        static let imageMinimumWidth: CGFloat = 120
        static let imageContainerSpacing: CGFloat = 30
    }

    private let titleLabel = OnboardingTextLabel(style: .title)
    private let subtitleLabel = OnboardingTextLabel(style: .subtitle)

    var onImportTapped: (() -> Void)?

    private lazy var importButton = OnboardingActionButton(title: Localize.healthImportButton.localized) { [weak self] in
        self?.onImportTapped?()
    }
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localize.commonSkip.localized, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.onRoute?(.healthImportSkipped)
        }, for: .touchUpInside)
        return button
    }()

    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupData(for stepType: OnboardingStepType, data: OnboardingData) {
        titleLabel.setupData(Localize.healthImportTitle.localized)
        subtitleLabel.setupData(Localize.healthImportSubtitle.localized)
    }

    func setLoading(_ loading: Bool) {
        importButton.isEnabled = !loading
        importButton.alpha = loading ? 0.5 : 1.0
        skipButton.isEnabled = !loading
        loading ? spinner.startAnimating() : spinner.stopAnimating()
    }

    override func configureUI() {
        super.configureUI()

        let stack = UIStackView(arrangedSubviews: [containerView(), titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        let buttonsStack = UIStackView(arrangedSubviews: [importButton, skipButton])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = Constants.buttonsSpacing
        buttonsStack.alignment = .fill
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsStack)
        addSubview(spinner)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: importButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: importButton.centerYAnchor)
        ] + actionButtonConstraints(for: buttonsStack))
    }

    private func containerView() -> UIView {
        let imageSize: CGFloat = traitCollection.userInterfaceIdiom == .pad ? Constants.iPadImageSize : Constants.phoneImageSize

        let imageView = UIImageView(image: UIImage(named: "healthIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.imageMinimumWidth),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])

        let view = UIStackView(arrangedSubviews: [imageView])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = Constants.imageContainerSpacing
        return view
    }
}
