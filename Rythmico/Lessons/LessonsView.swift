import SwiftUI
import Sugar

struct LessonsView: View, TestableView {
    @ObservedObject
    private var fetchingCoordinator: LessonPlanFetchingCoordinator
    @ObservedObject
    private var lessonPlanRepository = Current.lessonPlanRepository
    @State
    private var selectedLessonPlan: LessonPlan?
    @State
    private(set) var lessonRequestView: RequestLessonPlanView?

    init?() {
        guard let fetchingCoordinator = Current.lessonPlanFetchingCoordinator() else {
            return nil
        }
        self.fetchingCoordinator = fetchingCoordinator
        self.lessonPlanRepository = lessonPlanRepository
    }

    var lessonPlans: [LessonPlan] { lessonPlanRepository.lessonPlans }
    var isLoading: Bool { fetchingCoordinator.state.isLoading }
    var errorMessage: String? { fetchingCoordinator.state.failureValue?.localizedDescription }

    func dismissErrorAlert() {
        fetchingCoordinator.dismissError()
    }

    func presentRequestLessonFlow() {
        lessonRequestView = RequestLessonPlanView(context: RequestLessonPlanContext())
    }

    var onAppear: Handler<Self>?
    var body: some View {
        NavigationView {
            CollectionView(lessonPlans, padding: EdgeInsets(.spacingMedium)) { lessonPlan in
                NavigationLink(
                    destination: LessonPlanDetailView(lessonPlan),
                    tag: lessonPlan,
                    selection: self.$selectedLessonPlan,
                    label: {
                        LessonPlanSummaryCell(lessonPlan: lessonPlan)
                    }
                )
                .transition(self.transition(for: lessonPlan))
            }
            .navigationBarTitle("Lessons", displayMode: .large)
            .navigationBarItems(
                leading: Group {
                    if isLoading {
                        ActivityIndicator(style: .medium, color: .rythmicoGray90)
                    }
                },
                trailing: Button(action: presentRequestLessonFlow) {
                    Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                        .padding(.vertical, .spacingExtraSmall)
                        .padding(.horizontal, .spacingExtraLarge)
                        .offset(x: .spacingExtraLarge)
                }
                .accessibility(label: Text("Request lessons"))
                .accessibility(hint: Text("Double tap to request a lesson plan"))
            )
            .alert(error: self.errorMessage, dismiss: dismissErrorAlert)
            .onAppear { self.onAppear?(self) }
            .onAppear(perform: fetchingCoordinator.fetchLessonPlans)
        }
        .modifier(BestNavigationStyleModifier())
        .accentColor(.rythmicoPurple)
        .betterSheet(item: $lessonRequestView, content: { $0 })
    }

    private func transition(for lessonPlan: LessonPlan) -> AnyTransition {
        let transitionDelay: Double
        if
            lessonPlanRepository.previousLessonPlans.isEmpty,
            let index = lessonPlanRepository.lessonPlans.firstIndex(of: lessonPlan)
        {
            transitionDelay = Double(index) * (.durationShort * 2/3)
        } else {
            transitionDelay = 0
        }
        return AnyTransition.opacity.combined(with: .scale(scale: 0.8))
            .animation(
                Animation
                    .rythmicoSpring(duration: .durationMedium)
                    .delay(transitionDelay)
            )
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
struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(
            result: .success(.stub),
//            delay: 2
            delay: nil
        )
        return Group {
            LessonsView()
                .environment(\.colorScheme, .light)
//                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            LessonsView()
                .environment(\.colorScheme, .dark)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
    }
}
#endif
