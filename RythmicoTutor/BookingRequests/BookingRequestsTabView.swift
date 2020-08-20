import SwiftUI

struct BookingRequestsTabView: View {
    enum Screen: String, CaseIterable {
        case upcoming = "Upcoming"
        case applied = "Applied"
    }

    @State
    private(set) var screen: Screen = .upcoming

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $screen) {
                ForEach(Screen.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 250)
            .padding(.top, .spacingUnit)
            .padding(.bottom, .spacingSmall)

            Divider()

            if screen == .upcoming {
                BookingRequestsView()
            } else if screen == .applied {
                Color.white // TODO
            }
        }
        .onRoute(perform: handleRoute)
    }

    private func handleRoute(_ route: Route) {
        switch route {
        case .bookingRequests, .bookingApplications:
            screen = .upcoming
            Current.router.end()
        case .bookingApplications:
            screen = .applied
            Current.router.end()
        }
    }
}

struct BookingRequestsTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsTabView()
    }
}
