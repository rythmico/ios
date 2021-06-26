public struct NavigationBar<BackButton: View, LeadingItem: View, Title: View, TrailingItem: View>: View {
    private let backButton: BackButton
    private let leadingItem: LeadingItem
    private let title: Title
    private let trailingItem: TrailingItem

    public init(
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder leadingItem: () -> LeadingItem,
        @ViewBuilder title: () -> Title,
        @ViewBuilder trailingItem: () -> TrailingItem
    ) {
        self.backButton = backButton()
        self.leadingItem = leadingItem()
        self.title = title()
        self.trailingItem = trailingItem()
    }

    public var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            backButton
                .offset(x: -7)
                .frame(idealWidth: .infinity, alignment: .leading)

            leadingItem
                .frame(idealWidth: .infinity, alignment: .leading)

            if isTitleEmpty {
                Spacer()
            } else {
                title
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            trailingItem
                .multilineTextAlignment(.trailing)
                .frame(idealWidth: .infinity, alignment: .trailing)
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding(.horizontal, spacing)
    }

    var isTitleEmpty: Bool { title is EmptyView }
    var spacing: CGFloat { 16 }
    var height: CGFloat { 56 }
}

extension NavigationBar where LeadingItem == EmptyView, Title == EmptyView {
    public init(
        @ViewBuilder backButton: () -> BackButton,
        @ViewBuilder trailingItem: () -> TrailingItem
    ) {
        self.init(
            backButton: backButton,
            leadingItem: { EmptyView() },
            title: { EmptyView() },
            trailingItem: trailingItem
        )
    }
}

#if DEBUG
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(
            backButton: { Button("Back", action: {}) },
            leadingItem: { EmptyView() },
            title: { EmptyView() },
            trailingItem: { Text("qwdwd") }
        )
        .previewLayout(.sizeThatFits)
    }
}
#endif
