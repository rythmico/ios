import SwiftUI
import Sugar

struct LessonPlanDetailView: View, TestableView {
    @ObservedObject
    private var state = Current.state

    var lessonPlan: LessonPlan

    var title: String {
        [lessonPlan.student.name.firstWord, "\(lessonPlan.instrument.name) Lessons"]
            .compact()
            .joined(separator: " - ")
    }

    func showCancelLessonPlanForm() {
        state.lessonsContext.isCancellingLessonPlan = true
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .spacingExtraLarge) {
                TitleContentView(title: title) {
                    Pill(status: lessonPlan.status)
                }
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
                    }
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray90)
                }
            }
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingMedium)
            .frame(maxHeight: .infinity, alignment: .top)

            ActionList(
                [.init(title: "Cancel Lesson Plan", action: showCancelLessonPlanForm)],
                showBottomSeparator: false
            )
            .foregroundColor(.rythmicoGray90)
            .rythmicoFont(.body)
        }
        .testable(self)
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $state.lessonsContext.isCancellingLessonPlan) {
            LessonPlanCancellationView(lessonPlan: lessonPlan)
        }
    }

    private let startDateFormatter = Current.dateFormatter(format: .custom("d MMMM @ h:mma"))
    private var startDateText: String { startDateFormatter.string(from: lessonPlan.schedule.startDate) }

    private var durationText: String { "\(lessonPlan.schedule.duration) minutes" }
}

#if DEBUG
struct LessonPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanDetailView(lessonPlan: .jesseDrumsPlanStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
