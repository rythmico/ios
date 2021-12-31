import SwiftUIEncore

struct DateOnlyPicker<Picker: View>: View {
    var selection: Binding<DateOnly>
    var picker: (Binding<Date>) -> Picker

    var body: some View {
        picker(
            Binding(
                get: { Date(selection.wrappedValue, in: .neutral) },
                set: { selection.wrappedValue = DateOnly($0, in: .neutral) }
            )
        )
        .environment(\.timeZone, .neutral)
    }
}
