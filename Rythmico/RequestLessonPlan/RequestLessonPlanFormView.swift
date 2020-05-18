import SwiftUI
import Sugar

struct RequestLessonPlanFormView: View, TestableView {
    fileprivate let instrumentSelectionViewState = InstrumentSelectionView.ViewState()
    fileprivate let studentDetailsViewState = StudentDetailsView.ViewState()
    fileprivate let addressDetailsViewState = AddressDetailsView.ViewState()
    fileprivate let schedulingViewState = SchedulingView.ViewState()
    fileprivate let privateNoteViewState = PrivateNoteView.ViewState()

    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    @ObservedObject
    private var context: RequestLessonPlanContext
    private let coordinator: RequestLessonPlanCoordinatorBase
    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let instrumentProvider: InstrumentSelectionListProviderProtocol
    private let keyboardDismisser: KeyboardDismisser

    init(
        context: RequestLessonPlanContext,
        coordinator: RequestLessonPlanCoordinatorBase,
        accessTokenProvider: AuthenticationAccessTokenProvider,
        instrumentProvider: InstrumentSelectionListProviderProtocol,
        keyboardDismisser: KeyboardDismisser
    ) {
        self.context = context
        self.coordinator = coordinator
        self.accessTokenProvider = accessTokenProvider
        self.instrumentProvider = instrumentProvider
        self.keyboardDismisser = keyboardDismisser
    }

    var didAppear: Handler<Self>?

    var shouldShowBackButton: Bool {
        !context.currentStep.isInstrumentSelection
    }

    func back() {
        keyboardDismisser.dismissKeyboard()
        context.unwindLatestStep()
    }

    var body: some View {
        VStack(spacing: .spacingSmall) {
            VStack(spacing: 0) {
                HStack {
                    if shouldShowBackButton {
                        BackButton(action: back).transition(.opacity)
                    }
                    Spacer()
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemSymbol: .xmark).font(.system(size: 21, weight: .semibold))
                            .padding(.horizontal, .spacingExtraLarge)
                            .offset(x: .spacingExtraLarge)
                    }
                    .accentColor(.rythmicoGray90)
                    .accessibility(label: Text("Close"))
                    .accessibility(hint: Text("Double tap to return to main screen"))
                }
                .frame(minHeight: 64)
                .padding(.horizontal, .spacingSmall)
                .animation(.rythmicoSpring(duration: .durationShort), value: shouldShowBackButton)

                StepBar(currentStepNumber, of: stepCount).padding(.horizontal, .spacingMedium)
            }

            ZStack {
                instrumentSelectionView.transition(pageTransition(forStepIndex: 0))
                studentDetailsView.transition(pageTransition(forStepIndex: 1))
                addressDetailsView.transition(pageTransition(forStepIndex: 2))
                schedulingView.transition(pageTransition(forStepIndex: 3))
                privateNoteView.transition(pageTransition(forStepIndex: 4))
                reviewRequestView.transition(pageTransition(forStepIndex: 5))
            }
            .animation(.rythmicoSpring(duration: .durationMedium), value: context.currentStep.index)
            .onEdgeSwipe(.left, perform: back)
        }
    }

    private func pageTransition(forStepIndex index: Int) -> AnyTransition {
        AnyTransition.move(
            edge: index == context.currentStep.index
                ? context.direction == .forward ? .trailing : .leading
                : context.direction == .forward ? .leading : .trailing
        )
        .combined(with: .opacity)
    }
}

extension RequestLessonPlanFormView {
    var currentStepNumber: Int { context.currentStep.index + 1 }
    var stepCount: Int { RequestLessonPlanContext.Step.count }

    var instrumentSelectionView: InstrumentSelectionView? {
        context.currentStep.isInstrumentSelection
            ? InstrumentSelectionView(state: instrumentSelectionViewState, context: context, instrumentProvider: instrumentProvider)
            : nil
    }

    var studentDetailsView: StudentDetailsView? {
        context.currentStep.studentDetailsValue.map {
            StudentDetailsView(
                instrument: $0,
                state: studentDetailsViewState,
                context: context,
                keyboardDismisser: keyboardDismisser
            )
        }
    }

    var addressDetailsView: AddressDetailsView? {
        context.currentStep.addressDetailsValue.map { values in
            AddressDetailsView(
                student: values.1,
                instrument: values.0,
                state: addressDetailsViewState,
                context: context,
                addressProvider: AddressSearchService(accessTokenProvider: accessTokenProvider)
            )
        }
    }

    var schedulingView: SchedulingView? {
        context.currentStep.schedulingValue.map {
            SchedulingView(
                instrument: $0,
                state: schedulingViewState,
                context: context
            )
        }
    }

    var privateNoteView: PrivateNoteView? {
        context.currentStep.isPrivateNote
            ? PrivateNoteView(
                state: privateNoteViewState,
                context: context,
                keyboardDismisser: keyboardDismisser
            )
            : nil
    }

    var reviewRequestView: ReviewRequestView? {
        context.currentStep.reviewRequestValue.map {
            ReviewRequestView(
                coordinator: coordinator,
                context: context,
                instrument: $0.0,
                student: $0.1,
                address: $0.2,
                schedule: $0.3,
                privateNote: $0.4
            )
        }
    }
}
