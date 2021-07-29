import SwiftUISugar

extension Color {
    static let rythmico = ColorSet<Color>()
}

extension UIColor {
    static let rythmico = ColorSet<UIColor>()
}

struct ColorSet<Color: UIColorProtocol> {
    let red = Color(light: 0xB00020, dark: 0x9E001C)


    let extraLightBlue = Color(light: 0xE8F1FF, dark: 0x17386A)


    let lightPurple = Color(light: 0xE8DAFF, dark: 0xD6BDFF)
    let purple = Color(light: 0x6558F5, dark: 0x6558F5)
    let highlightPurple = Color(light: 0x4B3EE5, dark: 0x766CED)
    let darkPurple = Color(light: 0x6929C4, dark: 0x783ec9)

    let white = Color(light: 0xFFFFFF, dark: foregroundDarkModeHex)

    let gray5 = Color(light: 0xFAFAFA, dark: 0x191919)
    let outline = Color(light: 0xE7E7E7, dark: 0x2B2B2B)

    let tagPurple = Color(light: 0xE8DAFF, dark: 0xD6BDFF)
    let tagTextPurple = Color(light: 0x6929C4, dark: 0x5E24B0)

    let tagGray = Color(light: 0xDDE1E6, dark: 0x424345)
    let tagTextGray = Color(light: 0x111619, dark: 0x9FA1A3)

    let tagBlue = Color(light: 0xd0e2ff, dark: 0xd0e2ff)
    let tagTextBlue = Color(light: 0x0043CE, dark: 0x0043CE)

    let tagBurgundy = Color(light: 0xFFD6E8, dark: 0xe5c0d0)
    let tagTextBurgundy = Color(light: 0x9F1754, dark: 0x8f144b)

    let tagGreen = Color(light: 0xA7F0BB, dark: 0x96d8a8)
    let tagTextGreen = Color(light: 0x0F6027, dark: 0x0d5623)

    let gray10 = Color(light: 0xF0F4F7, dark: 0x363637)
    let gray30 = Color(light: 0x9AA3AA, dark: 0x4D5155)
    let gray90 = Color(light: 0x4B5C6B, dark: 0xA5ADB5)

    let foreground = Color(light: foregroundLightModeHex, dark: foregroundDarkModeHex)

    let background = Color(light: 0xFFFFFF, dark: 0x000000)
    let backgroundSecondary = Color(light: 0xFFFFFF, dark: 0x181818)
    let backgroundTertiary = Color(light: 0xFFFFFF, dark: 0x1e1e1e)
}

// Shared colors.

private let foregroundLightModeHex: UInt = 0x1B1D22
private let foregroundDarkModeHex: UInt = 0xe8e8e8
