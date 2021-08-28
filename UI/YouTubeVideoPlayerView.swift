import SwiftUIEncore
import YouTubeiOSPlayerHelper

struct YouTubeVideoPlayerView: UIViewRepresentable {
    var videoId: String

    func makeUIView(context: Context) -> YTPlayerView {
        YTPlayerView() => {
            $0.isHidden = true
            $0.delegate = context.coordinator
            $0.load(
                withVideoId: videoId,
                playerVars: [
                    "playsinline": 1,
                    "iv_load_policy": 3,
                    "rel": 0,
                    "modestbranding": 1
                ]
            )
        }
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, YTPlayerViewDelegate {
        func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
            playerView.playVideo()
        }

        func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
            if playerView.isHidden, state == .buffering {
                playerView.isHidden = false
            }
        }
    }
}
