import UIKit
import Combine

extension NotificationCenter {
    enum EventType {
        case appInForeground
        case appInBackground
        case sizeCategoryChanged

        var notificationName: Notification.Name {
            switch self {
            case .appInForeground:
                return UIApplication.willEnterForegroundNotification
            case .appInBackground:
                return UIApplication.didEnterBackgroundNotification
            case .sizeCategoryChanged:
                return UIContentSizeCategory.didChangeNotification
            }
        }
    }

    func publisher(for eventType: EventType) -> AnyPublisher<Void, Never> {
        publisher(for: eventType.notificationName).map { _ in }.eraseToAnyPublisher()
    }
}

import SwiftUI

extension View {
    func onEvent(
        _ eventType: NotificationCenter.EventType,
        emitter: NotificationCenter = Current.eventEmitter,
        perform action: @escaping () -> Void
    ) -> some View {
        onReceive(
            emitter.publisher(for: eventType),
            perform: action
        )
    }
}
