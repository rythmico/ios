import SwiftUI
import Sugar

struct RequestLessonPlanView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    @StateObject
    var context: RequestLessonPlanContext
    @StateObject
    var coordinator: Coordinator
    @State
    private var _formView: RequestLessonPlanFormView

    init?(context: RequestLessonPlanContext) {
        guard
            let coordinator = Current.coordinator(for: \.lessonPlanRequestService),
            let formView = RequestLessonPlanFormView(context: context, coordinator: coordinator)
        else {
            return nil
        }
        self._context = .init(wrappedValue: context)
        self._coordinator = .init(wrappedValue: coordinator)
        self.__formView = .init(wrappedValue: formView)
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
            successContent: { confirmationView },
            loadingContent: { loadingView },
            inputContent: { formView.alertOnFailure(coordinator) }
        )
        .testable(self)
        .onSuccess(coordinator, perform: Current.lessonPlanRepository.insertItem)
        .sheetInteractiveDismissal(swipeDownToDismissEnabled)
    }

    private func stateTransition(scale: CGFloat) -> AnyTransition {
        AnyTransition
            .opacity
            .combined(with: .scale(scale: scale))
            .animation(.rythmicoSpring(duration: .durationShort))
    }
}

extension RequestLessonPlanView {
    var formView: RequestLessonPlanFormView? {
        coordinator.state.isReady || coordinator.state.isFailure ? _formView : nil
    }

    var loadingView: LoadingView? {
        coordinator.state.isLoading ? LoadingView(title: "Submitting proposal...") : nil
    }

    var confirmationView: RequestLessonPlanConfirmationView? {
        coordinator.state.successValue.map(RequestLessonPlanConfirmationView.init)
    }
}

#if DEBUG
struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(context: RequestLessonPlanContext())
    }
}
#endif
