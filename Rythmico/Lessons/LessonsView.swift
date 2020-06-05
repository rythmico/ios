import SwiftUI
import Sugar

struct LessonsView: View, TestableView {
    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerBase
    @ObservedObject
    private var fetchingCoordinator: LessonPlanFetchingCoordinatorBase
    @ObservedObject
    private var lessonPlanRepository: LessonPlanRepository
    @State
    private(set) var lessonRequestView: RequestLessonPlanView?

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerBase,
        lessonPlanFetchingCoordinator: LessonPlanFetchingCoordinatorBase,
        lessonPlanRepository: LessonPlanRepository
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.pushNotificationAuthorizationManager = pushNotificationAuthorizationManager
        self.fetchingCoordinator = lessonPlanFetchingCoordinator
        self.lessonPlanRepository = lessonPlanRepository
    }

    func presentRequestLessonFlow() {
        lessonRequestView = RequestLessonPlanView(
            coordinator: LessonPlanRequestCoordinator(
                service: LessonPlanRequestService(accessTokenProvider: accessTokenProvider),
                repository: lessonPlanRepository
            ),
            context: RequestLessonPlanContext(),
            accessTokenProvider: accessTokenProvider,
            instrumentProvider: InstrumentSelectionListProviderFake(),
            keyboardDismisser: UIApplication.shared,
            notificationsAuthorizationManager: pushNotificationAuthorizationManager
        )
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
                trailing: Button(action: presentRequestLessonFlow) {
                    Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                        .padding(.vertical, .spacingExtraSmall)
                        .padding(.horizontal, .spacingExtraLarge)
                        .offset(x: .spacingExtraLarge)
                }
                .accessibility(label: Text("Request lessons"))
                .accessibility(hint: Text("Double tap to request a lesson plan"))
            )
            .alert(
                item: Binding(
                    get: { self.fetchingCoordinator.error?.localizedDescription },
                    set: { self.fetchingCoordinator.error = $0 }
                )
            ) {
                Alert(title: Text("An error ocurred"), message: Text($0.localizedDescription))
            }
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
        let repository = LessonPlanRepository()
        let view = LessonsView(
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            pushNotificationAuthorizationManager: PushNotificationAuthorizationManagerDummy(),
            lessonPlanFetchingCoordinator: LessonPlanFetchingCoordinatorStub(
                result: .success([.stub, .stub, .stub, .stub]),
                delay: 1,
                repository: repository
            ),
            lessonPlanRepository: repository
        )
        return Group {
            view
                .environment(\.colorScheme, .light)
//                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            view
                .environment(\.colorScheme, .dark)
//                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
    }
}
