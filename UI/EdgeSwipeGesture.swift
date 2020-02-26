import SwiftUI
import Sugar

struct EdgeSwipeGesture: Gesture {
    @Binding var recognition: Bool

    var action: Action

    init(_ recognition: Binding<Bool>, action: @escaping Action) {
        self._recognition = recognition
        self.action = action
    }

    var body: some Gesture {
        DragGesture()
            .onChanged { value in
                if !self.recognition, value.startLocation.x <= 40, value.translation.width > 20 {
                    self.recognition = true
                    self.action()
                }
            }
            .onEnded { _ in self.recognition = false }
    }
}
