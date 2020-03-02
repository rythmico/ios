import UIKit

protocol EditingCoordinator {
    func endEditing()
}

extension UIApplication: EditingCoordinator {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

final class EditingCoordinatorSpy: EditingCoordinator {
    var endEditingCount = 0

    func endEditing() {
        endEditingCount += 1
    }
}
