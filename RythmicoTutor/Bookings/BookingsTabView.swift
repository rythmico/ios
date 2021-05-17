import SwiftUI

struct BookingsTabView: View {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case upcoming = "Upcoming"
        case past = "Past"
    }

    @ObservedObject
    private var navigation = Current.navigation

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $navigation.scheduleFilter) {
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

            BookingsView()
        }
    }
}

#if DEBUG
struct BookingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookingsTabView()
    }
}
#endif
