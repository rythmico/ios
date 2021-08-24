import SwiftUIEncore

enum RythmicoLabelLayout: Hashable {
    case iconAndTitle
    case titleAndIcon
}

struct RythmicoLabel<Icon: View, AlignedContent: View>: View {
    @Environment(\.sizeCategory) private var sizeCategory

    var layout: RythmicoLabelLayout = .iconAndTitle
    let icon: Icon
    let title: Text
    var titleStyle: Font.RythmicoTextStyle = .body
    var titleSpacing: CGFloat = .grid(3)
    var titleLineLimit: Int? = nil
    var alignedContentSpacing: CGFloat = .grid(2)
    @ViewBuilder
    let alignedContent: AlignedContent

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: titleSpacing) {
            if layout == .iconAndTitle { iconView }
            VStack(alignment: .leading, spacing: alignedContentSpacing) {
                title
                    .rythmicoTextStyle(titleStyle)
                    .lineLimit(titleLineLimit)
                    .minimumScaleFactor(titleLineLimit == nil ? 1 : 0.5)
                alignedContent
            }
            .fixedSize(horizontal: false, vertical: true)
            if layout == .titleAndIcon { iconView }
        }
        .foregroundColor(.rythmico.foreground)
    }

    @State
    private var iconHeight: CGFloat = 0

    @ViewBuilder
    private var iconView: some View {
        icon.onSizeChange { iconHeight = $0.height }
            .alignmentGuide(.firstTextBaseline) { $0[.bottom] - iconYOffset }
    }

    private var iconYOffset: CGFloat {
        -(titleCapHeight - iconHeight) / 2
    }

    private var titleCapHeight: CGFloat {
        UIFont.rythmicoFont(
            titleStyle,
            overrideSizeCategory: UIContentSizeCategory(sizeCategory)
        ).capHeight
    }
}

extension RythmicoLabel where Icon == DynamicImage {
    init(
        layout: RythmicoLabelLayout = .iconAndTitle,
        asset: ImageAsset,
        title: Text,
        titleStyle: Font.RythmicoTextStyle = .body,
        titleSpacing: CGFloat = .grid(3),
        titleLineLimit: Int? = nil,
        alignedContentSpacing: CGFloat = .grid(2),
        @ViewBuilder alignedContent: () -> AlignedContent
    ) {
        self.init(
            layout: layout,
            icon: DynamicImage(asset: asset),
            title: title,
            titleStyle: titleStyle,
            titleSpacing: titleSpacing,
            titleLineLimit: titleLineLimit,
            alignedContentSpacing: alignedContentSpacing,
            alignedContent: alignedContent
        )
    }
}

extension RythmicoLabel where AlignedContent == EmptyView {
    init(
        layout: RythmicoLabelLayout = .iconAndTitle,
        icon: Icon,
        title: Text,
        titleStyle: Font.RythmicoTextStyle = .body,
        titleSpacing: CGFloat = .grid(3),
        titleLineLimit: Int? = nil,
        alignedContentSpacing: CGFloat = .grid(2)
    ) {
        self.init(
            layout: layout,
            icon: icon,
            title: title,
            titleStyle: titleStyle,
            titleSpacing: titleSpacing,
            titleLineLimit: titleLineLimit,
            alignedContentSpacing: alignedContentSpacing,
            alignedContent: EmptyView.init
        )
    }
}

extension RythmicoLabel where Icon == DynamicImage, AlignedContent == EmptyView {
    init(
        layout: RythmicoLabelLayout = .iconAndTitle,
        asset: ImageAsset,
        title: Text,
        titleStyle: Font.RythmicoTextStyle = .body,
        titleSpacing: CGFloat = .grid(3),
        titleLineLimit: Int? = nil,
        alignedContentSpacing: CGFloat = .grid(2)
    ) {
        self.init(
            layout: layout,
            asset: asset,
            title: title,
            titleStyle: titleStyle,
            titleSpacing: titleSpacing,
            titleLineLimit: titleLineLimit,
            alignedContentSpacing: alignedContentSpacing,
            alignedContent: EmptyView.init
        )
    }
}

#if DEBUG
struct RythmicoLabel_Previews: PreviewProvider {
    static var previews: some View {
        RythmicoLabel(
            asset: Asset.Icon.Label.info,
            title: Text("Something and a very long string of whatever things m8")
        ) {
            Text("Additional content")
                .rythmicoFontWeight(.body)
                .background(Color.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
