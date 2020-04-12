import SwiftUI
import Sugar

typealias PrivateNoteView = AnyView
typealias ReviewProposalView = AnyView

struct RequestLessonPlanView: View, Identifiable, TestableView {
    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    private let instrumentSelectionViewState = InstrumentSelectionView.ViewState()
    private let studentDetailsViewState = StudentDetailsView.ViewState()
    private let addressDetailsViewState = AddressDetailsView.ViewState()

    @ObservedObject
    private var context: RequestLessonPlanContext
    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    init(
        context: RequestLessonPlanContext,
        accessTokenProvider: AuthenticationAccessTokenProvider,
        instrumentProvider: InstrumentSelectionListProviderProtocol
    ) {
        self.context = context
        self.accessTokenProvider = accessTokenProvider
        self.instrumentProvider = instrumentProvider
    }

    let id = UUID()
    var didAppear: Handler<Self>?

    var shouldShowBackButton: Bool {
        !context.currentStep.isInstrumentSelection
    }

    func back() {
        if context.address.nilifyIfSome() { return }
        if context.student.nilifyIfSome() { return }
        if context.instrument.nilifyIfSome() { return }
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
                .animation(.easeInOut(duration: .durationShort), value: shouldShowBackButton)

                StepBar(currentStepNumber, of: stepCount)
                    .padding(.horizontal, .spacingMedium)
            }

            ZStack {
                instrumentSelectionView.transition(pageTransition(forStepIndex: 0))
                studentDetailsView.transition(pageTransition(forStepIndex: 1))
                addressDetailsView.transition(pageTransition(forStepIndex: 2))
                schedulingView.transition(pageTransition(forStepIndex: 3))
                privateNoteView.transition(pageTransition(forStepIndex: 4))
                reviewProposalView.transition(pageTransition(forStepIndex: 5))
            }
            .animation(.easeInOut(duration: .durationMedium), value: context.currentStep.index)
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
                editingCoordinator: UIApplication.shared,
                dispatchQueue: .main
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
                addressProvider: AddressSearchService(accessTokenProvider: accessTokenProvider),
                editingCoordinator: UIApplication.shared
            )
        }
    }

    var schedulingView: SchedulingView? {
        context.currentStep.isScheduling ? SchedulingView() : nil
    }

    var privateNoteView: PrivateNoteView? {
        context.currentStep.isPrivateNote ? PrivateNoteView(EmptyView()) : nil
    }

    var reviewProposalView: ReviewProposalView? {
        context.currentStep.isReviewProposal ? ReviewProposalView(EmptyView()) : nil
    }
}

struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(
            context: .init(),
            accessTokenProvider: AuthenticationAccessTokenProviderDummy(),
            instrumentProvider: InstrumentSelectionListProviderFake()
        )
    }
}
