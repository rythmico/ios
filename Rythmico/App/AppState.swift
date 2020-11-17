import SwiftUI
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
        case viewing(LessonPlan)
        case cancelling(LessonPlan)
        case reviewing(LessonPlan, LessonPlan.Application? = nil)
        case booking(LessonPlan, LessonPlan.Application)
        case booked(LessonPlan, LessonPlan.Application)

        case viewingLesson(Lesson)
        case skippingLesson(Lesson)
    }
}

extension AppState.LessonsContext {
    var isRequestingLessonPlan: Bool {
        get {
            switch self {
            case .requestingLessonPlan:
                return true
            default:
                return false
            }
        }
        set {
            if newValue {
                self = .requestingLessonPlan
            } else if isRequestingLessonPlan {
                self = .none
            }
        }
    }

    var viewingLesson: Lesson? {
        get {
            switch self {
            case .viewingLesson(let lesson), .skippingLesson(let lesson):
                return lesson
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self = .viewingLesson(newValue)
            } else if case .viewingLesson = self {
                self = .none
            }
        }
    }

    var skippingLesson: Lesson? {
        get {
            switch self {
            case .skippingLesson(let lesson):
                return lesson
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self = .skippingLesson(newValue)
            } else if let lesson = skippingLesson {
                self = .viewingLesson(lesson)
            }
        }
    }

    var selectedLessonPlan: LessonPlan? {
        get {
            switch self {
            case .viewing(let lessonPlan), .cancelling(let lessonPlan):
                return lessonPlan
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self = .viewing(newValue)
            } else if case .viewing = self {
                self = .none
            }
        }
    }

    var cancellingLessonPlan: LessonPlan? {
        get {
            switch self {
            case .cancelling(let lessonPlan):
                return lessonPlan
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self = .cancelling(newValue)
            } else if let lessonPlan = cancellingLessonPlan {
                self = .viewing(lessonPlan)
            }
        }
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
