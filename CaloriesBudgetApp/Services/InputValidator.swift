import Foundation

protocol InputValidating {
    func shouldAllowChange(currentText: String?, range: NSRange, replacementString string: String) -> Bool
    func isValidWeightValue(_ weight: Double) -> Bool
    func normalizedImportedHeight(_ height: Double?) -> Double
    func maximumDateOfBirth() -> Date
}

final class InputValidator: InputValidating {
    private enum Constants {
        static let defaultHeightMeters: Double = OnboardingData.defaultHeightMeters
    }

    private let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,"))
    private let maxFractionDigits = 1
    private let validWeightRange = 10.0...500.0
    private let validHeightRange = 1.0...2.5
    private let maxWeightCharacters = 5

    func shouldAllowChange(currentText: String?, range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return true }

        guard string.unicodeScalars.allSatisfy({ allowedCharacters.contains($0) }) else {
            return false
        }

        let current = currentText ?? ""
        guard let textRange = Range(range, in: current) else { return false }
        let proposed = current.replacingCharacters(in: textRange, with: string)
        if proposed.count > maxWeightCharacters { return false }

        let separatorCount = proposed.filter { $0 == "." || $0 == "," }.count
        if separatorCount > 1 { return false }

        if let separatorIndex = proposed.firstIndex(where: { $0 == "." || $0 == "," }) {
            let fractionPart = proposed[proposed.index(after: separatorIndex)...]
            if fractionPart.count > maxFractionDigits { return false }
        }

        return true
    }

    func isValidWeightValue(_ weight: Double) -> Bool {
        validWeightRange.contains(weight)
    }

    func normalizedImportedHeight(_ height: Double?) -> Double {
        guard let height, validHeightRange.contains(height) else {
            return Constants.defaultHeightMeters
        }
        return height
    }

    func maximumDateOfBirth() -> Date {
        Date()
    }
}
