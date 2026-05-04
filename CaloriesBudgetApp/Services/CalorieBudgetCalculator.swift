import Foundation

protocol SummaryProviding {
    func makeSummary(onboardingData: OnboardingData) -> SummaryData
    func makeDisplayBudget(from summary: SummaryData) -> Int
}

final class CalorieBudgetCalculator: SummaryProviding {
    private enum Constants {
        static let fallbackDailyBudget: Int = 2000
        static let kilojoulePerKilocalorie: Double = 4.184
        static let defaultAgeYears: Double = 25.0
        static let physicalActivityFactor: Double = 1.0

        static let maleBase: Double = 662.0
        static let maleAgeFactor: Double = 9.53
        static let maleWeightFactor: Double = 15.91
        static let maleHeightFactor: Double = 539.6

        static let femaleBase: Double = 354.0
        static let femaleAgeFactor: Double = 6.91
        static let femaleWeightFactor: Double = 9.36
        static let femaleHeightFactor: Double = 726.0
    }

    func makeSummary(onboardingData: OnboardingData) -> SummaryData {
        let budget = calculateDailyCalorieBudget(from: onboardingData)
        return SummaryData(
            dailyCalorieBudget: budget,
            useMetricSystem: onboardingData.useMetricSystem
        )
    }

    func makeDisplayBudget(from summary: SummaryData) -> Int {
        guard summary.useMetricSystem else {
            return summary.dailyCalorieBudget
        }
        return Int((Double(summary.dailyCalorieBudget) * Constants.kilojoulePerKilocalorie).rounded())
    }

    private func calculateDailyCalorieBudget(from data: OnboardingData) -> Int {
        guard
            let gender = data.gender,
            let weightKg = data.currentWeightKg,
            let dateOfBirth = data.dateOfBirth
        else {
            return Constants.fallbackDailyBudget
        }

        let ageInYears = preciseAgeInYears(from: dateOfBirth) ?? Constants.defaultAgeYears

        let dailyBudget: Double
        switch gender {
        case .male:
            dailyBudget =
                Constants.maleBase
                - Constants.maleAgeFactor * ageInYears
                + Constants.physicalActivityFactor * (
                    Constants.maleWeightFactor * weightKg
                    + Constants.maleHeightFactor * data.heightMeters
                )
        case .female:
            dailyBudget =
                Constants.femaleBase
                - Constants.femaleAgeFactor * ageInYears
                + Constants.physicalActivityFactor * (
                    Constants.femaleWeightFactor * weightKg
                    + Constants.femaleHeightFactor * data.heightMeters
                )
        }

        return Int(dailyBudget.rounded())
    }

    private func preciseAgeInYears(from dateOfBirth: Date, now: Date = Date()) -> Double? {
        let calendar = Calendar(identifier: .gregorian)
        let fullYears = calendar.dateComponents([.year], from: dateOfBirth, to: now).year ?? 0
        guard fullYears >= 0,
              let anniversary = calendar.date(byAdding: .year, value: fullYears, to: dateOfBirth),
              let nextAnniversary = calendar.date(byAdding: .year, value: 1, to: anniversary) else {
            return nil
        }

        let elapsed = now.timeIntervalSince(anniversary)
        let yearLength = nextAnniversary.timeIntervalSince(anniversary)
        guard yearLength > 0 else {
            return nil
        }

        return Double(fullYears) + (elapsed / yearLength)
    }
}
