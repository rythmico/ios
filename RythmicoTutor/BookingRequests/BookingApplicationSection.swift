import SwiftUI

struct BookingApplicationSection<HeaderAccessory: View>: View {
    private let applications: [BookingApplication]
    private let status: BookingApplication.Status
    private let headerAccessory: HeaderAccessory

    @State
    private var selectedBookingApplication: BookingApplication?

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
            header: HStack {
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
            NavigationLink(
                destination: BookingApplicationDetailView(bookingApplication: application),
                tag: application,
                selection: $selectedBookingApplication,
                label: { BookingApplicationCell(application: application) }
            )
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
