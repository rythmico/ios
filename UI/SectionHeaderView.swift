import SwiftUI

struct SectionHeaderView<Accessory: View>: View {
    var title: String
    var accessory: Accessory

    var body: some View {
        HStack(alignment: .center, spacing: .spacingExtraSmall) {
            Text(title.localizedUppercase)
                .fixedSize(horizontal: true, vertical: false)
                .rythmicoFont(.footnoteBold)
                .foregroundColor(.rythmicoGray90)
            VStack {
                Divider().background(Color.rythmicoGray20)
            }
            accessory
        }
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
    var alignment: HorizontalAlignment
    var padding: EdgeInsets
    var accessory: Accessory
    var content: Content

    init(
        title: String,
        alignment: HorizontalAlignment = .center,
        padding: EdgeInsets = .zero,
        accessory: Accessory,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.alignment = alignment
        self.padding = padding
        self.accessory = accessory
        self.content = content()
    }

    var body: some View {
        VStack(alignment: alignment, spacing: .spacingSmall) {
            SectionHeaderView(title: title, accessory: accessory).padding(padding)
            content
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
