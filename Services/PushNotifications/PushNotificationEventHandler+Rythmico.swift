import Foundation
import Combine

final class PushNotificationEventHandler: PushNotificationEventHandlerProtocol {
    private var cancellables: [AnyCancellable] = []

    func handle(_ event: PushNotificationEvent) {
        switch event {
        case .lessonPlansChanged:
            run(\.lessonPlanFetchingService, storeInto: \.lessonPlanRepository)
        }
    }

    private func run<Request: RythmicoAPIRequest, Item>(
        _ serviceKeyPath: KeyPath<AppEnvironment, APIServiceBase<Request>>,
        storeInto repositoryKeyPath: KeyPath<AppEnvironment, Repository<Item>>
    ) where Request.Properties == Void, Request.Response == [Item] {
        guard let coordinator = Current.coordinator(for: serviceKeyPath) else {
            return
        }
        coordinator.$state
            .compactMap(\.successValue)
            .sink(receiveValue: Current[keyPath: repositoryKeyPath].setItems)
            .store(in: &cancellables)
        coordinator.runToIdle()
    }
}
