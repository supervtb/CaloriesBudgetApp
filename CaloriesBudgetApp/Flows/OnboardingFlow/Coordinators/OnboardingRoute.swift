import Foundation

enum OnboardingRoute {
    case welcome
    case genderSelected(Gender)
    case healthImportCompleted(weightKg: Double?, dateOfBirth: Date?, heightMeters: Double?)
    case healthImportSkipped
    case currentWeightEntered(weightKg: Double, useMetricSystem: Bool)
    case dateOfBirthEntered(Date)
    case nextStep
}
