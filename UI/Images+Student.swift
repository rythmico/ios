import SwiftUISugar

extension Image {
    static func checkmarkIcon(color: Color) -> some View {
        Image(decorative: Asset.Icon.Misc.checkmark.name)
            .renderingMode(.template)
            .foregroundColor(color)
    }
}

// MARK: Chevrons

let chevronSymbolSize:                     CGFloat = 14
let chevronSymbolWeight:               Font.Weight = .medium
let chevronSymbolWeightUIKit: UIImage.SymbolWeight = .medium
let chevronSymbolScale:                Image.Scale = .large
let chevronSymbolScaleUIKit:   UIImage.SymbolScale = .large

extension Image {
    static var chevronLeft: some View { chevronSymbolImage(.chevronLeft) }
    static var chevronRight: some View { chevronSymbolImage(.chevronRight) }

    private static func chevronSymbolImage(_ symbol: SFSymbol) -> some View {
        Image(systemSymbol: symbol)
            .renderingMode(.template)
            .font(.system(size: chevronSymbolSize, weight: chevronSymbolWeight)).imageScale(chevronSymbolScale)
    }
}

extension UIImage {
    static var chevronLeft: UIImage { chevronSymbolImage(.chevronLeft) }
    static var chevronRight: UIImage { chevronSymbolImage(.chevronRight) }

    private static func chevronSymbolImage(_ symbol: SFSymbol) -> UIImage {
        UIImage(systemSymbol: symbol)
            .withRenderingMode(.alwaysTemplate)
            .applyingSymbolConfiguration(
                .init(pointSize: chevronSymbolSize, weight: chevronSymbolWeightUIKit, scale: chevronSymbolScaleUIKit)
            )!
    }
}
