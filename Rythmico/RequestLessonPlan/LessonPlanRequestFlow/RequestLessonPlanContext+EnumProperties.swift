import Foundation

extension RequestLessonPlanContext.Step {
    var isInstrumentSelection: Bool {
        guard case .instrumentSelection = self else { return false }
        return true
    }

    var studentDetailsValue: Instrument? {
        guard case let .studentDetails(studentDetails) = self else { return nil }
        return studentDetails
    }

    var isStudentDetails: Bool {
        guard case .studentDetails = self else { return false }
        return true
    }

    var addressDetailsValue: (instrument: Instrument, student: Student)? {
        guard case let .addressDetails(instrument, student) = self else { return nil }
        return (instrument: instrument, student: student)
    }

    var isAddressDetails: Bool {
        guard case .addressDetails = self else { return false }
        return true
    }

    var schedulingValue: Instrument? {
        guard case let .scheduling(scheduling) = self else { return nil }
        return scheduling
    }

    var isScheduling: Bool {
        guard case .scheduling = self else { return false }
        return true
    }

    var isPrivateNote: Bool {
        guard case .privateNote = self else { return false }
        return true
    }

    var reviewRequestValue: (
        instrument: Instrument,
        student: Student,
        address: Address,
        schedule: Schedule,
        privateNote: String
    )? {
        guard case let .reviewRequest(instrument, student, address, schedule, privateNote) = self else {
            return nil
        }
        return (
            instrument: instrument,
            student: student,
            address: address,
            schedule: schedule,
            privateNote: privateNote
        )
    }

    var isReviewRequest: Bool {
        guard case .reviewRequest = self else { return false }
        return true
    }
}
