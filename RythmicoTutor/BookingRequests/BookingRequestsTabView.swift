import SwiftUI

struct BookingRequestsTabView: View {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case upcoming = "Upcoming"
        case applied = "Applied"
    }

    @ObservedObject
    private var state = Current.state

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
                BookingRequestsView()
            } else if state.requestsTab == .applied {
                BookingApplicationsView()
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
