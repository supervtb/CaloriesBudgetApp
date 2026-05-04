import Foundation

enum OnboardingStepType: CaseIterable {
    case welcome
    case gender
    case healthImport
    case currentWeight
    case dateOfBirth

    func next(in flow: [OnboardingStepType] = allCases) -> OnboardingStepType? {
        guard let index = flow.firstIndex(of: self), index + 1 < flow.count else {
            return nil
        }
        return flow[index + 1]
    }
}
