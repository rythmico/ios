import SwiftUIEncore
import PhoneNumberKit

struct PhoneNumberField: UIViewRepresentable {

    @Binding var phoneNumber: PhoneNumber?
    @Binding var inputError: Error?

    init(_ phoneNumber: Binding<PhoneNumber?>, inputError: Binding<Error?> = .constant(nil)) {
        self._phoneNumber = phoneNumber
        self._inputError = inputError
    }

    func makeUIView(context: Context) -> PhoneNumberTextField {
        let regionCode = context.environment.locale.regionCode !! preconditionFailure(
            """
            Region code missing from running device.
            This should only happen on SIM, and rarely.
            If happening on device, a Locale other than Locale.current must be being used.
            """
        )
        return RythmicoPhoneNumberTextField(defaultRegion: regionCode).then {
            $0.withFlag = true
            $0.withPrefix = true // allow explicit + prefixes
            $0.placeholder = PhoneNumberKit().getFormattedExampleNumber(forCountry: regionCode, withFormat: .national, withPrefix: false)
            $0.countryCodePlaceholderColor = .rythmico.textPlaceholder
            $0.numberPlaceholderColor = .rythmico.textPlaceholder
            $0.textColor = .rythmico.foreground
            $0.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
            $0.setContentHuggingPriority(.required, for: .vertical)

            phoneNumber.map($0.setNationalPhoneNumber)
        }
    }

    func updateUIView(_ uiView: PhoneNumberTextField, context: Context) {
        let uiView = uiView as! RythmicoPhoneNumberTextField
        let env = context.environment

        uiView._defaultRegion = env.locale.regionCode
        let font = UIFont.rythmicoFont(.body)
        uiView.font = font
        uiView.inputAccessoryView = UIToolbar.dismissKeyboardTooltip(color: .rythmico.picoteeBlue)
        uiView.updateFlag()
        uiView.updatePlaceholder()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        let control: PhoneNumberField

        init(_ control: PhoneNumberField) {
            self.control = control
        }

        @objc func onTextUpdate(textField: PhoneNumberTextField) {
            control.phoneNumber = textField.phoneNumber
            control.inputError = textField.validationError
        }
    }
}

private extension PhoneNumberTextField {
    func setNationalPhoneNumber(_ phoneNumber: PhoneNumber) {
        text = phoneNumberKit.format(phoneNumber, toType: .national)
    }

    var validationError: Error? {
        Result { try text.map { try phoneNumberKit.parse($0) } }.failureValue
    }
}

private final class RythmicoPhoneNumberTextField: PhoneNumberTextField {
    private var padding: UIEdgeInsets {
        UIEdgeInsets(
            top: 15,
            left: flagButton.frame.width,
            bottom: 15,
            right: 16
        )
    }

    var _defaultRegion: String?

    init(defaultRegion: String?) {
        self._defaultRegion = defaultRegion
        super.init(frame: .zero)
    }

    override var defaultRegion: String {
        get { _defaultRegion ?? super.defaultRegion }
        set {}
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    @available(*, unavailable)
    required init(coder aDecoder: NSCoder) {
        fatalError("Nah fam")
    }
}
