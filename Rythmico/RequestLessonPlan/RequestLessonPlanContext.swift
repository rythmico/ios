import Foundation
import Sugar

final class RequestLessonPlanContext: ObservableObject {
    @Published var instrument: Instrument? {
        willSet { previousStep = currentStep }
    }
    @Published var student: Student? {
        willSet { previousStep = currentStep }
    }

    var previousStep: Step?
}

extension RequestLessonPlanContext {
    enum Step: Comparable {
        case instrumentSelection
        case studentDetails(Instrument)
        case addressDetails(Instrument, Student)
        case scheduling
        case privateNote
        case reviewProposal

        var index: Int {
            switch self {
            case .instrumentSelection:
                return 0
            case .studentDetails:
                return 1
            case .addressDetails:
                return 2
            case .scheduling:
                return 3
            case .privateNote:
                return 4
            case .reviewProposal:
                return 5
            }
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.index < rhs.index
        }

        static func > (lhs: Self, rhs: Self?) -> Bool {
            guard let rhs = rhs else {
                return true
            }
            return lhs > rhs
        }
    }

    var currentStep: Step {
        guard let instrument = instrument else {
            return .instrumentSelection
        }

        guard let student = student else {
            return .studentDetails(instrument)
        }

        return .addressDetails(instrument, student)
    }
}

extension RequestLessonPlanContext: InstrumentSelectionContext {
    func setInstrument(_ instrument: Instrument) { self.instrument = instrument }
}

extension RequestLessonPlanContext: StudentDetailsContext {
    func setStudent(_ student: Student) { self.student = student }
}
