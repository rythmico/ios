import SwiftUI

extension Color {
    static var rythmicoRed: Color {
        Color(base256Red: 176, green: 0, blue: 32)
    }

    static var rythmicoPurple: Color {
        Color(
            lightModeVariant: .init(base256Red: 93, green: 97, blue: 241),
            darkModeVariant: .init(base256Red: 83, green: 87, blue: 216)
        )
    }

    static var rythmicoGray90: Color {
        Color(
            lightModeVariant: .init(base256Red: 75, green: 93, blue: 107),
            darkModeVariant: .init(base256Red: 165, green: 174, blue: 181)
        )
    }

    static var rythmicoGray10: Color {
        Color(
            lightModeVariant: rythmicoGray10LightModeVariant,
            darkModeVariant: .init(base256Red: 48, green: 48, blue: 49)
        )
    }

    static var rythmicoWhite: Color {
        Color(lightModeVariant: .white, darkModeVariant: rythmicoGray10LightModeVariant)
    }

    private static var rythmicoGray10LightModeVariant: UIColor {
        UIColor(base256Red: 240, green: 244, blue: 247)
    }

    static var rythmicoForeground: Color {
        Color(lightModeVariant: .black, darkModeVariant: .white)
    }

    static var rythmicoBackground: Color {
        Color(lightModeVariant: .white, darkModeVariant: .black)
    }
}

private extension UIColor {
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
}

private extension Color {
    init(lightModeVariant: UIColor, darkModeVariant: UIColor) {
        self.init(UIColor(dynamicProvider: {
            if $0.userInterfaceStyle == .light {
                return lightModeVariant
            } else {
                return darkModeVariant
            }
        }))
    }

    init(
        _ colorSpace: Color.RGBColorSpace = .sRGB,
        base256Red red: Int,
        green: Int,
        blue: Int,
        opacity: Double = 1
    ) {
        self.init(
            colorSpace,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: opacity
        )
    }
}
