import SwiftUIEncore

// MARK: - TimeOnlyPicker -

struct TimeOnlyPickerInputMode: CustomTextFieldInputMode {
    var selection: Binding<TimeOnly>
    var style: UIDatePickerStyle = .wheels
    var minuteInterval: Int = 5

    func view(for textField: UITextField) -> UIView? {
        TimeOnlyPickerAsUIView(
            selection: selection,
            style: style,
            minuteInterval: minuteInterval
        )
    }
}

extension CustomTextFieldInputMode where Self == TimeOnlyPickerInputMode {
    static func timeOnlyPicker(
        selection: Binding<TimeOnly>,
        style: UIDatePickerStyle = .wheels,
        minuteInterval: Int = 5
    ) -> TimeOnlyPickerInputMode {
        TimeOnlyPickerInputMode(selection: selection, style: style, minuteInterval: minuteInterval)
    }
}

private final class TimeOnlyPickerAsUIView: UIDatePicker {
    private let selection: Binding<TimeOnly>

    init(selection: Binding<TimeOnly>, style: UIDatePickerStyle, minuteInterval: Int) {
        self.selection = selection
        super.init(frame: .zero)
        self.calendar = Current.calendar()
        self.locale = Current.locale()
        self.timeZone = .neutral
        self.date = Date(selection.wrappedValue, in: .neutral)
        self.datePickerMode = .time
        self.preferredDatePickerStyle = style
        self.minuteInterval = minuteInterval
        self.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onDateChanged() {
        selection.wrappedValue = TimeOnly(date, in: .neutral)
    }
}
