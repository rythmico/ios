import SwiftUI
import FoundationSugar

extension Binding where Value == Bool {
    init<Wrapped>(trueIfSome optional: Binding<Wrapped?>) {
        self.init(
            get: { optional.wrappedValue != nil },
            set: { if !$0 { optional.wrappedValue = nil } }
        )
    }
}

extension Binding where Value: OptionalProtocol {
    typealias Wrapped = Value.Wrapped

    func or(_ value: Wrapped) -> Binding<Wrapped> {
        Binding<Wrapped>(
            get: { wrappedValue.value ?? value },
            set: { wrappedValue = .some($0) }
        )
    }
}
