import Foundation

struct MapOpener {
    enum Link {
        enum Action {
            case search(query: String)
        }

        case appleMaps(Action)
        case googleMaps(Action, zoom: Int)
    }

    private let urlOpener: URLOpener

    init(urlOpener: URLOpener) {
        self.urlOpener = urlOpener
    }

    func open(_ link: Link) throws {
        try urlOpener.open(link.url())
    }
}

fileprivate extension MapOpener.Link {
    var scheme: String {
        switch self {
        case .appleMaps: return "http"
        case .googleMaps: return "comgooglemaps"
        }
    }

    var host: String {
        switch self {
        case .appleMaps: return "maps.apple.com"
        case .googleMaps: return ""
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .appleMaps(let action):
            switch action {
            case .search(let query):
                return [URLQueryItem(name: "q", value: query)]
            }
        case .googleMaps(let action, let zoom):
            switch action {
            case .search(let query):
                return [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "zoom", value: String(zoom)),
                ]
            }
        }
    }

    func url() throws -> URL {
        try URL(scheme: scheme, host: host, queryItems: queryItems)
    }
}
