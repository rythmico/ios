import SwiftUI
import MultiModal
import FoundationSugar

struct LessonPlanDetailView: View, TestableView {
    @ObservedObject
    private var state = Current.state

    var lessonPlan: LessonPlan

    var title: String {
        [lessonPlan.student.name.firstWord, "\(lessonPlan.instrument.assimilatedName) Lessons"]
            .compact()
            .joined(separator: " - ")
    }

    var lessonPlanReschedulingView: LessonReschedulingView? { !lessonPlan.status.isCancelled ? .reschedulingView(lessonPlan: lessonPlan) : nil }
    var lessonPlanCancellationView: LessonPlanCancellationView? { LessonPlanCancellationView(lessonPlan: lessonPlan) }

    @State
    private var isRescheduling = false // TODO: move to AppState
    var showRescheduleAlertAction: Action? {
        lessonPlanReschedulingView != nil
            ? { isRescheduling = true }
            : nil
    }

    var showCancelLessonPlanFormAction: Action? {
        lessonPlanCancellationView != nil
            ? { state.lessonsContext.isCancellingLessonPlan = true }
            : nil
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .spacingExtraLarge) {
                TitleContentView(title: title) {
                    Pill(status: lessonPlan.status)
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingMedium) {
                        SectionHeaderView(title: "Lesson Details")
                        Group {
                            HStack(spacing: .spacingUnit * 2) {
                                Image(decorative: Asset.iconInfo.name).renderingMode(.template)
                                Text(startDateText)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            HStack(spacing: .spacingUnit * 2) {
                                Image(decorative: Asset.iconTime.name).renderingMode(.template)
                                Text(durationText)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            HStack(alignment: .firstTextBaseline, spacing: .spacingUnit * 2) {
                                Image(decorative: Asset.iconLocation.name)
                                    .renderingMode(.template)
                                    .offset(x: 0, y: .spacingUnit / 2)
                                Text(lessonPlan.address.condensedFormattedString)
                                    .lineSpacing(.spacingUnit)
                            }
                            InlineContentAndTitleView(status: lessonPlan.status, summarized: false)
                            if lessonPlan.status.isPending {
                                InfoBanner(text: "Potential tutors have received your request and will submit applications for your consideration.")
                            }
                        }
                        .rythmicoFont(.body)
                        .foregroundColor(.rythmicoGray90)
                    }
                }
            }
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingMedium)

            ActionList(actions, showBottomSeparator: false)
                .foregroundColor(.rythmicoGray90)
                .rythmicoFont(.body)
        }
        .testable(self)
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .multiModal {
            $0.alert(isPresented: $isRescheduling) { .reschedulingView(lessonPlan: lessonPlan) }
            $0.sheet(isPresented: $state.lessonsContext.isCancellingLessonPlan) { lessonPlanCancellationView }
        }
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("d MMMM @ h:mma"))

    private var startDateText: String { Self.startDateFormatter.string(from: lessonPlan.schedule.startDate) }
    private var durationText: String { "\(lessonPlan.schedule.duration) minutes" }

    @ArrayBuilder<ActionList.Button>
    private var actions: [ActionList.Button] {
        if let action = showRescheduleAlertAction {
            .init(title: "Reschedule", action: action)
        }
        if let action = showCancelLessonPlanFormAction {
            .init(title: "Cancel Lesson Plan", action: action)
        }
    }
}

#if DEBUG
struct LessonPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanDetailView(lessonPlan: .jesseDrumsPlanStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
