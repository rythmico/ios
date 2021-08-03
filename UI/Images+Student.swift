import SwiftUISugar

extension Image {
    static func checkmarkIcon(color: Color) -> some View {
        Image(decorative: Asset.Icon.Misc.checkmark.name)
            .renderingMode(.template)
            .foregroundColor(color)
    }
}
