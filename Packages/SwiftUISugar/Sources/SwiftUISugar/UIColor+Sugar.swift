public protocol UIColorProtocol {
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    init(dynamicProvider: @escaping (UITraitCollection) -> UIColor)
}

extension UIColorProtocol {
    public init(light: UIColor, dark: UIColor) {
        self.init { $0.userInterfaceStyle == .dark ? dark : light }
    }

    public init(light: UInt, dark: UInt) {
        self.init(light: .init(hex: light), dark: .init(hex: dark))
    }

    public init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255,
            blue: CGFloat(hex & 0x0000FF) / 255,
            alpha: alpha
        )
    }
}

extension UIColor: UIColorProtocol {}

extension Color: UIColorProtocol {
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }

    public init(dynamicProvider: @escaping (UITraitCollection) -> UIColor) {
        self.init(UIColor(dynamicProvider: dynamicProvider))
    }
}
