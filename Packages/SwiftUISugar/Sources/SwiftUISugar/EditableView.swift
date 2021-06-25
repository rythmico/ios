public protocol EditableView {
    associatedtype EditingFocus: EditingFocusEnum
    typealias EditingCoordinator = SwiftUISugar.EditingCoordinator<EditingFocus>
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
