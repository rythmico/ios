import SwiftUIEncore

// MARK: - DateOnlyPicker -

struct DateOnlyPickerInputMode: CustomTextFieldInputMode {
    var selection: Binding<DateOnly>
    var style: UIDatePickerStyle = .wheels

    func view(for textField: UITextField) -> UIView? {
        DateOnlyPickerAsUIView(
            selection: selection,
            style: style
        )
    }
}

extension CustomTextFieldInputMode where Self == DateOnlyPickerInputMode {
    static func dateOnlyPicker(selection: Binding<DateOnly>, style: UIDatePickerStyle = .wheels) -> DateOnlyPickerInputMode {
        DateOnlyPickerInputMode(selection: selection, style: style)
    }
}

private final class DateOnlyPickerAsUIView: UIDatePicker {
    private let selection: Binding<DateOnly>

    init(selection: Binding<DateOnly>, style: UIDatePickerStyle) {
        self.selection = selection
        super.init(frame: .zero)
        self.calendar = Current.calendar()
        self.locale = Current.locale()
        self.timeZone = .neutral
        self.date = Date(selection.wrappedValue, timeZone: .neutral)
        self.datePickerMode = .date
        self.preferredDatePickerStyle = style
        self.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onDateChanged() {
        selection.wrappedValue = DateOnly(date, timeZone: .neutral)
    }
}
