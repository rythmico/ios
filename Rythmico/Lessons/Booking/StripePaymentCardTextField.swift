import SwiftUI
import Stripe
import Then

struct StripePaymentCardTextField: UIViewRepresentable {
    @Binding var cardDetails: STPPaymentMethodCardParams
    @Binding var cardIsValid: Bool

    func makeUIView(context: Context) -> STPPaymentCardTextField {
        STPPaymentCardTextField().then { view in
            #if DEBUG
            view.cardParams = cardDetails
            DispatchQueue.main.async {
                view.resignFirstResponder()
            }
            #endif
            view.borderWidth = 0
            view.postalCodeEntryEnabled = false
            view.delegate = context.coordinator
            view.textColor = .rythmicoForeground
            view.textErrorColor = .rythmicoRed
            view.placeholderColor = .rythmicoGray30
            view.setContentHuggingPriority(.required, for: .vertical)
        }
    }

    func updateUIView(_ view: STPPaymentCardTextField, context: Context) {
        view.font = .rythmicoFont(.body, sizeCategory: context.environment.sizeCategory, legibilityWeight: context.environment.legibilityWeight)
    }

    func makeCoordinator() -> StripePaymentCardTextField.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        var parent: StripePaymentCardTextField

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
