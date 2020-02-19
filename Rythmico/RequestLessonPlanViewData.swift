import SwiftUI

typealias StudentDetailsView = AnyView
typealias AddressDetailsView = AnyView
typealias SchedulingView = AnyView
typealias PrivateNoteView = AnyView
typealias ReviewProposalView = AnyView

enum RequestLessonPlanStep {
    case instrumentSelection(InstrumentSelectionView)
    case studentDetails(StudentDetailsView)
    case addressDetails(AddressDetailsView)
    case scheduling(SchedulingView)
    case privateNote(PrivateNoteView)
    case reviewProposal(ReviewProposalView)

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

struct RequestLessonPlanViewData {
    var currentStep: RequestLessonPlanStep
}
