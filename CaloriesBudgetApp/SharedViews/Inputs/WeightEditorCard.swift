import UIKit

final class WeightEditorCard: UIView, UITextFieldDelegate {
    private enum Constants {
        static let cardCornerRadius: CGFloat = 22
        static let cardShadowOpacity: Float = 0.08
        static let cardShadowRadius: CGFloat = 14
        static let cardShadowOffset = CGSize(width: 0, height: 8)
        static let unitFontSize: CGFloat = 24
        static let weightFontSize: CGFloat = 44
        static let rowSpacing: CGFloat = 10
        static let cardHeight: CGFloat = 130
        static let horizontalInset: CGFloat = 16
    }

    private let weightTextField = UITextField()
    private let unitLabel = UILabel()

    var inputValidator: InputValidating?

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var weightText: String? {
        get { weightTextField.text }
        set { weightTextField.text = newValue }
    }

    func setUnitText(_ text: String) {
        unitLabel.text = text
    }

    func setPlaceholder(_ placeholder: String) {
        weightTextField.placeholder = placeholder
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cardCornerRadius).cgPath
    }

    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .appCardBackground
        layer.cornerRadius = Constants.cardCornerRadius
        layer.shadowColor = UIColor.appShadow.cgColor
        layer.shadowOpacity = Constants.cardShadowOpacity
        layer.shadowRadius = Constants.cardShadowRadius
        layer.shadowOffset = Constants.cardShadowOffset

        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.textColor = .appTextSecondary
        unitLabel.font = .systemFont(ofSize: Constants.unitFontSize, weight: .semibold)

        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.textColor = .appTextPrimary
        weightTextField.font = .systemFont(ofSize: Constants.weightFontSize, weight: .heavy)
        weightTextField.textAlignment = .center
        weightTextField.borderStyle = .none
        weightTextField.keyboardType = .decimalPad
        weightTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        weightTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        weightTextField.delegate = self
        
        unitLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        unitLabel.setContentHuggingPriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [weightTextField, unitLabel])
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.spacing = Constants.rowSpacing
        row.alignment = .center

        addSubview(row)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Constants.cardHeight),
            row.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: Constants.horizontalInset),
            row.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -Constants.horizontalInset),
            row.centerXAnchor.constraint(equalTo: centerXAnchor),
            row.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func focusInputField() {
        weightTextField.becomeFirstResponder()
    }

    // MARK: - UITextFieldDelegate

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        inputValidator?.shouldAllowChange(currentText: textField.text, range: range, replacementString: string) ?? true
    }
}
