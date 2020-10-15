import SwiftUI

struct AddNewCardEntryView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var availableCards: [Card]

    @StateObject
    private var coordinator = Current.coordinator(for: \.cardSetupCredentialFetchingService)!

    var body: some View {
        ZStack {
            if let credential = coordinator.state.successValue {
                AddNewCardView(credential: credential, availableCards: $availableCards).transition(.opacity)
            } else {
                ActivityIndicator(color: .rythmicoGray90).transition(.opacity)
            }
        }
        .onAppear(perform: coordinator.start)
        .onDisappear(perform: coordinator.cancel)
        .alertOnFailure(coordinator, onDismiss: dismiss)
        .animation(.rythmicoSpring(duration: .durationMedium), value: coordinator.state.successValue)
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddNewCardEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingEntryView(
            lessonPlan: .davidGuitarPlanStub,
            application: .davidStub
        )
    }
}
