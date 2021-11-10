import SwiftUIEncore

// MARK: - Picker -

struct PickerInputMode<Data: RandomAccessCollection>: CustomTextFieldInputMode where
    Data.Index == Int, Data.Element: Hashable
{
    typealias Element = Data.Element

    let data: Data
    let selection: Binding<Element>
    let formatter: (Element) -> String

    func view(for textField: UITextField) -> UIView? {
        PickerAsUIView(data: data, selection: selection, formatter: formatter)
    }
}

extension CustomTextFieldInputMode {
    static func picker<Data: RandomAccessCollection>(
        data: Data,
        selection: Binding<Data.Element>,
        formatter: @escaping (Data.Element) -> String
    ) -> Self where Self == PickerInputMode<Data>, Data.Index == Int, Data.Element: Hashable {
        PickerInputMode(data: data, selection: selection, formatter: formatter)
    }
}

private final class PickerAsUIView<Data: RandomAccessCollection>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate where
    Data.Index == Int, Data.Element: Hashable
{
    typealias Element = Data.Element

    private let data: Data
    private let selection: Binding<Element>
    private let formatter: (Element) -> String

    init(data: Data, selection: Binding<Element>, formatter: @escaping (Element) -> String) {
        self.data = data
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
