import SwiftUISugar

struct RythmicoLabel<AlignedContent: View>: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let asset: ImageAsset
    let title: Text
    var titleStyle: Font.RythmicoTextStyle = .body
    var titleLineLimit: Int? = nil
    var alignedContentSpacing: CGFloat = .grid(2)
    @ViewBuilder
    let alignedContent: AlignedContent

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .grid(3)) {
            Image(uiImage: asset.image.resized(width: iconWidth))
                .renderingMode(.template)
                .alignmentGuide(.firstTextBaseline) { $0[.bottom] - iconYOffset - 0.25 }
            VStack(alignment: .leading, spacing: alignedContentSpacing) {
                title
                    .rythmicoTextStyle(titleStyle)
                    .lineLimit(titleLineLimit)
                    .minimumScaleFactor(titleLineLimit == nil ? 1 : 0.5)
                alignedContent
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundColor(.rythmico.foreground)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var iconWidth: CGFloat {
        UIFontMetrics(forTextStyle: .largeTitle)
            .scaledValue(
                for: asset.image.size.width,
                compatibleWith: .init(preferredContentSizeCategory: UIContentSizeCategory(sizeCategory))
            )
    }

    private var iconYOffset: CGFloat {
        -(titleCapHeight - iconWidth) / 2
    }

    private var titleCapHeight: CGFloat {
        UIFont.rythmicoFont(
            titleStyle,
            overrideSizeCategory: UIContentSizeCategory(sizeCategory)
        ).capHeight
    }
}

extension RythmicoLabel where AlignedContent == EmptyView {
    init(
        asset: ImageAsset,
        title: Text,
        titleStyle: Font.RythmicoTextStyle = .body,
        titleLineLimit: Int? = nil
    ) {
        self.init(
            asset: asset,
            title: title,
            titleStyle: titleStyle,
            titleLineLimit: titleLineLimit,
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
