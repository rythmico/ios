import Combine
import ComposableNavigator
import TutorDO
import SwiftUIEncore

struct LessonPlanRequestsView: View {
    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var tabSelection = Current.tabSelection
    @ObservedObject
    private var lessonPlanRequestsTabNavigation = Current.lessonPlanRequestsTabNavigation
    @ObservedObject
    private var coordinator = Current.lessonPlanRequestFetchingCoordinator
    @ObservedObject
    private var repository = Current.lessonPlanRequestRepository

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.output?.error }
    var requests: [LessonPlanRequest] { repository.items }

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
                ForEach(requests, content: LessonPlanRequestCell.init)
            }
        }
        .listStyle(GroupedListStyle())
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)

        .onReceive(shouldFetchPublisher(), perform: fetch)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
        .onReceive(Current.apiEventListener.on(.lessonPlanRequestsChanged)) {
            coordinator.reset()
        }
    }

    private func shouldFetchPublisher() -> AnyPublisher<Void, Never> {
        coordinator.$state.zip(onRequestsOpenTabRootPublisher()).b
    }

    private func onRequestsOpenTabRootPublisher() -> AnyPublisher<Void, Never> {
        tabSelection.$mainTab.combineLatest(tabSelection.$requestsTab, lessonPlanRequestsTabNavigation.$path.map(\.current))
            .filter { $0 == .requests && $1 == .open && $2.is(LessonPlanRequestsTabScreen()) }
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

#if DEBUG
struct LessonPlanRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanRequestsView()
    }
}
#endif
