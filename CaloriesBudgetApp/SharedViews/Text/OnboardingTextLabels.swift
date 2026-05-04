import UIKit

final class OnboardingTextLabel: UILabel {
    private enum Constants {
        static let titleFontSize: CGFloat = 42
        static let titleLineHeight: CGFloat = 48
        static let subtitleFontSize: CGFloat = 17
        static let subtitleLineHeight: CGFloat = 23
    }

    enum Style {
        case title
        case subtitle
    }

    private let style: Style

    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupData(_ text: String) {
        textAlignment = .center
        numberOfLines = 0

        switch style {
        case .title:
            attributedText = makeAttributedText(
                text,
                font: .systemFont(ofSize: Constants.titleFontSize, weight: .heavy),
                color: .appTitlePrimary,
                lineHeight: Constants.titleLineHeight
            )
        case .subtitle:
            attributedText = makeAttributedText(
                text,
                font: .systemFont(ofSize: Constants.subtitleFontSize, weight: .regular),
                color: .appTextSecondary,
                lineHeight: Constants.subtitleLineHeight
            )
        }
    }

    private func configureUI() {
        textAlignment = .center
        numberOfLines = 0
    }

    private func makeAttributedText(_ text: String, font: UIFont, color: UIColor, lineHeight: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        return NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]
        )
    }
}
