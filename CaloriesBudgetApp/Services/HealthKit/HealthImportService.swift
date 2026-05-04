import Foundation
import HealthKit

private enum Access<Value> {
    case value(Value)
    case noData
    case denied
}

protocol HealthImporting {
    func checkPermissionStatus() async -> HealthPermissionStatus
    func requestPermissions() async -> HealthPermissionStatus
    func importProfile() async -> HealthProfile
}

actor HealthImportService: HealthImporting {
    private let healthStore = HKHealthStore()

    func checkPermissionStatus() async -> HealthPermissionStatus {
        guard HKHealthStore.isHealthDataAvailable() else { return .unavailable }

        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass),
              let heightType = HKQuantityType.quantityType(forIdentifier: .height),
              let dobType = HKCharacteristicType.characteristicType(forIdentifier: .dateOfBirth) else {
            return .unavailable
        }

        if healthStore.authorizationStatus(for: weightType) == .notDetermined
            && healthStore.authorizationStatus(for: heightType) == .notDetermined
            && healthStore.authorizationStatus(for: dobType) == .notDetermined {
            return .notDetermined
        }

        return await probeAccess(weightType: weightType, heightType: heightType)
    }

    func requestPermissions() async -> HealthPermissionStatus {
        guard HKHealthStore.isHealthDataAvailable() else { return .unavailable }

        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass),
              let heightType = HKQuantityType.quantityType(forIdentifier: .height),
              let dobType = HKCharacteristicType.characteristicType(forIdentifier: .dateOfBirth) else {
            return .unavailable
        }

        let didSucceed = await requestAuthorization(readTypes: [weightType, heightType, dobType])
        guard didSucceed else { return .denied }

        return await probeAccess(weightType: weightType, heightType: heightType)
    }

    func importProfile() async -> HealthProfile {
        let emptyProfile = HealthProfile(weightKg: nil, dateOfBirth: nil, heightMeters: nil)

        guard HKHealthStore.isHealthDataAvailable() else {
            return emptyProfile
        }

        let status = await checkPermissionStatus()
        guard case .authorized(hasData: true) = status else {
            return emptyProfile
        }

        async let weightResult = readLatestQuantity(type: HKQuantityType(.bodyMass), unit: .gramUnit(with: .kilo))
        async let heightResult = readLatestQuantity(type: HKQuantityType(.height), unit: .meter())
        let dobResult = readDateOfBirth()

        return await HealthProfile(
            weightKg: extractValue(weightResult),
            dateOfBirth: extractValue(dobResult),
            heightMeters: extractValue(heightResult)
        )
    }

    // MARK: - Private

    private func requestAuthorization(readTypes: Set<HKObjectType>) async -> Bool {
        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            return true
        } catch {
            return false
        }
    }

    private func probeAccess(weightType: HKQuantityType, heightType: HKQuantityType) async -> HealthPermissionStatus {
        async let weightResult = readLatestQuantity(type: weightType, unit: .gramUnit(with: .kilo))
        async let heightResult = readLatestQuantity(type: heightType, unit: .meter())
        let dobResult = readDateOfBirth()

        let weight = await weightResult
        let height = await heightResult

        if isDenied(weight) || isDenied(height) || isDenied(dobResult) {
            return .denied
        }

        let hasAnyData = hasValue(weight) || hasValue(height) || hasValue(dobResult)
        return .authorized(hasData: hasAnyData)
    }

    private func readDateOfBirth() -> Access<Date> {
        do {
            guard let date = try healthStore.dateOfBirthComponents().date else {
                return .noData
            }
            return .value(date)
        } catch let error as HKError {
            return error.code == .errorAuthorizationDenied ? .denied : .noData
        } catch {
            return .noData
        }
    }

    private func readLatestQuantity(type: HKQuantityType, unit: HKUnit) async -> Access<Double> {
        let notInFuturePredicate = HKQuery.predicateForSamples(
            withStart: nil,
            end: Date(),
            options: []
        )

        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: type, predicate: notInFuturePredicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)],
            limit: 1
        )

        do {
            let samples = try await descriptor.result(for: healthStore)
            guard let value = samples.first?.quantity.doubleValue(for: unit) else {
                return .noData
            }
            return .value(value)
        } catch let error as HKError {
            return error.code == .errorAuthorizationDenied ? .denied : .noData
        } catch {
            return .noData
        }
    }

    private func hasValue<Value>(_ access: Access<Value>) -> Bool {
        if case .value = access {
            return true
        }
        return false
    }

    private func isDenied<Value>(_ access: Access<Value>) -> Bool {
        if case .denied = access {
            return true
        }
        return false
    }

    private func extractValue<Value>(_ access: Access<Value>) -> Value? {
        if case .value(let value) = access {
            return value
        }
        return nil
    }
}
