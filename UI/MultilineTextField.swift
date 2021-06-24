import FoundationSugar
import SwiftUISugar

extension NSAttributedString {
    typealias Attributes = [Key: Any]
}

extension NSAttributedString.Attributes {
    var font: UIFont? { self[.font] as? UIFont }
}

private struct UITextViewWrapper: UIViewRepresentable {
    final class UITextViewPrimitive: UITextView {
        override func caretRect(for position: UITextPosition) -> CGRect {
            super.caretRect(for: position).with {
                $0.size.height = UIFontMetrics(forTextStyle: .largeTitle).scaledValue(for: 23)
            }
        }
    }

    var placeholder: String
    @Binding
    var text: String
    var attributes: NSAttributedString.Attributes
    var accentColor: UIColor?
    var inputAccessory: CustomTextFieldInputAccessory?
    var minHeight: CGFloat
    @Binding var calculatedHeight: CGFloat
    var padding: EdgeInsets
    var onEditingChanged: (Bool) -> Void

    func makeUIView(context: Context) -> UITextView {
        let textField = UITextViewPrimitive()
        textField.delegate = context.coordinator

        textField.attributedText = NSAttributedString(string: text, attributes: attributes)
        textField.font = fontOrDefaultFont
        textField.isEditable = true
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = .clear
        textField.textContainerInset = UIEdgeInsets(
            top: padding.top,
            left: padding.leading,
            bottom: padding.bottom,
            right: padding.trailing
        )
        textField.textContainer.lineFragmentPadding = 0
        textField.inputAccessoryView = inputAccessory?.view(accentColor: accentColorOrDefault)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.attributedText.string != text {
            uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        uiView.font = fontOrDefaultFont
        UITextViewWrapper.recalculateHeight(
            view: uiView,
            placeholder: placeholder,
            attributes: attributes,
            minHeight: minHeight,
            result: $calculatedHeight
        )
    }

    private static func recalculateHeight(
        view: UITextView,
        placeholder: String,
        attributes: NSAttributedString.Attributes,
        minHeight: CGFloat,
        result: Binding<CGFloat>
    ) {
        let oldText = view.text
        if view.attributedText.string.isEmpty {
            view.attributedText = NSAttributedString(string: placeholder, attributes: attributes)
        }
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = max(minHeight, newSize.height)
        view.text = oldText
        if result.wrappedValue != newHeight {
            DispatchQueue.main.async {
                result.wrappedValue = newHeight // !! must be called asynchronously
            }
        }
    }

    private var fontOrDefaultFont: UIFont {
        attributes.font ?? .preferredFont(forTextStyle: .body)
    }

    private var accentColorOrDefault: UIColor {
        accentColor ?? .systemBlue
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            placeholder: placeholder,
            text: $text,
            attributes: attributes,
            minHeight: minHeight,
            height: $calculatedHeight,
            onEditingChanged: onEditingChanged
        )
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var placeholder: String
        var text: Binding<String>
        var attributes: NSAttributedString.Attributes
        var minHeight: CGFloat
        var calculatedHeight: Binding<CGFloat>
        var onEditingChanged: (Bool) -> Void

        init(
            placeholder: String,
            text: Binding<String>,
            attributes: NSAttributedString.Attributes,
            minHeight: CGFloat,
            height: Binding<CGFloat>,
            onEditingChanged: @escaping (Bool) -> Void
        ) {
            self.placeholder = placeholder
            self.text = text
            self.attributes = attributes
            self.minHeight = minHeight
            self.calculatedHeight = height
            self.onEditingChanged = onEditingChanged
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(
                view: uiView,
                placeholder: placeholder,
                attributes: attributes,
                minHeight: minHeight,
                result: calculatedHeight
            )
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
    private var minHeight: CGFloat
    private var attributes: NSAttributedString.Attributes
    private var accentColor: UIColor?
    private var placeholderColor: Color?
    private var inputAccessory: CustomTextFieldInputAccessory?
    private var padding: EdgeInsets
    private var onEditingChanged: (Bool) -> Void

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding(
            get: { text },
            set: {
                text = $0
                showingPlaceholder = $0.isEmpty
            }
        )
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init(
        _ placeholder: String = "",
        text: Binding<String>,
        attributes: NSAttributedString.Attributes,
        accentColor: UIColor?,
        placeholderColor: Color?,
        inputAccessory: CustomTextFieldInputAccessory?,
        minHeight: CGFloat? = nil,
        padding: EdgeInsets? = nil,
        onEditingChanged: @escaping (Bool) -> Void
    ) {
        self.placeholder = placeholder
        self._text = text
        self.attributes = attributes
        self.accentColor = accentColor
        self.placeholderColor = placeholderColor
        self.inputAccessory = inputAccessory
        self.minHeight = minHeight ?? 0
        self.padding = padding ?? .zero
        self.onEditingChanged = onEditingChanged
        self._showingPlaceholder = State(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(
            placeholder: placeholder,
            text: internalText,
            attributes: attributes,
            accentColor: accentColor,
            inputAccessory: inputAccessory,
            minHeight: minHeight,
            calculatedHeight: $dynamicHeight,
            padding: padding,
            onEditingChanged: onEditingChanged
        )
        .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight, alignment: .topLeading)
        .background(placeholderView, alignment: .topLeading)
    }

    @ViewBuilder
    var placeholderView: some View {
        if showingPlaceholder {
            Text(placeholder)
                .font(Font(fontOrDefaultFont))
                .foregroundColor(placeholderColor ?? Color(.tertiaryLabel))
                .fixedSize(horizontal: false, vertical: true)
                .padding(padding)
        }
    }

    private var fontOrDefaultFont: UIFont {
        attributes.font ?? .preferredFont(forTextStyle: .body)
    }
}
