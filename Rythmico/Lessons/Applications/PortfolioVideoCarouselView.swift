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
        .sheet(item: $selectedVideo) {
            VideoPlayer(player: AVPlayer(url: $0.videoURL).then { $0.play() })
                .edgesIgnoringSafeArea(.all)
        }
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
