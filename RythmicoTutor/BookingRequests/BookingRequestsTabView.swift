import SwiftUI

struct BookingRequestsTabView: View {
    enum Tab: String, CaseIterable {
        case upcoming = "Upcoming"
        case applied = "Applied"
    }

    @ObservedObject
    private var state = Current.state

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
            Picker("", selection: $state.requestsTab) {
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

            if state.requestsTab == .upcoming {
                bookingRequestsView
            } else if state.requestsTab == .applied {
                bookingApplicationsView
            }
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
