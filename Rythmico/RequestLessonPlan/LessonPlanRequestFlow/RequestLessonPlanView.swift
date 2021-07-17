import SwiftUISugar
import ComposableNavigator

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
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    @StateObject
    var flow: RequestLessonPlanFlow
    @StateObject
    var coordinator: Coordinator
    @State
    private var _flowView: RequestLessonPlanFlowView

    init(flow: RequestLessonPlanFlow) {
        self._flow = .init(wrappedValue: flow)
        let coordinator = Current.lessonPlanRequestCoordinator()
        self._coordinator = .init(wrappedValue: coordinator)
        self.__flowView = .init(wrappedValue: RequestLessonPlanFlowView(flow: flow, requestCoordinator: coordinator))
    }

    let inspection = SelfInspection()

    var interactiveDismissDisabled: Bool {
        flow.step.index > 0 || !coordinator.state.isReady
    }

    var errorMessage: String? {
        coordinator.state.failureValue?.legibleLocalizedDescription
    }

    func dismissError() {
        coordinator.dismissFailure()
    }

    var body: some View {
        CoordinatorStateView(
            coordinator: coordinator,
            successContent: LessonPlanConfirmationView.init,
            loadingTitle: "Submitting proposal...",
            inputContent: { flowView.alertOnFailure(coordinator) }
        )
        .testable(self)
        .backgroundColor(.rythmicoBackgroundSecondary)
        .interactiveDismissDisabled(interactiveDismissDisabled)
        .onSuccess(coordinator, perform: onLessonPlanRequested)
    }

    private func onLessonPlanRequested(_ lessonPlan: LessonPlan) {
        Current.lessonPlanRepository.insertItem(lessonPlan)
        Current.analytics.track(.lessonPlanRequested(lessonPlan, through: flow))
    }
}

extension RequestLessonPlanView {
    var flowView: RequestLessonPlanFlowView? {
        coordinator.state.isReady || coordinator.state.isFailure ? _flowView : nil
    }
}

#if DEBUG
struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(flow: RequestLessonPlanFlow())
    }
}
#endif
