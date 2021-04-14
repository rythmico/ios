import SwiftUI
import SFSafeSymbols
import Then

private struct UITextViewWrapper: UIViewRepresentable {
    final class UITextViewPrimitive: UITextView {
        override func caretRect(for position: UITextPosition) -> CGRect {
            super.caretRect(for: position).with {
                $0.size.height = UIFontMetrics(forTextStyle: .largeTitle).scaledValue(for: 26)
            }
        }
    }

    typealias TextStyle = MultilineTextField.TextStyle

    var placeholder: String
    @Binding var text: String
    var textStyle: TextStyle?
    var accentColor: UIColor?
    var textColor: UIColor
    var inputAccessory: CustomTextFieldInputAccessory?
    var minHeight: CGFloat
    @Binding var calculatedHeight: CGFloat
    var padding: EdgeInsets
    var onEditingChanged: (Bool) -> Void

    func makeUIView(context: Context) -> UITextView {
        let textField = UITextViewPrimitive()
        textField.delegate = context.coordinator

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
        if uiView.rythmicoText != text {
            uiView.setRythmicoText(text, color: textColor, style: styleOrDefaultStyle)
        }
        uiView.font = fontOrDefaultFont
        UITextViewWrapper.recalculateHeight(
            view: uiView,
            placeholder: placeholder,
            textStyle: styleOrDefaultStyle,
            textColor: textColor,
            minHeight: minHeight,
            result: $calculatedHeight
        )
    }

    private static func recalculateHeight(
        view: UITextView,
        placeholder: String,
        textStyle: TextStyle,
        textColor: UIColor,
        minHeight: CGFloat,
        result: Binding<CGFloat>
    ) {
        let oldText = view.text
        if view.rythmicoText.isEmpty {
            view.setRythmicoText(placeholder, color: textColor, style: textStyle)
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
        #if RYTHMICO
        Rythmico.font(for: textStyle) ?? .preferredFont(forTextStyle: .body)
        #elseif TUTOR
        Tutor.font(for: textStyle) ?? .preferredFont(forTextStyle: .body)
        #endif
    }

    private var styleOrDefaultStyle: TextStyle {
        #if RYTHMICO
        textStyle ?? .body
        #elseif TUTOR
        textStyle ?? .preferredFont(forTextStyle: .body)
        #endif
    }

    private var accentColorOrDefault: UIColor {
        accentColor ?? .systemBlue
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            placeholder: placeholder,
            text: $text,
            textStyle: styleOrDefaultStyle,
            textColor: textColor,
            minHeight: minHeight,
            height: $calculatedHeight,
            onEditingChanged: onEditingChanged
        )
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var placeholder: String
        var text: Binding<String>
        var textStyle: TextStyle
        var textColor: UIColor
        var minHeight: CGFloat
        var calculatedHeight: Binding<CGFloat>
        var onEditingChanged: (Bool) -> Void

        init(
            placeholder: String,
            text: Binding<String>,
            textStyle: TextStyle,
            textColor: UIColor,
            minHeight: CGFloat,
            height: Binding<CGFloat>,
            onEditingChanged: @escaping (Bool) -> Void
        ) {
            self.placeholder = placeholder
            self.text = text
            self.textStyle = textStyle
            self.textColor = textColor
            self.minHeight = minHeight
            self.calculatedHeight = height
            self.onEditingChanged = onEditingChanged
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(
                view: uiView,
                placeholder: placeholder,
                textStyle: textStyle,
                textColor: textColor,
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
    #if RYTHMICO
    typealias TextStyle = Font.RythmicoTextStyle
    #elseif TUTOR
    typealias TextStyle = UIFont
    #endif

    private var placeholder: String
    private var minHeight: CGFloat
    private var textStyle: TextStyle?
    private var accentColor: UIColor?
    private var textColor: UIColor?
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

    @Environment(\.sizeCategory) private var sizeCategory

    init(
        _ placeholder: String = "",
        text: Binding<String>,
        textStyle: TextStyle?,
        accentColor: UIColor?,
        textColor: UIColor?,
        placeholderColor: Color?,
        inputAccessory: CustomTextFieldInputAccessory?,
        minHeight: CGFloat? = nil,
        padding: EdgeInsets? = nil,
        onEditingChanged: @escaping (Bool) -> Void
    ) {
        self.placeholder = placeholder
        self._text = text
        self.textStyle = textStyle
        self.accentColor = accentColor
        self.textColor = textColor
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
            textStyle: textStyle,
            accentColor: accentColor,
            textColor: textColor ?? .label,
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
            // Forces placeholder UIFont change on sizeCategory change.
            if sizeCategory == sizeCategory {
                Text(placeholder)
                    .font(Font(
                        CTFontCreateWithFontDescriptor(
                            fontOrDefaultFont.fontDescriptor as CTFontDescriptor,
                            fontOrDefaultFont.pointSize,
                            nil
                        )
                    ))
                    .foregroundColor(placeholderColor ?? Color(.tertiaryLabel))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(padding)
            }
        }
    }

    private var fontOrDefaultFont: UIFont {
        #if RYTHMICO
        Rythmico.font(for: textStyle) ?? .preferredFont(forTextStyle: .body)
        #elseif TUTOR
        Tutor.font(for: textStyle) ?? .preferredFont(forTextStyle: .body)
        #endif
    }
}

#if RYTHMICO
// hacky af
private func font(for style: MultilineTextField.TextStyle?) -> UIFont? {
    style.map { [NSAttributedString.Key: Any].rythmicoTextAttributes(color: nil, style: $0) }?[.font] as? UIFont
}
#elseif TUTOR
private func font(for style: MultilineTextField.TextStyle?) -> UIFont? {
    style
}
#endif

private extension UITextView {
    var rythmicoText: String { attributedText.string }

    func setRythmicoText(_ string: String, color: UIColor, style: MultilineTextField.TextStyle) {
        let attributes: [NSAttributedString.Key: Any]
        #if RYTHMICO
        attributes = .rythmicoTextAttributes(color: color, style: style)
        #elseif TUTOR
        attributes = [
            .paragraphStyle: NSMutableParagraphStyle().with(\.paragraphSpacing, .spacingSmall),
            .font: style,
            .foregroundColor: color,
        ]
        #endif
        attributedText = NSAttributedString(string: string, attributes: attributes)
    }
}
