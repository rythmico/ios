import SwiftUI

struct SectionHeaderView: View {
    var title: String

    var body: some View {
        HStack(alignment: .center, spacing: .spacingExtraSmall) {
            Text(title.localizedUppercase)
                .fixedSize(horizontal: true, vertical: false)
                .rythmicoFont(.footnote)
                .foregroundColor(.rythmicoGray90)
            VStack {
                Divider().background(Color.rythmicoGray20)
            }
        }
    }
}

struct SectionHeaderContentView<Content: View>: View {
    var title: String
    var padding: EdgeInsets
    var content: Content

    init(
        title: String,
        padding: EdgeInsets = .zero,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        VStack(spacing: .spacingSmall) {
            SectionHeaderView(title: title).padding(padding)
            content
        }
    }
}
