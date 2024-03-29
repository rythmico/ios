import SwiftUIEncore

struct ProgressBar: View {
    private enum Const {
        static let height: CGFloat = .grid(4)
    }

    private let progress: Double

    init(progress: Double) {
        self.progress = progress
    }

    var body: some View {
        GeometryReader { metrics in
            ZStack(alignment: .leading) {
                Capsule(style: .circular).fill(barColor)
                Capsule(style: .circular).fill(progressColor)
                    .frame(maxWidth: barWidth(metrics), maxHeight: barHeight(metrics))
                    .padding(.horizontal, barHorizontalPadding(metrics))
            }
        }
        .frame(height: Const.height)
    }

    private func barWidth(_ metrics: GeometryProxy) -> CGFloat {
        metrics.size.width * CGFloat(progress)
    }

    private func barHeight(_ metrics: GeometryProxy) -> CGFloat {
        metrics.size.height / 2
    }

    private func barHorizontalPadding(_ metrics: GeometryProxy) -> CGFloat {
        (Const.height - barHeight(metrics)) / 2
    }

    private var barColor: Color {
        .rythmico.picoteeBlue
    }

    private var progressColor: Color {
        Color(
            light: .rythmico.resolved(\.azureBlue, mode: .light),
            dark: .rythmico.resolved(\.darkPurple, mode: .dark)
        )
    }
}

#if DEBUG
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        StatefulView(Double(0)) { $progress in
            ProgressBar(progress: progress).onAppear {
                withAnimation(.easeInOut.speed(0.25).delay(1)) {
                    progress = 1
                }
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
