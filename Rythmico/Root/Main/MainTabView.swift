import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView {
    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let pushNotificationRegistrationService: PushNotificationRegistrationServiceProtocol
    private let pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerBase
    private let deauthenticationService: DeauthenticationServiceProtocol

    @State private(set) var lessonRequestView: RequestLessonPlanView?

    func presentRequestLessonFlow() {
        lessonRequestView = RequestLessonPlanView(
            coordinator: RequestLessonPlanCoordinator(
                service: RequestLessonPlanService(accessTokenProvider: accessTokenProvider)
            ),
            context: RequestLessonPlanContext(),
            accessTokenProvider: accessTokenProvider,
            instrumentProvider: InstrumentSelectionListProviderFake(),
            keyboardDismisser: UIApplication.shared,
            notificationsAuthorizationManager: pushNotificationAuthorizationManager
        )
    }

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        pushNotificationRegistrationService: PushNotificationRegistrationServiceProtocol,
        pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerBase,
        deauthenticationService: DeauthenticationServiceProtocol
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.pushNotificationRegistrationService = pushNotificationRegistrationService
        self.pushNotificationAuthorizationManager = pushNotificationAuthorizationManager
        self.deauthenticationService = deauthenticationService
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TabView {
            NavigationView {
                Color.clear
                    .navigationBarTitle("Lessons", displayMode: .large)
                    .navigationBarItems(
                        trailing: Button(action: presentRequestLessonFlow) {
                            Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                                .padding(.vertical, .spacingExtraSmall)
                                .padding(.horizontal, .spacingExtraLarge)
                                .offset(x: .spacingExtraLarge)
                        }
                        .accessibility(label: Text("Request lessons"))
                        .accessibility(hint: Text("Double tap to request a lesson plan"))
                    )
            }
            .tabItem {
                Image(systemSymbol: .calendar).font(Font.system(size: 21, weight: .medium))
                Text("LESSONS")
            }

            NavigationView {
                ProfileView(
                    notificationsAuthorizationManager: pushNotificationAuthorizationManager,
                    deauthenticationService: deauthenticationService
                )
            }
            .tabItem {
                Image(systemSymbol: .person).font(Font.system(size: 21, weight: .semibold))
                Text("PROFILE")
            }
        }
        .accentColor(.rythmicoPurple)
        .betterSheet(item: $lessonRequestView, content: { $0 })
        .onAppear { self.didAppear?(self) }
        .onAppear(perform: pushNotificationRegistrationService.registerForPushNotifications)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            pushNotificationRegistrationService: PushNotificationRegistrationServiceDummy(),
            pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerDummy(),
            deauthenticationService: DeauthenticationServiceDummy()
        )
    }
}
