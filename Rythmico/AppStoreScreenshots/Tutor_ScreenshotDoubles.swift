import Foundation

extension LessonPlan.Application {
    static let screenshotRebekahStub = Self(
        tutor: .screenshotRebekahStub,
        privateNote: """
        Hey Jonathan,

        I’d be happy to teach Jane piano lessons. Most piano lesson sites force beginners to do boring exercises and drills for months before actually making music. She will be making music on day 1, with our beginner Core Learning System.
        """
    )

    static let screenshotCallumStub = Self(tutor: .screenshotCallumStub, privateNote: "")
    static let screenshotMarshaStub = Self(tutor: .screenshotMarshaStub, privateNote: "")
    static let screenshotStephStub = Self(tutor: .screenshotStephStub, privateNote: "")
}

extension Tutor {
    private static let rebekahPhotoURL = URL(string: "https://dl.airtable.com/.attachmentThumbnails/f961edaef053f1aada6441aad9bcb17c/20cb7ddc")!

    static let screenshotRebekahStub = Self(
        id: .random(),
        name: "Rebekah F",
        photoURL: .url(rebekahPhotoURL),
        thumbnailURL: .url(rebekahPhotoURL),
        instruments: [.flute, .piano, .singing]
    )

    private static let callumPhotoURL = URL(string: "https://dl.airtable.com/.attachmentThumbnails/01875077ec1f599fbf0c3092b7ce5bde/7a9b03da")!

    static let screenshotCallumStub = Self(
        id: .random(),
        name: "Callum",
        photoURL: .url(callumPhotoURL),
        thumbnailURL: .url(callumPhotoURL),
        instruments: []
    )

    private static let marshaPhotoURL = URL(string: "https://dl.airtable.com/.attachmentThumbnails/881360eeb65a35823bba08bb22af3c21/2cd360fc")!

    static let screenshotMarshaStub = Self(
        id: .random(),
        name: "Marsha",
        photoURL: .url(marshaPhotoURL),
        thumbnailURL: .url(marshaPhotoURL),
        instruments: []
    )

    private static let stephPhotoURL = URL(string: "https://dl.airtable.com/.attachmentThumbnails/a2250eaf3b398a344ff62db7fac9131c/853b9957")!

    static let screenshotStephStub = Self(
        id: .random(),
        name: "Steph",
        photoURL: .url(stephPhotoURL),
        thumbnailURL: .url(stephPhotoURL),
        instruments: []
    )
}
