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
    var image: ImageAsset
    var title: String
    var titleHidden: Bool = false

    var body: some View {
        ZStack {
            Color(.clear)
            VStack(spacing: .grid(6)) {
                Image(decorative: image.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68)
                if !titleHidden {
                    Text(title)
                        .appSplashTitle()
                        .multilineTextAlignment(.center)
                        .transition(.offset(y: -.grid(6)) + .opacity)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

private extension Text {
    func appSplashTitle() -> some View {
        #if RYTHMICO
        self.rythmicoTextStyle(.largeTitle)
            .foregroundColor(.rythmicoForeground)
        #elseif TUTOR
        self.font(.system(.largeTitle).bold())
        #endif
    }
}

#if RYTHMICO && DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        AppSplash(image: Asset.Logo.rythmico, title: "Rythmico")
    }
}
#endif
