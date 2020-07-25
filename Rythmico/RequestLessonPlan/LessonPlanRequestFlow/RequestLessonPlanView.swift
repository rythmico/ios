import SwiftUI
import Sugar

struct RequestLessonPlanView: View, Identifiable, TestableView {
    typealias Coordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    @ObservedObject
    private(set) var coordinator: Coordinator
    @ObservedObject
    private var context: RequestLessonPlanContext
    private let _formView: RequestLessonPlanFormView

    init?(context: RequestLessonPlanContext) {
        guard
            let coordinator = Current.lessonPlanRequestCoordinator(),
            let formView = RequestLessonPlanFormView(context: context, coordinator: coordinator)
        else {
            return nil
        }
        self.coordinator = coordinator
        self.context = context
        self._formView = formView
    }

    let id = UUID()
    var onAppear: Handler<Self>?

    var swipeDownToDismissEnabled: Bool {
        coordinator.state.isIdle && context.currentStep.index == 0
    }

    var errorMessage: String? {
        coordinator.state.failureValue?.localizedDescription
    }

    func dismissError() {
        coordinator.dismissFailure()
    }

    var body: some View {
        ZStack {
            formView.transition(stateTransition(scale: 0.9)).alertOnFailure(coordinator)
            loadingView.transition(stateTransition(scale: 0.7))
            confirmationView.transition(stateTransition(scale: 0.7))
        }
        .betterSheetIsModalInPresentation(!swipeDownToDismissEnabled)
        .onAppear { self.onAppear?(self) }
        .onSuccess(coordinator, perform: Current.lessonPlanRepository.insertItem)
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
        coordinator.state.isIdle || coordinator.state.isFailure ? _formView : nil
    }

    var loadingView: RequestLessonPlanLoadingView? {
        coordinator.state.isLoading ? RequestLessonPlanLoadingView() : nil
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
