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
        case requestingLessonPlan
        case reviewing(LessonPlan, LessonPlan.Application? = nil)
        case booking(LessonPlan, LessonPlan.Application)
        case booked(LessonPlan, LessonPlan.Application)

        case viewingLessonPlan(LessonPlan, cancelling: Bool = false)
        case viewingLesson(Lesson, skipping: Bool = false)
    }
}

extension AppState.LessonsContext {
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
        set { viewingLesson.map { self = .viewingLesson($0, skipping: newValue) } }
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
        set { viewingLessonPlan.map { self = .viewingLessonPlan($0, cancelling: newValue) } }
    }

    var reviewingLessonPlan: LessonPlan? {
        get {
            switch self {
            case let .reviewing(lessonPlan, _), let .booking(lessonPlan, _):
                return lessonPlan
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self = .reviewing(newValue, nil)
            } else if reviewingLessonPlan != nil {
                self = .none
            }
        }
    }

    var reviewingLessonPlanApplication: LessonPlan.Application? {
        get {
            switch self {
            case let .reviewing(_, application):
                return application
            case let .booking(_, application):
                return application
            default:
                return nil
            }
        }
        set {
            if let lessonPlan = reviewingLessonPlan {
                self = .reviewing(lessonPlan, newValue)
            }
        }
    }

    var bookingValues: (lessonPlan: LessonPlan, application: LessonPlan.Application)? {
        get {
            switch self {
            case let .booking(lessonPlan, application), let .booked(lessonPlan, application):
                return (lessonPlan, application)
            default:
                return nil
            }
        }
        set {
            guard newValue == nil else { return }
            switch self {
            case let .booking(lessonPlan, application):
                self = .reviewing(lessonPlan, application)
            case .booked:
                self = .none
            default:
                break
            }
        }
    }
}
