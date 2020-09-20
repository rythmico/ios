import SwiftUI
import AVKit

struct VideoCarouselView: View {
    var videos: [Portfolio.Video]

    let rows = [GridItem(.fixed(.spacingUnit * 33), alignment: .leading)]

    @State
    private var selectedVideo: Portfolio.Video?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: .spacingExtraSmall) {
                ForEach(videos, id: \.self) { video in
                    VideoCarouselCell(video: video).onTapGesture {
                        selectedVideo = video
                    }
                }
            }
            .padding(.horizontal, .spacingMedium)
        }
        .fullScreenCover(item: $selectedVideo) {
            VideoPlayer(player: AVPlayer(url: $0.videoURL).then { $0.play() })
                .edgesIgnoringSafeArea(.all)
                .gesture(
                    DragGesture().onEnded {
                        if $0.translation.height > 150 {
                            selectedVideo = nil
                        }
                    }
                )
        }
    }
}

private struct VideoCarouselCell: View {
    var video: Portfolio.Video

    var body: some View {
        ZStack {
            AsyncImage(.simple(video.thumbnailURL)) {
                if let uiImage = $0 {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.rythmicoGray20
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
