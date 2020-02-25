import SwiftUI
import ViewModel

struct RequestLessonPlanView: View, Identifiable, ViewModelable {
    let id = UUID()

    @Environment(\.betterSheetPresentationMode) private var presentationMode
    @State private var didRecognizeBackGesture: Bool = false

    @ObservedObject var viewModel: RequestLessonPlanViewModel

    var body: some View {
        VStack(spacing: .spacingSmall) {
            VStack(spacing: 0) {
                HStack {
                    if viewData.shouldShowBackButton {
                        BackButton(action: viewModel.back).transition(.opacity)
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
                .animation(.easeInOut(duration: .durationShort), value: viewData.shouldShowBackButton)

                StepBar(viewData.currentStepNumber, of: viewData.stepCount)
                    .padding(.horizontal, .spacingMedium)
            }

            ZStack {
                viewData.currentStep.instrumentSelectionView?.tag(0).transition(pageTransitionForCurrentContext)
                viewData.currentStep.studentDetailsView?.tag(1).transition(pageTransitionForCurrentContext)
                viewData.currentStep.addressDetailsView?.tag(2).transition(pageTransitionForCurrentContext)
                viewData.currentStep.schedulingView?.tag(3).transition(pageTransitionForCurrentContext)
                viewData.currentStep.privateNoteView?.tag(4).transition(pageTransitionForCurrentContext)
                viewData.currentStep.reviewProposalView?.tag(5).transition(pageTransitionForCurrentContext)
            }
            .animation(.easeInOut(duration: .durationMedium), value: viewData.currentStepNumber)
        }
        .highPriorityGesture(
            DragGesture()
                .onChanged { value in
                    if !self.didRecognizeBackGesture, value.startLocation.x <= 40, value.translation.width > 20 {
                        self.didRecognizeBackGesture = true
                        self.viewModel.back()
                    }
                }
                .onEnded { _ in self.didRecognizeBackGesture = false }
        )
        .betterSheetIsModalInPresentation(viewData.shouldShowBackButton)
    }

    private var pageTransitionForCurrentContext: AnyTransition {
        let transition: AnyTransition
        if let direction = viewData.direction {
            transition = .asymmetric(
                insertion: .move(edge: direction == .next ? .trailing : .leading),
                removal: .move(edge: direction == .back ? .leading : .trailing)
            )
        } else {
            transition = .move(edge: .leading)
        }
        return transition.combined(with: .opacity)
    }
}

struct RequestLessonPlanView_Preview: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanView(
            viewModel: RequestLessonPlanViewModel(
                instrumentProvider: InstrumentSelectionListProviderFake()
            )
        )
    }
}
