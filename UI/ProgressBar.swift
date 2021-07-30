import SwiftUI

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
                Capsule(style: .circular).fill(Color.rythmico.picoteeBlue)
                Capsule(style: .circular).fill(Color.rythmico.azureBlue)
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
}

#if DEBUG
struct ProgressBar_PreviewContainer: View {
    @State var progress: Double = 0

    var body: some View {
        ProgressBar(progress: progress)
            .onAppear {
                withAnimation(.default.speed(0.01)) {
                    progress = 1
                }
            }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar_PreviewContainer()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
