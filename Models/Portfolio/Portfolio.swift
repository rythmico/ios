import Foundation

struct Portfolio: Equatable, Decodable, Hashable {
    struct Training: Equatable, Decodable, Hashable {
        struct Duration: Equatable, Decodable, Hashable {
            var fromYear: Int
            var toYear: Int? // nil means til now
        }

        var title: String
        var description: String
        var duration: Duration?
    }

    struct Video: Equatable, Decodable, Hashable {
        enum Source: Equatable, Hashable {
            case youtube(videoId: String)
            case directURL(URL)
        }
        var source: Source
        var thumbnailURL: ImageReference
    }

    struct Photo: Equatable, Decodable, Hashable {
        var photoURL: ImageReference
        var thumbnailURL: ImageReference
    }

    var age: Int
    var bio: String
    var training: [Training]
    var videos: [Video]
    var photos: [Photo]
}

extension Portfolio.Video.Source: Decodable {
    private enum Kind: String {
        case youtube = "YOUTUBE"
        case directURL = "URL"
    }

    private enum CodingKeys: String, CodingKey {
        case kind
        case reference
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawKind = try container.decode(String.self, forKey: .kind)
        switch Kind(rawValue: rawKind) {
        case .youtube:
            self = .youtube(videoId: try container.decode(String.self, forKey: .reference))
        case .directURL:
            self = .directURL(try container.decode(URL.self, forKey: .reference))
        case .none:
            throw DecodingError.dataCorruptedError(
                forKey: .kind,
                in: container,
                debugDescription: "Invalid kind '\(rawKind)' found."
            )
        }
    }
}
