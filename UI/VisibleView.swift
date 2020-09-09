import SwiftUI
import Combine

protocol VisibleView {
    var isVisibleBinding: Binding<Bool> { get }
}

extension View {
    func visible<VV: VisibleView>(_ view: VV) -> some View {
        visibility(view.isVisibleBinding)
    }

    private func visibility(_ visibilityBinding: Binding<Bool>) -> some View {
        self.onAppear { visibilityBinding.wrappedValue = true }
            .onDisappear { visibilityBinding.wrappedValue = false }
    }
}

extension View {
    func onAppearOrForeground<VV: VisibleView>(
        _ view: VV,
        perform action: @escaping () -> Void
    ) -> some View {
        self.onAppear(perform: action)
            .onEvent(.appInForeground, if: view.isVisibleBinding, perform: action)
    }
}
