import Foundation

@MainActor
final class OnboardingViewModel {
    private enum Constants {
        static let minPositiveWeight: Double = 0
        static let kgPerLb: Double = 0.45359237
        static let defaultAgeYears: Int = 0
        static let minimumAllowedAgeYears: Int = 13
    }

    struct AlertPayload {
        let title: String
        let message: String
    }

    enum InlineValidationError {
        case weightEmpty
        case weightInvalid
        case weightOutOfRange
        case dateOfBirthUnderMinimumAge

        var message: String {
            switch self {
            case .weightEmpty:
                return Localize.weightErrorEmpty.localized
            case .weightInvalid:
                return Localize.weightErrorInvalid.localized
            case .weightOutOfRange:
                return Localize.weightErrorRange.localized
            case .dateOfBirthUnderMinimumAge:
                return Localize.dobErrorUnder13.localized
            }
        }
    }

    enum CurrentWeightValidationResult {
        case success(OnboardingRoute)
        case failure(InlineValidationError)
    }
    
    enum DateOfBirthValidationResult {
        case success(OnboardingRoute)
        case failure(InlineValidationError)
    }

    enum HealthPermissionFlowResult {
        case proceedImport
        case skipImport(alert: AlertPayload)
        case skipImportWithSettings(alert: AlertPayload)
    }

    let stepType: OnboardingStepType
    let onboardingData: OnboardingData
    let inputValidator: InputValidating
    private let healthImportService: HealthImporting

    init(
        stepType: OnboardingStepType,
        onboardingData: OnboardingData,
        inputValidator: InputValidating,
        healthImportService: HealthImporting
    ) {
        self.stepType = stepType
        self.onboardingData = onboardingData
        self.inputValidator = inputValidator
        self.healthImportService = healthImportService
    }

    func resolveCurrentWeightRoute(weightText: String?, useMetricSystem: Bool) -> CurrentWeightValidationResult {
        let trimmedText = weightText?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmedText.isEmpty else {
            return .failure(.weightEmpty)
        }

        let normalizedText = trimmedText.replacingOccurrences(of: ",", with: ".")
        guard let enteredWeight = Double(normalizedText), enteredWeight > Constants.minPositiveWeight else {
            return .failure(.weightInvalid)
        }
        if !inputValidator.isValidWeightValue(enteredWeight) {
            return .failure(.weightOutOfRange)
        }

        let weightKg = useMetricSystem ? enteredWeight : enteredWeight * Constants.kgPerLb
        return .success(.currentWeightEntered(weightKg: weightKg, useMetricSystem: useMetricSystem))
    }
    
    func resolveDateOfBirthRoute(dateOfBirth: Date) -> DateOfBirthValidationResult {
        let years = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? Constants.defaultAgeYears
        guard years >= Constants.minimumAllowedAgeYears else {
            return .failure(.dateOfBirthUnderMinimumAge)
        }
        return .success(.dateOfBirthEntered(dateOfBirth))
    }

    func resolveHealthImport() async -> OnboardingRoute {
        let profile = await healthImportService.importProfile()
        let normalizedHeightMeters = inputValidator.normalizedImportedHeight(
            profile.heightMeters
        )

        return .healthImportCompleted(
            weightKg: profile.weightKg,
            dateOfBirth: profile.dateOfBirth,
            heightMeters: normalizedHeightMeters
        )
    }

    func resolveHealthPermissionFlow() async -> HealthPermissionFlowResult {
        let currentStatus = await healthImportService.checkPermissionStatus()

        switch currentStatus {
        case .notDetermined:
            let status = await healthImportService.requestPermissions()
            return resolveAfterPermission(status)

        case .authorized(let hasData):
            if hasData {
                return .proceedImport
            }
            return .skipImport(
                alert: AlertPayload(
                    title: Localize.healthPermissionNoDataTitle.localized,
                    message: Localize.healthPermissionNoDataMessage.localized
                )
            )

        case .denied:
            return .skipImportWithSettings(
                alert: AlertPayload(
                    title: Localize.healthPermissionDeniedTitle.localized,
                    message: Localize.healthPermissionDeniedMessage.localized
                )
            )

        case .unavailable:
            return .skipImport(
                alert: AlertPayload(
                    title: Localize.healthPermissionUnavailableTitle.localized,
                    message: Localize.healthPermissionUnavailableMessage.localized
                )
            )
        }
    }

    private func resolveAfterPermission(_ status: HealthPermissionStatus) -> HealthPermissionFlowResult {
        switch status {
        case .authorized(let hasData):
            if hasData {
                return .proceedImport
            }
            return .skipImport(
                alert: AlertPayload(
                    title: Localize.healthPermissionNoDataTitle.localized,
                    message: Localize.healthPermissionNoDataMessage.localized
                )
            )
        case .denied:
            return .skipImportWithSettings(
                alert: AlertPayload(
                    title: Localize.healthPermissionDeniedTitle.localized,
                    message: Localize.healthPermissionDeniedMessage.localized
                )
            )
        case .notDetermined, .unavailable:
            return .skipImport(
                alert: AlertPayload(
                    title: Localize.healthPermissionUnavailableTitle.localized,
                    message: Localize.healthPermissionUnavailableMessage.localized
                )
            )
        }
    }
}
