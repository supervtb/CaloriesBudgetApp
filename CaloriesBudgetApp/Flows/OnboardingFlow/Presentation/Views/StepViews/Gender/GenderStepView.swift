import UIKit

final class GenderStepView: BaseOnboardingStepView {
    private enum Constants {
        static let cardsSpacing: CGFloat = 16
        static let stackSpacing: CGFloat = 20
        static let horizontalInset: CGFloat = 24
        static let topInset: CGFloat = 72
        static let cardHeight: CGFloat = 176
        static let contentToButtonSpacing: CGFloat = 24
        static let iPadContentWidthMultiplier: CGFloat = 0.5
    }

    private let titleLabel = OnboardingTextLabel(style: .title)
    private let subtitleLabel = OnboardingTextLabel(style: .subtitle)
    private let maleCard = GenderOptionButton(
        symbol: "♂",
        symbolColor: .appMaleSymbol,
        symbolBackgroundColor: .appMaleSymbolBackground,
        title: Localize.genderMale.localized
    )
    private let femaleCard = GenderOptionButton(
        symbol: "♀",
        symbolColor: .appFemaleSymbol,
        symbolBackgroundColor: .appFemaleSymbolBackground,
        title: Localize.genderFemale.localized
    )

    private lazy var actionButton = OnboardingActionButton(title: Localize.commonContinue.localized) { [weak self] in
        guard let self, let selectedGender = self.selectedGender else { return }
        self.onRoute?(.genderSelected(selectedGender))
    }
    private var selectedGender: Gender?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        updateSelection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupData(for stepType: OnboardingStepType, data: OnboardingData) {
        titleLabel.setupData(Localize.genderTitle.localized)
        subtitleLabel.setupData(Localize.genderSubtitle.localized)
        selectedGender = data.gender
        updateSelection()
    }

    override func configureUI() {
        super.configureUI()

        let cardsStack = UIStackView(arrangedSubviews: [maleCard, femaleCard])
        cardsStack.axis = .horizontal
        cardsStack.spacing = Constants.cardsSpacing
        cardsStack.alignment = .fill
        cardsStack.distribution = .fillEqually

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, cardsStack])
        textStack.axis = .vertical
        textStack.spacing = Constants.stackSpacing
        textStack.alignment = .fill
        textStack.translatesAutoresizingMaskIntoConstraints = false
        cardsStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textStack)
        addSubview(actionButton)

        let maleTap = UITapGestureRecognizer(target: self, action: #selector(didTapMale))
        maleCard.addGestureRecognizer(maleTap)
        maleCard.isUserInteractionEnabled = true

        let femaleTap = UITapGestureRecognizer(target: self, action: #selector(didTapFemale))
        femaleCard.addGestureRecognizer(femaleTap)
        femaleCard.isUserInteractionEnabled = true

        var textConstraints: [NSLayoutConstraint] = [
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: actionButton.topAnchor, constant: -Constants.contentToButtonSpacing)
        ]

        if traitCollection.userInterfaceIdiom == .pad {
            textConstraints += [
                textStack.centerXAnchor.constraint(equalTo: centerXAnchor),
                textStack.centerYAnchor.constraint(equalTo: centerYAnchor),
                textStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: Constants.iPadContentWidthMultiplier),
                textStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.horizontalInset),
                textStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.horizontalInset),
                textStack.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topInset)
            ]
        } else {
            textConstraints += [
                textStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
                textStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
                textStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topInset)
            ]
        }

        NSLayoutConstraint.activate(textConstraints + [
            maleCard.heightAnchor.constraint(equalToConstant: Constants.cardHeight),
            femaleCard.heightAnchor.constraint(equalToConstant: Constants.cardHeight)
        ] + actionButtonConstraints(for: actionButton))
    }

    @objc private func didTapMale() {
        selectedGender = .male
        updateSelection()
    }

    @objc private func didTapFemale() {
        selectedGender = .female
        updateSelection()
    }

    private func updateSelection() {
        maleCard.isSelected = selectedGender == .male
        femaleCard.isSelected = selectedGender == .female
        updateContinueButtonState()
    }

    private func updateContinueButtonState() {
        let hasSelection = selectedGender != nil
        actionButton.isEnabled = hasSelection
        actionButton.alpha = hasSelection ? 1.0 : 0.5
    }
}
