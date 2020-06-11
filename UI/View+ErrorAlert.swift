import SwiftUI

extension View {
    func alert(
        error: @autoclosure @escaping () -> Error?,
        dismiss: @escaping () -> Void
    ) -> some View {
        alert(error: error()?.localizedDescription, dismiss: dismiss)
    }

    func alert(
        error: @autoclosure @escaping () -> String?,
        dismiss: @escaping () -> Void
    ) -> some View {
        let binding = Binding(
            get: { error() },
            set: { if $0 == nil { dismiss() } }
        )
        return alert(item: binding) {
            Alert(title: Text("An error ocurred"), message: Text($0))
        }
    }
}
