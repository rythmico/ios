import Foundation

final class NotificationCenterSpy: NotificationCenterProtocol {
    var notificationName: NSNotification.Name?
    var observerBlock: ((Notification) -> Void)?
    var returnedToken: Int

    init(returnedToken: Int) {
        self.returnedToken = returnedToken
    }

    func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        notificationName = name
        observerBlock = block
        return NSNumber(value: returnedToken)
    }
}
