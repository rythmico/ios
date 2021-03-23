import SwiftUI

protocol CustomTextFieldInputMode {
    func view(for textField: UITextField) -> UIView?
}

struct KeyboardInputMode: CustomTextFieldInputMode {
    var contentType: UITextContentType? = nil
    var autocapitalization: UITextAutocapitalizationType = .none
    var returnKey: UIReturnKeyType = .done

    func view(for textField: UITextField) -> UIView? {
        textField.textContentType = contentType
        textField.autocapitalizationType = autocapitalization
        textField.returnKeyType = returnKey
        return nil
    }
}

struct DatePickerInputMode: CustomTextFieldInputMode {
    var selection: Binding<Date>
    var mode: UIDatePicker.Mode
    var style: UIDatePickerStyle = .wheels
    var minuteInterval: Int = 5

    func view(for textField: UITextField) -> UIView? {
        DatePickerAsUIView(
            selection: selection,
            mode: mode,
            style: style,
            minuteInterval: minuteInterval
        )
    }
}

struct PickerInputMode<Element: CasePickable & Hashable>: CustomTextFieldInputMode where
    Element.PickableCases.Index == Int
{
    var selection: Binding<Element>
    var formatter: (Element) -> String

    func view(for textField: UITextField) -> UIView? {
        PickerAsUIView(selection: selection, formatter: formatter)
    }
}

private final class DatePickerAsUIView: UIDatePicker {
    private let selection: Binding<Date>

    init(
        selection: Binding<Date>,
        mode: UIDatePicker.Mode,
        style: UIDatePickerStyle,
        minuteInterval: Int
    ) {
        self.selection = selection
        super.init(frame: .zero)
        self.date = selection.wrappedValue
        self.datePickerMode = mode
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
        selection.wrappedValue = date
    }
}

private final class PickerAsUIView<Element: CasePickable & Hashable>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate where
    Element.PickableCases.Index == Int
{
    private var data: Element.PickableCases { Element.pickableCases }
    private let selection: Binding<Element>
    private let formatter: (Element) -> String

    init(selection: Binding<Element>, formatter: @escaping (Element) -> String) {
        self.selection = selection
        self.formatter = formatter
        super.init(frame: .zero)
        self.dataSource = self
        self.delegate = self
        self.selectRow(data.firstIndex(of: selection.wrappedValue) ?? 0, inComponent: 0, animated: false)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        formatter(data[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection.wrappedValue = data[row]
    }
}
