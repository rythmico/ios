import SwiftUISugar

extension Image {
    static func checkmarkIcon(color: Color) -> some View {
        Image(decorative: Asset.Icon.Misc.checkmark.name)
            .renderingMode(.template)
            .foregroundColor(color)
    }
}

// MARK: Symbol-based

private let symbolSize: CGFloat = 15
private let symbolWeight: (Font.Weight, UIImage.SymbolWeight) = (.medium, .medium)
private let symbolScale: (Image.Scale, UIImage.SymbolScale) = (.large, .large)

extension Image {
    static let chevronLeft: some View = symbolImage(.chevronLeft)
    static let chevronRight: some View = symbolImage(.chevronRight)
    static let x: some View = symbolImage(.xmark)

    private static func symbolImage(_ symbol: SFSymbol) -> some View {
        Image(systemSymbol: symbol)
            .renderingMode(.template)
            .font(.system(size: symbolSize, weight: symbolWeight.0)).imageScale(symbolScale.0)
    }
}

extension UIImage {
    static let chevronLeft = symbolImage(.chevronLeft)
    static let chevronRight = symbolImage(.chevronRight)
    static let x = symbolImage(.xmark)

    private static func symbolImage(_ symbol: SFSymbol) -> UIImage {
        UIImage(systemSymbol: symbol)
            .withRenderingMode(.alwaysTemplate)
            .applyingSymbolConfiguration(
                .init(pointSize: symbolSize, weight: symbolWeight.1, scale: symbolScale.1)
            )!
    }
}
