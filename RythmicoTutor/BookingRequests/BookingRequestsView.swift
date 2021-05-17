import SwiftUI
import Combine

struct BookingRequestsView: View {
    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var navigation = Current.navigation
    @ObservedObject
    private var coordinator = Current.bookingRequestFetchingCoordinator
    @ObservedObject
    private var repository = Current.bookingRequestRepository
    @ObservedObject
    private var applicationRepository = Current.bookingApplicationRepository

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var requests: [BookingRequest] {
        // Optimization to remove already-applied requests before fetch.
        repository.items.filter { request in
            !applicationRepository.items.contains {
                $0.statusInfo.status == .pending && $0.bookingRequestId == request.id
            }
        }
    }

    var body: some View {
        List {
            Section(
                header: HStack(spacing: .spacingUnit * 2) {
                    Text("UPCOMING")
                    if isLoading {
                        ActivityIndicator()
                    }
                }
            ) {
                ForEach(requests, content: BookingRequestCell.init)
            }
        }
        .listStyle(GroupedListStyle())
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)

        .onReceive(coordinator.$state.zip(navigation.onRequestsOpenTabRootPublisher).b, perform: fetch)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

private extension AppNavigation {
    var onRequestsOpenTabRootPublisher: AnyPublisher<Void, Never> {
        $selectedTab.combineLatest($requestsFilter, $requestsNavigation)
            .filter { $0 == (.requests, .open, .none) }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
