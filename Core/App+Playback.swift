import Foundation
import AVKit

extension App.Delegate {
    func allowAudioPlaybackOnSilentMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            assertionFailure("AVAudioSessionCategoryPlayback not set")
        }
    }
}
