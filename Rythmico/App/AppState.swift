import SwiftUI
import Then

final class AppState: ObservableObject {
    @Published var tab: MainView.Tab = .lessons
    // TODO: use optional when Binding allows chaining optional sub-bindings.
    // e.g. $state.lessonsContext(?).reviewingValues(?).0
    @Published var lessonsContext: LessonsContext = .none
}

extension AppState {
    enum LessonsContext {
        case none
        case requestingLessonPlan
        case viewing(LessonPlan)
        case cancelling(LessonPlan)
        case reviewing(LessonPlan, LessonPlan.Application? = nil)
        case booking(LessonPlan, LessonPlan.Application)
        case booked(LessonPlan, LessonPlan.Application)
    }
}

extension AppState.LessonsContext {
    var isRequestingLessonPlan: Bool {
        get {
            switch self {
            case .requestingLessonPlan:
                return true
            case .none, .viewing, .cancelling, .booked, .reviewing, .booking:
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

    var selectedLessonPlan: LessonPlan? {
        get {
            switch self {
            case .none, .requestingLessonPlan, .booked, .reviewing, .booking:
                return nil
            case .viewing(let lessonPlan), .cancelling(let lessonPlan):
                return lessonPlan
            }
        }
        set {
            if let newValue = newValue {
                self = .viewing(newValue)
            } else if selectedLessonPlan != nil {
                switch self {
                case .none, .requestingLessonPlan, .cancelling, .reviewing, .booking, .booked:
                    break
                case .viewing:
                    self = .none
                }
            }
        }
    }

    var cancellingLessonPlan: LessonPlan? {
        get {
            switch self {
            case .none, .requestingLessonPlan, .viewing, .booked, .reviewing, .booking:
                return nil
            case .cancelling(let lessonPlan):
                return lessonPlan
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
            case .none, .requestingLessonPlan, .viewing, .cancelling, .booked:
                return nil
            case let .reviewing(lessonPlan, _), let .booking(lessonPlan, _):
                return lessonPlan
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
            case .none, .requestingLessonPlan, .viewing, .cancelling, .booked:
                return nil
            case let .reviewing(_, application):
                return application
            case let .booking(_, application):
                return application
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
            case .none, .requestingLessonPlan, .viewing, .cancelling, .reviewing:
                return nil
            case let .booking(lessonPlan, application), let .booked(lessonPlan, application):
                return (lessonPlan, application)
            }
        }
        set {
            guard newValue == nil else { return }
            switch self {
            case .none, .requestingLessonPlan, .viewing, .cancelling, .reviewing:
                break
            case let .booking(lessonPlan, application):
                self = .reviewing(lessonPlan, application)
            case .booked:
                self = .none
            }
        }
    }
}
