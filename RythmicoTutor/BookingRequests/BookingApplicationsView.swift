import SwiftUI
import Combine

struct BookingApplicationsView: View {
    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var navigation = Current.navigation
    @ObservedObject
    private var coordinator = Current.bookingApplicationFetchingCoordinator
    @ObservedObject
    private var repository = Current.bookingApplicationRepository
    @State
    private var selectedBookingApplicationGroup: BookingApplication.Status?

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var applications: [BookingApplication] { repository.items }

    var body: some View {
        VStack(spacing: .grid(5)) {
            List {
                BookingApplicationSection(applications: applications, status: .pending) {
                    if isLoading {
                        ActivityIndicator()
                    }
                }
                Section(header: Text("OTHER STATUS")) {
                    ForEach([.selected, .notSelected, .cancelled], id: \.self, content: applicationGroupCell)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .onReceive(coordinator.$state.zip(navigation.onRequestsAppliedTabRootPublisher).b, perform: fetch)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func applicationGroupCell(for status: BookingApplication.Status) -> some View {
        NavigationLink(
            destination: BookingApplicationGroupView(applications: applications, status: status),
            tag: status,
            selection: $selectedBookingApplicationGroup,
            label: { BookingApplicationGroupCell(status: status, applications: applications) }
        )
        .disabled(numberOfApplications(withStatus: status) == 0)
    }

    private func numberOfApplications(withStatus status: BookingApplication.Status) -> Int {
        applications.count { $0.statusInfo.status == status }
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

private extension AppNavigation {
    var onRequestsAppliedTabRootPublisher: AnyPublisher<Void, Never> {
        $selectedTab.combineLatest($requestsFilter, $requestsNavigation)
            .filter { $0 == (.requests, .applied, .none) }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

#if DEBUG
struct BookingApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationsView()
    }
}
#endif
