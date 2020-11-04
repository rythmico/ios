import Foundation

extension Tutor.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }
}

extension Tutor {
    static let jesseStub = Self(
        id: .random(),
        name: "Jesse Bildner",
        photoThumbnailURL: nil,
        photoURL: nil
    )

    static let davidStub = Self(
        id: .random(),
        name: "David Roman",
        photoThumbnailURL: nil,
        photoURL: nil
    )

    static let charlotteStub = Self(
        id: .random(),
        name: "Charlotte",
        photoThumbnailURL: nil,
        photoURL: nil
    )
}
