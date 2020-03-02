import SwiftUI
import ViewModel

struct RequestLessonPlanView: View, Identifiable, ViewModelable {
    let id = UUID()

    @ObservedObject var viewModel: RequestLessonPlanViewModel

    @Environment(\.betterSheetPresentationMode) private var presentationMode

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
                ForEach(0..<viewData.currentStep.allViews.count) { index in
                    self.viewData.currentStep.allViews[index].tag(index).transition(self.pageTransition(forStepIndex: index))
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: viewData.currentStepNumber)
            .onEdgeSwipe(.left, perform: self.viewModel.back)
        }
        .betterSheetIsModalInPresentation(viewData.shouldShowBackButton)
    }

    private func pageTransition(forStepIndex index: Int) -> AnyTransition {
        AnyTransition.move(
            edge: index == viewData.currentStep.index
                ? viewData.direction == .next ? .trailing : .leading
                : viewData.direction == .next ? .leading : .trailing
        )
        .combined(with: .opacity)
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
