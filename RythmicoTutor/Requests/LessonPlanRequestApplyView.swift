import ComposableNavigator
import SwiftUIEncore
import TutorDO

struct LessonPlanRequestApplyScreen: Screen {
    let lessonPlanRequest: LessonPlanRequest
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanRequestApplyScreen) in
                    LessonPlanRequestApplyView(lessonPlanRequest: screen.lessonPlanRequest)
                }
            )
        }
    }
}

struct LessonPlanRequestApplyView: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen
    @StateObject
    private var coordinator = Current.lessonPlanApplicationCreationCoordinator()

    var lessonPlanRequest: LessonPlanRequest

    @State
    var privateNote = ""

    func submit() {
        Current.keyboardDismisser.dismissKeyboard()
        coordinator.run(with: .init(body: .init(requestID: lessonPlanRequest.id, privateNote: privateNote)))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Section(header: header, footer: footer) {
                        MultilineTextField(
                            "Add a private note...",
                            text: $privateNote,
                            inputAccessory: .none,
                            minHeight: .grid(20)
                        )
                        .padding(.vertical, .grid(1))
                    }
                }
                .listStyle(GroupedListStyle())

                FloatingView {
                    RythmicoButton("Submit Application", style: .primary(), action: submit)
                }
            }
            .navigationBarTitle(Text("Application"), displayMode: .inline)
            .navigationBarItems(trailing: trailingBarItem)
        }
        .interactiveDismissDisabled(interactiveDismissDisabled)
        .disabled(coordinator.state.isLoading)
        .animation(.easeInOut(duration: .durationMedium), value: coordinator.state.isLoading)
        .alertOnFailure(coordinator)
        .onSuccess(coordinator, perform: finalize)
    }

    @ViewBuilder
    private var trailingBarItem: some View {
        if coordinator.state.isLoading {
            ActivityIndicator()
        } else {
            Button("Close", action: dismiss)
        }
    }

    private var header: some View {
        Text("Add a private note").textCase(.uppercase)
    }

    private var footer: Text {
        Text("Increase your chances of being selected by sending a private message detailing your experience and how you intend to teach.")
    }

    private var interactiveDismissDisabled: Bool {
        !privateNote.isEmpty || !coordinator.isReady
    }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }

    private func finalize(_ application: LessonPlanApplication) {
        Current.lessonPlanApplicationRepository.insertItem(application)
        Current.tabSelection.requestsTab = .applied
        navigator.goBack(to: .root)
    }
}

#if DEBUG
struct LessonPlanApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanRequestApplyView(lessonPlanRequest: .stub)
            .environment(\.colorScheme, .dark)
    }
}
#endif
