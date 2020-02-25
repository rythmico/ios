import SwiftUI

struct DatePickerViewData {
    var label: String
    var selection: Binding<Date>
    var displayedComponents: DatePickerComponents
}

extension DatePicker where Label == Text {
    init(_ viewData: DatePickerViewData) {
        self.init(viewData.label, selection: viewData.selection, displayedComponents: viewData.displayedComponents)
    }
}
