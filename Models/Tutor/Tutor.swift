import FoundationSugar

struct Tutor: Identifiable, Equatable, Decodable, Hashable {
    typealias ID = Tagged<Self, String>

    var id: ID
    var name: String
    var photoURL: ImageReference?
    var thumbnailURL: ImageReference?
}

extension Tutor {
    var firstName: String? {
        name.firstWord
    }

    var lastName: String? {
        name.word(at: 1)
    }

    var shortName: String? {
        unwrap(firstName, lastName?.first).map { "\($0) \($1)." } ?? firstName
    }
}
