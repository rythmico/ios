import SwiftUI
import Combine
import Sugar

typealias PrivateNoteView = AnyView
typealias ReviewProposalView = AnyView

struct RequestLessonPlanView: View, Identifiable {
    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    private let instrumentSelectionViewState = InstrumentSelectionView.ViewState()
    private let studentDetailsViewState = StudentDetailsView.ViewState()
    private let addressDetailsViewState = AddressDetailsView.ViewState()

    @ObservedObject
    private var context: RequestLessonPlanContext
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    init(instrumentProvider: InstrumentSelectionListProviderProtocol) {
        self.instrumentProvider = instrumentProvider
        self.context = RequestLessonPlanContext()
    }

    let id = UUID()

    var shouldShowBackButton: Bool {
        !context.currentStep.isInstrumentSelection
    }

    func back() {
        if context.address.nilifiedIfSome() { return }
        if context.student.nilifiedIfSome() { return }
        if context.instrument.nilifiedIfSome() { return }
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
                ForEach(0..<allStepViews.count) { index in
                    self.allStepViews[index].tag(index).transition(self.pageTransition(forStepIndex: index))
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: currentStepViewIndex)
            .onEdgeSwipe(.left, perform: back)
        }
        .betterSheetIsModalInPresentation(shouldShowBackButton)
    }

    private func pageTransition(forStepIndex index: Int) -> AnyTransition {
        AnyTransition.move(
            edge: index == currentStepViewIndex
                ? context.direction == .forward ? .trailing : .leading
                : context.direction == .forward ? .leading : .trailing
        )
        .combined(with: .opacity)
    }
}

extension RequestLessonPlanView {
    var allStepViews: [AnyView?] {
        [
            instrumentSelectionView.map(AnyView.init),
            studentDetailsView.map(AnyView.init),
            addressDetailsView.map(AnyView.init),
            schedulingView.map(AnyView.init),
            privateNoteView.map(AnyView.init),
            reviewProposalView.map(AnyView.init)
        ]
    }

    var stepCount: Int { allStepViews.count }

    var currentStepNumber: Int { currentStepViewIndex + 1 }

    var currentStepViewIndex: Int {
        guard let index = allStepViews.firstIndex(where: { $0 != nil }) else {
            preconditionFailure("RequestLessonPlanContext.Step enum cases and RequestLessonPlanView.allStepViews array are not in sync")
        }
        return index
    }

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
                addressProvider: AddressSearchService(),
                editingCoordinator: UIApplication.shared,
                dispatchQueue: .main
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
        RequestLessonPlanView(instrumentProvider: InstrumentSelectionListProviderFake())
    }
}
