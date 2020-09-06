import SwiftUI

struct BookingRequestsTabView: View, RoutableView {
    enum Tab: String, CaseIterable {
        case upcoming = "Upcoming"
        case applied = "Applied"
    }

    @State
    private(set) var tab: Tab = .upcoming

    private let bookingRequestsView: BookingRequestsView
    private let bookingApplicationsView: BookingApplicationsView

    init?() {
        guard
            let bookingRequestsView = BookingRequestsView(),
            let bookingApplicationsView = BookingApplicationsView()
        else {
            return nil
        }
        self.bookingRequestsView = bookingRequestsView
        self.bookingApplicationsView = bookingApplicationsView
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $tab) {
                ForEach(Tab.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 250)
            .padding(.top, .spacingUnit)
            .padding(.bottom, .spacingSmall)

            Divider()

            if tab == .upcoming {
                bookingRequestsView
            } else if tab == .applied {
                bookingApplicationsView
            }
        }
        .routable(self)
    }

    func handleRoute(_ route: Route) {
        switch route {
        case .bookingRequests:
            tab = .upcoming
            Current.router.end()
        case .bookingApplications:
            tab = .applied
            Current.router.end()
        }
    }
}

#if DEBUG
struct BookingRequestsTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsTabView()
    }
}
#endif
