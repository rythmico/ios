import SwiftUIEncore
import ComposableNavigator

struct LessonPlanRequestsTabScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                LessonPlanRequestsTabScreen.self,
                content: {
                    LessonPlanRequestsTabView()
                },
                nesting: {
                    LessonPlanRequestDetailScreen.Builder()
                    LessonPlanApplicationDetailScreen.Builder()
                    LessonPlanApplicationGroupScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanRequestsTabView: View {
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
            .padding(.vertical, .grid(3))

            Divider()

            switch tabSelection.requestsTab {
            case .open:
                LessonPlanRequestsView()
            case .applied:
                LessonPlanApplicationsView()
            }
        }
        .navigationBarTitle(MainView.Tab.requests.title, displayMode: .large)
    }
}

#if DEBUG
struct LessonPlanRequestsTabView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanRequestsTabView()
    }
}
#endif
