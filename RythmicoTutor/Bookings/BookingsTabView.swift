import SwiftUISugar
import ComposableNavigator

struct BookingsTabScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                BookingsTabScreen.self,
                content: { BookingsTabView() },
                nesting: {
                    LessonDetailScreen.Builder()
                }
            )
        }
    }
}

struct BookingsTabView: View {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case upcoming = "Upcoming"
        case past = "Past"
    }

    @ObservedObject
    private var tabSelection = Current.tabSelection
    @ObservedObject
    private var coordinator = Current.bookingsFetchingCoordinator

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $tabSelection.scheduleTab) {
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

            BookingsView()
        }
        .navigationBarTitle(MainView.Tab.schedule.title, displayMode: .large)
        .navigationBarItems(leading: ZStack {
            if coordinator.state.isLoading {
                ActivityIndicator()
            }
        })
    }
}

#if DEBUG
struct BookingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookingsTabView()
    }
}
#endif
