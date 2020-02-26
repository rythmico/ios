import SwiftUI
import Sugar

struct EdgeSwipeGesture: Gesture {
    @State private var didRecognizeGesture: Bool = false

    var action: Action

    var body: some Gesture {
        DragGesture()
            .onChanged { value in
                if !self.didRecognizeGesture, value.startLocation.x <= 40, value.translation.width > 20 {
                    self.didRecognizeGesture = true
                    self.action()
                }
            }
            .onEnded { _ in self.didRecognizeGesture = false }
    }
}
