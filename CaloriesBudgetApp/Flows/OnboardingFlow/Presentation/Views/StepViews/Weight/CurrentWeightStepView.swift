import UIKit


protocol CurrentWeightInputProviding: AnyObject {
    var enteredWeightText: String? { get }
    var useMetricSystem: Bool { get }
    func showWeightError(_ message: String)
    func hideWeightError()
}

final class CurrentWeightStepView: BaseOnboardingStepView, UIGestureRecognizerDelegate {
    private enum Constants {
        static let kgToLbDivider: Double = 0.45359237
        static let errorFontSize: CGFloat = 13
        static let buttonBottomSpacing: CGFloat = 16
        static let contentTopInset: CGFloat = 24
        static let contentBottomInsetExtra: CGFloat = 20
        static let contentStackSpacing: CGFloat = 20
        static let contentHorizontalInset: CGFloat = 24
        static let iPadWidthMultiplier: CGFloat = 0.5
        static let weightFormat = "%.1f"
    }

    private let titleLabel = OnboardingTextLabel(style: .title)
    private let subtitleLabel = OnboardingTextLabel(style: .subtitle)
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let unitSystemCard = UnitSystemCard()
    private let weightEditorCard = WeightEditorCard()
    private let weightErrorLabel = UILabel()
    private let weightHintCard = WeightHintCard(
        title: Localize.weightHintTitle.localized,
        subtitle: Localize.weightHintSubtitle.localized
    )

    private var iPadWidthConstraint: NSLayoutConstraint?

    private lazy var actionButton = OnboardingActionButton(title: Localize.commonNext.localized) { [weak self] in
        guard let self else { return }
        self.endEditing(true)
        hideWeightError()
        self.onRoute?(.nextStep)
    }

    override var inputValidator: InputValidating? {
        didSet { weightEditorCard.inputValidator = inputValidator }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupData(for stepType: OnboardingStepType, data: OnboardingData) {
        titleLabel.setupData(Localize.weightTitle.localized)
        subtitleLabel.setupData(Localize.weightSubtitle.localized)
        unitSystemCard.setMetric(data.useMetricSystem)
        let isMetric = data.useMetricSystem
        weightEditorCard.setUnitText(isMetric ? Localize.unitKg.localized : Localize.unitLb.localized)

        if let savedWeightKg = data.currentWeightKg {
            let displayWeight = isMetric ? savedWeightKg : (savedWeightKg / Constants.kgToLbDivider)
            weightEditorCard.weightText = formatWeight(displayWeight)
        }

        hideWeightError()
    }

    override func configureUI() {
        super.configureUI()
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        dismissKeyboardTap.cancelsTouchesInView = false
        dismissKeyboardTap.delegate = self
        addGestureRecognizer(dismissKeyboardTap)

        unitSystemCard.onUnitChanged = { [weak self] unit in
            guard let self else { return }
            convertDisplayedWeightIfPossible(to: unit)
            let unitText = unit == .metric ? Localize.unitKg.localized : Localize.unitLb.localized
            weightEditorCard.setUnitText(unitText)
        }
        weightEditorCard.setUnitText(Localize.unitKg.localized)
        weightErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        weightErrorLabel.textColor = .appError
        weightErrorLabel.font = .systemFont(ofSize: Constants.errorFontSize, weight: .regular)
        weightErrorLabel.numberOfLines = 0
        weightErrorLabel.isHidden = true

        configureScrollContent()
        addSubview(scrollView)
        addSubview(actionButton)

        let buttonConstraints = actionButtonConstraints(for: actionButton)
        buttonConstraints.first?.priority = .defaultHigh

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            actionButton.bottomAnchor.constraint(lessThanOrEqualTo: keyboardLayoutGuide.topAnchor, constant: -Constants.buttonBottomSpacing)
        ] + buttonConstraints)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomOverlap = bounds.maxY - actionButton.frame.minY + Constants.contentBottomInsetExtra
        let bottomPadding = max(bottomOverlap, 0)
        scrollView.contentInset = UIEdgeInsets(
            top: safeAreaInsets.top + Constants.contentTopInset,
            left: 0,
            bottom: bottomPadding,
            right: 0
        )
        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(
            top: safeAreaInsets.top,
            left: 0,
            bottom: bottomPadding,
            right: 0
        )
    }

    private func configureScrollContent() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInsetAdjustmentBehavior = .never

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        contentStack.axis = .vertical
        contentStack.spacing = Constants.contentStackSpacing
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, subtitleLabel, unitSystemCard, weightEditorCard, weightErrorLabel, weightHintCard].forEach { contentStack.addArrangedSubview($0) }

        contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Constants.contentHorizontalInset),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.contentHorizontalInset),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        iPadWidthConstraint = contentStack.widthAnchor.constraint(
            equalTo: scrollView.frameLayoutGuide.widthAnchor,
            multiplier: Constants.iPadWidthMultiplier
        )
        iPadWidthConstraint?.isActive = traitCollection.userInterfaceIdiom == .pad
    }

    @objc private func didTapOutside() {
        endEditing(true)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var currentView: UIView? = touch.view
        while let view = currentView {
            if view is WeightEditorCard {
                weightEditorCard.focusInputField()
                return false
            }
            if view is UIControl {
                return false
            }
            currentView = view.superview
        }
        return true
    }

    private func formatWeight(_ weight: Double) -> String {
        String(format: Constants.weightFormat, weight)
    }

    private func convertDisplayedWeightIfPossible(to unit: UnitSystemCard.UnitSystem) {
        let currentText = (weightEditorCard.weightText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !currentText.isEmpty else { return }

        let normalized = currentText.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized) else { return }

        let convertedValue: Double
        switch unit {
        case .metric:
            convertedValue = value * Constants.kgToLbDivider
        case .imperial:
            convertedValue = value / Constants.kgToLbDivider
        }
        weightEditorCard.weightText = formatWeight(convertedValue)
    }
}

extension CurrentWeightStepView: CurrentWeightInputProviding {
    var enteredWeightText: String? { weightEditorCard.weightText }

    var useMetricSystem: Bool { unitSystemCard.selectedUnit == .metric }

    func showWeightError(_ message: String) {
        weightErrorLabel.text = message
        weightErrorLabel.isHidden = false
    }

    func hideWeightError() {
        weightErrorLabel.text = nil
        weightErrorLabel.isHidden = true
    }
}
