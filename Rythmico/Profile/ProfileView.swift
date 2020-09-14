import SwiftUI
import class FirebaseAuth.Auth
import Sugar

struct ProfileView: View, TestableView {
    private enum Const {
        static let horizontalMargins: CGFloat = 6
    }

    @ObservedObject
    private var notificationAuthorizationCoordinator = Current.pushNotificationAuthorizationCoordinator

    var errorMessage: String? {
        notificationAuthorizationCoordinator.status.failedValue?.localizedDescription
    }

    var enablePushNotificationsAction: Action? {
        notificationAuthorizationCoordinator.status.isDetermined
            ? nil
            : notificationAuthorizationCoordinator.requestAuthorization
    }

    var goToPushNotificationsSettingsAction: Action? {
        notificationAuthorizationCoordinator.status.isDetermined
            ? { Current.urlOpener.open(UIApplication.openSettingsURLString) }
            : nil
    }

    func dismissError() {
        notificationAuthorizationCoordinator.dismissFailure()
    }

    func logOut() {
        Current.deauthenticationService.deauthenticate()
    }

    let inspection = SelfInspection()
    var body: some View {
        List {
            Section(header: header("Notifications")) {
                cell(
                    "Push Notifications",
                    disclosure: enablePushNotificationsAction == nil,
                    action: goToPushNotificationsSettingsAction
                ) {
                    enablePushNotificationsAction.map {
                        Toggle("", isOn: .constant(notificationAuthorizationCoordinator.status.isAuthorizing))
                            .onTapGesture(perform: $0)
                    }
                }
            }
            Section {
                Button(action: logOut) {
                    HStack(alignment: .center) {
                        Text("Log out")
                            .rythmicoFont(.body)
                            .foregroundColor(.rythmicoRed)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(minHeight: 35)
                .accessibility(hint: Text("Double tap to log out of your account"))
            }
        }
        .listStyle(GroupedListStyle())
        .alert(error: errorMessage, dismiss: dismissError)
        .testable(self)
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .rythmicoFont(.subheadlineBold)
            .foregroundColor(.rythmicoForeground)
            .padding(.horizontal, Const.horizontalMargins)
            .padding(.bottom, .spacingUnit * 2)
    }

    private func cell<Content: View>(
        _ title: String,
        disclosure: Bool = false
    ) -> some View {
        cell(title, disclosure: disclosure) { EmptyView() }
    }

    private func cell<Content: View>(
        _ title: String,
        disclosure: Bool = false,
        action: Action? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        let cellContent = HStack {
            Text(title).frame(maxWidth: .infinity, alignment: .leading)
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
            .rythmicoFont(.body)
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
