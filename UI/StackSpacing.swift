import SwiftUI

struct HSpacing: View {
    var spacing: CGFloat

    init(_ spacing: CGFloat) {
        self.spacing = spacing
    }

    var body: some View {
        Color.clear.frame(width: spacing, height: 0)
    }
}

struct VSpacing: View {
    var spacing: CGFloat

    init(_ spacing: CGFloat) {
        self.spacing = spacing
    }

    var body: some View {
        Color.clear.frame(width: 0, height: spacing)
    }
}
