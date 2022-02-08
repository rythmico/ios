import SwiftUIEncore

struct InfoBanner: View {
    let text: String

    var body: some View {
        Container(
            style: .init(
                fill: Color.rythmico.azureBlue,
                shape: .squircle(radius: 4, style: .continuous),
                border: .none
            )
        ) {
            RythmicoLabel(
                asset: Asset.Icon.Label.info,
                title: Text(text),
                titleStyle: .callout,
                titleSpacing: .grid(2)
            )
            .padding(.grid(4))
            .frame(maxWidth: .infinity, alignment: .leading)
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
