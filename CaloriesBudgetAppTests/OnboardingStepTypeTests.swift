import XCTest
@testable import CaloriesBudgetApp

final class OnboardingStepTypeTests: XCTestCase {
    func testNextReturnsExpectedStep() {
        XCTAssertEqual(OnboardingStepType.welcome.next(), .gender)
        XCTAssertEqual(OnboardingStepType.gender.next(), .healthImport)
    }

    func testNextReturnsNilForLastStep() {
        XCTAssertNil(OnboardingStepType.dateOfBirth.next())
    }

    func testNextUsesCustomFlow() {
        let customFlow: [OnboardingStepType] = [.welcome, .currentWeight]
        XCTAssertEqual(OnboardingStepType.welcome.next(in: customFlow), .currentWeight)
        XCTAssertNil(OnboardingStepType.currentWeight.next(in: customFlow))
    }
}
