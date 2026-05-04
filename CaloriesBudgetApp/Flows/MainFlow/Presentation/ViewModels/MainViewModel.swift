import Foundation

final class MainViewModel {
    let titleText: String
    let summaryText: String

    init(onboardingData: OnboardingData, summaryProvider: SummaryProviding) {
        let summary = summaryProvider.makeSummary(onboardingData: onboardingData)
        let displayBudget = summaryProvider.makeDisplayBudget(from: summary)
        titleText = Localize.mainTitle.localized
        if summary.useMetricSystem {
            summaryText = String(format: Localize.mainSummaryMetricFormat.localized, displayBudget)
        } else {
            summaryText = String(format: Localize.mainSummaryFormat.localized, displayBudget)
        }
    }
}
