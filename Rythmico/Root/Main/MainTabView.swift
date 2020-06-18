import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView {
    enum TabSelection: String, Hashable {
        case lessons = "Lessons"
        case profile = "Profile"

        var title: String { rawValue }
        var uppercasedTitle: String { title.uppercased(with: Current.locale) }
    }

    final class ViewState: ObservableObject {
        @Published var tabSelection: TabSelection = .lessons
    }

    @ObservedObject
    private var state = ViewState()

    private let lessonsView: LessonsView
    private let profileView: ProfileView = ProfileView()

    @State
    private(set) var lessonRequestView: RequestLessonPlanView?

    @ObservedObject
    private var lessonPlanFetchingCoordinator: LessonPlanFetchingCoordinator
    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let lessonPlanFetchingCoordinator = Current.lessonPlanFetchingCoordinator(),
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
        self.lessonsView = LessonsView(coordinator: lessonPlanFetchingCoordinator)
        self.lessonPlanFetchingCoordinator = lessonPlanFetchingCoordinator
        self.deviceRegisterCoordinator = deviceRegisterCoordinator
    }

    func presentRequestLessonFlow() {
        lessonRequestView = RequestLessonPlanView(context: RequestLessonPlanContext())
    }

    var onAppear: Handler<Self>?
    var body: some View {
        NavigationView {
            TabView(selection: $state.tabSelection) {
                lessonsView
                    .tag(TabSelection.lessons)
                    .tabItem {
                        Image(systemSymbol: .calendar).font(.system(size: 21, weight: .medium))
                        Text(TabSelection.lessons.uppercasedTitle)
                    }

                profileView
                    .tag(TabSelection.profile)
                    .tabItem {
                        Image(systemSymbol: .person).font(.system(size: 21, weight: .semibold))
                        Text(TabSelection.profile.uppercasedTitle)
                    }
            }
            .navigationBarTitle(Text(state.tabSelection.title), displayMode: .large)
            .navigationBarItems(leading: leadingNavigationItem, trailing: trailingNavigationItem)
        }
        .modifier(BestNavigationStyleModifier())
        .onReceive(state.$tabSelection) { tabSelection in
            if self.state.tabSelection == .profile, tabSelection == .lessons {
                self.lessonsView.fetchLessonPlans()
            }
        }
        .accentColor(.rythmicoPurple)
        .betterSheet(item: $lessonRequestView, content: { $0 })
        .onAppear { self.onAppear?(self) }
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
    }

    private var leadingNavigationItem: AnyView? {
        switch state.tabSelection {
        case .lessons:
            return AnyView(
                Group {
                    if lessonPlanFetchingCoordinator.state.isLoading {
                        ActivityIndicator(style: .medium, color: .rythmicoGray90)
                    }
                }
            )
        case .profile:
            return nil
        }
    }

    private var trailingNavigationItem: AnyView? {
        switch state.tabSelection {
        case .lessons:
            return AnyView(
                Button(action: presentRequestLessonFlow) {
                    Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                        .padding(.vertical, .spacingExtraSmall)
                        .padding(.horizontal, .spacingExtraLarge)
                        .offset(x: .spacingExtraLarge)
                }
                .accessibility(label: Text("Request lessons"))
                .accessibility(hint: Text("Double tap to request a lesson plan"))
            )
        case .profile:
            return nil
        }
    }
}

private struct BestNavigationStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        UIDevice.current.userInterfaceIdiom == .phone
            ? AnyView(content.navigationViewStyle(StackNavigationViewStyle()))
            : AnyView(content.navigationViewStyle(DefaultNavigationViewStyle()))
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(
//            result: .success(.stub),
            result: .success([.davidGuitarPlanStub, .cancelledJackGuitarPlanStub]),
//            delay: 2,
            delay: nil
        )

        return Group {
            MainTabView()
                .environment(\.colorScheme, .light)
            MainTabView()
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
