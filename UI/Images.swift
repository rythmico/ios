import SwiftUIEncore

extension Image {
    static func rythmicoLogo(width: CGFloat, namespace: Namespace.ID) -> some View {
        Image(decorative: App.logo.name)
            .resizable()
            .matchedGeometryEffect(id: AppSplash.NamespaceLogoId(), in: namespace)
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
    }
}
