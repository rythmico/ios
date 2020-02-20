import SwiftUI
import ViewModel

struct RequestLessonPlanView: View, Identifiable, ViewModelable {
    private enum Const {
        static let closeButtonImageVerticalPadding: CGFloat = 12
        static let closeButtonImageHorizontalPadding: CGFloat = 28

        static let navigationButtonsTopPadding: CGFloat = 10
        static let navigationButtonsHorizontalPadding: CGFloat = 16

        static let horizontalPadding: CGFloat = 20
    }

    let id = UUID()

    @Environment(\.betterSheetPresentationMode) private var presentationMode
    @State private var didRecognizeBackGesture: Bool = false

    @ObservedObject var viewModel: RequestLessonPlanViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if viewData.shouldShowBackButton {
                    Button(action: viewModel.back) {
                        HStack {
                            Image(systemSymbol: .chevronLeft).font(.system(size: 21, weight: .semibold))
                            Text("Back").rythmicoFont(.callout)
                        }
                    }
                    .foregroundColor(.rythmicoGray90)
                    .transition(.opacity)
                }
                Spacer()
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemSymbol: .xmark).font(.system(size: 21, weight: .semibold))
                        .padding(.vertical, Const.closeButtonImageVerticalPadding)
                        .padding(.horizontal, Const.closeButtonImageHorizontalPadding)
                        .offset(x: Const.closeButtonImageHorizontalPadding)
                }
                .accentColor(.rythmicoGray90)
                .accessibility(label: Text("Close lesson request screen"))
                .accessibility(hint: Text("Double tap to return to main screen"))
            }
            .padding(.top, Const.navigationButtonsTopPadding)
            .padding(.horizontal, Const.navigationButtonsHorizontalPadding)
            .animation(.easeInOut(duration: 0.15), value: viewData.shouldShowBackButton)

            StepBar(viewData.currentStepNumber, of: viewData.stepCount)
                .padding(.horizontal, Const.horizontalPadding)

            ZStack {
                viewData.currentStep.instrumentSelectionView?.tag(0).transition(pageTransitionForCurrentContext)
                viewData.currentStep.studentDetailsView?.tag(1).transition(pageTransitionForCurrentContext)
                viewData.currentStep.addressDetailsView?.tag(2).transition(pageTransitionForCurrentContext)
                viewData.currentStep.schedulingView?.tag(3).transition(pageTransitionForCurrentContext)
                viewData.currentStep.privateNoteView?.tag(4).transition(pageTransitionForCurrentContext)
                viewData.currentStep.reviewProposalView?.tag(5).transition(pageTransitionForCurrentContext)
            }
            .animation(.easeInOut(duration: 0.3), value: viewData.currentStepNumber)
        }
        .gesture(
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
                instrumentProvider: InstrumentProviderFake()
            )
        )
    }
}
