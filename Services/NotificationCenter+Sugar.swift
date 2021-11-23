import UIKit
import Combine

extension NotificationCenter {
    enum EventType {
        case willEnterForeground
        case didEnterBackground
        case sizeCategoryChanged

        var notificationName: Notification.Name {
            switch self {
            case .willEnterForeground:
                return UIApplication.willEnterForegroundNotification
            case .didEnterBackground:
                return UIApplication.didEnterBackgroundNotification
            case .sizeCategoryChanged:
                return UIContentSizeCategory.didChangeNotification
            }
        }
    }

    func publisher(for eventType: EventType) -> AnyPublisher<Void, Never> {
        publisher(for: eventType.notificationName).mapToVoid().eraseToAnyPublisher()
    }
}

import SwiftUI

extension View {
    func onAppEvent(
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
