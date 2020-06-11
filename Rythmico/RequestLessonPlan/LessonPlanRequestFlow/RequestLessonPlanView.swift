import SwiftUI
import Sugar

typealias RequestLessonPlanFailureView = Alert

struct RequestLessonPlanView: View, Identifiable, TestableView {
    @ObservedObject
    private var coordinator: LessonPlanRequestCoordinator
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
    var didAppear: Handler<Self>?

    var swipeDownToDismissEnabled: Bool {
        coordinator.state.isIdle && context.currentStep.index == 0
    }

    var body: some View {
        ZStack {
            formView.transition(stateTransition(scale: 0.9)).alert(item: errorMessageBinding) {
                RequestLessonPlanFailureView(title: Text("An error ocurred"), message: Text($0))
            }
            loadingView.transition(stateTransition(scale: 0.7))
            confirmationView.transition(stateTransition(scale: 0.7))
        }
        .betterSheetIsModalInPresentation(!swipeDownToDismissEnabled)
        .onAppear { self.didAppear?(self) }
    }

    private func stateTransition(scale: CGFloat) -> AnyTransition {
        AnyTransition
            .opacity
            .combined(with: .scale(scale: scale))
            .animation(.rythmicoSpring(duration: .durationShort))
    }

    private var errorMessageBinding: Binding<String?> {
        Binding(
            get: { self.coordinator.state.failureValue?.localizedDescription },
            set: { if $0 == nil { self.coordinator.state = .idle } }
        )
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
        coordinator.state.successValue.map {
            RequestLessonPlanConfirmationView(lessonPlan: $0)
        }
    }
}

struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()

        Current.instrumentSelectionListProvider = InstrumentSelectionListProviderStub(
            instruments: Instrument.allCases
        )

        Current.addressSearchService = AddressSearchServiceStub(
            result: .success([.stub]),
            delay: 2
        )

        let context = RequestLessonPlanContext()
        context.instrument = .guitar
        context.student = .davidStub
        context.address = .stub
        context.schedule = .stub
        context.privateNote = "Note"

        Current.lessonPlanRequestService = LessonPlanRequestServiceStub(
            result: .success(.stub),
            delay: 2
        )

        Current.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: .notDetermined,
//                authorizationStatus: .authorized,
                authorizationRequestResult: (true, nil)
//                authorizationRequestResult: (false, nil)
//                authorizationRequestResult: (false, "Error")
            ),
            registerService: PushNotificationRegisterServiceDummy(),
            queue: nil
        )

        return RequestLessonPlanView(context: context)
    }
}
