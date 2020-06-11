import SwiftUI

extension View {
    func alert(
        error: @autoclosure @escaping () -> Error?,
        dismiss: @escaping () -> Void
    ) -> some View {
        let binding = Binding(
            get: { error()?.localizedDescription },
            set: { if $0 == nil { dismiss() } }
        )
        return alert(item: binding) {
            Alert(title: Text("An error ocurred"), message: Text($0.localizedDescription))
        }
    }
}
