import UIKit
import AVKit

extension AppDelegate {
    func allowAudioPlaybackOnSilentMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            assertionFailure("AVAudioSessionCategoryPlayback not set")
        }
    }
}
