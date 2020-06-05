import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView {
    enum TabSelection: Hashable {
        case lessons
        case profile
    }

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let lessonPlanFetchingCoordinator: LessonPlanFetchingCoordinatorBase
    private let lessonPlanRepository: LessonPlanRepository
    private let pushNotificationRegistrationService: PushNotificationRegistrationServiceProtocol
    private let pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerBase
    private let deauthenticationService: DeauthenticationServiceProtocol


    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        lessonPlanRepository: LessonPlanRepository,
        pushNotificationRegistrationService: PushNotificationRegistrationServiceProtocol,
        pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerBase,
        deauthenticationService: DeauthenticationServiceProtocol
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.lessonPlanFetchingCoordinator = LessonPlanFetchingCoordinator(
            service: LessonPlanFetchingService(accessTokenProvider: accessTokenProvider),
            repository: lessonPlanRepository
        )
        self.lessonPlanRepository = lessonPlanRepository
        self.pushNotificationRegistrationService = pushNotificationRegistrationService
        self.pushNotificationAuthorizationManager = pushNotificationAuthorizationManager
        self.deauthenticationService = deauthenticationService
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TabView {
            LessonsView(
                accessTokenProvider: accessTokenProvider,
                pushNotificationAuthorizationManager: pushNotificationAuthorizationManager,
                lessonPlanFetchingCoordinator: lessonPlanFetchingCoordinator,
                lessonPlanRepository: lessonPlanRepository
            )
            .tabItem {
                Image(systemSymbol: .calendar).font(.system(size: 21, weight: .medium))
                Text("LESSONS")
            }

            ProfileView(
                notificationsAuthorizationManager: pushNotificationAuthorizationManager,
                urlOpener: UIApplication.shared,
                deauthenticationService: deauthenticationService
            )
            .tabItem {
                Image(systemSymbol: .person).font(.system(size: 21, weight: .semibold))
                Text("PROFILE")
            }
        }
        .accentColor(.rythmicoPurple)
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: pushNotificationRegistrationService.registerForPushNotifications)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            lessonPlanRepository: LessonPlanRepository(),
            pushNotificationRegistrationService: PushNotificationRegistrationServiceDummy(),
            pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerDummy(),
            deauthenticationService: DeauthenticationServiceDummy()
        )
    }
}
