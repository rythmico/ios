import SwiftUIEncore
import ComposableNavigator

struct WhatIsRythmicoScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                WhatIsRythmicoScreen.self,
                content: { WhatIsRythmicoView() }
            )
        }
    }
}

struct WhatIsRythmicoView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var body: some View {
        InstructionalView(.whatIsRythmico, animated: false) {
            RythmicoButton("OK", style: .primary(), action: dismiss)
        }
        .backgroundColor(.rythmico.backgroundSecondary)
    }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }
}
