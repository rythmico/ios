import SwiftUISugar

extension Color {
    static let rythmico = ColorSet<Color>()
}

extension UIColor {
    static let rythmico = ColorSet<UIColor>()
}

struct ColorSet<Color: UIColorProtocol> {
    let foreground = Color(light: 0x150F2F, dark: 0xE8E8E8)
    let white = Color(light: 0xFFFFFF, dark: 0xE8E8E8)

    let azureBlue = Color(light: 0xE3F6F5, dark: 0x103230)
    let picoteeBlue = Color(light: 0x392396, dark: 0x394AD0)
    let darkPurple = Color(light: 0x150F2F, dark: 0xEBE8F8)

    let red = Color(light: 0xB00020, dark: 0x9E001C)

    // MARK: --

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

    // MARK: --

    var textPlaceholder: Color { foreground.opacity(0.5) }
    let outline = Color(light: 0xE7E7E7, dark: 0x2B2B2B)
    let gray1 = Color(light: 0xEBEBEC, dark: 0x363637)
    let gray2 = Color(light: 0xF8F8F8, dark: 0x0F0F0F)

    let background = Color(light: 0xFFFFFF, dark: 0x080808)
    let backgroundSecondary = Color(light: 0xFFFFFF, dark: 0x181818)
}

extension ColorSet {
    func inverted(_ keyPath: KeyPath<ColorSet<UIColor>, UIColor>) -> Color {
        Color(light: resolved(keyPath, mode: .dark), dark: resolved(keyPath, mode: .light))
    }

    func resolved(_ keyPath: KeyPath<ColorSet<UIColor>, UIColor>, mode: UIUserInterfaceStyle) -> Color {
        Color(cgColor: resolved(keyPath, mode: mode).cgColor)
    }

    private func resolved(_ keyPath: KeyPath<ColorSet<UIColor>, UIColor>, mode: UIUserInterfaceStyle) -> UIColor {
        ColorSet<UIColor>()[keyPath: keyPath].resolvedColor(with: .init(userInterfaceStyle: mode))
    }
}
