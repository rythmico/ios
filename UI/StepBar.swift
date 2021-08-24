import SwiftUIEncore

struct StepBar: View {
    let currentStep: Int
    let totalSteps: Int

    init(_ currentStep: Int, of totalSteps: Int) {
        self.currentStep = min(currentStep, totalSteps)
        self.totalSteps = totalSteps
    }

    var body: some View {
        HStack(spacing: 0) {
            ProgressBar(progress: Double(currentStep) / Double(totalSteps))
                .animation(.rythmicoSpring(duration: .durationMedium))
            ZStack(alignment: .trailing) {
                progressText(currentStep: currentStep)
                progressText(currentStep: 50).hidden()
            }
        }
        .frame(maxWidth: .grid(.max))
        .accessibilityElement()
        .accessibility(label: Text("Step indicator"))
        .accessibility(value: Text("\(currentStep) out of \(totalSteps) steps completed"))
    }

    @ViewBuilder
    func progressText(currentStep: Int) -> some View {
        Text("\(currentStep)/\(totalSteps)")
            .rythmicoTextStyle(.footnoteBold)
            .foregroundColor(.rythmico.picoteeBlue)
    }
}

#if DEBUG
import Combine

struct StepBar_Previews: PreviewProvider {
    static var cancellables: [AnyCancellable] = []

    static var previews: some View {
        StatefulView(0) { currentStep in
            StepBar(currentStep.wrappedValue, of: 7)
                .onAppear {
                    DispatchQueue.main.schedule(after: .init(.now() + 2), interval: 1) {
                        currentStep.wrappedValue += 1
                    }.store(in: &cancellables)
                }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
