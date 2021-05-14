import SwiftUI
import ComposableNavigator

struct LessonPlanBookingEntryScreen: Screen {
    let lessonPlan: LessonPlan
    let application: LessonPlan.Application
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanBookingEntryScreen) in
                    LessonPlanBookingEntryView(
                        lessonPlan: screen.lessonPlan,
                        application: screen.application
                    )
                },
                nesting: {
                    AddNewCardEntryScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanBookingEntryView: View {
    @Environment(\.presentationMode) private var presentationMode

    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @StateObject
    private var coordinator = Current.lessonPlanGetCheckoutCoordinator()

    var body: some View {
        NavigationView {
            ZStack {
                if let checkout = coordinator.state.successValue {
                    LessonPlanBookingView(
                        lessonPlan: lessonPlan,
                        application: application,
                        checkout: checkout
                    )
                    .transition(.opacity)
                } else {
                    ActivityIndicator(color: .rythmicoGray90)
                        .transition(.opacity)
                        .navigationBarItems(trailing: CloseButton(action: dismiss))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheetInteractiveDismissal(false)
        .accentColor(.rythmicoPurple)
        .onAppear(perform: fetch)
        .onDisappear(perform: coordinator.cancel)
        .alertOnFailure(coordinator)
        .animation(.rythmicoSpring(duration: .durationMedium), value: coordinator.state.successValue)
    }

    private func fetch() {
        coordinator.start(with: .init(lessonPlanId: lessonPlan.id, applicationId: application.tutor.id))
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct LessonPlanBookingEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingEntryView(
            lessonPlan: .davidGuitarPlanStub,
            application: .davidStub
        )
    }
}
#endif
