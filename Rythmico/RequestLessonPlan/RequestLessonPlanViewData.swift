import SwiftUI

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
    var direction: Direction = .next
    var currentStep: Step
    var stepCount: Int { currentStep.allViews.count }
}

extension RequestLessonPlanViewData {
    enum Step {
        case instrumentSelection(InstrumentSelectionView)
        case studentDetails(StudentDetailsView)
        case addressDetails(AddressDetailsView)
        case scheduling(SchedulingView)
        case privateNote(PrivateNoteView)
        case reviewProposal(ReviewProposalView)

        var allViews: [AnyView?] {
            [
                instrumentSelectionView.map(AnyView.init),
                studentDetailsView.map(AnyView.init),
                addressDetailsView.map(AnyView.init),
                schedulingView.map(AnyView.init),
                privateNoteView.map(AnyView.init),
                reviewProposalView.map(AnyView.init)
            ]
        }

        var index: Int {
            guard let index = allViews.firstIndex(where: { $0 != nil }) else {
                preconditionFailure("RequestLessonPlanViewData.Step enum cases and allViews array are not in sync")
            }
            return index
        }
    }
}

private extension RequestLessonPlanViewData.Step {
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
