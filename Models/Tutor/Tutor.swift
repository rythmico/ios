import Foundation
import Tagged

struct Tutor: Identifiable, Equatable, Decodable, Hashable {
    typealias ID = Tagged<Self, String>

    var id: ID
    var name: String
    var photoURL: ImageReference?
    var thumbnailURL: ImageReference?
}
