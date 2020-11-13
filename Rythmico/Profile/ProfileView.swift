import SwiftUI
import class FirebaseAuth.Auth
import Sugar

struct ProfileView: View, TestableView {
    private enum Const {
        static let horizontalMargins: CGFloat = 6
    }

    private enum Page {
        case parentInfoAndSafety
    }

    @ObservedObject
    private var notificationAuthorizationCoordinator = Current.pushNotificationAuthorizationCoordinator
    @State
    private var page: Page?

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
            Group {
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
                Section(header: header("Help & Support")) {
                    ZStack {
                        cell("Parent Info & Safety", disclosure: true)
                        NavigationLink(
                            destination: ParentInfoAndSafetyView(),
                            tag: .parentInfoAndSafety,
                            selection: $page,
                            label: { EmptyView() }
                        )
                        .frame(width: 0)
                        .opacity(0)
                    }
                    cell(
                        "Contact Us",
                        disclosure: true,
                        action: { Current.urlOpener.open("mailto:info@rythmico.com") }
                    )
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
            .textCase(nil)
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
