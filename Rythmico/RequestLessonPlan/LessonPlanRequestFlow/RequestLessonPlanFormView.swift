import SwiftUI
import FoundationSugar

struct RequestLessonPlanFormView: View, TestableView {
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
    var context: RequestLessonPlanContext
    var requestCoordinator: RequestCoordinator
    @StateObject
    private var addressSearchCoordinator = Current.addressSearchCoordinator()

    var shouldShowBackButton: Bool {
        context.step.index > 0
    }

    func back() {
        Current.keyboardDismisser.dismissKeyboard()
        context.back()
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: .spacingSmall) {
            VStack(spacing: 0) {
                HStack {
                    if shouldShowBackButton {
                        BackButton(action: back).transition(.opacity)
                    }
                    Spacer()
                    CloseButton(action: dismiss)
                        .accessibility(hint: Text("Double tap to return to main screen"))
                }
                .accentColor(.rythmicoGray90)
                .frame(minHeight: 64)
                .padding(.horizontal, .spacingSmall)
                .animation(.rythmicoSpring(duration: .durationShort), value: shouldShowBackButton)

                StepBar(context.step.index + 1, of: type(of: context.step).count).padding(.horizontal, .spacingMedium)
            }

            FlowView(flow: context, transition: .slide + .opacity, content: content).onEdgeSwipe(.left, perform: back)
        }
        .testable(self)
    }

    @ViewBuilder
    func content(for step: RequestLessonPlanContext.Step) -> some View {
        switch step {
        case .instrumentSelection:
            InstrumentSelectionView(
                state: instrumentSelectionViewState,
                instrument: $context.instrument
            )
        case .studentDetails(let instrument):
            StudentDetailsView(
                instrument: instrument,
                state: studentDetailsViewState,
                student: $context.student
            )
        case .addressDetails(let instrument, let student):
            AddressDetailsView(
                student: student,
                instrument: instrument,
                state: addressDetailsViewState,
                coordinator: addressSearchCoordinator,
                address: $context.address
            )
        case .scheduling(let instrument):
            SchedulingView(
                state: schedulingViewState,
                instrument: instrument,
                schedule: $context.schedule
            )
        case .privateNote:
            PrivateNoteView(
                state: privateNoteViewState,
                privateNote: $context.privateNote
            )
        case .reviewRequest(let instrument, let student, let address, let schedule, let privateNote):
            ReviewRequestView(
                coordinator: requestCoordinator,
                context: context,
                instrument: instrument,
                student: student,
                address: address,
                schedule: schedule,
                privateNote: privateNote
            )
        }
    }
}
