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
            Text("\(currentStep) / \(totalSteps)").rythmicoFont(.footnote).foregroundColor(.rythmicoGray90)
        }
    }
}
