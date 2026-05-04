import XCTest
@testable import CaloriesBudgetApp

final class CalorieBudgetCalculatorTests: XCTestCase {
    private let calculator = CalorieBudgetCalculator()
    private let physicalActivityFactor: Double = 1.0

    func testMaleFormulaMatchesSpecification() throws {
        let now = Date()
        let dateOfBirth = try XCTUnwrap(Calendar(identifier: .gregorian).date(byAdding: .year, value: -30, to: now))
        let onboardingData = OnboardingData(
            gender: .male,
            heightMeters: 1.8,
            currentWeightKg: 80.0,
            dateOfBirth: dateOfBirth,
            useMetricSystem: false
        )

        let summary = calculator.makeSummary(onboardingData: onboardingData)
        let expected = Int((
            662.0
            - 9.53 * 30.0
            + physicalActivityFactor * (15.91 * 80.0 + 539.6 * 1.8)
        ).rounded())

        XCTAssertEqual(summary.dailyCalorieBudget, expected)
    }

    func testFemaleFormulaMatchesSpecification() throws {
        let now = Date()
        let dateOfBirth = try XCTUnwrap(Calendar(identifier: .gregorian).date(byAdding: .year, value: -25, to: now))
        let onboardingData = OnboardingData(
            gender: .female,
            heightMeters: 1.65,
            currentWeightKg: 60.0,
            dateOfBirth: dateOfBirth,
            useMetricSystem: true
        )

        let summary = calculator.makeSummary(onboardingData: onboardingData)
        let expected = Int((
            354.0
            - 6.91 * 25.0
            + physicalActivityFactor * (9.36 * 60.0 + 726.0 * 1.65)
        ).rounded())

        XCTAssertEqual(summary.dailyCalorieBudget, expected)
    }

    func testFallbackBudgetWhenRequiredInputsMissing() {
        let onboardingData = OnboardingData(
            gender: nil,
            heightMeters: 1.7,
            currentWeightKg: nil,
            dateOfBirth: nil,
            useMetricSystem: false
        )

        let summary = calculator.makeSummary(onboardingData: onboardingData)

        XCTAssertEqual(summary.dailyCalorieBudget, 2000)
    }

    func testSummaryCarriesSelectedUnitSystemFlag() throws {
        let now = Date()
        let dateOfBirth = try XCTUnwrap(Calendar(identifier: .gregorian).date(byAdding: .year, value: -20, to: now))
        let onboardingData = OnboardingData(
            gender: .male,
            heightMeters: 1.75,
            currentWeightKg: 72.0,
            dateOfBirth: dateOfBirth,
            useMetricSystem: true
        )

        let summary = calculator.makeSummary(onboardingData: onboardingData)

        XCTAssertTrue(summary.useMetricSystem)
    }

    func testDisplayBudgetReturnsKcalWhenImperial() {
        let summary = SummaryData(dailyCalorieBudget: 2100, useMetricSystem: false)

        let displayBudget = calculator.makeDisplayBudget(from: summary)

        XCTAssertEqual(displayBudget, 2100)
    }

    func testDisplayBudgetConvertsKcalToKilojoulesWhenMetric() {
        let summary = SummaryData(dailyCalorieBudget: 2000, useMetricSystem: true)

        let displayBudget = calculator.makeDisplayBudget(from: summary)

        XCTAssertEqual(displayBudget, 8368)
    }

    func testDisplayBudgetRoundsKilojoulesToInteger() {
        let summary = SummaryData(dailyCalorieBudget: 1999, useMetricSystem: true)

        let displayBudget = calculator.makeDisplayBudget(from: summary)

        XCTAssertEqual(displayBudget, Int((1999.0 * 4.184).rounded()))
    }
}
