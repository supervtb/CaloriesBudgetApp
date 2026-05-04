import XCTest
@testable import CaloriesBudgetApp

final class OnboardingViewModelTests: XCTestCase {
    @MainActor
    func testResolveHealthPermissionFlowProceedsWhenAlreadyAuthorizedWithData() async {
        let service = HealthImportingMock(
            checkStatus: .authorized(hasData: true),
            requestStatus: .denied,
            importedProfile: HealthProfile(weightKg: nil, dateOfBirth: nil, heightMeters: nil)
        )
        let viewModel = makeHealthViewModel(service: service)

        let result = await viewModel.resolveHealthPermissionFlow()

        if case .proceedImport = result {
            return
        }
        XCTFail("Expected .proceedImport")
    }

    @MainActor
    func testResolveHealthPermissionFlowRequestsPermissionAndReturnsDeniedWithSettings() async {
        let service = HealthImportingMock(
            checkStatus: .notDetermined,
            requestStatus: .denied,
            importedProfile: HealthProfile(weightKg: nil, dateOfBirth: nil, heightMeters: nil)
        )
        let viewModel = makeHealthViewModel(service: service)

        let result = await viewModel.resolveHealthPermissionFlow()

        if case .skipImportWithSettings = result {
            XCTAssertEqual(service.requestPermissionsCallCount, 1)
            return
        }
        XCTFail("Expected .skipImportWithSettings")
    }

    @MainActor
    func testResolveHealthImportMapsProfileToRoute() async throws {
        let dob = Date(timeIntervalSince1970: 1_700_000_000)
        let service = HealthImportingMock(
            checkStatus: .authorized(hasData: true),
            requestStatus: .authorized(hasData: true),
            importedProfile: HealthProfile(weightKg: 82.4, dateOfBirth: dob, heightMeters: 1.83)
        )
        let viewModel = makeHealthViewModel(service: service)

        let route = await viewModel.resolveHealthImport()

        guard case .healthImportCompleted(let weightKg, let dateOfBirth, let heightMeters) = route else {
            return XCTFail("Expected .healthImportCompleted")
        }
        XCTAssertEqual(try XCTUnwrap(weightKg), 82.4, accuracy: 0.0001)
        XCTAssertEqual(dateOfBirth, dob)
        XCTAssertEqual(try XCTUnwrap(heightMeters), 1.83, accuracy: 0.0001)
    }

    @MainActor
    private func makeHealthViewModel(service: HealthImporting) -> OnboardingViewModel {
        return OnboardingViewModel(
            stepType: .healthImport,
            onboardingData: OnboardingData.initial(locale: Locale(identifier: "en_US")),
            inputValidator: InputValidator(),
            healthImportService: service
        )
    }
}
