import Foundation

extension Student {
    static var stub: Student {
        .init(
            name: "David Roman",
            dateOfBirth: Date(),
            gender: .male,
            about: ""
        )
    }
}
