import SwiftUI

struct LabelessDatePicker: View {
    var selection: Binding<Date>
    var displayedComponents: DatePickerComponents = .date

    var body: some View {
        DatePicker(
            "",
            selection: selection,
            displayedComponents: displayedComponents
        )
        .labelsHidden()
        .datePickerStyle(WheelDatePickerStyle())
    }
}

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
                Text(formatter($0)).tag($0)
            }
        }
        .labelsHidden()
        .pickerStyle(WheelPickerStyle())
    }
}

protocol CasePickable {
    associatedtype PickableCases: Collection where PickableCases.Element == Self
    static var pickableCases: PickableCases { get }
}

extension CasePickable where Self: CaseIterable, PickableCases == AllCases {
    static var pickableCases: PickableCases { allCases }
}

extension BetterPicker where Selection: CasePickable, Selection.PickableCases == Options {
    init(selection: Binding<Selection>, formatter: @escaping (Selection) -> String) {
        self.init(options: Selection.pickableCases, selection: selection, formatter: formatter)
    }
}
