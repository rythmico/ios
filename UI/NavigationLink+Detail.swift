import SwiftUI

extension NavigationLink where Destination == AnyView {
    init<Value, Destination: View>(
        @ViewBuilder destination: (Value) -> Destination,
        item: Binding<Value?>,
        @ViewBuilder label: () -> Label
    ) {
        let destination = Group {
            if let value = item.wrappedValue {
                destination(value)
            }
        }

        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        self.init(destination: AnyView(destination), isActive: isActive, label: label)
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

    @ViewBuilder
    func detail<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder content: () -> Destination
    ) -> some View {
        background(NavigationLink(destination: content(), isActive: isActive, label: EmptyView.init))
    }
}
