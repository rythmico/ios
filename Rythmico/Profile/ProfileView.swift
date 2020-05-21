import SwiftUI
import class FirebaseAuth.Auth
import Sugar

struct ProfileView: View {
    private enum Const {
        static let horizontalMargins: CGFloat = 6
    }

    @State private var pushNotificationsEnabled = false

    @ObservedObject
    private var notificationsAuthorizationManager: PushNotificationAuthorizationManagerBase
    private let deauthenticationService: DeauthenticationServiceProtocol

    init(
        notificationsAuthorizationManager: PushNotificationAuthorizationManagerBase,
        deauthenticationService: DeauthenticationServiceProtocol
    ) {
        self.notificationsAuthorizationManager = notificationsAuthorizationManager
        self.deauthenticationService = deauthenticationService
    }

    var pushNotificationsAction: Action? {
        guard notificationsAuthorizationManager.status == .notDetermined else {
            return nil
        }
        return {
            self.notificationsAuthorizationManager.requestAuthorization { error in
                self.pushNotificationsEnabled = false
                self.errorMessage = error.localizedDescription
            }
        }
    }

    var goToPushNotificationsSettingsAction: Action? {
        guard notificationsAuthorizationManager.status != .notDetermined else {
            return nil
        }
        return {
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil
            )
        }
    }

    @State
    var errorMessage: String?

    var body: some View {
        Form {
            Section(header: header("Notifications")) {
                cell(
                    "Push Notifications",
                    disclosure: pushNotificationsAction == nil,
                    action: goToPushNotificationsSettingsAction
                ) {
                    pushNotificationsAction.map {
                        Toggle("", isOn: $pushNotificationsEnabled).onTapGesture(perform: $0)
                    }
                }

            }
            Section {
                Button(action: deauthenticationService.deauthenticate) {
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
        .alert(item: $errorMessage) { Alert(title: Text("An error ocurred"), message: Text($0)) }
        .navigationBarTitle(Text("Profile"), displayMode: .large)
    }

    func header(_ title: String) -> some View {
        Text(title)
            .rythmicoFont(.headline)
            .foregroundColor(.rythmicoForeground)
            .padding(.horizontal, Const.horizontalMargins)
            .padding(.bottom, .spacingUnit * 2)
    }

    func cell<Content: View>(
        _ title: String,
        disclosure: Bool = false
    ) -> some View {
        cell(title, disclosure: disclosure) { EmptyView() }
    }

    func cell<Content: View>(
        _ title: String,
        disclosure: Bool = false,
        action: Action? = nil,
        content: () -> Content
    ) -> some View {
        let cellContent = HStack {
            Text(title)
            Spacer()
            content()
            if disclosure {
                Image(decorative: Asset.disclosureIndicator.name)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = PushNotificationAuthorizationManagerStub(
            status: .notDetermined,
//            requestAuthorizationResult: .success(true)
            requestAuthorizationResult: .failure("something")
        )
        return ProfileView(
            notificationsAuthorizationManager: manager,
            deauthenticationService: DeauthenticationServiceDummy()
        )
    }
}
