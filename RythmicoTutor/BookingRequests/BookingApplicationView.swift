import SwiftUI

struct BookingApplicationView: View {
    @Environment(\.presentationMode)
    private var presentationMode
    @ObservedObject
    private var coordinator: APIActivityCoordinator<CreateBookingApplicationRequest>
    private let booking: BookingRequest

    init?(booking: BookingRequest) {
        guard let coordinator = Current.coordinator(for: \.bookingApplicationCreatingService) else {
            return nil
        }
        self.coordinator = coordinator
        self.booking = booking
    }

    @State
    var privateNote = ""

    func submit() {
        coordinator.run(with: (id: booking.id, body: .init(privateNote: privateNote)))
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
        .onSuccess(coordinator, perform: dismiss)
    }

    @ViewBuilder
    private var trailingBarItem: some View {
        if coordinator.state.isLoading {
            ActivityIndicator(style: .medium)
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
        privateNote.isEmpty && coordinator.state.isIdle
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct BookingApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationView(booking: .stub)
            .environment(\.colorScheme, .dark)
    }
}
#endif
