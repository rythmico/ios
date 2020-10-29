import SwiftUI
import PhoneNumberKit

struct PhoneNumberInputView: View {
    @Binding var phoneNumber: PhoneNumber?
    @Binding var phoneNumberInputError: Error?

    var body: some View {
        VStack(spacing: .spacingSmall) {
            MultiStyleText(parts: contactNumberInstructions)
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

    var contactNumberInstructions: [MultiStyleText.Part] {
        "Enter a contact number of the ".color(.rythmicoGray90) +
        "parent/guardian".style(.bodyBold).color(.rythmicoGray90) +
        " of the student.".color(.rythmicoGray90)
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
