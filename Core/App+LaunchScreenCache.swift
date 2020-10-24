import Foundation

extension App.Delegate {
    func clearLaunchScreenCache(_ shouldClear: Bool) {
        #if DEBUG
        guard shouldClear else { return }

        do {
            try FileManager.default.removeItem(atPath: NSHomeDirectory() + "/Library/SplashBoard")
        } catch {
            print("Failed to delete launch screen cache: \(error)")
        }
        #endif
    }
}
