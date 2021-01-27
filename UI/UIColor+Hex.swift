import UIKit

extension UIColor {
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
