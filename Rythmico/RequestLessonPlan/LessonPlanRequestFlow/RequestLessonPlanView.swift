import ComposableNavigator
import StudentDTO
import SwiftUIEncore

struct RequestLessonPlanScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: RequestLessonPlanScreen) in
                    RequestLessonPlanView(flow: RequestLessonPlanFlow())
                }
            )
        }
    }
}

struct RequestLessonPlanView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequestRequest>

    @StateObject
    var flow: RequestLessonPlanFlow
    @StateObject
    var coordinator: Coordinator
    @State
    private var _flowView: RequestLessonPlanFlowView

    init(flow: RequestLessonPlanFlow) {
        self._flow = .init(wrappedValue: flow)
        let coordinator = Current.lessonPlanRequestCreationCoordinator()
        self._coordinator = .init(wrappedValue: coordinator)
        self.__flowView = .init(wrappedValue: RequestLessonPlanFlowView(flow: flow, requestCoordinator: coordinator))
    }

    let inspection = SelfInspection()

    var interactiveDismissDisabled: Bool {
        flow.step.index > 0 || !coordinator.isReady
    }

    var errorMessage: String? {
        coordinator.output?.error?.legibleLocalizedDescription
    }

    func dismissError() {
        coordinator.dismissFailure()
    }

    var body: some View {
        CoordinatorStateView(
            coordinator: coordinator,
            successContent: LessonPlanRequestConfirmationView.init,
            loadingTitle: "Submitting proposal...",
            inputContent: { flowView.alertOnFailure(coordinator) }
        )
        .testable(self)
        .backgroundColor(.rythmico.backgroundSecondary)
        .interactiveDismissDisabled(interactiveDismissDisabled)
        .onSuccess(coordinator, perform: onLessonPlanRequestCreated)
    }

    private func onLessonPlanRequestCreated(_ lessonPlanRequest: LessonPlanRequest) {
        Current.lessonPlanRequestRepository.insertItem(lessonPlanRequest)
        Current.analytics.track(.lessonPlanRequestCreated(lessonPlanRequest, through: flow))
    }
}

extension RequestLessonPlanView {
    var flowView: RequestLessonPlanFlowView? {
        coordinator.isReady || coordinator.isFailed() ? _flowView : nil
    }
}

#if DEBUG
struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(flow: RequestLessonPlanFlow())
    }
}
#endif
