import SwiftUI

extension Color {
    static let rythmicoRed = Color(base256Red: 176, green: 0, blue: 32)

    static let rythmicoPurple = Color(.rythmicoPurple)

    static let rythmicoGray90 = Color(
        lightModeVariant: .init(base256Red: 75, green: 93, blue: 107),
        darkModeVariant: .init(base256Red: 165, green: 174, blue: 181)
    )

    static let rythmicoGray20 = Color(.rythmicoGray20)

    static let rythmicoGray10 = Color(
        lightModeVariant: rythmicoGray10LightModeVariant,
        darkModeVariant: .init(base256Red: 48, green: 48, blue: 49)
    )

    static let rythmicoWhite = Color(lightModeVariant: .white, darkModeVariant: rythmicoGray10LightModeVariant)

    private static let rythmicoGray10LightModeVariant = UIColor(base256Red: 240, green: 244, blue: 247)

    static let rythmicoForeground = Color(lightModeVariant: .black, darkModeVariant: .white)

    static let rythmicoBackground = Color(lightModeVariant: .white, darkModeVariant: .black)

    static let systemLightGray = Color(
        lightModeVariant: .init(base256Red: 246, green: 246, blue: 246),
        darkModeVariant: .init(base256Red: 40, green: 40, blue: 41)
    )
}

extension UIColor {
    static let rythmicoPurple = UIColor(
        lightModeVariant: .init(base256Red: 93, green: 97, blue: 241),
        darkModeVariant: .init(base256Red: 83, green: 87, blue: 216)
    )

    static let rythmicoGray20 = UIColor(
        lightModeVariant: .init(base256Red: 195, green: 196, blue: 197),
        darkModeVariant: .init(base256Red: 90, green: 90, blue: 94)
    )
}

private extension Color {
    init(lightModeVariant: UIColor, darkModeVariant: UIColor) {
        self.init(UIColor(lightModeVariant: lightModeVariant, darkModeVariant: darkModeVariant))
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
}
