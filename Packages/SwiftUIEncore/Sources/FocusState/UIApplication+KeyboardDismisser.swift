// TODO: move away towards closure-based DI in AppEnvironment

public protocol KeyboardDismisser {
    func dismissKeyboard()
}

extension UIApplication: KeyboardDismisser {
    public func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public final class KeyboardDismisserSpy: KeyboardDismisser {
    private(set) public var dismissKeyboardCount = 0

    public init() {}

    public func dismissKeyboard() {
        dismissKeyboardCount += 1
    }
}

public final class KeyboardDismisserDummy: KeyboardDismisser {
    public init() {}
    public func dismissKeyboard() {}
}
