import SwiftUI

extension View {
    func sheet<Item, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        sheet(isPresented: Binding(trueIfSome: item), onDismiss: onDismiss) {
            item.wrappedValue.map(content)
        }
    }

    func fullScreenCover<Item, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        fullScreenCover(isPresented: Binding(trueIfSome: item), onDismiss: onDismiss) {
            item.wrappedValue.map(content)
        }
    }
}
