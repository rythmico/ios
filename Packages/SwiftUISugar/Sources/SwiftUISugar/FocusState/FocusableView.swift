public protocol FocusableView {
    associatedtype Focus: FocusEnum
    typealias FocusCoordinator = SwiftUISugar.FocusCoordinator<Focus>
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
