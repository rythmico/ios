import SwiftUI
import AVKit

struct VideoCarouselView: View {
    var videos: [Portfolio.Video]

    let rows = [GridItem(.fixed(.spacingUnit * 33), alignment: .leading)]

    @Binding
    var selectedVideo: Portfolio.Video?
    @State
    private var scrollViewWidth: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: .spacingExtraSmall) {
                ForEach(videos, id: \.self) { video in
                    VideoCarouselCell(video: video).onTapGesture {
                        selectedVideo = video
                    }
                }
            }
            .padding(.horizontal, scrollViewWidth < .spacingMax ? .spacingMedium : 0)
        }
        .introspectScrollView { scrollViewWidth = $0.frame.width }
        .frame(maxWidth: .spacingMax)
    }
}

private struct VideoCarouselCell: View {
    var video: Portfolio.Video

    var body: some View {
        ZStack {
            AsyncImage(.simple(video.thumbnailURL)) {
                if let uiImage = $0 {
                    GeometryReader { gr in
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: gr.size.width)
                    }
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: .durationShort)))
                } else {
                    Color.rythmicoGray20
                        .scaledToFill()
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: .durationShort)))
                }
            }
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.01), Color.black.opacity(0.4)]),
                startPoint: .top,
                endPoint: .bottom
            )
            Image(decorative: Asset.iconVideo.name)
                .renderingMode(.template)
                .foregroundColor(.rythmicoWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding([.leading, .bottom], .spacingSmall)
        }
        .cornerRadius(.spacingUnit * 2, antialiased: true)
    }
}

/// Video direct link player.
struct VideoCarouselPlayer: View {
    var video: Portfolio.Video
    private var player: AVPlayer

    init(video: Portfolio.Video) {
        self.video = video
        self.player = AVPlayer(url: video.videoURL)
    }

    var body: some View {
        DismissableContainer {
            VideoPlayer(player: player)
        }
        .onAppear(perform: player.play)
    }
}

struct DismissableContainer<Content: View>: View {
    @Environment(\.presentationMode) private var presentationMode

    var backgroundColor: Color
    var content: Content

    init(
        backgroundColor: Color = .black,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }

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
        presentationMode.wrappedValue.dismiss()
    }
}
