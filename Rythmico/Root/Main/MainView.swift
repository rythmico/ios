import SwiftUI
import SFSafeSymbols
import MultiSheet
import Sugar

struct MainView: View, TestableView {
    enum Tab: String, Hashable, CaseIterable {
        case lessons = "Lessons"
        case profile = "Profile"

        var title: String { rawValue }
        var uppercasedTitle: String { title.uppercased(with: Current.locale) }
    }

    @ObservedObject
    private var state = Current.state
    @State
    private var lessonsView: LessonsView
    @State
    private var profileView = ProfileView()

    @State
    private var hasPresentedLessonRequestView = false

    @ObservedObject
    private var lessonPlanFetchingCoordinator: LessonsView.Coordinator
    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let lessonPlanFetchingCoordinator = Current.sharedCoordinator(for: \.lessonPlanFetchingService),
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
        self._lessonsView = .init(wrappedValue: LessonsView(coordinator: lessonPlanFetchingCoordinator))
        self.lessonPlanFetchingCoordinator = lessonPlanFetchingCoordinator
        self.deviceRegisterCoordinator = deviceRegisterCoordinator
    }

    func presentRequestLessonFlow() {
        state.lessonsContext = .requestingLessonPlan
    }

    func presentRequestLessonFlowIfNeeded(_ lessonPlans: [LessonPlan]) {
        guard !hasPresentedLessonRequestView, lessonPlans.isEmpty else { return }
        state.lessonsContext = .requestingLessonPlan
    }

    let inspection = SelfInspection()
    var body: some View {
        MainViewContent(
            tabs: Tab.allCases, selection: $state.tab,
            navigationTitle: \.title, leadingItem: leadingItem, trailingItem: trailingItem,
            content: content,
            tabTitle: \.uppercasedTitle, tabIcons: icon
        )
        .testable(self)
        .onChange(of: state.lessonsContext.isRequestingLessonPlan, perform: onIsLessonRequestViewPresentedChange)
        .accentColor(.rythmicoPurple)
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
        .onSuccess(lessonPlanFetchingCoordinator, perform: presentRequestLessonFlowIfNeeded)
        .multiSheet {
            $0.sheet(isPresented: $state.lessonsContext.isRequestingLessonPlan) {
                RequestLessonPlanView(context: RequestLessonPlanContext())
            }
            $0.sheet(item: $state.lessonsContext.bookingValues) {
                LessonPlanBookingEntryView(lessonPlan: $0.lessonPlan, application: $0.application)
            }
        }
    }

    @ViewBuilder
    private func icon(for tab: Tab) -> some View {
        switch tab {
        case .lessons: Image(systemSymbol: .calendar).font(.system(size: 21, weight: .medium))
        case .profile: Image(systemSymbol: .person).font(.system(size: 21, weight: .semibold))
        }
    }

    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .lessons: lessonsView
        case .profile: profileView
        }
    }

    @ViewBuilder
    private func leadingItem(for tab: Tab) -> some View {
        switch tab {
        case .lessons where lessonPlanFetchingCoordinator.state.isLoading:
            ActivityIndicator(color: .rythmicoGray90)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func trailingItem(for tab: Tab) -> some View {
        switch tab {
        case .lessons:
            Button(action: presentRequestLessonFlow) {
                Image(decorative: Asset.buttonRequestLessons.name)
                    .padding(.vertical, .spacingExtraSmall)
                    .padding(.horizontal, .spacingExtraLarge)
                    .offset(x: .spacingExtraLarge)
            }
            .accessibility(label: Text("Request lessons"))
            .accessibility(hint: Text("Double tap to request a lesson plan"))
        case .profile:
            EmptyView()
        }
    }

    private func onIsLessonRequestViewPresentedChange(_ flag: Bool) {
        if flag { hasPresentedLessonRequestView = true }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.colorScheme, .light)
        MainView()
            .environment(\.colorScheme, .dark)
    }
}
#endif
