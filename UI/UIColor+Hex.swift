import SwiftUI

extension Color {
    init(light: UIColor, dark: UIColor) {
        self.init(UIColor(light: light, dark: dark))
    }

    init(light: UIColor, dark: Int) {
        self.init(UIColor(light: light, dark: dark))
    }

    init(light: Int, dark: UIColor) {
        self.init(UIColor(light: light, dark: dark))
    }

    init(light: Int, dark: Int) {
        self.init(UIColor(light: light, dark: dark))
    }
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { $0.userInterfaceStyle == .light ? light : dark }
    }

    convenience init(light: UIColor, dark: Int) {
        self.init(light: light, dark: .init(hex: dark))
    }

    convenience init(light: Int, dark: UIColor) {
        self.init(light: .init(hex: light), dark: dark)
    }

    convenience init(light: Int, dark: Int) {
        self.init(light: .init(hex: light), dark: .init(hex: dark))
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
