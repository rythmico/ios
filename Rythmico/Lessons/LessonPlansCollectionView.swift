import SwiftUISugar

struct LessonPlansCollectionView: View {
    let lessonPlans: [LessonPlan]

    var body: some View {
        CollectionView(topPadding: 0) {
            section("Pending", content: pendingPlans)
            section("Reviewing", content: reviewingPlans)
            section("Active", content: activePlans)
            section("Paused", content: pausedPlans)
            section("Cancelled", content: cancelledPlans)
        }
    }

    @ViewBuilder
    private func section(_ title: String, content: [LessonPlan]) -> some View {
        if !content.isEmpty {
            header(title)
            ForEach(content) { lessonPlan in
                LessonPlanSummaryCell(lessonPlan: lessonPlan).transition(transition)
            }
        }
    }

    @ViewBuilder
    private func header(_ title: String) -> some View {
        Container(style: .box(radius: .small)) {
            Text(title)
                .rythmicoTextStyle(.bodyBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, .grid(3))
                .padding(.vertical, .grid(2))
        }
        .accessibility(addTraits: .isHeader)
    }

    private var pendingPlans: [LessonPlan] {
        lessonPlans.filter(\.status.isPending)
    }

    private var reviewingPlans: [LessonPlan] {
        lessonPlans.filter(\.status.isReviewing)
    }

    private var activePlans: [LessonPlan] {
        lessonPlans.filter(\.status.isActive)
    }

    private var pausedPlans: [LessonPlan] {
        lessonPlans.filter(\.status.isPaused)
    }

    private var cancelledPlans: [LessonPlan] {
        lessonPlans.filter(\.status.isCancelled)
    }

    private var transition: AnyTransition {
        (.scale(scale: 0.75) + .opacity).animation(.rythmicoSpring(duration: .durationMedium))
    }
}

#if DEBUG
struct LessonPlansCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlansCollectionView(lessonPlans: .stub)
    }
}
#endif
