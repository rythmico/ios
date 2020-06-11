import SwiftUI

struct StepBar: View {
    var currentStep: Int
    var totalSteps: Int

    init(_ currentStep: Int, of totalSteps: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
    }

    var body: some View {
        HStack(spacing: 10) {
            ProgressBar(progress: Double(currentStep) / Double(totalSteps))
                .animation(.rythmicoSpring(duration: .durationMedium))
            Text("\(currentStep) / \(totalSteps)")
                .rythmicoFont(.footnoteBold)
                .foregroundColor(.rythmicoGray90)
        }
        .accessibilityElement()
        .accessibility(label: Text("Step indicator"))
        .accessibility(value: Text("\(currentStep) out of \(totalSteps) steps completed"))
    }
}
