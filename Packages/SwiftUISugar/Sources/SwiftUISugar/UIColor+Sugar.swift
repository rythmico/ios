extension Color {
    public init(light: UIColor, dark: UIColor) {
        self.init(UIColor(light: light, dark: dark))
    }

    public init(light: UIColor, dark: UInt) {
        self.init(UIColor(light: light, dark: dark))
    }

    public init(light: UInt, dark: UIColor) {
        self.init(UIColor(light: light, dark: dark))
    }

    public init(light: UInt, dark: UInt) {
        self.init(UIColor(light: light, dark: dark))
    }
}

extension UIColor {
    public convenience init(light: UIColor, dark: UIColor) {
        self.init { $0.userInterfaceStyle == .light ? light : dark }
    }

    public convenience init(light: UIColor, dark: UInt) {
        self.init(light: light, dark: .init(hex: dark))
    }

    public convenience init(light: UInt, dark: UIColor) {
        self.init(light: .init(hex: light), dark: dark)
    }

    public convenience init(light: UInt, dark: UInt) {
        self.init(light: .init(hex: light), dark: .init(hex: dark))
    }
}

extension UIColor {
    public convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255,
            blue: CGFloat(hex & 0x0000FF) / 255,
            alpha: alpha
        )
    }
}
