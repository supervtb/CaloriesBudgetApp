import UIKit

final class WelcomeStepView: BaseOnboardingStepView {
    private enum Constants {
        static let stackSpacing: CGFloat = 16
        static let horizontalInset: CGFloat = 24
        static let logoSize: CGFloat = 146
    }

    private let logoImageView = UIImageView()
    private let titleLabel = OnboardingTextLabel(style: .title)
    private let subtitleLabel = OnboardingTextLabel(style: .subtitle)
    private lazy var actionButton = OnboardingActionButton(title: Localize.welcomeAction.localized) { [weak self] in
        self?.onRoute?(.nextStep)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupData(for stepType: OnboardingStepType, data: OnboardingData) {
        titleLabel.setupData(Localize.welcomeTitle.localized)
        subtitleLabel.setupData(Localize.welcomeSubtitle.localized)
    }

    override func configureUI() {
        super.configureUI()

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [logoImageView, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: stack.widthAnchor),
            subtitleLabel.widthAnchor.constraint(equalTo: stack.widthAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoSize)
        ] + actionButtonConstraints(for: actionButton))
    }

}
