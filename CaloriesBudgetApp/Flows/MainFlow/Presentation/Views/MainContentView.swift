import UIKit

protocol MainDisplaying: UIView {
    var onRestartTap: (() -> Void)? { get set }
    func setupData(title: String, summary: String)
}

final class MainContentView: UIView, MainDisplaying {
    private enum Constants {
        static let stackSpacing: CGFloat = 20
        static let cardSpacing: CGFloat = 12
        static let cardInset: CGFloat = 20
        static let horizontalInset: CGFloat = 24
        static let iPadContentWidthMultiplier: CGFloat = 0.5
        static let cardCornerRadius: CGFloat = 22
        static let cardShadowOpacity: Float = 0.08
        static let cardShadowRadius: CGFloat = 14
        static let cardShadowOffset = CGSize(width: 0, height: 8)
    }

    var onRestartTap: (() -> Void)?

    private let backgroundImageView = UIImageView()
    private let titleLabel = OnboardingTextLabel(style: .title)
    private let summaryLabel = OnboardingTextLabel(style: .subtitle)
    private let cardView = UIView()
    private let contentStack = UIStackView()
    private lazy var restartButton = OnboardingActionButton(title: Localize.mainRestart.localized) { [weak self] in
        self?.onRestartTap?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupData(title: String, summary: String) {
        titleLabel.setupData(title)
        summaryLabel.setupData(summary)
    }

    private func configureUI() {
        backgroundColor = .appBackground
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "bg")
        backgroundImageView.contentMode = .scaleAspectFill

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .appCardBackground
        cardView.layer.cornerRadius = Constants.cardCornerRadius
        cardView.layer.shadowColor = UIColor.appShadow.cgColor
        cardView.layer.shadowOpacity = Constants.cardShadowOpacity
        cardView.layer.shadowRadius = Constants.cardShadowRadius
        cardView.layer.shadowOffset = Constants.cardShadowOffset

        let cardStack = UIStackView(arrangedSubviews: [titleLabel, summaryLabel])
        cardStack.axis = .vertical
        cardStack.alignment = .fill
        cardStack.spacing = Constants.cardSpacing
        cardStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(cardStack)

        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.spacing = Constants.stackSpacing
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(cardView)
        contentStack.addArrangedSubview(restartButton)

        addSubview(backgroundImageView)
        addSubview(contentStack)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.horizontalInset),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.horizontalInset),
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            cardStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.cardInset),
            cardStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.cardInset),
            cardStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.cardInset),
            cardStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Constants.cardInset),
        ])
        
        if traitCollection.userInterfaceIdiom == .pad {
            contentStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: Constants.iPadContentWidthMultiplier).isActive = true
        }
    }

}
