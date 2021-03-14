import SwiftUI
import MultiModal
import FoundationSugar

struct RequestLessonPlanView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    @StateObject
    var context: RequestLessonPlanContext
    @StateObject
    var coordinator: Coordinator
    @State
    private var _formView: RequestLessonPlanFormView

    init(context: RequestLessonPlanContext) {
        self._context = .init(wrappedValue: context)
        let coordinator = Current.coordinator(for: \.lessonPlanRequestService)
        self._coordinator = .init(wrappedValue: coordinator)
        self.__formView = .init(wrappedValue: RequestLessonPlanFormView(context: context, requestCoordinator: coordinator))
    }

    let inspection = SelfInspection()

    var swipeDownToDismissEnabled: Bool {
        coordinator.state.isReady && context.currentStep.index == 0
    }

    var errorMessage: String? {
        coordinator.state.failureValue?.localizedDescription
    }

    func dismissError() {
        coordinator.dismissFailure()
    }

    var body: some View {
        CoordinatorStateView(
            coordinator: coordinator,
            successContent: LessonPlanConfirmationView.init,
            loadingTitle: "Submitting proposal...",
            inputContent: { formView.alertOnFailure(coordinator) }
        )
        .testable(self)
        .onSuccess(coordinator, perform: Current.lessonPlanRepository.insertItem)
        .sheetInteractiveDismissal(swipeDownToDismissEnabled)
    }

    private func stateTransition(scale: CGFloat) -> AnyTransition {
        (.scale(scale: scale) + .opacity).animation(.rythmicoSpring(duration: .durationShort))
    }
}

extension RequestLessonPlanView {
    var formView: RequestLessonPlanFormView? {
        coordinator.state.isReady || coordinator.state.isFailure ? _formView : nil
    }
}

#if DEBUG
struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(context: RequestLessonPlanContext())
    }
}
#endif
