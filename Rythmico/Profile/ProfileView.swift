import SwiftUI
import ComposableNavigator

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
    var title: String { "Profile" }

    let inspection = SelfInspection()
    var body: some View {
        TitleContentView(title: title) {
            List {
                ProfileSection("Notifications") {
                    ProfilePushNotificationsCell()
                    ProfileCalendarSyncCell()
                }
                ProfileSection("Help & Support") {
                    ProfileParentInfoCell()
                    ProfileContactUsCell()
                }
                #if DEBUG
                Section {
                    ProfileLogOutCell()
                }
                #endif
            }
            .listStyle(InsetGroupedListStyle())
        }
        .backgroundColor(.rythmicoBackground)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .testable(self)
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
