import SwiftUI
import Sugar

struct LessonsView: View, TestableView {
    @ObservedObject
    private var fetchingCoordinator: LessonPlanFetchingCoordinator
    @ObservedObject
    private var lessonPlanRepository = Current.lessonPlanRepository
    @State
    private(set) var lessonRequestView: RequestLessonPlanView?

    init?() {
        guard let fetchingCoordinator = Current.lessonPlanFetchingCoordinator() else {
            return nil
        }
        self.fetchingCoordinator = fetchingCoordinator
        self.lessonPlanRepository = lessonPlanRepository
    }

    func presentRequestLessonFlow() {
        lessonRequestView = RequestLessonPlanView(context: RequestLessonPlanContext())
    }

    var didAppear: Handler<Self>?
    var body: some View {
        NavigationView {
            CollectionView(
                lessonPlanRepository.lessonPlans,
                padding: EdgeInsets(horizontal: .spacingMedium, vertical: .spacingMedium)
            ) {
                LessonPlanSummaryCell(lessonPlan: $0, transitionDelay: self.transitionDelay(for: $0))
            }
            .navigationBarTitle("Lessons", displayMode: .large)
            .navigationBarItems(
                leading: Group {
                    if fetchingCoordinator.state.isLoading {
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
            .alert(error: self.fetchingCoordinator.state.failureValue, dismiss: fetchingCoordinator.dismissError)
            .onAppear { self.didAppear?(self) }
            .onAppear(perform: fetchingCoordinator.fetchLessonPlans)
        }
        .accentColor(.rythmicoPurple)
        .betterSheet(item: $lessonRequestView, content: { $0 })
    }

    private func transitionDelay(for lessonPlan: LessonPlan) -> Double? {
        guard
            lessonPlanRepository.previousLessonPlans.isEmpty,
            let index = lessonPlanRepository.lessonPlans.firstIndex(of: lessonPlan)
        else {
            return nil
        }
        return Double(index) * .durationShort
    }
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(
            result: .success([.stub]),
            delay: 2
        )
        return Group {
            LessonsView()
                .environment(\.colorScheme, .light)
//                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            LessonsView()
                .environment(\.colorScheme, .dark)
//                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
    }
}
