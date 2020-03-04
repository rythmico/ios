import SwiftUI
import Combine

typealias SchedulingView = AnyView
typealias PrivateNoteView = AnyView
typealias ReviewProposalView = AnyView

struct RequestLessonPlanView: View, Identifiable {
    @ObservedObject
    private var context: RequestLessonPlanContext
    private let instrumentProvider: InstrumentSelectionListProviderProtocol

    let id = UUID()
    @Environment(\.betterSheetPresentationMode) private var presentationMode

    init(instrumentProvider: InstrumentSelectionListProviderProtocol) {
        self.instrumentProvider = instrumentProvider
        self.context = RequestLessonPlanContext()

    }

    var shouldShowBackButton: Bool {
        switch context.currentStep {
        case .instrumentSelection:
            return false
        default:
            return true
        }
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
                ? context.currentStep > context.previousStep ? .trailing : .leading
                : context.currentStep > context.previousStep ? .leading : .trailing
        )
        .combined(with: .opacity)
    }

    func back() {
        guard context.student == nil else {
            context.student = nil
            return
        }

        guard context.instrument == nil else {
            context.instrument = nil
            return
        }
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
        guard case .instrumentSelection = context.currentStep else {
            return nil
        }
        return InstrumentSelectionView(context: context, instrumentProvider: instrumentProvider)
    }

    var studentDetailsView: StudentDetailsView? {
        guard case let .studentDetails(instrument) = context.currentStep else {
            return nil
        }
        return StudentDetailsView(instrument: instrument, context: context, editingCoordinator: UIApplication.shared, dispatchQueue: .main)
    }

    var addressDetailsView: AddressDetailsView? {
        guard case let .addressDetails(instrument, student) = context.currentStep else {
            return nil
        }
        return AddressDetailsView(student: student, instrument: instrument)
    }

    var schedulingView: SchedulingView? {
        guard case .scheduling = context.currentStep else {
            return nil
        }
        return SchedulingView(EmptyView())
    }

    var privateNoteView: PrivateNoteView? {
        guard case .privateNote = context.currentStep else {
            return nil
        }
        return PrivateNoteView(EmptyView())
    }

    var reviewProposalView: ReviewProposalView? {
        guard case .reviewProposal = context.currentStep else {
            return nil
        }
        return ReviewProposalView(EmptyView())
    }
}

struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(instrumentProvider: InstrumentSelectionListProviderFake())
    }
}
