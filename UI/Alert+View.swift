import SwiftUI

extension View {
    func alert(item: Binding<Alert?>) -> some View {
        alert(
            isPresented: Binding(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            ),
            content: { item.wrappedValue! }
        )
    }
}
