import SwiftUISugar

struct BookingApplicationSection<HeaderAccessory: View>: View {
    private let applications: [BookingApplication]
    private let status: BookingApplication.Status
    private let headerAccessory: HeaderAccessory

    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    init(
        applications: [BookingApplication],
        status: BookingApplication.Status,
        @ViewBuilder headerAccessory: () -> HeaderAccessory
    ) {
        self.applications = applications.filter { $0.statusInfo.status == status }
        self.status = status
        self.headerAccessory = headerAccessory()
    }

    var body: some View {
        Section(
            header: HStack(spacing: .grid(2)) {
                if header.isEmpty { EmptyView() } else { Text(header) }
                headerAccessory
            },
            footer: Group {
                if footer.isEmpty { EmptyView() } else { Text(footer) }
            }
        ) {
            ForEach(applications, content: applicationCell)
        }
    }

    private var header: String {
        switch status {
        case .pending:
            return "PENDING"
        case .selected, .notSelected, .cancelled, .retracted:
            return ""
        }
    }

    @ViewBuilder
    private func applicationCell(_ application: BookingApplication) -> some View {
        if canNavigate {
            Button(action: { goToDetail(application) }) {
                BookingApplicationCell(application: application)
            }
        } else {
            BookingApplicationCell(application: application)
        }
    }

    private var canNavigate: Bool {
        switch status {
        case .pending, .selected:
            return true
        case .notSelected, .cancelled, .retracted:
            return false
        }
    }

    private func goToDetail(_ application: BookingApplication) {
        navigator.go(to: BookingApplicationDetailScreen(bookingApplication: application), on: currentScreen)
    }

    private var footer: String {
        switch status {
        case .selected:
            return "You’ve been selected for these requests. These lesson plans will now appear on your Schedule tab."
        case .notSelected:
            return "Unfortunately you weren’t selected for these requests. Please go to the Requests tab to find more requests."
        case .cancelled:
            return "These requests were cancelled by the parent/guardian. Please go to the Requests tab to find more requests."
        case .pending, .retracted:
            return ""
        }
    }
}

extension BookingApplicationSection where HeaderAccessory == EmptyView {
    init(applications: [BookingApplication], status: BookingApplication.Status) {
        self.init(applications: applications, status: status, headerAccessory: { EmptyView() })
    }
}
