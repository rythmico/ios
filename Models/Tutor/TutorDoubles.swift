import FoundationSugar

extension Tutor.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }
}

extension Tutor {
    static let jesseStub = Self(
        id: .random(),
        name: "Jesse Bildner",
        photoURL: nil,
        thumbnailURL: nil,
        instruments: [.guitar, .piano, .singing, .flute]
    )

    static let davidStub = Self(
        id: .random(),
        name: "David Roman",
        photoURL: nil,
        thumbnailURL: nil,
        instruments: [.guitar, .piano, .singing, .flute]
    )

    static let charlotteStub = Self(
        id: .random(),
        name: "Charlotte",
        photoURL: nil,
        thumbnailURL: nil,
        instruments: [.guitar, .piano, .singing, .flute]
    )
}
