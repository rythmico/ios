import Foundation
import PhoneNumberKit
import Sugar

extension URLOpener {
    func open(_ link: PhoneNumberLink) throws {
        open(try link.url())
    }
}

enum PhoneNumberLink {
    case phone(PhoneNumber)
    case messages(PhoneNumber)
    case whatsapp(PhoneNumber)
}

fileprivate extension PhoneNumberLink {
    var scheme: String {
        switch self {
        case .phone:
            return "tel"
        case .messages:
            return "sms"
        case .whatsapp:
            return "https"
        }
    }

    var host: String {
        switch self {
        case .phone(let phoneNumber), .messages(let phoneNumber):
            return PhoneNumberKit().format(phoneNumber, toType: .e164)
        case .whatsapp:
            return "wa.me"
        }
    }

    var path: String {
        switch self {
        case .phone, .messages:
            return .empty
        case .whatsapp(let phoneNumber):
            return "/" + PhoneNumberKit().format(phoneNumber, toType: .e164)
        }
    }

    func url() throws -> URL {
        try URL(scheme: scheme, host: host, path: path)
    }
}
