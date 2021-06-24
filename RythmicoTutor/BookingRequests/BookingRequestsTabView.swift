import SwiftUI

struct BookingRequestsTabView: View {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case open = "Open"
        case applied = "Applied"
    }

    @ObservedObject
    private var navigation = Current.navigation

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $navigation.requestsFilter) {
                ForEach(Tab.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 250)
            .padding(.top, .grid(1))
            .padding(.bottom, .grid(4))

            Divider()

            if navigation.requestsFilter == .open {
                BookingRequestsView()
            } else if navigation.requestsFilter == .applied {
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
