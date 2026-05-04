import UIKit

extension UIColor {
    static let appBackground = UIColor.systemBackground
    static let appError = UIColor.systemRed

    static let appWhite = UIColor(hex: 0xFFFFFF)
    static let appShadow = UIColor.black

    static let appCardBackground = appWhite.withAlphaComponent(0.92)
    static let appTranslucentCardBackground = appWhite.withAlphaComponent(0.9)
    static let appHintCardBackground = appWhite.withAlphaComponent(0.72)

    static let appBrandMint = UIColor(hex: 0x33B89F)
    static let appBrandPurple = UIColor(hex: 0x6C63FF)

    static let appMaleSymbol = UIColor(hex: 0x5B85F0)
    static let appMaleSymbolBackground = UIColor(hex: 0x4D8CFF).withAlphaComponent(0.12)
    static let appFemaleSymbol = UIColor(hex: 0xD86799)
    static let appFemaleSymbolBackground = UIColor(hex: 0xE85D8F).withAlphaComponent(0.12)

    static let appTitlePrimary = UIColor(hex: 0x11121A)
    static let appTextPrimary = UIColor(hex: 0x171820)
    static let appTextSecondary = UIColor(hex: 0x6E7280)

    static let appSelectedBorder = UIColor(hex: 0xE85D8F)
    static let appUnselectedBorder = UIColor(hex: 0xDADDE7)
    static let appSubtleBorder = UIColor(hex: 0xCDD2E1)
}
