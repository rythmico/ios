import SwiftUI
import PhoneNumberKit

struct PhoneNumberInputView: View {
    @Binding var phoneNumber: PhoneNumber?
    @Binding var phoneNumberInputError: Error?

    var body: some View {
        VStack(spacing: .spacingSmall) {
            contactNumberInstructions
                .lineLimit(6)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: .spacingExtraSmall) {
                PhoneNumberField($phoneNumber, inputError: $phoneNumberInputError)
                    .padding(.horizontal, .spacingUnit * 2.5)
                    .modifier(RoundedThinOutlineContainer(padded: false))
                if let error = phoneNumberInputError {
                    ErrorText(error)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    var contactNumberInstructions: Text {
        Text {
            "Enter a contact number of the"
            "parent/guardian".text.rythmicoFont(.bodyBold)
            "of the student."
        }
        .foregroundColor(.rythmicoGray90)
        .rythmicoFont(.body)
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
