import SwiftUI

extension Color {
    static let rythmicoRed = Color(.rythmicoRed)

    static let rythmicoLightBurgundy = Color(.rythmicoLightBurgundy)
    static let rythmicoDarkBurgundy = Color(.rythmicoDarkBurgundy)

    static let rythmicoExtraLightBlue = Color(.rythmicoExtraLightBlue)
    static let rythmicoLightBlue = Color(.rythmicoLightBlue)
    static let rythmicoDarkBlue = Color(.rythmicoDarkBlue)

    static let rythmicoLightGreen = Color(.rythmicoLightGreen)
    static let rythmicoDarkGreen = Color(.rythmicoDarkGreen)

    static let rythmicoLightPurple = Color(.rythmicoLightPurple)
    static let rythmicoPurple = Color(.rythmicoPurple)
    static let rythmicoHighlightPurple = Color(.rythmicoHighlightPurple)
    static let rythmicoDarkPurple = Color(.rythmicoDarkPurple)

    static let rythmicoWhite = Color(.rythmicoWhite)

    static let rythmicoGray5 = Color(.rythmicoGray5)
    static let rythmicoGray10 = Color(.rythmicoGray10)
    static let rythmicoGray20 = Color(.rythmicoGray20)
    static let rythmicoGray30 = Color(.rythmicoGray30)
    static let rythmicoGray90 = Color(.rythmicoGray90)

    static let rythmicoForeground = Color(.rythmicoForeground)
    static let rythmicoBackground = Color(.rythmicoBackground)
    static let rythmicoBackgroundSecondary = Color(.rythmicoBackgroundSecondary)
}

extension UIColor {
    static let rythmicoRed = UIColor(
        lightModeVariant: .init(hex: 0xB00020),
        darkModeVariant: .init(hex: 0x9E001C)
    )

    static let rythmicoLightBurgundy = UIColor(
        lightModeVariant: .init(hex: 0xFFD6E8),
        darkModeVariant: .init(hex: 0xe5c0d0)
    )

    static let rythmicoDarkBurgundy = UIColor(
        lightModeVariant: .init(hex: 0x9F1754),
        darkModeVariant: .init(hex: 0x8f144b)
    )

    static let rythmicoExtraLightBlue = UIColor(
        lightModeVariant: .init(hex: 0xE8F1FF),
        darkModeVariant: .init(hex: 0x17386A)
    )

    static let rythmicoLightBlue = UIColor(
        lightModeVariant: .init(hex: 0xd0e2ff),
        darkModeVariant: .init(hex: 0xd0e2ff)
    )

    static let rythmicoDarkBlue = UIColor(
        lightModeVariant: .init(hex: 0x0043CE),
        darkModeVariant: .init(hex: 0x0043CE)
    )

    static let rythmicoLightGreen = UIColor(
        lightModeVariant: .init(hex: 0xA7F0BB),
        darkModeVariant: .init(hex: 0x96d8a8)
    )

    static let rythmicoDarkGreen = UIColor(
        lightModeVariant: .init(hex: 0x0F6027),
        darkModeVariant: .init(hex: 0x0d5623)
    )

    static let rythmicoLightPurple = UIColor(
        lightModeVariant: .init(hex: 0xE8DAFF),
        darkModeVariant: .init(hex: 0xD6BDFF)
    )

    static let rythmicoPurple = UIColor(
        lightModeVariant: .init(hex: 0x6558F5),
        darkModeVariant: .init(hex: 0x6558F5)
    )

    static let rythmicoHighlightPurple = UIColor(
        lightModeVariant: .init(hex: 0x4B3EE5),
        darkModeVariant: .init(hex: 0x766CED)
    )

    static let rythmicoDarkPurple = UIColor(
        lightModeVariant: .init(hex: 0x6929C4),
        darkModeVariant: .init(hex: 0x5e24b0)
    )

    static let rythmicoWhite = UIColor(
        lightModeVariant: .white,
        darkModeVariant: .rythmicoForegroundDarkModeVariant
    )

    static let rythmicoGray5 = UIColor(
        lightModeVariant: .init(hex: 0xFAFAFA),
        darkModeVariant: .init(hex: 0x191919)
    )

    static let rythmicoGray10 = UIColor(
        lightModeVariant: .init(hex: 0xF0F4F7),
        darkModeVariant: .init(hex: 0x363637)
    )

    static let rythmicoGray20 = UIColor(
        lightModeVariant: .init(hex: 0xD5D6D7),
        darkModeVariant: .init(hex: 0x4A4B4B)
    )

    static let rythmicoGray30 = UIColor(
        lightModeVariant: .init(hex: 0x9AA3AA),
        darkModeVariant: .init(hex: 0x4D5155)
    )

    static let rythmicoGray90 = UIColor(
        lightModeVariant: .init(hex: 0x4B5C6B),
        darkModeVariant: .init(hex: 0xA5ADB5)
    )

    static let rythmicoForeground = UIColor(
        lightModeVariant: .rythmicoForegroundLightModeVariant,
        darkModeVariant: .rythmicoForegroundDarkModeVariant
    )

    static let rythmicoBackground = UIColor(
        lightModeVariant: .white,
        darkModeVariant: .init(hex: 0x232323)
    )

    static let rythmicoBackgroundSecondary = UIColor(
        lightModeVariant: .white,
        darkModeVariant: .init(hex: 0x1C1C1E)
    )

    // Shared colors.

    private static let rythmicoForegroundLightModeVariant = UIColor(hex: 0x1B1D22)
    private static let rythmicoForegroundDarkModeVariant = UIColor(hex: 0xe8e8e8)
}

extension Color {
    static let systemTooltipGray = Color(.systemTooltipGray)
}

extension UIColor {
    static let systemTooltipGray = UIColor(
        lightModeVariant: .init(base256Red: 246, green: 246, blue: 246),
        darkModeVariant: .init(base256Red: 40, green: 40, blue: 41)
    )
}

extension Color {
    init(lightModeVariantHex: Int, darkModeVariantHex: Int) {
        self.init(
            UIColor(
                lightModeVariant: UIColor(hex: lightModeVariantHex),
                darkModeVariant: UIColor(hex: darkModeVariantHex)
            )
        )
    }
}
