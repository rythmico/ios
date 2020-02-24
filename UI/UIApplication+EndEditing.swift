import UIKit

protocol EditingCoordinator {
    func endEditing()
}

extension UIApplication: EditingCoordinator {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
