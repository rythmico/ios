import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView {
    enum TabSelection: Hashable {
        case lessons
        case profile
    }

    final class ViewState: ObservableObject {
        @Published var tabSelection: TabSelection = .lessons
    }

    @ObservedObject
    private var state = ViewState()

    private let lessonsView: LessonsView
    private let profileView: ProfileView = ProfileView()

    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let lessonsView = LessonsView(),
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
        self.lessonsView = lessonsView
        self.deviceRegisterCoordinator = deviceRegisterCoordinator
    }

    var onAppear: Handler<Self>?
    var body: some View {
        TabView(selection: $state.tabSelection) {
            lessonsView
                .tag(TabSelection.lessons)
                .tabItem {
                    Image(systemSymbol: .calendar).font(.system(size: 21, weight: .medium))
                    Text("LESSONS")
                }

            profileView
                .tag(TabSelection.profile)
                .tabItem {
                    Image(systemSymbol: .person).font(.system(size: 21, weight: .semibold))
                    Text("PROFILE")
                }
        }
        .onReceive(state.$tabSelection) { tabSelection in
            if self.state.tabSelection == .profile, tabSelection == .lessons {
                self.lessonsView.fetchLessonPlans()
            }
        }
        .accentColor(.rythmicoPurple)
        .onAppear { self.onAppear?(self) }
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(
            result: .success(.stub),
            delay: 2
        )

        return MainTabView()
    }
}
#endif
