import SwiftUI
import Sugar

struct RequestLessonPlanView: View, Identifiable, TestableView {
    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    fileprivate let instrumentSelectionViewState = InstrumentSelectionView.ViewState()
    fileprivate let studentDetailsViewState = StudentDetailsView.ViewState()
    fileprivate let addressDetailsViewState = AddressDetailsView.ViewState()
    fileprivate let schedulingViewState = SchedulingView.ViewState()
    fileprivate let privateNoteViewState = PrivateNoteView.ViewState()

    @ObservedObject
    private var context: RequestLessonPlanContext
    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let instrumentProvider: InstrumentSelectionListProviderProtocol
    private let keyboardDismisser: KeyboardDismisser

    init(
        context: RequestLessonPlanContext,
        accessTokenProvider: AuthenticationAccessTokenProvider,
        instrumentProvider: InstrumentSelectionListProviderProtocol,
        keyboardDismisser: KeyboardDismisser
    ) {
        self.context = context
        self.accessTokenProvider = accessTokenProvider
        self.instrumentProvider = instrumentProvider
        self.keyboardDismisser = keyboardDismisser
    }

    let id = UUID()
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
        .betterSheetIsModalInPresentation(shouldShowBackButton)
        .onAppear { self.didAppear?(self) }
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

extension RequestLessonPlanView {
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
                keyboardDismisser: UIApplication.shared
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
                keyboardDismisser: UIApplication.shared
            )
            : nil
    }

    var reviewRequestView: ReviewRequestView? {
        context.currentStep.reviewRequestValue.map {
            ReviewRequestView(
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

struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        let context = RequestLessonPlanContext()
        context.instrument = .guitarStub
        context.student = .davidStub
        context.address = .stub
        context.schedule = .stub
        context.privateNote = "Note"
        let view = RequestLessonPlanView(
            context: context,
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            instrumentProvider: InstrumentSelectionListProviderFake(),
            keyboardDismisser: UIApplication.shared
        )

        view.instrumentSelectionViewState.instruments = [
            .init(name: Instrument.guitarStub.name, icon: Instrument.guitarStub.icon, action: nil)
        ]

//        view.addressDetailsViewState.addresses = [
//            .stub, .stub, .stub, .stub, .stub, .stub, .stub, .stub
//        ]

        return view
            .environment(\.locale, Locale(identifier: "en_GB"))
            .previewDevices()
    }
}
