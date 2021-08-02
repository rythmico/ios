public protocol UIColorProtocol {
    associatedtype ColorType where ColorType == Self
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    init(dynamicProvider: @escaping (UITraitCollection) -> UIColor)
    init(cgColor: CGColor)
    func opacity(_ opacity: Double) -> ColorType
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

extension UIColor: UIColorProtocol {
    public func opacity(_ opacity: Double) -> UIColor {
        self.withAlphaComponent(CGFloat(opacity))
    }
}

extension Color: UIColorProtocol {
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }

    public init(dynamicProvider: @escaping (UITraitCollection) -> UIColor) {
        self.init(UIColor(dynamicProvider: dynamicProvider))
    }

    public init(cgColor: CGColor) {
        self.init(UIColor(cgColor: cgColor))
    }
}
