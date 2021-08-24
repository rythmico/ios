import SwiftUIEncore

// TODO: potentially define in a more semantically generic way...
// (e.g. as a HorizontalInsets static member)
let TitleContentViewHorizontalPadding = HorizontalInsets(.grid(5))

struct TitleContentView<Accessory: View, Content: View>: View {
    let title: String
    let style: Font.RythmicoTextStyle
    let accessory: Accessory
    let spacing: CGFloat
    @ViewBuilder
    let content: (_ padding: HorizontalInsets) -> Content

    init(
        _ title: String,
        style: Font.RythmicoTextStyle = .largeTitle,
        accessory: Accessory,
        spacing: CGFloat = .grid(3),
        @ViewBuilder content: @escaping (_ padding: HorizontalInsets) -> Content
    ) {
        self.title = title
        self.style = style
        self.accessory = accessory
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        VStack(spacing: spacing) {
            HStack(spacing: .grid(3)) {
                Text(title)
                    .rythmicoTextStyle(style)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibility(addTraits: .isHeader)
                accessory
            }
            .padding(TitleContentViewHorizontalPadding)

            content(TitleContentViewHorizontalPadding)
                .environment(\.idealHorizontalInsets, TitleContentViewHorizontalPadding)
        }
        .foregroundColor(.rythmico.foreground)
        .padding(.top, style == .largeTitle ? .grid(1) : 0)
    }
}

extension TitleContentView where Accessory == EmptyView {
    init(
        _ title: String,
        style: Font.RythmicoTextStyle = .largeTitle,
        spacing: CGFloat = .grid(3),
        @ViewBuilder content: @escaping (_ padding: HorizontalInsets) -> Content
    ) {
        self.init(title, style: style, accessory: EmptyView(), spacing: spacing, content: content)
    }
}

extension EnvironmentValues {
    private struct IdealHorizontalInsetsKey: EnvironmentKey {
        static let defaultValue: HorizontalInsets = .zero
    }

    var idealHorizontalInsets: HorizontalInsets {
        get { self[IdealHorizontalInsetsKey.self] }
        set { self[IdealHorizontalInsetsKey.self] = newValue }
    }
}
