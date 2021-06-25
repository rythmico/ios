import SwiftUISugar

typealias _EditingCoordinator<Focus: EditingFocusEnum> = EditingCoordinator<Focus>

protocol EditableView {
    associatedtype EditingFocus: EditingFocusEnum
    typealias EditingCoordinator = _EditingCoordinator<EditingFocus>
    var editingCoordinator: EditingCoordinator { get }
}

extension EditableView {
    var editingFocus: EditingFocus? {
        get { editingCoordinator.focus }
        nonmutating set { editingCoordinator.focus = newValue }
    }

    func endEditing() {
        editingCoordinator.endEditing()
    }
}
