import Foundation

enum Localize: String {
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

    case commonNext
    case commonContinue
    case commonSkip
    case commonOpenSettings

    case unitKg
    case unitLb

    case welcomeAction
    case welcomeTitle
    case welcomeSubtitle

    case genderMale
    case genderFemale
    case genderTitle
    case genderSubtitle

    case healthImportButton
    case healthImportTitle
    case healthImportSubtitle
    case healthPermissionUnavailableTitle
    case healthPermissionUnavailableMessage
    case healthPermissionGrantedTitle
    case healthPermissionGrantedMessage
    case healthPermissionNoDataTitle
    case healthPermissionNoDataMessage
    case healthPermissionDeniedTitle
    case healthPermissionDeniedMessage

    case weightTitle
    case weightSubtitle
    case weightHintTitle
    case weightHintSubtitle
    case weightErrorEmpty
    case weightErrorInvalid
    case weightErrorRange

    case dobTitle
    case dobSubtitle
    case dobErrorUnder13

    case metricTitle

    case mainTitle
    case mainSummaryFormat
    case mainSummaryMetricFormat
    case mainRestart
}
