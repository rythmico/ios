import SwiftUI
import Sugar

typealias RequestLessonPlanFailureView = Alert

struct RequestLessonPlanView: View, Identifiable, TestableView {
    @ObservedObject
    private var coordinator: RequestLessonPlanCoordinator
    @ObservedObject
    private var context: RequestLessonPlanContext
    private let _formView: RequestLessonPlanFormView
    private let notificationsAuthorizationManager: PushNotificationAuthorizationManagerProtocol

    init(
        coordinator: RequestLessonPlanCoordinator,
        context: RequestLessonPlanContext,
        accessTokenProvider: AuthenticationAccessTokenProvider,
        instrumentProvider: InstrumentSelectionListProviderProtocol,
        keyboardDismisser: KeyboardDismisser,
        notificationsAuthorizationManager: PushNotificationAuthorizationManagerProtocol
    ) {
        self.coordinator = coordinator
        self.context = context
        self._formView = RequestLessonPlanFormView(
            context: context,
            coordinator: coordinator,
            accessTokenProvider: accessTokenProvider,
            instrumentProvider: instrumentProvider,
            keyboardDismisser: keyboardDismisser
        )
        self.notificationsAuthorizationManager = notificationsAuthorizationManager
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

    func stateTransition(scale: CGFloat) -> AnyTransition {
        AnyTransition
            .opacity
            .combined(with: .scale(scale: scale))
            .animation(.rythmicoSpring(duration: .durationShort))
    }

    var errorMessageBinding: Binding<String?> {
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
            RequestLessonPlanConfirmationView(
                lessonPlan: $0,
                notificationsAuthorizationManager: notificationsAuthorizationManager
            )
        }
    }
}

struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        let service = RequestLessonPlanServiceStub(result: .success(.stub), delay: 3)
//        service.result = .failure(RythmicoAPIError.init(errorDescription: "something"))

        let context = RequestLessonPlanContext()
        context.instrument = .guitarStub
        context.student = .davidStub
        context.address = .stub
        context.schedule = .stub
        context.privateNote = "Note"

        let view = RequestLessonPlanView(
            coordinator: RequestLessonPlanCoordinator(service: service),
            context: context,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            instrumentProvider: InstrumentSelectionListProviderFake(),
            keyboardDismisser: UIApplication.shared,
            notificationsAuthorizationManager: PushNotificationAuthorizationManagerStub(
                authorizationStatus: .notDetermined,
                requestAuthorizationResult: .success(true)
            )
        )

        return view
            .environment(\.locale, Locale(identifier: "en_GB"))
            .previewDevices()
    }
}
