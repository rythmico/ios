import SwiftUISugar

struct RythmicoLabel: View {
    @Environment(\.sizeCategory) var sizeCategory

    let asset: ImageAsset
    let title: Text

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .grid(3)) {
            Image(decorative: asset.name).renderingMode(.template).offset(y: iconYOffset + 0.25)
            title.rythmicoTextStyle(textStyle).minimumScaleFactor(0.5)
        }
    }

    private var textStyle: Font.RythmicoTextStyle {
        .body
    }

    private var titleCapHeight: CGFloat {
        UIFont.rythmicoFont(
            textStyle,
            overrideSizeCategory: UIContentSizeCategory(sizeCategory)
        ).capHeight
    }

    private var iconYOffset: CGFloat {
        -(titleCapHeight - asset.image.size.height) / 2
    }
}

#if DEBUG
struct RythmicoLabel_Previews: PreviewProvider {
    static var previews: some View {
        RythmicoLabel(
            asset: Asset.Icon.Label.info,
            title: Text("Something and a very long string of whatever things m8")
        )
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
