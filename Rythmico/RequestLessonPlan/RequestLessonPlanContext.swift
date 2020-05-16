import Foundation
import Sugar

final class RequestLessonPlanContext: ObservableObject {
    @Published var instrument: Instrument? {
        willSet { previousStep = currentStep }
    }
    @Published var student: Student? {
        willSet { previousStep = currentStep }
    }
    @Published var address: AddressDetails? {
        willSet { previousStep = currentStep }
    }
    @Published var schedule: Schedule? {
        willSet { previousStep = currentStep }
    }
    @Published var privateNote: String? {
        willSet { previousStep = currentStep }
    }

    private(set) var previousStep: Step?
}

extension RequestLessonPlanContext {
    enum Step: Comparable {
        case instrumentSelection
        case studentDetails(Instrument)
        case addressDetails(Instrument, Student)
        case scheduling(Instrument)
        case privateNote
        case reviewRequest(Instrument, Student, AddressDetails, Schedule, String)

        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.index < rhs.index
        }

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
    }

    enum Direction {
        case forward, backward
    }

    var currentStep: Step {
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

    var direction: Direction {
        guard let previousStep = previousStep else {
            return .forward
        }
        return currentStep > previousStep ? .forward : .backward
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
    func setAddress(_ address: AddressDetails) { self.address = address }
}

extension RequestLessonPlanContext: SchedulingContext {
    func setSchedule(_ schedule: Schedule) { self.schedule = schedule }
}

extension RequestLessonPlanContext: PrivateNoteContext {
    func setPrivateNote(_ note: String) { self.privateNote = note }
}
