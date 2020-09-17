import UIKit

extension Portfolio {
    static let minimalStub = Self(
        age: 29,
        bio: .empty,
        training: [],
        videos: [],
        photos: []
    )

    static let shortStub = Self(
        age: 29,
        bio: """
        Victor is a graduate from The Juilliard School and the Manhattan School of Music where he held full-scholarships.
        """,
        training: [.shortStub],
        videos: [.stub(.red)],
        photos: [.stub(.red), .stub(.green)]
    )

    static let longStub = Self(
        age: 29,
        bio: """
        Victor is a graduate from The Juilliard School and the Manhattan School of Music where he held full-scholarships. Before moving to New York, Victor was a member of two professional Orchestras in Rio de Janeiro.

        He was accepted into the Brazilian Symphony Orchestra at the age of 17 and later to the Rio de Janeiro Municipal Theatre Orchestra, where he performed Opera and Ballet productions for one full season.

        Victor has travelled extensively and toured with various ensembles throughout Europe, North America, South America and Africa.
        """,
        training: [.longStubA, .longStubB],
        videos: [.stub(.red), .stub(.green), .stub(.blue), .stub(.purple)],
        photos: [.stub(.red), .stub(.green), .stub(.blue), .stub(.purple)]
    )
}

extension Portfolio.Training {
    static let shortStub = Self(
        title: "The Juilliard School",
        description: "",
        fromYear: 2014,
        toYear: nil
    )

    static let longStubA = Self(
        title: "The Juilliard School",
        description: "Master of Music Scholarship",
        fromYear: 2014,
        toYear: 2016
    )

    static let longStubB = Self(
        title: "Manhattan School of Music",
        description: "Undergraduate Music Scholarship",
        fromYear: 2011,
        toYear: 2014
    )
}

extension Portfolio.Video {
    static func stub(_ color: UIColor) -> Self {
        .init(
            videoURL: URL(string: "https://google.com")!,
            thumbnailURL: .image(UIImage(.red))
        )
    }
}

extension Portfolio.Photo {
    static func stub(_ color: UIColor) -> Self {
        .init(
            photoURL: .image(UIImage(color)),
            thumbnailURL: .image(UIImage(color))
        )
    }
}
