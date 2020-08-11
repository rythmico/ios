import SwiftUI

extension View {
    func alert(error: Binding<Error?>) -> some View {
        alert(
            error: Binding(
                get: { error.wrappedValue?.localizedDescription },
                set: { if $0 == nil { error.wrappedValue = nil } }
            )
        )
    }

    func alert(error: Binding<String?>) -> some View {
        alert(item: error) {
            Alert(title: Text("An error ocurred"), message: Text($0))
        }
    }
}

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
        return alert(error: binding)
    }
}
