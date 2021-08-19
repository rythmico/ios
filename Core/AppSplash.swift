import SwiftUISugar

struct AnimatedAppSplash: View {
    enum Const {
        static let animationDuration: TimeInterval = 0.25
        static let animationDelay: TimeInterval = 0.25 // must be over 0.18
    }

    var image: ImageAsset
    var title: String

    @State private var isShowingTitle = false

    var body: some View {
        AppSplash(
            image: image,
            title: title,
            titleHidden: !isShowingTitle
        )
        .onAppear(perform: showTitle)
    }

    func showTitle() {
        let animation = Animation
            .rythmicoSpring(duration: Const.animationDuration)
            .delay(Const.animationDelay)
        withAnimation(animation) { isShowingTitle = true }
    }
}

struct AppSplash: View {
    @Environment(\.appSplashNamespace) private var appSplashNamespace

    var image: ImageAsset
    var title: String
    var titleHidden: Bool = false

    var body: some View {
        VStack(spacing: .grid(6)) {
            Image.rythmicoLogo(width: 68, namespace: appSplashNamespace)
            titleView
        }
        .edgesIgnoringSafeArea(.all)
    }

    @ViewBuilder
    private var titleView: some View {
        if !titleHidden {
            Group {
                #if RYTHMICO
                Text(title)
                    .rythmicoTextStyle(.largeTitle)
                    .foregroundColor(.rythmico.foreground)
                #elseif TUTOR
                Text(title)
                    .font(.system(.largeTitle).bold())
                #endif
            }
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .ifLet(appSplashNamespace) { $0.matchedGeometryEffect(id: NamespaceTitleId(), in: $1) }
            .transition(.offset(y: -.grid(6)) + .opacity)
        }
    }
}

extension AppSplash {
    struct NamespaceLogoId: Hashable {}
    struct NamespaceTitleId: Hashable {}
}

extension EnvironmentValues {
    private struct AppSplashNamespaceKey: EnvironmentKey {
        static let defaultValue: Namespace.ID? = nil
    }

    var appSplashNamespace: Namespace.ID? {
        get { self[AppSplashNamespaceKey.self] }
        set { self[AppSplashNamespaceKey.self] = newValue }
    }
}

#if RYTHMICO && DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        AppSplash(image: Asset.Logo.rythmico, title: "Rythmico")
    }
}
#endif
