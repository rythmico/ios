import SwiftUISugar

struct NavigationBar<BackButton: View, LeadingItem: View, Title: View, TrailingItem: View>: View {
    @ViewBuilder var backButton: BackButton
    @ViewBuilder var leadingItem: LeadingItem
    @ViewBuilder var title: Title
    @ViewBuilder var trailingItem: TrailingItem

    var body: some View {
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
    init(
        @ViewBuilder backButton: @escaping () -> BackButton,
        @ViewBuilder trailingItem: @escaping () -> TrailingItem
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
            backButton: { BackButton(action: {}) },
            leadingItem: { EmptyView() },
            title: { EmptyView() },
            trailingItem: { Text("qwdwd") }
        )
        .previewLayout(.sizeThatFits)
    }
}
#endif
