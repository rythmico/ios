import SwiftUISugar

final class RequestLessonPlanFlow: Flow {
    let id = Current.uuid()
    @Published
    var instrument: Instrument?
    @Published
    var student: Student?
    @Published
    var address: Address?
    @Published
    var schedule: Schedule?
    @Published
    var privateNote: String?
}

extension RequestLessonPlanFlow: Then {}

extension RequestLessonPlanFlow {
    enum Step: FlowStep, Equatable {
        case instrumentSelection
        case studentDetails(Instrument)
        case addressDetails(Instrument, Student)
        case scheduling(Instrument, Student, Address)
        case privateNote(Instrument, Student, Address, Schedule)
        case reviewRequest(Instrument, Student, Address, Schedule, String)

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
            case .reviewRequest:
                return 5
            }
        }

        static var count: Int {
            return 6
        }
    }

    var step: Step {
        guard let instrument = instrument else {
            return .instrumentSelection
        }

        guard let student = student else {
            return .studentDetails(instrument)
        }

        guard let address = address else {
            return .addressDetails(instrument, student)
        }

        guard let schedule = schedule else {
            return .scheduling(instrument, student, address)
        }

        guard let privateNote = privateNote else {
            return .privateNote(instrument, student, address, schedule)
        }

        return .reviewRequest(instrument, student, address, schedule, privateNote)
    }

    func back() {
        switch step {
        case .instrumentSelection:
            break
        case .studentDetails:
            instrument = nil
        case .addressDetails:
            student = nil
        case .scheduling:
            address = nil
        case .privateNote:
            schedule = nil
        case .reviewRequest:
            privateNote = nil
        }
    }
}
