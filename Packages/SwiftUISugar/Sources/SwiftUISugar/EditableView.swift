public typealias _EditingCoordinator<Focus: EditingFocusEnum> = EditingCoordinator<Focus>

public protocol EditableView {
    associatedtype EditingFocus: EditingFocusEnum
    typealias EditingCoordinator = _EditingCoordinator<EditingFocus>
    var editingCoordinator: EditingCoordinator { get }
}

extension EditableView {
    public var editingFocus: EditingFocus? {
        get { editingCoordinator.focus }
        nonmutating set { editingCoordinator.focus = newValue }
    }

    public func endEditing() {
        editingCoordinator.endEditing()
    }
}
