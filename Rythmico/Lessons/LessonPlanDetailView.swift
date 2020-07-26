import SwiftUI
import Sugar

struct LessonPlanDetailView: View, TestableView {
    @Environment(\.presentationMode) private var presentationMode

    var lessonPlan: LessonPlan
    @State
    private(set) var cancellationView: LessonPlanCancellationView?

    init(_ lessonPlan: LessonPlan) {
        self.lessonPlan = lessonPlan
    }

    var title: String {
        [
            lessonPlan.student.name.firstWord,
            "\(lessonPlan.instrument.name) Lessons"
        ].compactMap { $0 }.joined(separator: " - ")
    }

    func showCancelLessonPlanForm() {
        cancellationView = LessonPlanCancellationView(lessonPlan: lessonPlan, onSuccessfulCancellation: back)
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .spacingExtraLarge) {
                TitleContentView(title: title) {
                    LessonPlanStatusPill(lessonPlan.status)
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
                            Text(lessonPlan.address.condensedFormattedString)
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                                .lineSpacing(.spacingUnit)
                        }
                        LessonPlanTutorStatusView(lessonPlan.status, summarized: false)
                    }
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray90)
                }
            }
            .padding(.horizontal, .spacingMedium)

            Spacer()

            ActionList(
                [.init(title: "Cancel Lesson Plan Request", action: showCancelLessonPlanForm)],
                showBottomSeparator: false
            )
            .foregroundColor(.rythmicoGray90)
            .rythmicoFont(.body)
        }
        .padding(.top, .spacingExtraSmall)
        .onEdgeSwipe(.left, perform: back)
        .betterSheet(item: $cancellationView) { $0 }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(title: "Lessons", action: back))
        .testable(self)
    }

    private let startDateFormatter = DateFormatter().then { $0.dateFormat = "d MMMM @ ha" }
    private var startDateText: String { startDateFormatter.string(from: lessonPlan.schedule.startDate) }

    private var durationText: String { "\(lessonPlan.schedule.duration) minutes" }

    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct LessonPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanDetailView(.jesseDrumsPlanStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
