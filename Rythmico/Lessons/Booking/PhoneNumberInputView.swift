import SwiftUIEncore
import PhoneNumberKit

struct PhoneNumberInputView: View {
    @Binding var phoneNumber: PhoneNumber?
    @Binding var phoneNumberInputError: Error?

    var body: some View {
        VStack(spacing: .grid(4)) {
            contactNumberInstructions.frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: .grid(3)) {
                Container(style: .field) {
                    PhoneNumberField($phoneNumber, inputError: $phoneNumberInputError)
                        .padding(.horizontal, .grid(2.5))
                }
                if let error = phoneNumberInputError {
                    ErrorText(error)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    var contactNumberInstructions: some View {
        Text(separator: .whitespace) {
            "Enter a contact number of the"
            "parent/guardian".text.rythmicoFontWeight(.bodyBold)
            "of the student."
        }
        .rythmicoTextStyle(.body)
        .foregroundColor(.rythmico.foreground)
    }
}

#if DEBUG
struct PhoneNumberInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhoneNumberInputView(phoneNumber: .constant(nil), phoneNumberInputError: .constant(nil))
            PhoneNumberInputView(phoneNumber: .constant(nil), phoneNumberInputError: .constant(.some("Some error")))
            PhoneNumberInputView(phoneNumber: .constant(.stub), phoneNumberInputError: .constant(nil))
            PhoneNumberInputView(phoneNumber: .constant(.stub), phoneNumberInputError: .constant(.some("Some error")))
        }
        .environment(\.locale, Current.locale)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
