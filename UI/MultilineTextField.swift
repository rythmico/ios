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
    var font: UIFont?
    var accentColor: UIColor?
    var textColor: UIColor
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

        // add done button tooltip
        textField.inputAccessoryView = UIToolbar().then {
            $0.sizeToFit()
            $0.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(
                    customView: UIButton().then {
                        $0.setTitle("Done", for: .normal)
                        $0.setTitleColor(accentColorOrDefault, for: .normal)
                        $0.setTitleColor(accentColorOrDefault.withAlphaComponent(0.2), for: .highlighted)
                        $0.titleLabel?.font = fontOrDefaultFont.fontDescriptor
                            .withSymbolicTraits(.traitBold)
                            .map { UIFont(descriptor: $0, size: $0.pointSize) }
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
            uiView.setRythmicoText(self.text, font: fontOrDefaultFont, color: textColor)
        }
        uiView.font = font ?? .preferredFont(forTextStyle: .body)
        UITextViewWrapper.recalculateHeight(
            view: uiView,
            placeholder: placeholder,
            font: fontOrDefaultFont,
            textColor: textColor,
            minHeight: minHeight,
            result: $calculatedHeight
        )
    }

    private static func recalculateHeight(
        view: UITextView,
        placeholder: String,
        font: UIFont,
        textColor: UIColor,
        minHeight: CGFloat,
        result: Binding<CGFloat>
    ) {
        let oldText = view.text
        if view.rythmicoText.isEmpty {
            view.setRythmicoText(placeholder, font: font, color: textColor)
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
        font ?? .preferredFont(forTextStyle: .body)
    }

    private var accentColorOrDefault: UIColor {
        accentColor ?? .systemBlue
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            placeholder: placeholder,
            text: $text,
            font: fontOrDefaultFont,
            textColor: textColor,
            minHeight: minHeight,
            height: $calculatedHeight,
            onEditingChanged: onEditingChanged
        )
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var placeholder: String
        var text: Binding<String>
        var font: UIFont
        var textColor: UIColor
        var minHeight: CGFloat
        var calculatedHeight: Binding<CGFloat>
        var onEditingChanged: (Bool) -> Void

        init(
            placeholder: String,
            text: Binding<String>,
            font: UIFont,
            textColor: UIColor,
            minHeight: CGFloat,
            height: Binding<CGFloat>,
            onEditingChanged: @escaping (Bool) -> Void
        ) {
            self.placeholder = placeholder
            self.text = text
            self.font = font
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
                font: font,
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
    private var placeholder: String
    private var minHeight: CGFloat
    private var font: UIFont?
    private var accentColor: UIColor?
    private var textColor: UIColor?
    private var placeholderColor: Color?
    private var padding: EdgeInsets
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

    init(
        _ placeholder: String = "",
        text: Binding<String>,
        font: UIFont?,
        accentColor: UIColor?,
        textColor: UIColor?,
        placeholderColor: Color?,
        minHeight: CGFloat? = nil,
        padding: EdgeInsets? = nil,
        onEditingChanged: @escaping (Bool) -> Void
    ) {
        self.placeholder = placeholder
        self._text = text
        self.font = font
        self.accentColor = accentColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.minHeight = minHeight ?? 0
        self.padding = padding ?? .zero
        self.onEditingChanged = onEditingChanged
        self._showingPlaceholder = State(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(
            placeholder: placeholder,
            text: internalText,
            font: font,
            accentColor: accentColor,
            textColor: textColor ?? .label,
            minHeight: minHeight,
            calculatedHeight: $dynamicHeight,
            padding: padding,
            onEditingChanged: onEditingChanged
        )
        .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight, alignment: .topLeading)
        .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
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
        font ?? .preferredFont(forTextStyle: .body)
    }
}

private extension UITextView {
    var rythmicoText: String { attributedText.string }

    func setRythmicoText(_ string: String, font: UIFont, color: UIColor) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = .spacingSmall

        attributedText = NSAttributedString(
            string: string,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: font,
                .foregroundColor: color,
            ]
        )
    }
}
