import SwiftUIEncore

// MARK: - Picker -

struct PickerInputMode<Element: CasePickable & Hashable>: CustomTextFieldInputMode where
    Element.PickableCases.Index == Int
{
    var selection: Binding<Element>
    var formatter: (Element) -> String

    func view(for textField: UITextField) -> UIView? {
        PickerAsUIView(selection: selection, formatter: formatter)
    }
}

// TODO: uncomment when parameterized extensions are available
//extension <Element> CustomTextFieldInputMode where Self == PickerInputMode<Element> where Element: CasePickable & Hashable {
//    static func picker(
//        selection: Binding<Element>,
//        formatter: (Element) -> String
//    ) -> Self {
//        PickerInputMode(selection: selection, formatter: formatter)
//    }
//}

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
