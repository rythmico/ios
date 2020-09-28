import Foundation
import AVKit

extension App {
    func allowAudioPlaybackOnSilentMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            assertionFailure("AVAudioSessionCategoryPlayback not set")
        }
    }
}
