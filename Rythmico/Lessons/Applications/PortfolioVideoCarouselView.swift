import SwiftUI
import ComposableNavigator

struct VideoCarouselView: View {
    var videos: [Portfolio.Video]

    let rows = [GridItem(.fixed(.spacingUnit * 33), alignment: .leading)]

    @State
    private var scrollViewWidth: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: .spacingExtraSmall) {
                ForEach(videos, id: \.self, content: VideoCarouselCell.init)
            }
            .padding(.horizontal, scrollViewWidth < .spacingMax ? .spacingMedium : 0)
            .fixedSize(horizontal: false, vertical: true)
        }
        .introspectScrollView { scrollViewWidth = $0.frame.width }
        .frame(maxWidth: .spacingMax)
    }
}

private struct VideoCarouselCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var video: Portfolio.Video

    var body: some View {
        ZStack {
            AsyncImage(content: .simple(video.thumbnailURL)) {
                if let uiImage = $0 {
                    GeometryReader { gr in
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: gr.size.width)
                    }
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                    .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
                } else {
                    Color.rythmicoGray20
                        .scaledToFill()
                        .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
                }
            }
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.01), .black.opacity(0.5)]),
                startPoint: .top,
                endPoint: .bottom
            )
            Image(decorative: Asset.Icon.Misc.video.name)
                .renderingMode(.template)
                .foregroundColor(.rythmicoWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding([.leading, .bottom], .spacingSmall)
        }
        .cornerRadius(.spacingUnit * 2, antialiased: true)
        .overlay(overlay)
        .onTapGesture(perform: openPlayer)
    }

    @Environment(\.colorScheme) private var colorScheme
    @ViewBuilder
    private var overlay: some View {
        if colorScheme == .dark {
            RoundedRectangle(
                cornerRadius: .spacingUnit * 2,
                style: .continuous
            )
            .strokeBorder(Color.white.opacity(0.15), lineWidth: 1, antialiased: true)
        }
    }

    private func openPlayer() {
        navigator.go(to: VideoCarouselPlayerScreen(video: video), on: currentScreen)
    }
}

struct VideoCarouselPlayerScreen: Screen {
    var video: Portfolio.Video
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: VideoCarouselPlayerScreen) in
                    VideoCarouselPlayer(video: screen.video)
                }
            )
        }
    }
}

struct VideoCarouselPlayer: View {
    var video: Portfolio.Video

    var body: some View {
        DismissableContainer {
            switch video.source {
            case .youtube(let videoId):
                YouTubeVideoPlayerView(videoId: videoId)
            case .directURL(let url):
                DirectURLVideoPlayerView(url: url)
            }
        }
    }
}

private struct DismissableContainer<Content: View>: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var backgroundColor: Color = .black
    @ViewBuilder
    var content: Content

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(alignment: .trailing, spacing: 0) {
                CloseButton(action: dismiss)
                    .padding([.trailing, .bottom], .spacingSmall)
                    .padding(.top, .spacingMedium)
                    .accentColor(.rythmicoWhite)
                content
            }
        }
    }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }
}
