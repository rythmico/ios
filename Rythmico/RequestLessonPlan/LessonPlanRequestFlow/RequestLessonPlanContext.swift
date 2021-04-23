import Foundation
import FoundationSugar
import Then

final class RequestLessonPlanContext: Flow {
    @Published var instrument: Instrument?
    @Published var student: Student?
    @Published var address: Address?
    @Published var schedule: Schedule?
    @Published var privateNote: String?
}

extension RequestLessonPlanContext: Then {}

extension RequestLessonPlanContext {
    enum Step: FlowStep {
        case instrumentSelection
        case studentDetails(Instrument)
        case addressDetails(Instrument, Student)
        case scheduling(Instrument)
        case privateNote
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
            return .scheduling(instrument)
        }

        guard let privateNote = privateNote else {
            return .privateNote
        }

        return .reviewRequest(instrument, student, address, schedule, privateNote)
    }

    func unwindLatestStep() {
        if privateNote.nilifyIfSome() { return }
        if schedule.nilifyIfSome() { return }
        if address.nilifyIfSome() { return }
        if student.nilifyIfSome() { return }
        if instrument.nilifyIfSome() { return }
    }
}

extension RequestLessonPlanContext: InstrumentSelectionContext {
    func setInstrument(_ instrument: Instrument) { self.instrument = instrument }
}

extension RequestLessonPlanContext: StudentDetailsContext {
    func setStudent(_ student: Student) { self.student = student }
}

extension RequestLessonPlanContext: AddressDetailsContext {
    func setAddress(_ address: Address) { self.address = address }
}

extension RequestLessonPlanContext: SchedulingContext {
    func setSchedule(_ schedule: Schedule) { self.schedule = schedule }
}

extension RequestLessonPlanContext: PrivateNoteContext {
    func setPrivateNote(_ note: String) { self.privateNote = note }
}
