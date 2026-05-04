import XCTest
@testable import CaloriesBudgetApp

final class InputValidatorTests: XCTestCase {
    private let inputValidator = InputValidator()

    func testRejectsMultipleFractionSeparators() {
        let allowed = inputValidator.shouldAllowChange(
            currentText: "70.5",
            range: NSRange(location: 4, length: 0),
            replacementString: "."
        )

        XCTAssertFalse(allowed)
    }

    func testRejectsMoreThanOneFractionDigit() {
        let allowed = inputValidator.shouldAllowChange(
            currentText: "70.5",
            range: NSRange(location: 4, length: 0),
            replacementString: "6"
        )

        XCTAssertFalse(allowed)
    }

    func testAllowsCommaAsSeparator() {
        let allowed = inputValidator.shouldAllowChange(
            currentText: "70",
            range: NSRange(location: 2, length: 0),
            replacementString: ","
        )

        XCTAssertTrue(allowed)
    }

    func testWeightRangeValidation() {
        XCTAssertFalse(inputValidator.isValidWeightValue(9.9))
        XCTAssertTrue(inputValidator.isValidWeightValue(10.0))
        XCTAssertTrue(inputValidator.isValidWeightValue(500.0))
        XCTAssertFalse(inputValidator.isValidWeightValue(500.1))
    }

    func testNormalizedImportedHeightReturnsInputWhenWithinValidRange() {
        let normalizedHeight = inputValidator.normalizedImportedHeight(1.83)

        XCTAssertEqual(normalizedHeight, 1.83, accuracy: 0.0001)
    }

    func testNormalizedImportedHeightReturnsDefaultWhenTooSmall() {
        let normalizedHeight = inputValidator.normalizedImportedHeight(0.9)

        XCTAssertEqual(normalizedHeight, OnboardingData.defaultHeightMeters, accuracy: 0.0001)
    }

    func testNormalizedImportedHeightReturnsDefaultWhenTooLarge() {
        let normalizedHeight = inputValidator.normalizedImportedHeight(2.8)

        XCTAssertEqual(normalizedHeight, OnboardingData.defaultHeightMeters, accuracy: 0.0001)
    }

    func testNormalizedImportedHeightReturnsDefaultWhenNil() {
        let normalizedHeight = inputValidator.normalizedImportedHeight(nil)

        XCTAssertEqual(normalizedHeight, OnboardingData.defaultHeightMeters, accuracy: 0.0001)
    }
}
