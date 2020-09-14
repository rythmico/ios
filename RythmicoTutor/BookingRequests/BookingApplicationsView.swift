import SwiftUI

struct BookingApplicationsView: View, VisibleView {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingApplicationsGetRequest>
    @ObservedObject
    private var repository = Current.bookingApplicationRepository

    @State
    private var selectedBookingApplicationGroup: BookingApplication.Status?
    @State
    private(set) var isVisible = false; var isVisibleBinding: Binding<Bool> { $isVisible }

    init?() {
        guard let coordinator = Current.sharedCoordinator(for: \.bookingApplicationFetchingService) else {
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
                        ActivityIndicator().transition(AnyTransition.opacity.combined(with: .scale))
                    }
                }
                Section(header: Text("OTHER STATUS")) {
                    ForEach([.selected, .notSelected, .cancelled], id: \.self, content: applicationGroupCell)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .visible(self)
        .onAppearOrForeground(self, perform: coordinator.startToIdle)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func applicationGroupCell(for status: BookingApplication.Status) -> some View {
        NavigationLink(
            destination: BookingApplicationGroupView(applications: applications, status: status),
            tag: status,
            selection: $selectedBookingApplicationGroup,
            label: { BookingApplicationGroupCell(status: status, applications: applications) }
        )
        .disabled(numberOfApplications(withStatus: status) == 0)
    }

    private func numberOfApplications(withStatus status: BookingApplication.Status) -> Int {
        applications.count { $0.statusInfo.status == status }
    }
}

#if DEBUG
struct BookingApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationsView()
    }
}
#endif
