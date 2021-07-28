import SwiftUISugar
import Stripe

struct StripePaymentCardTextField: UIViewRepresentable {
    @Binding var cardDetails: StripeCardDetails
    @Binding var cardIsValid: Bool

    func makeUIView(context: Context) -> STPPaymentCardTextField {
        STPPaymentCardTextField().then { view in
            view.borderWidth = 0
            view.postalCodeEntryEnabled = false
            view.delegate = context.coordinator
            view.textColor = .rythmico.foreground
            view.textErrorColor = .rythmico.red
            view.placeholderColor = .rythmico.gray30
            view.setContentHuggingPriority(.required, for: .vertical)

            view.cardParams = cardDetails
            view.becomeFirstResponder() // auto-start editing
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.cardIsValid = view.isValid
            }
        }
    }

    func updateUIView(_ view: STPPaymentCardTextField, context: Context) {
        view.font = .rythmicoFont(.body)
    }

    func makeCoordinator() -> StripePaymentCardTextField.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        private var parent: StripePaymentCardTextField

        init(_ textField: StripePaymentCardTextField) {
            parent = textField
        }

        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            parent.cardDetails = textField.cardParams
            parent.cardIsValid = textField.isValid
        }
    }
}

struct StripePaymentCardTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StripePaymentCardTextField(cardDetails: .constant(.init()), cardIsValid: .constant(true))
            StripePaymentCardTextField(cardDetails: .constant(.init()), cardIsValid: .constant(true))
                .background(Color.black)
                .environment(\.colorScheme, .dark)
        }
        .previewLayout(.sizeThatFits)
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
