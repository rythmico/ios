import Foundation

public final class NotificationCenterSpy: NotificationCenterProtocol {
    public private(set) var notificationName: NSNotification.Name?
    public private(set) var observerBlock: ((Notification) -> Void)?

    public var returnedToken: Int

    public init(returnedToken: Int) {
        self.returnedToken = returnedToken
    }

    public func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        notificationName = name
        observerBlock = block
        return NSNumber(value: returnedToken)
    }
}
