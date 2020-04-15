import SwiftUI

struct LabelessDatePicker: View {
    var selection: Binding<Date>
    var displayedComponents: DatePickerComponents = .date

    var body: some View {
        DatePicker(
            "",
            selection: selection,
            displayedComponents: displayedComponents
        ).labelsHidden()
    }
}

// TODO: generalize components
// - Implement FloatingViewContainer<Content: View> and helper View.floatingViewContainer function.
struct BetterPicker<Options: RandomAccessCollection, Selection: Hashable>: View where Options.Element == Selection {
    var options: Options
    var selection: Binding<Selection>
    var formatter: (Selection) -> String

    init(options: Options, selection: Binding<Selection>, formatter: @escaping (Selection) -> String) {
        self.options = options
        self.selection = selection
        self.formatter = formatter
    }

    var body: some View {
        Picker("", selection: selection) {
            ForEach(options, id: \.hashValue) {
                Text(self.formatter($0)).tag($0)
            }
        }
        .labelsHidden()
        .pickerStyle(WheelPickerStyle())
    }
}

extension BetterPicker where Selection: CaseIterable, Selection.AllCases == Options {
    init(selection: Binding<Selection>, formatter: @escaping (Selection) -> String) {
        self.init(options: Selection.allCases, selection: selection, formatter: formatter)
    }
}
