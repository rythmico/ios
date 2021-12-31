import FoundationEncore
import TutorDTO

extension LessonPlanRequest.PartialStudent {
    static let baseStub = Self(
        firstName: "",
        age: 9,
        about: ""
    )

    static let jackStub = baseStub => (\.firstName, "Jack")
    static let jesseStub = baseStub => (\.firstName, "Jesse")

    static let charlotteStub = baseStub => {
        $0.firstName = "Charlotte"
    }

    static let janeStub = baseStub => {
        $0.firstName = "Jane"
    }

    static let davidStub = baseStub => {
        $0.firstName = "David"
        $0.about = """
        Something qwdsqw sqw qwdsqwsq
        Swdqwd qwd swqs qws qw dq wd
        """
    }

    static let davidStubNoAbout = baseStub => (\.firstName, "David")

    static let unnamedStub = baseStub => {
        $0.firstName = ""
        $0.about = """
        Something qwdsqw sqw qwdsqwsq
        Swdqwd qwd swqs qws qw dq wd
        """
    }
}
