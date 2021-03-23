import SwiftUI
import FoundationSugar
import EnumKit
import Then

final class AppState: ObservableObject {
    @Published var tab: MainView.Tab = .lessons
    @Published var lessonsFilter: LessonsView.Filter = .upcoming
    // TODO: use optional when Binding allows chaining optional sub-bindings.
    // e.g. $state.lessonsContext(?).reviewingValues(?).0
    @Published var lessonsContext: LessonsContext = .none

    func reset() {
        tab = .lessons
        lessonsFilter = .upcoming
        lessonsContext = .none
    }
}

extension AppState {
    enum LessonsContext: Equatable, CaseAccessible {
        case none

        enum ReviewingLessonPlanContext: Equatable, CaseAccessible {
            case none
            case reviewingApplication(LessonPlan.Application, isBooking: Bool = false)
        }

        case requestingLessonPlan
        case viewingLessonPlan(LessonPlan, isCancelling: Bool = false)
        case reviewingLessonPlan(LessonPlan, ReviewingLessonPlanContext = .none)
        case bookedLessonPlan(LessonPlan, LessonPlan.Application)

        enum ViewingLessonContext: Equatable, CaseAccessible {
            case none
            case skippingLesson
            case cancellingLessonPlan
        }

        case viewingLesson(Lesson, ViewingLessonContext = .none)
    }
}

extension AppState.LessonsContext {
    // TODO: enable when Swift allows this (put @dynamicMemberLookup above enum declaration)
//    subscript<Value>(dynamicMember keyPath: KeyPath<Self.Type, (Value) -> Self>) -> Value? {
//        self[case: Self.self[keyPath: keyPath]]
//    }

    private mutating func setIfSomeOrReset<T, AssociatedValue>(_ newValue: T?, onCase pattern: (AssociatedValue) -> Self, _ caseMap: (T) -> Self) {
        newValue.map { self = caseMap($0) } ?? { self.do(onCase: pattern) { _ in self = .none } }()
    }

    var isRequestingLessonPlan: Bool {
        get { self.matches(case: .requestingLessonPlan) }
        set { if newValue { self = .requestingLessonPlan } else if isRequestingLessonPlan { self = .none } } // not worth specializing `setIfSomeOrReset` for this one
    }

    var viewingLesson: Lesson? {
        get { self[case: Self.viewingLesson]?.0 }
        set { setIfSomeOrReset(newValue, onCase: Self.viewingLesson) { .viewingLesson($0) } }
    }

    var isSkippingLesson: Bool {
        get { self[case: Self.viewingLesson]?.1.matches(case: .skippingLesson) == true }
        set { self[case: Self.viewingLesson]?.1 = newValue ? .skippingLesson : .none }
    }

    var viewingLessonPlan: LessonPlan? {
        get { self[case: Self.viewingLessonPlan]?.0 }
        set { setIfSomeOrReset(newValue, onCase: Self.viewingLessonPlan) { .viewingLessonPlan($0) } }
    }

    var isCancellingLessonPlan: Bool {
        get {
            self[case: Self.viewingLessonPlan]?.1 == true
            ||
            self[case: Self.viewingLesson]?.1.matches(case: .cancellingLessonPlan) == true
        }
        set {
            (self[case: Self.viewingLessonPlan]?.1 = newValue)
            ??
            (self[case: Self.viewingLesson]?.1 = newValue ? .cancellingLessonPlan : .none)
        }
    }

    var reviewingLessonPlan: LessonPlan? {
        get { self[case: Self.reviewingLessonPlan]?.0 }
        set { setIfSomeOrReset(newValue, onCase: Self.reviewingLessonPlan) { .reviewingLessonPlan($0) } }
    }

    var reviewingApplication: LessonPlan.Application? {
        get { self[case: Self.reviewingLessonPlan]?.1[case: ReviewingLessonPlanContext.reviewingApplication]?.0 }
        set { self[case: Self.reviewingLessonPlan]?.1 = newValue.map { .reviewingApplication($0) } ?? .none }
    }

    var isBookingLessonPlan: Bool {
        get { self[case: Self.reviewingLessonPlan]?.1[case: ReviewingLessonPlanContext.reviewingApplication]?.1 == true }
        set { self[case: Self.reviewingLessonPlan]?.1[case: ReviewingLessonPlanContext.reviewingApplication]?.1 = newValue }
    }

    var bookingValues: (lessonPlan: LessonPlan, application: LessonPlan.Application)? {
        get {
            (isBookingLessonPlan ? unwrap(reviewingLessonPlan, reviewingApplication) : nil)
            ??
            self[case: Self.bookedLessonPlan]
        }
        set {
            guard newValue == nil else { return }
            switch self {
            case .reviewingLessonPlan: self.isBookingLessonPlan = false
            case .bookedLessonPlan: self = .none
            default: break
            }
        }
    }
}
