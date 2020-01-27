import Foundation

protocol NotificationCenterProtocol {
    func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol
}

extension NotificationCenter: NotificationCenterProtocol {}


