import Foundation
import Combine

final class PushNotificationEventHandler: PushNotificationEventHandlerProtocol {
    private var cancellables: [AnyCancellable] = []

    func handle(_ event: PushNotificationEvent) {
        switch event {
        case .lessonPlanUpdate: handleLessonPlanUpdateEvent()
        }
    }

    private func handleLessonPlanUpdateEvent() {
        guard let coordinator = Current.coordinator(for: \.lessonPlanFetchingService) else {
            return
        }
        coordinator.$state
            .compactMap(\.successValue)
            .sink(receiveValue: Current.lessonPlanRepository.setItems)
            .store(in: &cancellables)
        coordinator.run()
    }
}
