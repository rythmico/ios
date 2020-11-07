import SwiftUI
import Sugar

struct LessonDetailView: View, TestableView {
    @ObservedObject
    private var state = Current.state

    var lesson: Lesson

    var title: String {
        [lesson.student.name.firstWord, "\(lesson.instrument.name) Lesson \(lesson.number)"]
            .compact()
            .joined(separator: " - ")
    }

//    func showCancelLessonPlanForm() {
//        state.lessonsContext = .cancelling(lessonPlan)
//    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .spacingExtraLarge) {
                TitleContentView(title: title) {
                    Pill(status: lesson.status)
                }
                VStack(alignment: .leading, spacing: .spacingMedium) {
                    SectionHeaderView(title: "Lesson Details")
                    Group {
                        HStack(spacing: .spacingMedium) {
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
                        }
                        HStack(alignment: .firstTextBaseline, spacing: .spacingUnit * 2) {
                            Image(decorative: Asset.iconLocation.name)
                                .renderingMode(.template)
                                .offset(x: 0, y: .spacingUnit / 2)
                            Text(lesson.address.condensedFormattedString)
                                .lineSpacing(.spacingUnit)
                        }
                        InlineContentAndTitleView(lesson: lesson, summarized: false)
                    }
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray90)
                }
            }
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingMedium)
            .frame(maxHeight: .infinity, alignment: .top)

//            ActionList(
//                [
//                    .init(title: "View Lesson Plan", action: showCancelLessonPlanForm),
//                    .init(title: "Cancel Lesson", action: showCancelLessonPlanForm),
//                ],
//                showBottomSeparator: false
//            )
//            .foregroundColor(.rythmicoGray90)
//            .rythmicoFont(.body)
        }
        .testable(self)
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $state.lessonsContext.cancellingLessonPlan) {
            LessonPlanCancellationView(lessonPlan: $0)
        }
    }

    private let startDateFormatter = Current.dateFormatter(format: .custom("d MMMM @ h:mma"))
    private var startDateText: String { startDateFormatter.string(from: lesson.schedule.startDate) }

    private var durationText: String { "\(lesson.schedule.duration) minutes" }
}

#if DEBUG
struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: .scheduledStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
