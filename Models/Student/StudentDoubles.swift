import Foundation

extension Student {
    private static let dateOfBirth = Date().adding(-9, .year)

    static var davidStub: Student {
        .init(
            name: "David Roman",
            dateOfBirth: dateOfBirth,
            gender: .male,
            about: """
            Something qwdsqw sqw qwdsqwsq
            Swdqwd qwd swqs qws qw dq wd
            """
        )
    }

    static var davidStubNoAbout: Student {
        .init(
            name: "David Roman",
            dateOfBirth: dateOfBirth,
            gender: .male,
            about: ""
        )
    }

    static var unnamedStub: Student {
        .init(
            name: "",
            dateOfBirth: dateOfBirth,
            gender: .male,
            about: """
            Something qwdsqw sqw qwdsqwsq
            Swdqwd qwd swqs qws qw dq wd
            """
        )
    }
}
