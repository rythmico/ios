import FoundationSugar

extension Student: Then {}

extension Student {
    #if RYTHMICO
    static let baseStub = Self(
        name: "",
        dateOfBirth: .stub - (9, .year),
        about: ""
    )
    #elseif TUTOR
    static let baseStub = Self(
        name: "",
        age: 9,
        about: ""
    )
    #endif

    static let jackStub = baseStub.with(\.name, "Jack Doe")
    static let jesseStub = baseStub.with(\.name, "Jesse Doe")

    static let charlotteStub = baseStub.with {
        $0.name = "Charlotte Doe"
    }

    static let janeStub = baseStub.with {
        $0.name = "Jane Doe"
    }

    static let davidStub = baseStub.with {
        $0.name = "David Roman"
        $0.about = """
        Something qwdsqw sqw qwdsqwsq
        Swdqwd qwd swqs qws qw dq wd
        """
    }

    static let davidStubNoAbout = baseStub.with(\.name, "David Roman")

    static let unnamedStub = baseStub.with {
        $0.name = ""
        $0.about = """
        Something qwdsqw sqw qwdsqwsq
        Swdqwd qwd swqs qws qw dq wd
        """
    }
}
