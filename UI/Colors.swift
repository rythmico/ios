import SwiftUI

extension Color {
    static let rythmicoRed = Color(.rythmicoRed)
    static let rythmicoPurple = Color(.rythmicoPurple)
    static let rythmicoWhite = Color(.rythmicoWhite)

    static let rythmicoGray10LightModeVariant = Color(.rythmicoGray10LightModeVariant)
    static let rythmicoGray10 = Color(.rythmicoGray10)
    static let rythmicoGray20 = Color(.rythmicoGray20)
    static let rythmicoGray30 = Color(.rythmicoGray30)
    static let rythmicoGray90 = Color(.rythmicoGray90)

    static let rythmicoForegroundLightModeVariant = Color(.rythmicoForegroundLightModeVariant)
    static let rythmicoForegroundDarkModeVariant = Color(.rythmicoForegroundDarkModeVariant)
    static let rythmicoForeground = Color(.rythmicoForeground)

    static let rythmicoBackground = Color(.rythmicoBackground)
    static let rythmicoBackgroundSecondary = Color(.rythmicoBackgroundSecondary)

    static let systemLightGray = Color(.systemLightGray)
}

extension UIColor {
    static let rythmicoRed = UIColor(
        lightModeVariant: .init(base256Red: 176, green: 0, blue: 32),
        darkModeVariant: .init(base256Red: 158, green: 0, blue: 28)
    )

    static let rythmicoPurple = UIColor(
        lightModeVariant: .init(base256Red: 93, green: 97, blue: 241),
        darkModeVariant: .init(base256Red: 83, green: 87, blue: 216)
    )

    static let rythmicoWhite = UIColor(
        lightModeVariant: .white,
        darkModeVariant: .rythmicoForegroundDarkModeVariant
    )

    static let rythmicoGray10LightModeVariant = UIColor(base256Red: 240, green: 244, blue: 247)
    static let rythmicoGray10 = UIColor(
        lightModeVariant: rythmicoGray10LightModeVariant,
        darkModeVariant: .init(base256Red: 48, green: 48, blue: 49)
    )

    static let rythmicoGray20 = UIColor(
        lightModeVariant: .init(base256Red: 213, green: 214, blue: 215),
        darkModeVariant: .init(base256Red: 74, green: 75, blue: 75)
    )

    // FIXME: when TextField support placeholder custom colors, use real value rgb(154, 163, 170).
    static let rythmicoGray30 = UIColor(
        lightModeVariant: .init(base256Red: 195, green: 196, blue: 197),
        darkModeVariant: .init(base256Red: 90, green: 90, blue: 94)
    )

    static let rythmicoGray90 = UIColor(
        lightModeVariant: .init(base256Red: 75, green: 92, blue: 107),
        darkModeVariant: .init(base256Red: 165, green: 173, blue: 181)
    )

    static let rythmicoForegroundLightModeVariant = UIColor(base256Red: 28, green: 29, blue: 33)
    static let rythmicoForegroundDarkModeVariant = UIColor(base256Red: 232, green: 232, blue: 232)
    static let rythmicoForeground = UIColor(
        lightModeVariant: .rythmicoForegroundLightModeVariant,
        darkModeVariant: .rythmicoForegroundDarkModeVariant
    )

    static let rythmicoBackground = UIColor(
        lightModeVariant: .white,
        darkModeVariant: .black
    )

    static let rythmicoBackgroundSecondary = UIColor(
        lightModeVariant: .white,
        darkModeVariant: .init(base256Red: 28, green: 28, blue: 30)
    )

    static let systemLightGray = UIColor(
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
}
