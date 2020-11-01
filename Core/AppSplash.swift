import SwiftUI

struct AppSplash: View {
    enum Const {
        static let animationDuration: TimeInterval = 0.2
        static let animationDelay: TimeInterval = 0.3 // must be over 0.18
    }

    var image: ImageAsset
    var title: String

    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack(spacing: .spacingLarge) {
                Image(image.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68)
                if isShowingTitle {
                    Text(title)
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
        .transition(.opacity)
        .onAppear(perform: showTitle)
    }

    @State private var isShowingTitle = false

    func showTitle() {
        let animation = Animation
            .rythmicoSpring(duration: Const.animationDuration)
            .delay(Const.animationDelay)
        withAnimation(animation) { isShowingTitle = true }
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
            .font(.system(size: 28, weight: .bold))
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
