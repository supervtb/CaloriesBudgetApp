import UIKit

protocol DateOfBirthInputProviding: AnyObject {
    var selectedDateOfBirth: Date { get }
    func showDateOfBirthError(_ message: String)
    func hideDateOfBirthError()
}

final class DateOfBirthStepView: BaseOnboardingStepView {
    private enum Constants {
        static let maxPickerWidth: CGFloat = 360
        static let phonePickerHorizontalInset: CGFloat = 8
        static let errorFontSize: CGFloat = 13
        static let stackSpacing: CGFloat = 20
        static let horizontalInset: CGFloat = 24
        static let defaultAgeYears: Int = 25
    }

    private let titleLabel = OnboardingTextLabel(style: .title)
    private let subtitleLabel = OnboardingTextLabel(style: .subtitle)
    private let datePickerContainer = UIView()
    private let datePicker = UIDatePicker()
    private let errorLabel = UILabel()
    private lazy var actionButton = OnboardingActionButton(title: Localize.commonNext.localized) { [weak self] in
        self?.hideDateOfBirthError()
        self?.onRoute?(.nextStep)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupData(for stepType: OnboardingStepType, data: OnboardingData) {
        titleLabel.setupData(Localize.dobTitle.localized)
        subtitleLabel.setupData(Localize.dobSubtitle.localized)
        datePicker.maximumDate = inputValidator?.maximumDateOfBirth() ?? Date()
        datePicker.date = data.dateOfBirth ?? defaultDateOfBirth()
        hideDateOfBirthError()
    }

    override func configureUI() {
        super.configureUI()
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        datePickerContainer.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainer.addSubview(datePicker)

        let iPad = traitCollection.userInterfaceIdiom == .pad
        let pickerHorizontalInset: CGFloat = iPad ? 0 : Constants.phonePickerHorizontalInset

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            datePicker.centerXAnchor.constraint(equalTo: datePickerContainer.centerXAnchor),
            datePicker.leadingAnchor.constraint(greaterThanOrEqualTo: datePickerContainer.leadingAnchor, constant: pickerHorizontalInset),
            datePicker.trailingAnchor.constraint(lessThanOrEqualTo: datePickerContainer.trailingAnchor, constant: -pickerHorizontalInset),
            datePicker.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.maxPickerWidth)
        ])

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .appError
        errorLabel.font = .systemFont(ofSize: Constants.errorFontSize, weight: .regular)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, datePickerContainer, errorLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ] + actionButtonConstraints(for: actionButton))
    }

    private func defaultDateOfBirth() -> Date {
        Calendar.current.date(byAdding: .year, value: -Constants.defaultAgeYears, to: Date()) ?? Date()
    }
    
}

extension DateOfBirthStepView: DateOfBirthInputProviding {
    var selectedDateOfBirth: Date { datePicker.date }
    
    func showDateOfBirthError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func hideDateOfBirthError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
}
