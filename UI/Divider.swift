import SwiftUI

struct HDivider: View {
    var body: some View {
        Color.rythmico.gray20.opacity(0.75)
            .frame(maxWidth: .infinity, maxHeight: 1)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct HDividerContainer<Content: View>: View {
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            HDivider()
            content
            HDivider()
        }
    }
}
