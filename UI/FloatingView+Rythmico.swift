import SwiftUI

extension FloatingView {
    init(@ViewBuilder content: () -> Content) {
        self.backgroundColor = .rythmicoBackgroundSecondary
        self.content = content()
    }
}
