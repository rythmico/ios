import Foundation
import class UIKit.UIImage

enum ImageReference: Equatable, Decodable, Hashable {
    case url(URL)
    case assetName(String)
    case image(UIImage)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        guard let url = URL(string: value) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected valid image URL, got '\(value)' instead"
            )
        }
        self = .url(url)
    }
}
