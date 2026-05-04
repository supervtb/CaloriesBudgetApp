import XCTest
@testable import CaloriesBudgetApp

final class OnboardingDataTests: XCTestCase {
    func testMetricDefaultIsOffForEnglishUSLocale() {
        let locale = Locale(identifier: "en_US")

        let onboardingData = OnboardingData.initial(locale: locale)

        XCTAssertFalse(onboardingData.useMetricSystem)
    }

    func testMetricDefaultIsOnForNonUSOrNonEnglishLocales() {
        let britishLocale = Locale(identifier: "en_GB")
        let russianLocale = Locale(identifier: "ru_RU")

        let britishData = OnboardingData.initial(locale: britishLocale)
        let russianData = OnboardingData.initial(locale: russianLocale)

        XCTAssertTrue(britishData.useMetricSystem)
        XCTAssertTrue(russianData.useMetricSystem)
    }
}
