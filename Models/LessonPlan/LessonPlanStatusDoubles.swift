import FoundationSugar

extension LessonPlan.Status.ReviewingProps {
    static let stub = Self(applications: .stub)
}

extension LessonPlan.Status.ActiveProps {
    static let stub = Self(lessons: .stub, bookingInfo: .jesseStub)
}

extension LessonPlan.Status.PausedProps {
    static let stub = Self(lessons: .stub, bookingInfo: .jesseStub, pauseInfo: .stub)
}

extension LessonPlan.Status.CancelledProps {
    static let noTutorStub = Self(lessons: .stub, bookingInfo: nil, cancellationInfo: .stub)
    static let stub = Self(lessons: .stub, bookingInfo: .jesseStub, cancellationInfo: .stub)
}
