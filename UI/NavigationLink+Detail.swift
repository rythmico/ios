import SwiftUI

extension NavigationLink {
    init?<Value>(
        @ViewBuilder destination: (Value) -> Destination,
        item: Binding<Value?>,
        @ViewBuilder label: () -> Label
    ) {
        guard let value = item.wrappedValue else {
            return nil
        }

        let isActive = Binding(
            get: { true },
            set: { newValue in if !newValue { item.wrappedValue = nil } }
        )

        self.init(destination: destination(value), isActive: isActive, label: label)
    }
}

extension View {
    @ViewBuilder
    func detail<Value, Destination: View>(
        item: Binding<Value?>,
        @ViewBuilder content: (Value) -> Destination
    ) -> some View {
        background(NavigationLink(destination: content, item: item, label: EmptyView.init))
    }
}
