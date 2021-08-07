import Foundation

extension Student {
    static let screenshotJackStub = Self(name: "Jack", dateOfBirth: .stub, about: "")
}

// MARK: Jack - Drum Lessons

extension LessonPlan {
    fileprivate static let screenshotJackDrumsPlanStubId = ID.random()

    static let screenshotJackDrumsPlanStub = Self(
        id: screenshotJackDrumsPlanStubId,
        status: .reviewing(.init(applications: .init(.screenshotCallumStub, .screenshotMarshaStub, .screenshotRebekahStub, .screenshotStephStub))),
        instrument: .drums,
        student: .screenshotJackStub,
        address: .stub,
        schedule: .screenshotJackDrumsScheduleStub,
        privateNote: "",
        options: .reviewingStub
    )
}

fileprivate extension Schedule {
    static let screenshotJackDrumsScheduleStub = Self(startDate: "2020-10-19T19:00:00Z", duration: .oneHour)
}

extension LessonPlan.Status {
    static let screenshotJackDrumsPlanCancelled = Self.cancelled(
        CancelledProps(lessons: nil, bookingInfo: nil, cancellationInfo: .stub)
    )
}

// MARK: Jack - Guitar LessonCharlotte

extension LessonPlan {
    fileprivate static let screenshotJackGuitarPlanStubId = ID.random()

    static let screenshotJackGuitarPlanStub = Self(
        id: screenshotJackGuitarPlanStubId,
        status: .active(.init(lessons: [.screenshotJackGuitarLesson3], bookingInfo: .init(date: .stub, tutor: .screenshotCallumStub))),
        instrument: .guitar,
        student: .screenshotJackStub,
        address: .stub,
        schedule: .screenshotJackGuitarScheduleStub,
        privateNote: "",
        options: .activeStub
    )
}

fileprivate extension Schedule {
    static let screenshotJackGuitarScheduleStub = Self(startDate: "2020-10-23T19:00:00Z", duration: .oneHour)
}

fileprivate extension Lesson {
    static let screenshotJackGuitarLesson3 = Self(
        id: .random(),
        lessonPlanId: LessonPlan.screenshotJackGuitarPlanStubId,
        student: .screenshotJackStub,
        instrument: .guitar,
        week: 2,
        tutor: .screenshotCallumStub,
        status: .scheduled,
        address: .stub,
        schedule: .screenshotJackGuitarScheduleStub,
        options: .scheduledStub
    )
}

// MARK: Charlotte - Piano Lesson 6

extension Student {
    static let screenshotCharlotteStub = Self(name: "Charlotte", dateOfBirth: .stub, about: "")
}

extension LessonPlan {
    fileprivate static let screenshotCharlottePianoPlanStubId = ID.random()

    static let screenshotCharlottePianoPlanStub = Self(
        id: screenshotCharlottePianoPlanStubId,
        status: .active(.init(lessons: [.screenshotCharlottePianoLesson3], bookingInfo: .init(date: .stub, tutor: .screenshotStephStub))),
        instrument: .piano,
        student: .screenshotCharlotteStub,
        address: .stub,
        schedule: .screenshotCharlottePianoScheduleStub,
        privateNote: "",
        options: .activeStub
    )
}

fileprivate extension Schedule {
    static let screenshotCharlottePianoScheduleStub = Self(startDate: "2020-10-26T18:00:00Z", duration: .oneHour)
}

fileprivate extension Lesson {
    static let screenshotCharlottePianoLesson3 = Self(
        id: .random(),
        lessonPlanId: LessonPlan.screenshotCharlottePianoPlanStubId,
        student: .screenshotCharlotteStub,
        instrument: .piano,
        week: 5,
        tutor: .screenshotCallumStub,
        status: .scheduled,
        address: .stub,
        schedule: .screenshotCharlottePianoScheduleStub,
        options: .scheduledStub
    )
}

extension LessonPlan.Status {
    static let screenshotCharlottePianoPlanPaused = Self.paused(
        PausedProps(lessons: [], bookingInfo: .init(date: .stub, tutor: .screenshotStephStub), pauseInfo: .stub)
    )
}
