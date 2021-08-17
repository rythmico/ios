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
                    WhatIsRythmicoScreen.Builder()
                    LessonPlansScreen.Builder()
                    PaymentMethodsScreen.Builder()
                    ParentInfoAndSafetyScreen.Builder()
                }
            )
        }
    }
}

struct ProfileView: View, TestableView {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let inspection = SelfInspection()
    var body: some View {
        TitleContentView(title, spacing: .grid(0)) { _ in
            List {
                ProfileSection("Account") {
                    ProfileLessonPlansCell()
                    ProfilePaymentMethodsCell()
                }
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
            .listStyle(GroupedListStyle())
        }
        .backgroundColor(.rythmico.background)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingItem)
        .testable(self)
    }

    private var title: String { "Profile" }

    @ViewBuilder
    private var trailingItem: some View {
        Button.help(action: goToHelp)
            .padding(.vertical, .grid(3))
            .padding(.horizontal, .grid(7))
            .offset(x: .grid(7))
            .accessibility(label: Text("Request lessons"))
            .accessibility(hint: Text("Double tap to request a lesson plan"))
    }

    private func goToHelp() {
        navigator.go(to: WhatIsRythmicoScreen(), on: currentScreen)
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
