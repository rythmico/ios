import SwiftUISugar

struct RythmicoLabel<AlignedContent: View>: View {
    @Environment(\.sizeCategory) private var sizeCategory

    let asset: ImageAsset
    let title: Text
    @ViewBuilder
    let alignedContent: AlignedContent

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .grid(3)) {
            Image(uiImage: asset.image.resized(width: iconWidth)).renderingMode(.template).offset(y: iconYOffset + 0.25)
            VStack(spacing: .grid(2)) {
                title.rythmicoTextStyle(titleStyle).frame(maxWidth: .infinity, alignment: .leading)
                alignedContent.frame(maxWidth: .infinity, alignment: .leading)
            }
            .minimumScaleFactor(0.5)
        }
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

    private var titleStyle: Font.RythmicoTextStyle {
        .body
    }

    private var titleCapHeight: CGFloat {
        UIFont.rythmicoFont(
            titleStyle,
            overrideSizeCategory: UIContentSizeCategory(sizeCategory)
        ).capHeight
    }
}

extension RythmicoLabel where AlignedContent == EmptyView {
    init(asset: ImageAsset, title: Text) {
        self.init(asset: asset, title: title, alignedContent: EmptyView.init)
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
        }
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
