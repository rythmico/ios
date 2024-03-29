public typealias _FocusCoordinator<Focus: FocusEnum> = FocusCoordinator<Focus>

public protocol FocusableView {
    associatedtype Focus: FocusEnum
    typealias FocusCoordinator = _FocusCoordinator<Focus>
    var focusCoordinator: FocusCoordinator { get }
}

extension FocusableView {
    public var focus: Focus? {
        get { focusCoordinator.focus }
        nonmutating set { focusCoordinator.focus = newValue }
    }

    public func endEditing() {
        focusCoordinator.endEditing()
    }
}
