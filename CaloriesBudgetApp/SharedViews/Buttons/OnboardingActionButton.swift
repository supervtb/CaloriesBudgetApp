import UIKit

final class OnboardingActionButton: UIButton {
    private enum Constants {
        static let cornerRadius: CGFloat = 18
        static let titleFontSize: CGFloat = 17
        static let contentInsetVertical: CGFloat = 18
        static let gradientStartPoint = CGPoint(x: 0, y: 0.5)
        static let gradientEndPoint = CGPoint(x: 1, y: 0.5)
        static let shadowOpacity: Float = 0.16
        static let shadowRadius: CGFloat = 18
        static let shadowOffset = CGSize(width: 0, height: 10)
        static let titleLineHeight: CGFloat = 21
    }

    private var tapAction: (() -> Void)?
    private let gradientLayer = CAGradientLayer()

    init(title: String, action: (() -> Void)? = nil) {
        self.tapAction = action
        super.init(frame: .zero)
        configureUI()
        applyTitleStyle(title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Constants.cornerRadius

        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        titleLabel?.textAlignment = .center
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center

        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: Constants.contentInsetVertical, leading: 0, bottom: Constants.contentInsetVertical, trailing: 0)
        configuration = config

        gradientLayer.colors = [
            UIColor.appBrandMint.cgColor,
            UIColor.appBrandPurple.cgColor
        ]
        gradientLayer.startPoint = Constants.gradientStartPoint
        gradientLayer.endPoint = Constants.gradientEndPoint
        gradientLayer.cornerRadius = Constants.cornerRadius
        gradientLayer.masksToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)

        layer.shadowColor = UIColor.appShadow.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = Constants.shadowOffset

        addAction(UIAction { [weak self] _ in
            self?.tapAction?()
        }, for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = Constants.cornerRadius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cornerRadius).cgPath
    }

    private func applyTitleStyle(_ title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = Constants.titleLineHeight
        paragraphStyle.maximumLineHeight = Constants.titleLineHeight

        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .semibold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )

        setAttributedTitle(attributedTitle, for: .normal)
    }
}
