import SwiftUI
import SFSafeSymbols
import MultiModal
import FoundationSugar

struct MainView: View, TestableView {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case lessons = "Lessons"
        case profile = "Profile"

        var title: String { rawValue }
        var uppercasedTitle: String { title.uppercased(with: Current.locale) }
    }

    @ObservedObject
    private var state = Current.state
    @State
    private var hasFetchedLessonPlansAtLeastOnce = false
    @ObservedObject
    private var lessonPlanFetchingCoordinator = Current.lessonPlanFetchingCoordinator

    func presentRequestLessonFlow() {
        state.lessonsContext = .requestingLessonPlan
    }

    func onLessonPlansFetched(_ lessonPlans: [LessonPlan]) {
        guard !hasFetchedLessonPlansAtLeastOnce else { return }
        hasFetchedLessonPlansAtLeastOnce = true
        if lessonPlans.isEmpty {
            presentRequestLessonFlow()
        } else {
            Current.pushNotificationAuthorizationCoordinator.requestAuthorization()
        }
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
        .accentColor(.rythmicoPurple)
        .onAppear(perform: Current.deviceRegisterCoordinator.registerDevice)
        .onAppear(perform: Current.pushNotificationAuthorizationCoordinator.refreshAuthorizationStatus)
        .onSuccess(lessonPlanFetchingCoordinator, perform: onLessonPlansFetched)
        .multiModal {
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
        case .lessons: LessonsView()
        case .profile: ProfileView()
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
