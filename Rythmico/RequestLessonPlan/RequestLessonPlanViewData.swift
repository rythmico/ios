import SwiftUI

typealias AddressDetailsView = AnyView
typealias SchedulingView = AnyView
typealias PrivateNoteView = AnyView
typealias ReviewProposalView = AnyView

struct RequestLessonPlanViewData {
    enum Direction {
        case next
        case back
    }
    var shouldShowBackButton: Bool { currentStep.index > 0 }
    var currentStepNumber: Int { currentStep.index + 1 }
    var direction: Direction?
    var stepCount: Int { Step.count }
    var currentStep: Step
}

extension RequestLessonPlanViewData {
    enum Step {
        case instrumentSelection(InstrumentSelectionView)
        case studentDetails(StudentDetailsView)
        case addressDetails(AddressDetailsView)
        case scheduling(SchedulingView)
        case privateNote(PrivateNoteView)
        case reviewProposal(ReviewProposalView)
    }
}

extension RequestLessonPlanViewData.Step {
    fileprivate var index: Int {
        allCases.enumerated().first { $0.element != nil }?.offset ?? 0
    }

    fileprivate static var count: Int { 6 }

    private var allCases: [Any?] {
        [
            instrumentSelectionView,
            studentDetailsView,
            addressDetailsView,
            schedulingView,
            privateNoteView,
            reviewProposalView
        ]
    }
}

extension RequestLessonPlanViewData.Step {
    var instrumentSelectionView: InstrumentSelectionView? {
        guard case .instrumentSelection(let view) = self else {
            return nil
        }
        return view
    }

    var studentDetailsView: StudentDetailsView? {
        guard case .studentDetails(let view) = self else {
            return nil
        }
        return view
    }

    var addressDetailsView: AddressDetailsView? {
        guard case .addressDetails(let view) = self else {
            return nil
        }
        return view
    }

    var schedulingView: SchedulingView? {
        guard case .scheduling(let view) = self else {
            return nil
        }
        return view
    }

    var privateNoteView: PrivateNoteView? {
        guard case .privateNote(let view) = self else {
            return nil
        }
        return view
    }

    var reviewProposalView: ReviewProposalView? {
        guard case .reviewProposal(let view) = self else {
            return nil
        }
        return view
    }
}
