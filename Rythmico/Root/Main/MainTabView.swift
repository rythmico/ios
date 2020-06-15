import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView {
    enum TabSelection: Hashable {
        case lessons
        case profile
    }

    @State
    private var tabSelection: TabSelection = .lessons

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
        TabView(selection: $tabSelection) {
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
