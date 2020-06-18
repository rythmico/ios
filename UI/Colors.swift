import SwiftUI

extension Color {
    static let rythmicoRed = Color(.rythmicoRed)

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

    static let rythmicoLightPurple = UIColor(
        lightModeVariant: .init(hex: 0xE8DAFF),
        darkModeVariant: .init(hex: 0xd0c4e5)
    )

    static let rythmicoPurple = UIColor(
        lightModeVariant: .init(hex: 0x6558F5),
        darkModeVariant: .init(hex: 0x5A4FDC)
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
        lightModeVariant: .init(hex: 0xF8F8F8),
        darkModeVariant: .init(hex: 0x181818)
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

private extension UIColor {
    convenience init(lightModeVariant: UIColor, darkModeVariant: UIColor) {
        self.init(dynamicProvider: {
            if $0.userInterfaceStyle == .light {
                return lightModeVariant
            } else {
                return darkModeVariant
            }
        })
    }

    convenience init(
        base256Red red: Int,
        green: Int,
        blue: Int,
        alpha: CGFloat = 1
    ) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha
        )
    }

    convenience init(hex: Int, alpha: CGFloat = 1) {
        let (red, green, blue) = (
            CGFloat((hex >> 16) & 0xff) / 255,
            CGFloat((hex >> 08) & 0xff) / 255,
            CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
