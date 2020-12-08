import SwiftUI
import Sugar

struct LessonSkippingView: View {
    @Environment(\.presentationMode)
    private var presentationMode
    @StateObject
    private var coordinator = Current.coordinator(for: \.lessonSkippingService)!

    var lesson: Lesson
    var freeSkipUntil: Date

    init?(lesson: Lesson) {
        guard let freeSkipUntil = lesson.freeSkipUntil else {
            return nil
        }
        self.lesson = lesson
        self.freeSkipUntil = freeSkipUntil
    }

    var body: some View {
        CoordinatorStateView(
            coordinator: coordinator,
            successTitle: "Lesson Will Be Skipped",
            loadingTitle: "Skipping Lesson..."
        ) {
            NavigationView {
                VStack(spacing: 0) {
                    TitleSubtitleView(
                        title: "Confirm Skipping",
                        subtitle: ["This will cancel your payment for this lesson.".part]
                    )
                    .padding(.horizontal, .spacingMedium)

                    InteractiveBackground()

                    FloatingView {
                        Button("Skip Lesson", action: submit).secondaryStyle()
                    }
                }
                .padding(.top, .spacingExtraSmall)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: Group {
                        if true {
                            CloseButton(action: dismiss)
                        }
                    }
                )
            }
        }
        .sheetInteractiveDismissal(!coordinator.state.isLoading)
        .accentColor(.rythmicoGray90)
        .onSuccess(coordinator, perform: lessonSuccessfullySkipped)
        .alertOnFailure(coordinator)
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private func submit() {
        coordinator.run(with: lesson)
    }

    private func lessonSuccessfullySkipped(_ lessonPlan: LessonPlan) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Current.lessonPlanRepository.replaceById(lessonPlan)
            Current.state.lessonsContext = .none
        }
    }
}

#if DEBUG
struct LessonSkippingView_Preview: PreviewProvider {
    static var previews: some View {
        LessonSkippingView(lesson: .scheduledStub)
    }
}
#endif
