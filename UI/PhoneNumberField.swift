import SwiftUI
import PhoneNumberKit

struct PhoneNumberField: UIViewRepresentable {

    @Binding var phoneNumber: PhoneNumber?

    init(_ phoneNumber: Binding<PhoneNumber?>) {
        self._phoneNumber = phoneNumber
    }

    func makeUIView(context: Context) -> PhoneNumberTextField {
        RythmicoPhoneNumberTextField(defaultRegion: context.environment.locale.regionCode).then {
            $0.withFlag = true
            $0.withPrefix = true
            $0.withExamplePlaceholder = true
            $0.countryCodePlaceholderColor = .rythmicoGray30
            $0.numberPlaceholderColor = .rythmicoGray30
            $0.textColor = .rythmicoForeground
            $0.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
    }

    func updateUIView(_ uiView: PhoneNumberTextField, context: Context) {
        let uiView = uiView as! RythmicoPhoneNumberTextField
        let env = context.environment

        uiView._defaultRegion = env.locale.regionCode
        uiView.font = .rythmicoFont(.body, sizeCategory: env.sizeCategory, legibilityWeight: env.legibilityWeight)
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
        }
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
