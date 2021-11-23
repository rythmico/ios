import SwiftUIEncore
import Combine
import ComposableNavigator

struct BookingApplicationsView: View {
    @Environment(\.scenePhase)
    private var scenePhase
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen
    @ObservedObject
    private var tabSelection = Current.tabSelection
    @ObservedObject
    private var lessonPlanRequestsTabNavigation = Current.lessonPlanRequestsTabNavigation
    @ObservedObject
    private var coordinator = Current.bookingApplicationFetchingCoordinator
    @ObservedObject
    private var repository = Current.bookingApplicationRepository

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.output?.error }
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
        .onReceive(shouldFetchPublisher(), perform: fetch)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
        .onAPIEvent(.bookingApplicationsChanged, perform: coordinator.reset)
        .onAppEvent(.didEnterBackground, perform: coordinator.reset)
    }

    private func applicationGroupCell(for status: BookingApplication.Status) -> some View {
        Button(action: { goToGroup(for: status) }) {
            BookingApplicationGroupCell(status: status, applications: applications)
        }
        .disabled(numberOfApplications(withStatus: status) == 0)
    }

    private func goToGroup(for status: BookingApplication.Status) {
        navigator.go(to: BookingApplicationGroupScreen(applications: applications, status: status), on: currentScreen)
    }

    private func numberOfApplications(withStatus status: BookingApplication.Status) -> Int {
        applications.count { $0.statusInfo.status == status }
    }

    private func shouldFetchPublisher() -> AnyPublisher<Void, Never> {
        coordinator.$state.zip(onRequestsAppliedTabRootPublisher()).b
    }

    private func onRequestsAppliedTabRootPublisher() -> AnyPublisher<Void, Never> {
        tabSelection.$mainTab.combineLatest(tabSelection.$requestsTab, lessonPlanRequestsTabNavigation.$path.map(\.current))
            .filter { $0 == .requests && $1 == .applied && $2.is(LessonPlanRequestsTabScreen()) }
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

#if DEBUG
struct BookingApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationsView()
    }
}
#endif
