import Foundation

extension Student {
    static var davidStub: Student {
        .init(
            name: "David Roman",
            dateOfBirth: Date().adding(-9, .year),
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
            dateOfBirth: Date().adding(-9, .year),
            gender: .male,
            about: ""
        )
    }

    static var unnamedStub: Student {
        .init(
            name: "",
            dateOfBirth: Date().adding(-9, .year),
            gender: .male,
            about: """
            Something qwdsqw sqw qwdsqwsq
            Swdqwd qwd swqs qws qw dq wd
            """
        )
    }
}
