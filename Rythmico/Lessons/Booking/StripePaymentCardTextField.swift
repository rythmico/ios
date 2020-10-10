import SwiftUI
import Stripe
import Then

struct StripePaymentCardTextField: UIViewRepresentable {
    @Binding var cardDetails: STPPaymentMethodCardParams
    @Binding var cardIsValid: Bool

    func makeUIView(context: Context) -> STPPaymentCardTextField {
        STPPaymentCardTextField().then { view in
            view.borderWidth = 0
            view.postalCodeEntryEnabled = false
            view.delegate = context.coordinator
            view.textColor = .rythmicoForeground
            view.textErrorColor = .rythmicoRed
            view.placeholderColor = .rythmicoGray30
            view.setContentHuggingPriority(.required, for: .vertical)

            context.coordinator.performWithoutEditing {
                view.cardParams = cardDetails
                self.cardIsValid = view.isValid
            }
        }
    }

    func updateUIView(_ view: STPPaymentCardTextField, context: Context) {
        view.font = .rythmicoFont(.body, sizeCategory: context.environment.sizeCategory, legibilityWeight: context.environment.legibilityWeight)
    }

    func makeCoordinator() -> StripePaymentCardTextField.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        private var parent: StripePaymentCardTextField
        private var isEditingEnabled = true

        init(_ textField: StripePaymentCardTextField) {
            parent = textField
        }

        func paymentCardTextFieldDidBeginEditing(_ textField: STPPaymentCardTextField) {
            if !isEditingEnabled {
                textField.resignFirstResponder()
                isEditingEnabled = true
            }
        }

        func performWithoutEditing(_ setter: () -> Void) {
            isEditingEnabled = false
            setter()
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
