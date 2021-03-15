import Foundation

extension URLOpener {
    func open(_ link: MapLink) throws {
        open(try link.url())
    }
}

enum MapLink {
    enum Intent {
        case search(query: String)
    }

    case appleMaps(Intent)
    case googleMaps(Intent, zoom: Int)
}

fileprivate extension MapLink {
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
