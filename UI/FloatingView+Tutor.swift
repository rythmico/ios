import SwiftUI

extension FloatingView {
    init(@ViewBuilder content: () -> Content) {
        self.backgroundColor = .init(.systemBackground)
        self.content = content()
    }
}
