import FoundationSugar

extension URLOpener {
    func open(_ link: MailLink) throws {
        open(try link.url())
    }
}

enum MailLink {
    case mail(
        to: [String]? = nil,
        cc: [String]? = nil,
        subject: String? = nil,
        body: String? = nil
    )
}

fileprivate extension MailLink {
    var scheme: String {
        switch self {
        case .mail:
            return "mailto"
        }
    }

    var host: String {
        switch self {
        case .mail(let to, _, _, _):
            return to?.joined(separator: ",") ?? .empty
        }
    }

    @ArrayBuilder<URLQueryItem>
    var queryItems: [URLQueryItem] {
        switch self {
        case let .mail(_, cc, subject, body):
            if let cc = cc {
                URLQueryItem(name: "cc", value: cc.joined(separator: ","))
            }
            if let subject = subject {
                URLQueryItem(name: "subject", value: subject)
            }
            if let body = body {
                URLQueryItem(name: "body", value: body)
            }
        }
    }

    func url() throws -> URL {
        try URL(scheme: scheme, doubleSlash: false, host: host, queryItems: queryItems)
    }
}
