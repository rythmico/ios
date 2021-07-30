import SwiftUISugar

struct InfoBanner: View {
    let text: String

    var body: some View {
        Container(
            style: .init(
                fill: .rythmico.azureBlue,
                shape: .squircle(radius: 4, style: .continuous),
                border: .none
            )
        ) {
            HStack(alignment: .firstTextBaseline, spacing: .grid(3)) {
                Image(decorative: Asset.Icon.Label.info.name)
                    .renderingMode(.template)
                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - .grid(1) }
                Text(text)
                    .rythmicoTextStyle(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.grid(4))
            .foregroundColor(.rythmico.foreground)
            .accentColor(.rythmico.foreground)
        }
    }
}

#if DEBUG
struct InfoBanner_Previews: PreviewProvider {
    static var previews: some View {
        InfoBanner(text: "Hello World")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
