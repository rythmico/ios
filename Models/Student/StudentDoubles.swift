#if DEBUG
import Foundation
import Sugar

extension Student {
    static let jackStub = Self(
        name: "Jack Doe",
        dateOfBirth: .stub - (9, .year),
        gender: .male,
        about: ""
    )

    static let jesseStub = Self(
        name: "Jesse Doe",
        dateOfBirth: .stub - (9, .year),
        gender: .male,
        about: ""
    )

    static let charlotteStub = Self(
        name: "Charlotte Doe",
        dateOfBirth: .stub - (9, .year),
        gender: .female,
        about: ""
    )

    static let janeStub = Self(
        name: "Jane Doe",
        dateOfBirth: .stub - (9, .year),
        gender: .female,
        about: ""
    )

    static let davidStub = Self(
        name: "David Roman",
        dateOfBirth: .stub - (9, .year),
        gender: .male,
        about: """
        Something qwdsqw sqw qwdsqwsq
        Swdqwd qwd swqs qws qw dq wd
        """
    )

    static let davidStubNoAbout = Self(
        name: "David Roman",
        dateOfBirth: .stub - (9, .year),
        gender: .male,
        about: ""
    )

    static let unnamedStub = Self(
        name: "",
        dateOfBirth: .stub - (9, .year),
        gender: .male,
        about: """
        Something qwdsqw sqw qwdsqwsq
        Swdqwd qwd swqs qws qw dq wd
        """
    )
}
#endif
