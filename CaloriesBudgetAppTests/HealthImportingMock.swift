import XCTest
@testable import CaloriesBudgetApp

final class HealthImportingMock: HealthImporting {
    private let checkStatus: HealthPermissionStatus
    private let requestStatus: HealthPermissionStatus
    private let importedProfile: HealthProfile

    private(set) var requestPermissionsCallCount = 0

    init(checkStatus: HealthPermissionStatus, requestStatus: HealthPermissionStatus, importedProfile: HealthProfile) {
        self.checkStatus = checkStatus
        self.requestStatus = requestStatus
        self.importedProfile = importedProfile
    }

    func checkPermissionStatus() async -> HealthPermissionStatus {
        checkStatus
    }

    func requestPermissions() async -> HealthPermissionStatus {
        requestPermissionsCallCount += 1
        return requestStatus
    }

    func importProfile() async -> HealthProfile {
        importedProfile
    }
}
