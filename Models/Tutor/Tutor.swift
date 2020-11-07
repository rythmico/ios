import Foundation
import Tagged

struct Tutor: Identifiable, Equatable, Decodable, Hashable {
    typealias ID = Tagged<Self, String>

    var id: ID
    var name: String
    var photoThumbnailURL: ImageReference?
    var photoURL: ImageReference?
}
