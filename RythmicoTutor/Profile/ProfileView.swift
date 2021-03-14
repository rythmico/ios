import SwiftUI
import MultiModal
import class FirebaseAuth.Auth
import FoundationSugar

struct ProfileView: View, TestableView {
//    private enum Const {
//        static let horizontalMargins: CGFloat = 6
//    }

    @ObservedObject
    private var notificationAuthorizationCoordinator = Current.pushNotificationAuthorizationCoordinator
    @StateObject
    private var calendarSyncCoordinator = Current.calendarSyncCoordinator()!

    func logOut() {
        Current.deauthenticationService.deauthenticate()
    }

    let inspection = SelfInspection()
    var body: some View {
        List {
            Group {
                Section(header: header("Notifications")) {
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
                                .font(.body)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(minHeight: 35)
                    .accessibility(hint: Text("Double tap to log out of your account"))
                }
                #endif
            }
//            .textCase(nil)
        }
        .listStyle(GroupedListStyle())
        .multiModal {
            $0.alert(error: calendarSyncCoordinator.error, dismiss: calendarSyncCoordinator.dismissError)
            $0.alert(item: $calendarSyncCoordinator.permissionsNeededAlert)
        }
        .testable(self)
    }

    private func header(_ title: String) -> some View {
        Text(title)
//            .font(.subheadline)
            .foregroundColor(.secondary)
//            .padding(.horizontal, Const.horizontalMargins)
//            .padding(.bottom, .spacingUnit * 2)
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
                Image(systemSymbol: .chevronRight)
                    .renderingMode(.template)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
        }
        let view = action == nil
            ? AnyView(cellContent)
            : AnyView(Button(action: action!) { cellContent })
        return view
            .font(.body)
            .foregroundColor(.primary)
//            .padding(.horizontal, Const.horizontalMargins)
//            .padding(.vertical, .spacingUnit * 2)
            .frame(minHeight: 48)
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
