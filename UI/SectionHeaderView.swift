import SwiftUI

struct SectionHeaderView<Accessory: View>: View {
    var title: String
    var accessory: Accessory

    var body: some View {
        HStack(alignment: .center, spacing: .grid(3)) {
            Text(title.localizedUppercase)
                .rythmicoTextStyle(.footnoteBold)
                .foregroundColor(.rythmico.gray90)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
            HDivider()
            accessory
        }
        .frame(maxWidth: .grid(.max))
    }
}

extension SectionHeaderView where Accessory == EmptyView {
    init(title: String) {
        self.title = title
        self.accessory = EmptyView()
    }
}

struct SectionHeaderContentView<Accessory: View, Content: View>: View {
    var title: String
    var alignment: HorizontalAlignment = .center
    var padding: EdgeInsets = .zero
    var accessory: Accessory
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(alignment: alignment, spacing: .grid(4)) {
            SectionHeaderView(title: title, accessory: accessory).padding(padding)
            content.frame(maxWidth: .grid(.max), alignment: .leading)
        }
    }
}

extension SectionHeaderContentView where Accessory == EmptyView {
    init(
        title: String,
        alignment: HorizontalAlignment = .center,
        padding: EdgeInsets = .zero,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.alignment = alignment
        self.padding = padding
        self.accessory = EmptyView()
        self.content = content()
    }
}
