import UIKit

final class UnitSystemCard: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 18
        static let titleFontSize: CGFloat = 16
        static let labelsStackSpacing: CGFloat = 4
        static let labelsInset: CGFloat = 14
        static let labelsToToggleSpacing: CGFloat = 12
    }

    enum UnitSystem {
        case metric
        case imperial
    }

    var onUnitChanged: ((UnitSystem) -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let toggle = UISwitch()

    init(isMetric: Bool = true) {
        super.init(frame: .zero)
        toggle.isOn = isMetric
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var selectedUnit: UnitSystem {
        toggle.isOn ? .metric : .imperial
    }

    func setMetric(_ isMetric: Bool) {
        toggle.isOn = isMetric
    }

    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .appTranslucentCardBackground
        layer.cornerRadius = Constants.cornerRadius

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Localize.metricTitle.localized
        titleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        titleLabel.textColor = .appTextPrimary
        titleLabel.numberOfLines = 0

        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .appBrandMint
        toggle.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onUnitChanged?(self.selectedUnit)
        }, for: .valueChanged)

        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.axis = .vertical
        labelsStack.spacing = Constants.labelsStackSpacing

        addSubview(labelsStack)
        addSubview(toggle)

        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.labelsInset),
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelsInset),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.labelsInset),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -Constants.labelsToToggleSpacing),

            toggle.centerYAnchor.constraint(equalTo: centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.labelsInset)
        ])
    }
}
