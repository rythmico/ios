import SwiftUI

struct LessonPlanBookingEntryView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @StateObject
    private var coordinator = Current.coordinator(for: \.lessonPlanGetCheckoutService)!

    var body: some View {
        ZStack {
            if let checkout = coordinator.state.successValue {
                LessonPlanBookingView(
                    lessonPlan: lessonPlan,
                    application: application,
                    checkout: checkout
                )
                .transition(.opacity)
            } else {
                ActivityIndicator(color: .rythmicoGray90).transition(.opacity)
            }
        }
        .onAppear(perform: fetch)
        .onDisappear(perform: coordinator.cancel)
        .alertOnFailure(coordinator)
        .animation(.rythmicoSpring(duration: .durationMedium), value: coordinator.state.successValue)
    }

    private func fetch() {
        coordinator.start(with: .init(lessonPlanId: lessonPlan.id))
    }
}

struct LessonPlanBookingEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingEntryView(
            lessonPlan: .davidGuitarPlanStub,
            application: .davidStub
        )
    }
}
