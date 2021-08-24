import SwiftUIEncore
import ComposableNavigator

struct ProfileParentInfoCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var body: some View {
        ProfileCell("Parent Info & Safety", disclosure: true) {
            navigator.go(to: ParentInfoAndSafetyScreen(), on: currentScreen)
        }
    }
}
