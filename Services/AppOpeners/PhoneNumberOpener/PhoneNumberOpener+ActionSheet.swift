import SwiftUI
import PhoneNumberKit
import FoundationSugar

extension View {
    func phoneNumberOpeningSheet(
        isPresented: Binding<Bool>,
        urlOpener: URLOpener = Current.urlOpener,
        phoneNumber: PhoneNumber,
        error: Binding<Error?>
    ) -> some View {
        let links: [PhoneNumberLink] = [
            .phone(phoneNumber),
            .messages(phoneNumber),
            .whatsapp(phoneNumber),
        ]

        func button(for link: PhoneNumberLink) -> ActionSheet.Button {
            .default(Text(link.actionName)) {
                error.wrappedValue = Result { try urlOpener.open(link) }.failureValue
            }
        }

        return actionSheet(isPresented: isPresented) {
            ActionSheet(
                title: Text(PhoneNumberKit().format(phoneNumber, toType: .international)),
                buttons: links.map(button) + .cancel()
            )
        }
        .alert(error: error)
    }
}

private extension PhoneNumberLink {
    var actionName: String {
        switch self {
        case .phone:
            return "Call"
        case .messages:
            return "Message"
        case .whatsapp:
            return "WhatsApp"
        }
    }
}
