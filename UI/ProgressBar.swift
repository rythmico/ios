import SwiftUI

struct ProgressBar: View {
    private enum Const {
        static let height: CGFloat = 8
    }

    private let progress: Double

    init(progress: Double) {
        self.progress = progress
    }

    var body: some View {
        GeometryReader { metrics in
            ZStack(alignment: .leading) {
                Color.rythmico.gray10.cornerRadius(.greatestFiniteMagnitude, antialiased: true)
                Color.rythmico.purple
                    .cornerRadius(.greatestFiniteMagnitude, antialiased: true)
                    .frame(width: metrics.size.width * CGFloat(progress))
            }
        }
        .frame(height: Const.height)
    }
}
