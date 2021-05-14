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
    static let rythmicoBackgroundTertiary = Color(.rythmicoBackgroundTertiary)
}

extension UIColor {
    static let rythmicoRed = UIColor(light: 0xB00020, dark: 0x9E001C)

    static let rythmicoLightBurgundy = UIColor(light: 0xFFD6E8, dark: 0xe5c0d0)
    static let rythmicoDarkBurgundy = UIColor(light: 0x9F1754, dark: 0x8f144b)

    static let rythmicoExtraLightBlue = UIColor(light: 0xE8F1FF, dark: 0x17386A)
    static let rythmicoLightBlue = UIColor(light: 0xd0e2ff, dark: 0xd0e2ff)
    static let rythmicoDarkBlue = UIColor(light: 0x0043CE, dark: 0x0043CE)

    static let rythmicoLightGreen = UIColor(light: 0xA7F0BB, dark: 0x96d8a8)
    static let rythmicoDarkGreen = UIColor(light: 0x0F6027, dark: 0x0d5623)

    static let rythmicoLightPurple = UIColor(light: 0xE8DAFF, dark: 0xD6BDFF)
    static let rythmicoPurple = UIColor(light: 0x6558F5, dark: 0x6558F5)
    static let rythmicoHighlightPurple = UIColor(light: 0x4B3EE5, dark: 0x766CED)
    static let rythmicoDarkPurple = UIColor(light: 0x6929C4, dark: 0x783ec9)

    static let rythmicoWhite = UIColor(light: .white, dark: .rythmicoForegroundDarkModeVariant)

    static let rythmicoGray5 = UIColor(light: 0xFAFAFA, dark: 0x191919)
    static let rythmicoGray10 = UIColor(light: 0xF0F4F7, dark: 0x363637)
    static let rythmicoGray20 = UIColor(light: 0xD5D6D7, dark: 0x4A4B4B)
    static let rythmicoGray30 = UIColor(light: 0x9AA3AA, dark: 0x4D5155)
    static let rythmicoGray90 = UIColor(light: 0x4B5C6B, dark: 0xA5ADB5)

    static let rythmicoForeground = UIColor(light: .rythmicoForegroundLightModeVariant, dark: .rythmicoForegroundDarkModeVariant)

    static let rythmicoBackground = UIColor(light: .white, dark: .black)
    static let rythmicoBackgroundSecondary = UIColor(light: .white, dark: 0x181818)
    static let rythmicoBackgroundTertiary = UIColor(light: .white, dark: 0x1e1e1e)

    // Shared colors.

    private static let rythmicoForegroundLightModeVariant = UIColor(hex: 0x1B1D22)
    private static let rythmicoForegroundDarkModeVariant = UIColor(hex: 0xe8e8e8)
}
