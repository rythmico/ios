public enum AdHocButtonState: Equatable {
    case normal
    case pressed
    case disabled

    init(isPressed: Bool, isEnabled: Bool) {
        switch (isPressed, isEnabled) {
        case (false, true):
            self = .normal
        case (true, _):
            self = .pressed
        case (false, false):
            self = .disabled
        }
    }

    public func map<T>(
        normal: @autoclosure () -> T,
        pressed: @autoclosure () -> T? = nil,
        disabled: @autoclosure () -> T? = nil
    ) -> T {
        switch self {
        case .normal: return normal()
        case .pressed: return pressed() ?? normal()
        case .disabled: return disabled() ?? normal()
        }
    }
}
