import SwiftUI
import MultiModal
import FoundationSugar

struct LessonDetailView: View, TestableView {
    @ObservedObject
    private var state = Current.state

    var lesson: Lesson

    var title: String {
        [lesson.student.name.firstWord, "\(lesson.instrument.assimilatedName) Lesson \(lesson.number)"]
            .compact()
            .joined(separator: " - ")
    }

    var lessonSkippingView: LessonSkippingView? { LessonSkippingView(lesson: lesson) }
    var showSkipLessonFormAction: Action? {
        lessonSkippingView.map { _ in
            { state.lessonsContext.isSkippingLesson = true }
        }
    }

    func showCancelLessonPlanForm() {
        state.lessonsContext.isCancellingLessonPlan = true
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .spacingExtraLarge) {
                TitleContentView(title: title) {
                    Pill(status: lesson.status)
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
                                Text(lesson.address.condensedFormattedString)
                                    .lineSpacing(.spacingUnit)
                            }
                            InlineContentAndTitleView(lesson: lesson, summarized: false)
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
            $0.sheet(isPresented: $state.lessonsContext.isSkippingLesson) { lessonSkippingView }
            $0.sheet(isPresented: $state.lessonsContext.isCancellingLessonPlan) {
                if let lessonPlan = Current.lessonPlanRepository.firstById(lesson.planId) {
                    LessonPlanCancellationView(lessonPlan: lessonPlan)
                }
            }
        }
    }

    private let startDateFormatter = Current.dateFormatter(format: .custom("d MMMM @ h:mma"))
    private var startDateText: String { startDateFormatter.string(from: lesson.schedule.startDate) }

    private var durationText: String { "\(lesson.schedule.duration) minutes" }

    private var actions: [ActionList.Button] {
        [
//            .init(title: "View Lesson Plan", action: showLessonPlan),
            showSkipLessonFormAction.map { .init(title: "Skip Lesson", action: $0) },
            .init(title: "Cancel Lesson Plan", action: showCancelLessonPlanForm),
        ].compact()
    }
}

#if DEBUG
struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: .scheduledStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
