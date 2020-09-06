#if DEBUG
import Foundation
import Sugar

extension Student {
    static var jackStub: Student {
        .init(
            name: "Jack Doe",
            dateOfBirth: .stub - (9, .year),
            gender: .male,
            about: ""
        )
    }

    static var jesseStub: Student {
        .init(
            name: "Jesse Doe",
            dateOfBirth: .stub - (9, .year),
            gender: .male,
            about: ""
        )
    }

    static var charlotteStub: Student {
        .init(
            name: "Charlotte Doe",
            dateOfBirth: .stub - (9, .year),
            gender: .female,
            about: ""
        )
    }

    static var janeStub: Student {
        .init(
            name: "Jane Doe",
            dateOfBirth: .stub - (9, .year),
            gender: .female,
            about: ""
        )
    }

    static var davidStub: Student {
        .init(
            name: "David Roman",
            dateOfBirth: .stub - (9, .year),
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
            dateOfBirth: .stub - (9, .year),
            gender: .male,
            about: ""
        )
    }

    static var unnamedStub: Student {
        .init(
            name: "",
            dateOfBirth: .stub - (9, .year),
            gender: .male,
            about: """
            Something qwdsqw sqw qwdsqwsq
            Swdqwd qwd swqs qws qw dq wd
            """
        )
    }
}
#endif
