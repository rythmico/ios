import SwiftUI
import ComposableNavigator

struct AddNewCardEntryScreen: Screen {
    var availableCards: Binding<[Card]>
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    func hash(into hasher: inout Hasher) {
        hasher.combine(presentationStyle)
    }

    static func == (lhs: AddNewCardEntryScreen, rhs: AddNewCardEntryScreen) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: AddNewCardEntryScreen) in
                    AddNewCardEntryView(availableCards: screen.availableCards)
                }
            )
        }
    }
}

struct AddNewCardEntryView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    @Binding var availableCards: [Card]

    @StateObject
    private var coordinator = Current.cardSetupCredentialFetchingCoordinator()

    var body: some View {
        NavigationView {
            ZStack {
                Color.rythmico.backgroundSecondary.edgesIgnoringSafeArea(.all)
                if let credential = coordinator.state.successValue {
                    AddNewCardView(credential: credential, availableCards: $availableCards).transition(.opacity)
                } else {
                    ActivityIndicator(color: .rythmico.gray90)
                        .transition(.opacity)
                        .navigationBarItems(trailing: CloseButton(action: dismiss))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(.rythmico.purple)
        .onAppear(perform: coordinator.start)
        .onDisappear(perform: coordinator.cancel)
        .alertOnFailure(coordinator, onDismiss: dismiss)
        .animation(.rythmicoSpring(duration: .durationMedium), value: coordinator.state.successValue)
    }

    func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }
}

#if DEBUG
struct AddNewCardEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingEntryView(
            lessonPlan: .pendingDavidGuitarPlanStub,
            application: .davidStub
        )
    }
}
#endif
