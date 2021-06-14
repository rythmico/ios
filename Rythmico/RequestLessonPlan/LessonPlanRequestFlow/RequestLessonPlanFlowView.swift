import SwiftUI
import Combine
import FoundationSugar

struct RequestLessonPlanFlowView: View, TestableView {
    typealias RequestCoordinator = APIActivityCoordinator<CreateLessonPlanRequest>

    @StateObject
    fileprivate var instrumentSelectionViewState = InstrumentSelectionView.ViewState()
    @StateObject
    fileprivate var studentDetailsViewState = StudentDetailsView.ViewState()
    @StateObject
    fileprivate var addressDetailsViewState = AddressDetailsView.ViewState()
    @StateObject
    fileprivate var schedulingViewState = SchedulingView.ViewState()
    @StateObject
    fileprivate var privateNoteViewState = PrivateNoteView.ViewState()

    @Environment(\.presentationMode)
    private var presentationMode

    @ObservedObject
    var flow: RequestLessonPlanFlow
    var requestCoordinator: RequestCoordinator
    @StateObject
    private var addressSearchCoordinator = Current.addressSearchCoordinator()

    var shouldShowBackButton: Bool {
        flow.step.index > 0
    }

    func back() {
        Current.keyboardDismisser.dismissKeyboard()
        flow.back()
    }

    var stepNumber: Int {
        flow.step.index + 1
    }

    var stepCount: Int {
        type(of: flow.step).count
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                backButton: {
                    if shouldShowBackButton {
                        BackButton(action: back).transition(.opacity)
                    }
                },
                trailingItem: {
                    CloseButton(action: dismiss).accessibility(hint: Text("Double tap to return to main screen"))
                }
            )
            .accentColor(.rythmicoGray90)
            .animation(.rythmicoSpring(duration: .durationShort), value: shouldShowBackButton)

            StepBar(stepNumber, of: stepCount).padding(.horizontal, .spacingMedium)
            VSpacing(.spacingExtraSmall)
            FlowView(flow: flow, transition: .slide + .opacity, content: content).onEdgeSwipe(.left, perform: back)
        }
        .testable(self)
        .onAppear { trackScreenView(flow.step) }
        .onReceive(onFlowStepChangePublisher(), perform: trackScreenView)
    }

    @ViewBuilder
    func content(for step: RequestLessonPlanFlow.Step) -> some View {
        switch step {
        case .instrumentSelection:
            InstrumentSelectionView(
                state: instrumentSelectionViewState,
                setter: $flow.instrument.setter
            )
        case .studentDetails(let instrument):
            StudentDetailsView(
                instrument: instrument,
                state: studentDetailsViewState,
                setter: $flow.student.setter
            )
        case .addressDetails(let instrument, let student):
            AddressDetailsView(
                student: student,
                instrument: instrument,
                state: addressDetailsViewState,
                coordinator: addressSearchCoordinator,
                setter: $flow.address.setter
            )
        case .scheduling(let instrument, _, _):
            SchedulingView(
                state: schedulingViewState,
                instrument: instrument,
                setter: $flow.schedule.setter
            )
        case .privateNote:
            PrivateNoteView(
                state: privateNoteViewState,
                setter: $flow.privateNote.setter
            )
        case .reviewRequest(let instrument, let student, let address, let schedule, let privateNote):
            ReviewRequestView(
                coordinator: requestCoordinator,
                flow: flow,
                instrument: instrument,
                student: student,
                address: address,
                schedule: schedule,
                privateNote: privateNote
            )
        }
    }

    func onFlowStepChangePublisher() -> AnyPublisher<RequestLessonPlanFlow.Step, Never> {
        flow.objectWillChange
            .delay(for: 0, scheduler: DispatchQueue.main)
            .map { flow.step }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func trackScreenView(_ step: RequestLessonPlanFlow.Step) {
        Current.analytics.track(.screenView(step))
    }
}
