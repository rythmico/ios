import SwiftUISugar

extension Image {
    static func rythmicoLogo(width: CGFloat, namespace: Namespace.ID? = .none) -> some View {
        Image(decorative: App.logo.name)
            .resizable()
            .ifLet(namespace) { $0.matchedGeometryEffect(id: AppSplash.NamespaceLogoId(), in: $1) }
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
    }
}
