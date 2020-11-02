import SwiftUI

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
    var image: ImageAsset
    var title: String
    var titleHidden: Bool = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack(spacing: .spacingLarge) {
                Image(uiImage: image.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68)
                if !titleHidden {
                    Text(title)
                        .multilineTextAlignment(.center)
                        .lineSpacing(.spacingUnit)
                        .modifier(AppSplashTitleModifier())
                        .transition(
                            AnyTransition
                                .opacity
                                .combined(with: .offset(y: -.spacingLarge))
                        )
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

private struct AppSplashTitleModifier: ViewModifier {
    #if RYTHMICO
    func body(content: Content) -> some View {
        content
            .rythmicoFont(.largeTitle)
            .foregroundColor(.rythmicoForeground)
    }
    #elseif TUTOR
    func body(content: Content) -> some View {
        content
            .font(Font.system(.largeTitle).bold())
    }
    #endif
}

#if DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        AppSplash(image: Asset.appLogo, title: "Rythmico")
    }
}
#endif
