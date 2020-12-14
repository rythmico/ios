import SwiftUI
import Sugar

struct LessonSkippingView: View {
    @Environment(\.presentationMode)
    private var presentationMode
    @StateObject
    private var coordinator = Current.coordinator(for: \.lessonSkippingService)!

    var lesson: Lesson
    var freeSkipUntil: Date

    @State private
    var showingConfirmationSheet = false

    init?(lesson: Lesson) {
        guard let freeSkipUntil = lesson.freeSkipUntil else {
            return nil
        }
        self.lesson = lesson
        self.freeSkipUntil = freeSkipUntil
    }

    var body: some View {
        CoordinatorStateView(coordinator: coordinator, successTitle: "Lesson Skipped", loadingTitle: "Skipping Lesson...") {
            NavigationView {
                VStack(spacing: 0) {
                    TitleContentView(title: "Confirm Skip Lesson", titlePadding: .init(horizontal: .spacingMedium)) {
                        ScrollView {
                            LessonSkippingContentView(
                                isFree: isFree,
                                freeSkipUntil: freeSkipUntil
                            )
                            .padding(.horizontal, .spacingMedium)
                        }
                    }

                    FloatingView {
                        Button(submitButtonTitle, action: onSkipButtonPressed).secondaryStyle()
                    }
                }
                .padding(.top, .spacingExtraSmall)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: CloseButton(action: dismiss))
            }
        }
        .sheetInteractiveDismissal(!coordinator.state.isLoading)
        .accentColor(.rythmicoGray90)
        .onSuccess(coordinator, perform: lessonSuccessfullySkipped)
        .alertOnFailure(coordinator)
        .actionSheet(isPresented: $showingConfirmationSheet) {
            ActionSheet(
                title: Text("Are you sure?"),
                message: Text("You will still be charged the full amount for this lesson."),
                buttons: [.destructive(Text("Skip Lesson"), action: submit), .cancel()]
            )
        }
    }

    private var isFree: Bool {
        Current.date() < freeSkipUntil
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    private func submit() {
        coordinator.run(with: lesson)
    }

    private var submitButtonTitle: String {
        isFree ? "Skip Lesson For Free" : "Skip Lesson"
    }

    private func onSkipButtonPressed() {
        if isFree {
            submit()
        } else {
            showingConfirmationSheet = true
        }
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
