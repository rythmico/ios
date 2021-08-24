import SwiftUIEncore
import Combine
import ComposableNavigator

struct BookingRequestsView: View {
    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var tabSelection = Current.tabSelection
    @ObservedObject
    private var bookingRequestsTabNavigation = Current.bookingRequestsTabNavigation
    @ObservedObject
    private var coordinator = Current.bookingRequestFetchingCoordinator
    @ObservedObject
    private var repository = Current.bookingRequestRepository

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var requests: [BookingRequest] { repository.items }

    var body: some View {
        List {
            Section(
                header: HStack(spacing: .grid(2)) {
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

        .onReceive(shouldFetchPublisher(), perform: fetch)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func shouldFetchPublisher() -> AnyPublisher<Void, Never> {
        coordinator.$state.zip(onRequestsOpenTabRootPublisher()).b
    }

    private func onRequestsOpenTabRootPublisher() -> AnyPublisher<Void, Never> {
        tabSelection.$mainTab.combineLatest(tabSelection.$requestsTab, bookingRequestsTabNavigation.$path.map(\.current))
            .filter { $0 == .requests && $1 == .open && $2.is(BookingRequestsTabScreen()) }
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
