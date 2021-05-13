import SwiftUI
import ComposableNavigator
import MultiModal
import class FirebaseAuth.Auth
import FoundationSugar

struct ProfileScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                ProfileScreen.self,
                content: { ProfileView() },
                nesting: {
                    ParentInfoAndSafetyScreen.Builder()
                }
            )
        }
    }
}

struct ProfileView: View, TestableView {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    private enum Const {
        static let horizontalMargins: CGFloat = 6
    }

    @ObservedObject
    private var notificationAuthorizationCoordinator = Current.pushNotificationAuthorizationCoordinator
    @ObservedObject
    private var calendarSyncCoordinator = Current.calendarSyncCoordinator

    var pushNotificationErrorMessage: String? {
        notificationAuthorizationCoordinator.status.failedValue?.localizedDescription
    }

    func dismissPushNotificationError() {
        notificationAuthorizationCoordinator.dismissFailure()
    }

    var enablePushNotificationsAction: Action? {
        notificationAuthorizationCoordinator.status.isDetermined
            ? nil
            : notificationAuthorizationCoordinator.requestAuthorization
    }

    var goToPushNotificationsSettingsAction: Action? {
        enablePushNotificationsAction == nil
            ? { Current.urlOpener.openSettings() }
            : nil
    }

    func logOut() {
        Current.deauthenticationService.deauthenticate()
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleContentView(title: "Profile") {
            List {
                Group {
                    Section(header: header("Notifications")) {
                        cell("Push Notifications", disclosure: enablePushNotificationsAction == nil, action: goToPushNotificationsSettingsAction) {
                            enablePushNotificationsAction.map {
                                Toggle("", isOn: .constant(notificationAuthorizationCoordinator.status.isAuthorizing))
                                    .labelsHidden()
                                    .onTapGesture(perform: $0)
                            }
                        }
                        cell("Calendar Sync", disclosure: calendarSyncCoordinator.enableCalendarSyncAction == nil, action: calendarSyncCoordinator.goToCalendarAction) {
                            if calendarSyncCoordinator.isSyncingCalendar {
                                ActivityIndicator()
                            } else if let action = calendarSyncCoordinator.enableCalendarSyncAction {
                                Toggle("", isOn: .constant(calendarSyncCoordinator.isSyncingCalendar))
                                    .labelsHidden()
                                    .onTapGesture(perform: action)
                            }
                        }
                    }
                    Section(header: header("Help & Support")) {
                        cell(
                            "Parent Info & Safety",
                            disclosure: true,
                            action: { navigator.go(to: ParentInfoAndSafetyScreen(), on: currentScreen) }
                        )
                        cell(
                            "Contact Us",
                            disclosure: true,
                            action: { Current.urlOpener.open("mailto:info@rythmico.com") }
                        )
                    }
                    #if DEBUG
                    Section {
                        Button(action: logOut) {
                            HStack(alignment: .center) {
                                Text("Log out")
                                    .rythmicoTextStyle(.body)
                                    .foregroundColor(.rythmicoRed)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(minHeight: 35)
                        .accessibility(hint: Text("Double tap to log out of your account"))
                    }
                    #endif
                }
                .textCase(nil)
            }
            .listStyle(GroupedListStyle())
        }
        .navigationBarTitleDisplayMode(.inline)
        .multiModal {
            $0.alert(error: pushNotificationErrorMessage, dismiss: dismissPushNotificationError)
            $0.alert(error: calendarSyncCoordinator.error, dismiss: calendarSyncCoordinator.dismissError)
            $0.alert(item: $calendarSyncCoordinator.permissionsNeededAlert)
        }
        .testable(self)
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .rythmicoTextStyle(.subheadlineBold)
            .foregroundColor(.rythmicoForeground)
            .padding(.horizontal, Const.horizontalMargins)
            .padding(.bottom, .spacingUnit * 2)
    }

    private func cell(
        _ title: String,
        disclosure: Bool = false,
        action: Action? = nil
    ) -> some View {
        cell(title, disclosure: disclosure, action: action) { EmptyView() }
    }

    private func cell<Content: View>(
        _ title: String,
        disclosure: Bool = false,
        action: Action? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        let cellContent = HStack {
            Text(title)
                .rythmicoTextStyle(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            content()
            if disclosure {
                Image(decorative: Asset.iconDisclosure.name)
                    .renderingMode(.template)
            }
        }
        let view = action == nil
            ? AnyView(cellContent)
            : AnyView(Button(action: action!) { cellContent })
        return view
            .foregroundColor(.rythmicoGray90)
            .padding(.horizontal, Const.horizontalMargins)
            .padding(.vertical, .spacingUnit * 2)
            .frame(minHeight: 51)
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Current.pushNotificationAuthorization(
            initialStatus: .notDetermined,
//            initialStatus: .authorized,
            requestResult: (true, nil)
//            requestResult: (false, nil)
//            requestResult: (false, "Error")
        )
        return ProfileView()
    }
}
#endif
