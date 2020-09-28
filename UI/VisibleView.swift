import SwiftUI
import Combine

protocol VisibleView {
    var isVisible: Bool { get nonmutating set }
}

extension View {
    func visible<VV: VisibleView>(_ view: VV) -> some View {
        self.onAppear { view.isVisible = true }
            .onDisappear { view.isVisible = false }
    }
}

extension View {
    func onAppearOrForeground<VV: VisibleView>(
        _ view: VV,
        perform action: @escaping () -> Void
    ) -> some View {
        self.onAppear(perform: action)
            .onEvent(.appInForeground) {
                if view.isVisible {
                    action()
                }
            }
    }
}
