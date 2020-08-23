import SwiftUI

struct BookingApplicationsView: View {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingApplicationsGetRequest>
    @ObservedObject
    private var repository = Current.bookingApplicationRepository

    @State
    private var selectedBookingApplication: BookingApplication?

    init?() {
        guard let coordinator = Current.coordinator(for: \.bookingApplicationFetchingService) else {
            return nil
        }
        self.coordinator = coordinator
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var applications: [BookingApplication] { repository.items }

    var body: some View {
        VStack(spacing: .spacingMedium) {
            List {
                Section(
                    header: HStack {
                        Text("PENDING")
                        if isLoading {
                            ActivityIndicator(style: .medium)
                                .transition(AnyTransition.opacity.combined(with: .scale))
                        }
                    }
                ) {
                    ForEach(applications) { application in
                        NavigationLink(
                            destination: BookingApplicationDetailView(bookingApplication: application),
                            tag: application,
                            selection: self.$selectedBookingApplication,
                            label: { BookingApplicationCell(application: application) }
                        )
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .onAppear(perform: fetchOnAppear)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    @State
    private var didAppear = false
    private func fetchOnAppear() {
        guard !didAppear else { return }
        coordinator.run()
        didAppear = true
    }
}

#if DEBUG
struct BookingApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationsView()
    }
}
#endif
