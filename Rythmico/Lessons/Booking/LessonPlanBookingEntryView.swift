import SwiftUI

struct LessonPlanBookingEntryView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    @StateObject
    private var getCoordinator = Current.coordinator(for: \.lessonPlanGetCheckoutService)!

    var body: some View {
        ZStack {
            if let checkout = getCoordinator.state.successValue {
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
        .onDisappear(perform: getCoordinator.cancel)
        .alertOnFailure(getCoordinator)
        .animation(.rythmicoSpring(duration: .durationMedium), value: getCoordinator.state.successValue)
    }

    private func fetch() {
        getCoordinator.start(with: .init(lessonPlanId: lessonPlan.id))
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
