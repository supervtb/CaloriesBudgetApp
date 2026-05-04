import UIKit

final class WeightHintCard: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 18
        static let titleFontSize: CGFloat = 16
        static let subtitleFontSize: CGFloat = 14
        static let stackSpacing: CGFloat = 6
        static let contentInset: CGFloat = 14
    }

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .appHintCardBackground
        layer.cornerRadius = Constants.cornerRadius

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        titleLabel.textColor = .appTextPrimary

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: Constants.subtitleFontSize, weight: .regular)
        subtitleLabel.textColor = .appTextSecondary
        subtitleLabel.numberOfLines = 0

        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.axis = .vertical
        labelsStack.spacing = Constants.stackSpacing

        addSubview(labelsStack)

        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInset),
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInset),
            labelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInset),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInset)
        ])
    }
}
