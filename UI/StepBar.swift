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
                .rythmicoTextStyle(.footnoteBold)
                .foregroundColor(.rythmico.picoteeBlue)
        }
        .frame(maxWidth: .grid(.max))
        .accessibilityElement()
        .accessibility(label: Text("Step indicator"))
        .accessibility(value: Text("\(currentStep) out of \(totalSteps) steps completed"))
    }
}

#if DEBUG
struct StepBar_Previews: PreviewProvider {
    static var previews: some View {
        let steps = 0...4
        ForEach(steps, id: \.self) { step in
            StepBar(step, of: steps.upperBound)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
