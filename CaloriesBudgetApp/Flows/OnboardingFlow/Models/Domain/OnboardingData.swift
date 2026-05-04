import Foundation

enum Gender {
    case male
    case female
}

struct OnboardingData {
    static let defaultHeightMeters: Double = 1.7

    var gender: Gender?
    var heightMeters: Double
    var currentWeightKg: Double?
    var dateOfBirth: Date?
    var useMetricSystem: Bool

    static func initial(locale: Locale = .current) -> OnboardingData {
        let languageCode = locale.language.languageCode?.identifier.lowercased()
        let regionCode = locale.region?.identifier.lowercased()
        let usesUSImperialDefaults = languageCode == "en" && regionCode == "us"
        let metricOnByDefault = !usesUSImperialDefaults

        return OnboardingData(
            gender: nil,
            heightMeters: defaultHeightMeters,
            currentWeightKg: nil,
            dateOfBirth: nil,
            useMetricSystem: metricOnByDefault
        )
    }
}
