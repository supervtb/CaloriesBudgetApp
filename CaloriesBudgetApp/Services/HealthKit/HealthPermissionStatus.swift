import Foundation

enum HealthPermissionStatus {
    case authorized(hasData: Bool)
    case notDetermined
    case denied
    case unavailable
}
