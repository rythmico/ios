import SwiftUIEncore
import ComposableNavigator

struct BookingRequestsTabScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                BookingRequestsTabScreen.self,
                content: {
                    BookingRequestsTabView()
                },
                nesting: {
                    BookingRequestDetailScreen.Builder()
                    BookingApplicationDetailScreen.Builder()
                    BookingApplicationGroupScreen.Builder()
                }
            )
        }
    }
}

struct BookingRequestsTabView: View {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case open = "Open"
        case applied = "Applied"
    }

    @ObservedObject
    private var tabSelection = Current.tabSelection

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $tabSelection.requestsTab) {
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

            switch tabSelection.requestsTab {
            case .open:
                BookingRequestsView()
            case .applied:
                BookingApplicationsView()
            }
        }
        .navigationBarTitle(MainView.Tab.requests.title, displayMode: .large)
    }
}

#if DEBUG
struct BookingRequestsTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsTabView()
    }
}
#endif
