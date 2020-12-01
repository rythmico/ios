import SwiftUI
import CasePaths
import Then

final class AppState: ObservableObject {
    @Published var tab: MainView.Tab = .lessons
    @Published var lessonsFilter: LessonsView.Filter = .upcoming
    // TODO: use optional when Binding allows chaining optional sub-bindings.
    // e.g. $state.lessonsContext(?).reviewingValues(?).0
    @Published var lessonsContext: LessonsContext = .none
}

extension AppState {
    enum LessonsContext: Equatable {
        case none

        // TODO: make tuple when below is implemented.
        // https://github.com/apple/swift-evolution/blob/main/proposals/0283-tuples-are-equatable-comparable-hashable.md
        enum ReviewingLessonPlanContext: Equatable {
            case none
            case reviewingApplication(LessonPlan.Application, isBooking: Bool = false)
        }

        case requestingLessonPlan
        case viewingLessonPlan(LessonPlan, isCancelling: Bool = false)
        case reviewingLessonPlan(LessonPlan, ReviewingLessonPlanContext = .none)
        case bookedLessonPlan(LessonPlan, LessonPlan.Application)

        case viewingLesson(Lesson, isSkipping: Bool = false)
    }
}

extension AppState.LessonsContext {
    // TODO: enable when Swift allows this (put @dynamicMemberLookup above enum declaration)
//    subscript<Value>(dynamicMember keyPath: KeyPath<Self.Type, (Value) -> Self>) -> Value? {
//        CasePath.case(Self.self[keyPath: keyPath]).extract(from: self)
//    }

    private subscript<Value>(casePath: CasePath<Self, Value>) -> Value? {
        casePath.extract(from: self)
    }

    var isRequestingLessonPlan: Bool {
        get { self[/Self.requestingLessonPlan] != nil }
        set {
            if newValue { self = .requestingLessonPlan }
            else
            if isRequestingLessonPlan { self = .none }
        }
    }

    var viewingLesson: Lesson? {
        get { self[/Self.viewingLesson]?.0 }
        set {
            if let newValue = newValue { self = .viewingLesson(newValue) }
            else
            if viewingLesson != nil { self = .none }
        }
    }

    var isSkippingLesson: Bool {
        get { self[/Self.viewingLesson]?.1 == true }
        set { viewingLesson.map { self = .viewingLesson($0, isSkipping: newValue) } }
    }

    var viewingLessonPlan: LessonPlan? {
        get { self[/Self.viewingLessonPlan]?.0 }
        set {
            if let newValue = newValue { self = .viewingLessonPlan(newValue) }
            else
            if viewingLessonPlan != nil { self = .none }
        }
    }

    var isCancellingLessonPlan: Bool {
        get { self[/Self.viewingLessonPlan]?.1 == true }
        set { viewingLessonPlan.map { self = .viewingLessonPlan($0, isCancelling: newValue) } }
    }

    var reviewingLessonPlan: LessonPlan? {
        get { self[/Self.reviewingLessonPlan]?.0 }
        set {
            if let newValue = newValue { self = .reviewingLessonPlan(newValue) }
            else
            if reviewingLessonPlan != nil { self = .none }
        }
    }

    var reviewingApplication: LessonPlan.Application? {
        get { self[/Self.reviewingLessonPlan]?.1.reviewingApplication }
        set {
            reviewingLessonPlan.map {
                self = .reviewingLessonPlan($0, newValue.map { .reviewingApplication($0) } ?? .none)
            }
        }
    }

    var isBookingLessonPlan: Bool {
        get { self[/Self.reviewingLessonPlan]?.1.isBooking == true }
        set {
            reviewingLessonPlan.map {
                self = .reviewingLessonPlan($0,
                    reviewingApplication.map { .reviewingApplication($0, isBooking: newValue) } ?? .none
                )
            }
        }
    }

    var bookingValues: (lessonPlan: LessonPlan, application: LessonPlan.Application)? {
        get {
            self[/Self.bookedLessonPlan] ?? {
                if
                    let lessonPlan = reviewingLessonPlan,
                    let application = reviewingApplication,
                    isBookingLessonPlan
                {
                    return (lessonPlan, application)
                }
                return nil
            }()
        }
        set {
            guard newValue == nil else { return }
            switch self {
            case let .reviewingLessonPlan(lessonPlan, .reviewingApplication(application, _)):
                self = .reviewingLessonPlan(lessonPlan, .reviewingApplication(application, isBooking: false))
            case .bookedLessonPlan:
                self = .none
            default:
                break
            }
        }
    }
}

extension AppState.LessonsContext.ReviewingLessonPlanContext {
    private subscript<Value>(casePath: CasePath<Self, Value>) -> Value? {
        casePath.extract(from: self)
    }

    var reviewingApplication: LessonPlan.Application? {
        self[/Self.reviewingApplication]?.0
    }

    var isBooking: Bool {
        self[/Self.reviewingApplication]?.1 == true
    }
}
