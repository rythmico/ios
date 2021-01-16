import SwiftUI
import AVKit

struct DirectURLVideoPlayerView: View {
    var url: URL
    private var player: AVPlayer

    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)
    }

    var body: some View {
        ZStack {
            VideoPlayer(player: player)
        }
        .onAppear(perform: player.play)
    }
}
