import UIKit

protocol OnboardingDisplaying: UIView {
    var onRoute: ((OnboardingRoute) -> Void)? { get set }
    var inputValidator: InputValidating? { get set }
    func setupData(for stepType: OnboardingStepType, data: OnboardingData)
}

class BaseOnboardingStepView: UIView, OnboardingDisplaying {
    private enum Constants {
        static let actionButtonBottomInset: CGFloat = 56
        static let iPadButtonWidthMultiplier: CGFloat = 0.5
        static let iPadButtonHorizontalInset: CGFloat = 16
        static let phoneButtonHorizontalInset: CGFloat = 24
    }

    var onRoute: ((OnboardingRoute) -> Void)?
    var inputValidator: InputValidating?
    private let backgroundImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupData(for stepType: OnboardingStepType, data: OnboardingData) {
        assertionFailure("Subclasses must override setupData(for:data:)")
    }

    func actionButtonConstraints(for button: UIView) -> [NSLayoutConstraint] {
        var constraints = [
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.actionButtonBottomInset)
        ]

        if traitCollection.userInterfaceIdiom == .pad {
            constraints += [
                button.centerXAnchor.constraint(equalTo: centerXAnchor),
                button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.iPadButtonWidthMultiplier),
                button.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.iPadButtonHorizontalInset),
                button.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.iPadButtonHorizontalInset)
            ]
        } else {
            constraints += [
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.phoneButtonHorizontalInset),
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.phoneButtonHorizontalInset)
            ]
        }

        return constraints
    }

    func configureUI() {
        backgroundColor = .appBackground

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "bg")
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
