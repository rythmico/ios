import SwiftUI
import PhoneNumberKit

struct PhoneNumberField: UIViewRepresentable {

    @Binding var phoneNumber: PhoneNumber?
    var defaultRegion: String?

    init(_ phoneNumber: Binding<PhoneNumber?>, defaultRegion: String? = nil) {
        self._phoneNumber = phoneNumber
        self.defaultRegion = defaultRegion
    }

    func makeUIView(context: Context) -> PhoneNumberTextField {
        RythmicoPhoneNumberTextField(defaultRegion: defaultRegion).then {
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

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
        view.font = .rythmicoFont(.body)
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
    private let _defaultRegion: String?

    private let padding = UIEdgeInsets(
        top: 15,
        left: .spacingUnit * 7.5,
        bottom: 15,
        right: .spacingSmall
    )

    init(defaultRegion: String?) {
        self._defaultRegion = defaultRegion
        super.init(frame: .zero, phoneNumberKit: PhoneNumberKit())
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
