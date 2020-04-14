import SwiftUI
import Then

private struct UITextViewWrapper: UIViewRepresentable {
    final class UITextViewPrimitive: UITextView {
        override func caretRect(for position: UITextPosition) -> CGRect {
            var superRect = super.caretRect(for: position)
            guard let font = self.font else {
                return superRect
            }

            // "descender" is expressed as a negative value,
            // so to add its height you must subtract its value
            superRect.size.height = font.pointSize - font.descender
            return superRect
        }
    }

    var placeholder: String
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onEditingChanged: (Bool) -> Void

    func makeUIView(context: Context) -> UITextView {
        let textField = UITextViewPrimitive()
        textField.delegate = context.coordinator

        textField.font = .rythmicoFont(.body)
        textField.isEditable = true
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = .clear
        textField.textContainerInset = UIEdgeInsets(
            top: 15,
            left: .spacingSmall,
            bottom: 15,
            right: .spacingSmall
        )
        textField.textContainer.lineFragmentPadding = 0

        // add done button tooltip
        textField.inputAccessoryView = UIToolbar().then {
            $0.sizeToFit()
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(
                    customView: UIButton().then {
                        $0.setTitle("Done", for: .normal)
                        $0.setTitleColor(.rythmicoPurple, for: .normal)
                        $0.setTitleColor(UIColor.rythmicoPurple.withAlphaComponent(0.2), for: .highlighted)
                        $0.titleLabel?.font = .rythmicoFont(.callout)
                        $0.addTarget(textField, action: #selector(UITextField.resignFirstResponder), for: .touchUpInside)
                    }
                )
            ]
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.rythmicoText != self.text {
            uiView.rythmicoText = self.text
        }
        uiView.font = .rythmicoFont(.body)
        UITextViewWrapper.recalculateHeight(view: uiView, placeholder: placeholder, result: $calculatedHeight)
    }

    private static func recalculateHeight(view: UITextView, placeholder: String, result: Binding<CGFloat>) {
        let oldText = view.text
        if view.rythmicoText.isEmpty {
            view.rythmicoText = placeholder
        }
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        view.text = oldText
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(placeholder: placeholder, text: $text, height: $calculatedHeight, onEditingChanged: onEditingChanged)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var placeholder: String
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onEditingChanged: (Bool) -> Void

        init(placeholder: String, text: Binding<String>, height: Binding<CGFloat>, onEditingChanged: @escaping (Bool) -> Void) {
            self.placeholder = placeholder
            self.text = text
            self.calculatedHeight = height
            self.onEditingChanged = onEditingChanged
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, placeholder: placeholder, result: calculatedHeight)
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            onEditingChanged(true)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            onEditingChanged(false)
        }
    }
}

struct MultilineTextField: View {
    private var placeholder: String
    private var onEditingChanged: (Bool) -> Void

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding(
            get: { self.text },
            set: {
                self.text = $0
                self.showingPlaceholder = $0.isEmpty
            }
        )
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init(_ placeholder: String = "", text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void) {
        self.placeholder = placeholder
        self.onEditingChanged = onEditingChanged
        self._text = text
        self._showingPlaceholder = State(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(placeholder: placeholder, text: internalText, calculatedHeight: $dynamicHeight, onEditingChanged: onEditingChanged)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .leading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder)
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray30)
                    .padding(.horizontal, .spacingSmall)
            }
        }
    }
}

private extension UITextView {
    var rythmicoText: String {
        get { attributedText.string }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = .spacingSmall

            attributedText = NSAttributedString(
                string: newValue,
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .font: UIFont.rythmicoFont(.body)
                ]
            )
        }
    }
}
