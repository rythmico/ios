import SwiftUISugar

struct HeadlineContentView<Accessory: View, Content: View>: View {
    let title: String
    let accessory: Accessory
    let spacing: CGFloat
    @ViewBuilder
    let content: (_ padding: HorizontalInsets) -> Content

    init(
        _ title: String,
        accessory: Accessory,
        spacing: CGFloat = .grid(2),
        @ViewBuilder content: @escaping (_ padding: HorizontalInsets) -> Content
    ) {
        self.title = title
        self.accessory = accessory
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        TitleContentView(
            title,
            style: headerTextStyle,
            accessory: accessory,
            spacing: spacing,
            content: content
        )
    }

    private let headerTextStyle: Font.RythmicoTextStyle = .subheadlineBold
}

extension HeadlineContentView where Accessory == EmptyView {
    init(
        _ title: String,
        spacing: CGFloat = .grid(2),
        @ViewBuilder content: @escaping (_ padding: HorizontalInsets) -> Content
    ) {
        self.init(title, accessory: EmptyView(), spacing: spacing, content: content)
    }
}
