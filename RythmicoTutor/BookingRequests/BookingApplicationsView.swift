import SwiftUI

struct BookingApplicationsView: View {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingApplicationsGetRequest>
    @ObservedObject
    private var repository = Current.bookingApplicationRepository

    @State
    private var selectedBookingApplication: BookingApplication?
    @State
    private var selectedBookingApplicationGroup: BookingApplication.Status?

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
                BookingApplicationSection(applications: applications, status: .pending) {
                    if isLoading {
                        ActivityIndicator(style: .medium).transition(AnyTransition.opacity.combined(with: .scale))
                    }
                }
                Section(header: Text("OTHER STATUS")) {
                    ForEach([.selected, .notSelected, .cancelled], id: \.self, content: applicationGroupCell)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .onAppear(perform: fetchOnAppear)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    @ViewBuilder
    private func applicationGroupCell(for status: BookingApplication.Status) -> some View {
        if numberOfApplications(withStatus: status) > 0 {
            NavigationLink(
                destination: BookingApplicationGroupView(applications: applications, status: status),
                tag: status,
                selection: $selectedBookingApplicationGroup,
                label: { BookingApplicationGroupCell(status: status, applications: applications) }
            )
        } else {
            BookingApplicationGroupCell(status: status, applications: applications)
        }
    }

    private func numberOfApplications(withStatus status: BookingApplication.Status) -> Int {
        applications.filter { $0.statusInfo.status == status }.count // TODO: count(where:)
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
