import SwiftUIEncore

struct DateOnlyPicker<Picker: View>: View {
    var selection: Binding<DateOnly>
    var picker: (Binding<Date>) -> Picker

    var body: some View {
        picker(
            Binding(
                get: { Date(selection.wrappedValue, timeZone: .neutral) },
                set: { selection.wrappedValue = DateOnly($0, timeZone: .neutral) }
            )
        )
        .environment(\.timeZone, .neutral)
    }
}
