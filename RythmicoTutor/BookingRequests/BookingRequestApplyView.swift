import SwiftUI

struct BookingRequestApplyView: View {
    @Environment(\.presentationMode)
    private var presentationMode
    @StateObject
    private var coordinator: APIActivityCoordinator<BookingRequestApplyRequest>
    private let booking: BookingRequest

    init?(booking: BookingRequest) {
        guard let coordinator = Current.coordinator(for: \.bookingRequestApplyingService) else {
            return nil
        }
        self._coordinator = .init(wrappedValue: coordinator)
        self.booking = booking
    }

    @State
    var privateNote = ""

    func submit() {
        Current.keyboardDismisser.dismissKeyboard()
        coordinator.run(with: (bookingRequestId: booking.id, body: .init(privateNote: privateNote)))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Section(header: header, footer: footer) {
                        MultilineTextField(
                            "Add a private note...",
                            text: $privateNote,
                            minHeight: .spacingUnit * 20
                        )
                        .padding(.vertical, .spacingUnit)
                    }
                }
                .listStyle(GroupedListStyle())

                FloatingView {
                    Button("Submit Application", action: submit).primaryStyle()
                }
            }
            .navigationBarTitle(Text("Application"), displayMode: .inline)
            .navigationBarItems(trailing: trailingBarItem)
        }
        .sheetInteractiveDismissal(interactiveDismissalEnabled)
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

    private var header: Text {
        Text("Add a private note".uppercased())
    }

    private var footer: Text {
        Text("Increase your chances of being selected by sending a private message detailing your experience and how you intend to teach.")
    }

    private var interactiveDismissalEnabled: Bool {
        privateNote.isEmpty && coordinator.state.isReady
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private func finalize(_ application: BookingApplication) {
        Current.router.open(.bookingApplications)
        // FIXME: workaround for crash. Investigate.
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            Current.bookingApplicationRepository.insertItem(application)
        }
    }
}

#if DEBUG
struct BookingApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestApplyView(booking: .stub)
            .environment(\.colorScheme, .dark)
    }
}
#endif
