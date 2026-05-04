import UIKit

final class GenderOptionButton: UIView {
    private enum Constants {
        static let cardCornerRadius: CGFloat = 24
        static let shadowOpacity: Float = 0.08
        static let shadowRadius: CGFloat = 16
        static let shadowOffset = CGSize(width: 0, height: 10)
        static let selectedBorderWidth: CGFloat = 2
        static let unselectedBorderWidth: CGFloat = 1
        static let symbolContainerCornerRadius: CGFloat = 40
        static let symbolFontSize: CGFloat = 46
        static let titleFontSize: CGFloat = 19
        static let checkContainerCornerRadius: CGFloat = 16
        static let checkFontSize: CGFloat = 18
        static let unselectedIndicatorCornerRadius: CGFloat = 16
        static let unselectedIndicatorBorderWidth: CGFloat = 2
        static let symbolTopInset: CGFloat = 26
        static let symbolSize: CGFloat = 80
        static let horizontalInset: CGFloat = 12
        static let titleTopSpacing: CGFloat = 12
        static let indicatorSize: CGFloat = 32
        static let indicatorTopInset: CGFloat = 12
    }

    private let symbolLabel = UILabel()
    private let symbolContainer = UIView()
    private let optionTitleLabel = UILabel()
    private let checkMarkContainer = UIView()
    private let checkMarkLabel = UILabel()
    private let unselectedIndicatorView = UIView()

    private let symbolColor: UIColor
    private let symbolBackgroundColor: UIColor

    init(symbol: String, symbolColor: UIColor, symbolBackgroundColor: UIColor, title: String) {
        self.symbolColor = symbolColor
        self.symbolBackgroundColor = symbolBackgroundColor
        super.init(frame: .zero)

        symbolLabel.text = symbol
        optionTitleLabel.text = title

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isSelected: Bool = false {
        didSet {
            applySelectionState(isSelected)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cardCornerRadius).cgPath
    }

    private func applySelectionState(_ selected: Bool) {
        layer.borderColor = selected ? UIColor.appSelectedBorder.cgColor : UIColor.appUnselectedBorder.cgColor
        layer.borderWidth = selected ? Constants.selectedBorderWidth : Constants.unselectedBorderWidth

        checkMarkContainer.isHidden = !selected
        unselectedIndicatorView.isHidden = selected
    }

    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .appCardBackground
        layer.cornerRadius = Constants.cardCornerRadius
        layer.shadowColor = UIColor.appShadow.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = Constants.shadowOffset

        symbolContainer.translatesAutoresizingMaskIntoConstraints = false
        symbolContainer.backgroundColor = symbolBackgroundColor
        symbolContainer.layer.cornerRadius = Constants.symbolContainerCornerRadius

        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.font = .systemFont(ofSize: Constants.symbolFontSize, weight: .regular)
        symbolLabel.textColor = symbolColor
        symbolLabel.textAlignment = .center

        optionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        optionTitleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        optionTitleLabel.textAlignment = .center
        optionTitleLabel.textColor = .appTextPrimary

        checkMarkContainer.translatesAutoresizingMaskIntoConstraints = false
        checkMarkContainer.backgroundColor = .appFemaleSymbol
        checkMarkContainer.layer.cornerRadius = Constants.checkContainerCornerRadius

        checkMarkLabel.translatesAutoresizingMaskIntoConstraints = false
        checkMarkLabel.text = "✓"
        checkMarkLabel.font = .systemFont(ofSize: Constants.checkFontSize, weight: .bold)
        checkMarkLabel.textColor = .white
        checkMarkLabel.textAlignment = .center

        unselectedIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        unselectedIndicatorView.backgroundColor = .clear
        unselectedIndicatorView.layer.cornerRadius = Constants.unselectedIndicatorCornerRadius
        unselectedIndicatorView.layer.borderWidth = Constants.unselectedIndicatorBorderWidth
        unselectedIndicatorView.layer.borderColor = UIColor.appSubtleBorder.cgColor

        addSubview(symbolContainer)
        symbolContainer.addSubview(symbolLabel)
        addSubview(optionTitleLabel)
        addSubview(checkMarkContainer)
        checkMarkContainer.addSubview(checkMarkLabel)
        addSubview(unselectedIndicatorView)

        NSLayoutConstraint.activate([
            symbolContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            symbolContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.symbolTopInset),
            symbolContainer.widthAnchor.constraint(equalToConstant: Constants.symbolSize),
            symbolContainer.heightAnchor.constraint(equalToConstant: Constants.symbolSize),

            symbolLabel.centerXAnchor.constraint(equalTo: symbolContainer.centerXAnchor),
            symbolLabel.centerYAnchor.constraint(equalTo: symbolContainer.centerYAnchor),

            optionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            optionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            optionTitleLabel.topAnchor.constraint(equalTo: symbolContainer.bottomAnchor, constant: Constants.titleTopSpacing),

            checkMarkContainer.widthAnchor.constraint(equalToConstant: Constants.indicatorSize),
            checkMarkContainer.heightAnchor.constraint(equalToConstant: Constants.indicatorSize),
            checkMarkContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.indicatorTopInset),
            checkMarkContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),

            checkMarkLabel.centerXAnchor.constraint(equalTo: checkMarkContainer.centerXAnchor),
            checkMarkLabel.centerYAnchor.constraint(equalTo: checkMarkContainer.centerYAnchor),

            unselectedIndicatorView.widthAnchor.constraint(equalToConstant: Constants.indicatorSize),
            unselectedIndicatorView.heightAnchor.constraint(equalToConstant: Constants.indicatorSize),
            unselectedIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.indicatorTopInset),
            unselectedIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset)
        ])

        applySelectionState(false)
    }
}
